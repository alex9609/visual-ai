import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:visual_ia/interfaz.dart'; 
import 'package:path_provider/path_provider.dart';
import 'dart:io';

late List<CameraDescription> _cameraDisponible;

Future<void> main() async {
  // Inicializar la camara
  WidgetsFlutterBinding.ensureInitialized();
  _cameraDisponible = await availableCameras();

  runApp(const Camara());
}

class Camara extends StatefulWidget {
  const Camara({super.key});

  @override
  State<Camara> createState() => _EstadoCamara();
}

class _EstadoCamara extends State<Camara> {
  // controlador de la camara
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializar la camara
    _controller = CameraController(_cameraDisponible[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _tomarImagen() async {
    if (!_controller.value.isInitialized) {
      return;
    }
    try {
      final XFile pictureFile = await _controller.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final newPath = directory.path + '/ImagenesVIA';
      final carpeta = await Directory(newPath).create(recursive: true);
      
      // validar existencia de carpeta

      if (carpeta.existsSync()){
        final file = File('${carpeta.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(await pictureFile.readAsBytes());
        print("Existe tamaño: ${ await file.lengthSync()}");
      }else{
        print("No se ha creado carpeta");
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Interfaz(takePicture: _tomarImagen, cameraController: _controller), 
    );
  }
}
