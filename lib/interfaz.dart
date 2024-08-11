import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Interfaz extends StatelessWidget {
  final VoidCallback takePicture;
  final CameraController cameraController;
  final String descripcion;

  const Interfaz({
    Key? key,
    required this.takePicture,
    required this.cameraController,
    required this.descripcion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(162, 118, 255, 1),
      appBar: AppBar(
        title: const Text('Visual AI'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(162, 118, 255, 1),
        titleTextStyle: const TextStyle(
          fontFamily: 'RobotoMono',
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w900,
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: CameraPreview(cameraController),
                ),
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: takePicture,
                child: const Icon(Icons.camera),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Text(
              //     descripcion,
              //     style: const TextStyle(fontSize: 18),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}