import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_assets_server/local_assets_server.dart';
import 'package:three_model_viewer/model_viewer_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ModelViewer extends StatefulWidget {
  final String modelUrl;
  final Function(ModelViewerController controller) onPageLoaded;
  final Function(bool ready)? onServerReady;
  final Function(double? percentage)? onObjectLoading;
  final Function()? onObjectLoaded;
  final Function(Object error)? onError;
  final Widget? showWhenLoading;

  const ModelViewer({
    Key? key,
    required this.modelUrl,
    required this.onPageLoaded,
    this.onServerReady,
    this.onError,
    this.onObjectLoaded,
    this.onObjectLoading,
    this.showWhenLoading,
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

  void setupScene() {
    if (hasError) return;
    controller?.runJavascript('window.setupScene()');
  }

  void loadModel() {
    if (hasError) return;
    controller?.runJavascript('window.loadModel(\'${widget.modelUrl}\')');
  }

  void setBackgroundColor(String color, double alpha) {
    if (hasError) return;
    controller?.runJavascript('window.setBackgroundColor(\'$color\', $alpha)');
  }

  void setCameraPosition(double x, double y, double z) {
    if (hasError) return;
    controller?.runJavascript('window.setCameraPosition($x, $y, $z)');
  }

  void addAmbientLight(String color, int intensity) {
    if (hasError) return;
    controller?.runJavascript('window.addAmbientLight(\'$color\', $intensity)');
  }

  void _onObjectLoaded() {
    if (widget.onObjectLoaded != null) widget.onObjectLoaded!();
    Timer(const Duration(milliseconds: 400), () {
      setState(() {
        isReady = true;
      });
    });
  }

  void _onPageFinishedLoading(_) {
    setupScene();
    loadModel();
    widget.onPageLoaded(ModelViewerController(
      setBackgroundColor: setBackgroundColor,
      addAmbientLight: addAmbientLight,
      setCameraPosition: setCameraPosition,
    ));
  }

  @override
  initState() {
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
