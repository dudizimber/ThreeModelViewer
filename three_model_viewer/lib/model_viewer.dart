import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_assets_server/local_assets_server.dart';
import 'package:three_model_viewer/model_viewer_controller.dart';
import 'package:three_model_viewer/models/orbit_controls.dart';
import 'package:three_model_viewer/models/perspective_camera_config.dart';
import 'package:three_model_viewer/models/three_model.dart';
import 'package:three_model_viewer/three_model_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ModelViewer extends StatefulWidget {
  final List<ThreeModel> models;
  final Function(ModelViewerController controller) onPageLoaded;
  final PerspectiveCameraConfig cameraConfig;
  final Duration loaderDuration;
  final Function(bool ready)? onServerReady;
  final Function(double? percentage)? onObjectLoading;
  final Function()? onObjectLoaded;
  final Function(Object error)? onError;
  final Widget? showWhenLoading;

  const ModelViewer({
    Key? key,
    required this.models,
    required this.onPageLoaded,
    required this.cameraConfig,
    this.onServerReady,
    this.onError,
    this.onObjectLoaded,
    this.onObjectLoading,
    this.showWhenLoading,
    this.loaderDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _ModelViewerState createState() => _ModelViewerState();
}

class _ModelViewerState extends State<ModelViewer> {
  bool isListening = false;
  bool isReady = false;
  String? address;
  int? port;
  WebViewController? controller;
  bool hasError = false;

  Set<JavascriptChannel> channels = {};

  Future<String?>? setupScene() {
    if (hasError) return null;
    return controller?.runJavascriptReturningResult('window.setupScene()');
  }

  void loadModels() {
    if (hasError) return;
    for (var model in widget.models) {
      controller?.runJavascript(
          'window.loadModel(\'${model.src}\', ${model.playAnimation})');
    }
  }

  Future<String?>? createCamera(PerspectiveCameraConfig cameraConfig) {
    if (hasError) return null;
    return controller?.runJavascriptReturningResult(
        'window.createPerspectiveCamera($cameraConfig)');
  }

  void createOrbitControls() {
    if (hasError) return;
    controller?.runJavascript('window.createOrbitControls(undefined)');
  }

  void setBackgroundColor(String color, double alpha) {
    if (hasError) return;
    controller?.runJavascript('window.setBackgroundColor(\'$color\', $alpha)');
  }

  void setCameraPosition(Vector3 pos) {
    if (hasError) return;
    controller?.runJavascript('window.setCameraPosition($pos)');
  }

  void setCameraRotation(Vector3 pos) {
    if (hasError) return;
    controller?.runJavascript('window.setCameraRotation($pos)');
  }

  void setOrbitControls(OrbitControls orbitControls) {
    if (hasError) return;
    controller?.runJavascript('window.setOrbitControls($orbitControls)');
  }

  void addAmbientLight(String color, int intensity) {
    if (hasError) return;
    controller?.runJavascript('window.addAmbientLight(\'$color\', $intensity)');
  }

  void addDirectionalLight(DirectionalLight light) {
    if (hasError) return;
    controller?.runJavascript(
        'window.addDirectionalLight(${light.toString(map: true)})');
  }

  void setControlsTarget(Vector3 pos) {
    if (hasError) return;
    controller?.runJavascript('window.setControlsTarget($pos)');
  }

  void enableZoom(bool enable) {
    if (hasError) return;
    controller?.runJavascript('window.enableZoom($enable)');
  }

  void setStats(bool enable) {
    if (hasError) return;
    controller?.runJavascript('window.setStats($enable)');
  }

  void _onObjectLoaded() {
    if (widget.onObjectLoaded != null) widget.onObjectLoaded!();
    Timer(widget.loaderDuration, () {
      setState(() {
        isReady = true;
      });
    });
  }

  void _onPageFinishedLoading(_) async {
    await Future.delayed(Duration(milliseconds: 100));
    await setupScene();
    await createCamera(widget.cameraConfig);
    createOrbitControls();
    loadModels();
    widget.onPageLoaded(
      ModelViewerController(
        setBackgroundColor: setBackgroundColor,
        addAmbientLight: addAmbientLight,
        setCameraPosition: setCameraPosition,
        setCameraRotation: setCameraRotation,
        addDirectionalLight: addDirectionalLight,
        enableZoom: enableZoom,
        setControlsTarget: setControlsTarget,
        setOrbitControls: setOrbitControls,
        setStats: setStats,
      ),
    );
  }

  @override
  initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    _initChannels();
    _initServer();
    super.initState();
  }

  _initChannels() {
    channels = {
      JavascriptChannel(
          name: 'OnObjectLoading',
          onMessageReceived: (message) {
            double? value = double.tryParse(message.message);
            if (widget.onObjectLoading != null) widget.onObjectLoading!(value);
            if (value == 100) {
              _onObjectLoaded();
            }
          })
    };
  }

  _initServer() async {
    if (widget.onServerReady != null) widget.onServerReady!(false);
    final server = LocalAssetsServer(
      address: InternetAddress.loopbackIPv4,
      assetsBasePath: 'packages/three_model_viewer/web',
      logger: const DebugLogger(),
    );

    final address = await server.serve();

    setState(() {
      this.address = address.address;
      port = server.boundPort!;
      isListening = true;
    });
    if (widget.onServerReady != null) widget.onServerReady!(true);
  }

  @override
  Widget build(BuildContext context) {
    return isListening
        ? Stack(
            children: [
              if (!isReady) widget.showWhenLoading ?? const SizedBox(),
              WebView(
                debuggingEnabled: true,
                backgroundColor: Colors.transparent,
                initialUrl: 'http://$address:$port',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (c) {
                  controller = c;
                },
                onPageFinished: _onPageFinishedLoading,
                javascriptChannels: channels,
                onWebResourceError: (error) {
                  hasError = true;
                  if (widget.onError != null) {
                    widget.onError!(error.description);
                  }
                },
              ),
            ],
          )
        : const SizedBox();
  }
}
