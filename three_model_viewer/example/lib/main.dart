import 'package:flutter/material.dart';
import 'package:three_model_viewer/model_viewer.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: ModelViewer(
          modelUrl:
              'https://storage.googleapis.com/flutter-futx.appspot.com/test/test.gltf',
          onPageLoaded: (controller) {
            controller.setBackgroundColor('#000', .2);
            controller.setCameraPosition(0, 5, 2);
            controller.addAmbientLight('#404040', 10);
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
