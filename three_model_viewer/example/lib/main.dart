import 'dart:math';

import 'package:flutter/material.dart';
import 'package:three_model_viewer/three_model_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text('Open model'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Model(),
          ));
        },
      )),
    );
  }
}

class Model extends StatefulWidget {
  const Model({Key? key}) : super(key: key);

  @override
  State<Model> createState() => _ModelState();
}

class _ModelState extends State<Model> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.teal[900],
        body: ModelViewer(
          models: [
            ThreeModel(
              src:
                  'https://storage.googleapis.com/flutter-futx.appspot.com/test/FutX_Junto_meioTermo.glb',
              playAnimation: true,
            ),
            // ThreeModel(
            //   src:
            //       '"https://storage.googleapis.com/flutter-futx.appspot.com/test/FutX_Camera.glb',
            //   playAnimation: false,
            // ),
          ],
          cameraConfig: PerspectiveCameraConfig.def(),
          onPageLoaded: (controller) {
            controller.setOrbitControls(
                OrbitControls(minPolarAngle: pi / 2, maxPolarAngle: pi / 2));
            controller.setBackgroundColor('#000', 0);
            // controller.setCameraPosition(Vector3(x: 0, y: 5, z: 2));
            controller.setControlsTarget(Vector3(x: 1, y: 2, z: 3));
            controller.addAmbientLight('#404040', 2);
            controller.addDirectionalLight(
              DirectionalLight(
                color: Colors.white,
                intensity: 2,
                pos: Vector3(x: 10, y: 20, z: 30),
              ),
            );
            controller.enableZoom(true);
          },
          onObjectLoading: (percentage) {
            print('$percentage');
          },
          onServerReady: (ready) => print('Server Ready: $ready'),
          showWhenLoading: const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
