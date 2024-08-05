import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Interfaz extends StatelessWidget {
  final VoidCallback takePicture;
  final CameraController cameraController;

  const Interfaz({required this.takePicture, required this.cameraController});

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
                child: Icon(Icons.camera),
              ),
            ],
          );
        },
      ),
    );
  }
}


