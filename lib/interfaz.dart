import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Interfaz extends StatelessWidget {
  final VoidCallback takePicture;
  final CameraController cameraController;

  const Interfaz({required this.takePicture, required this.cameraController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 162, 23, 1),
      appBar: AppBar(
        title: const Text('Visual IA'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 32),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          
          Expanded(
            child: CameraPreview(cameraController),
          ),
        
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: takePicture,
        child: Icon(Icons.camera),
      ),
    );
  }
}
