import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visual_ia/interfaz.dart';
import 'package:visual_ia/gemini.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.manageExternalStorage.request();
  _cameras = await availableCameras();
  runApp(const Camara());
}

class Camara extends StatefulWidget {
  const Camara({super.key});

  @override
  State<Camara> createState() => _EstadoCamara();
}

class _EstadoCamara extends State<Camara> {
  late CameraController _controller;
  String _descripcion = '';

  @override
  void initState() {
    super.initState();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
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
      final guardarImagen = await guardarImagenGaleria(pictureFile);

      if (guardarImagen != null) {
        final descripcion = await obtenerDescripcionGemini(guardarImagen.path);
        setState(() {
          _descripcion = descripcion;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<File?> guardarImagenGaleria(XFile imageFile) async {
    // // Verificar permiso de almacenamiento
    // final status = await Permission.manageExternalStorage.request();//Permission.storage.request();
    // if (true) {
    // //if (status.isGranted) {
    //   final directory = await getApplicationDocumentsDirectory();
    //   final newPath = directory.path + '/ImagenesVIA';
    //   final carpeta = Directory(newPath);
    //   await carpeta.create(recursive: true); // Crear directorio si no existe

    //   final file = File('${carpeta.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    //   await file.writeAsBytes(await imageFile.readAsBytes());
    //   return file; // Retornar el archivo guardado para posibles acciones
    // } else {
    //   print('Permiso de almacenamiento denegado');
    //   return null;
    // }

      final downlaodPath = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('$downlaodPath/$fileName');

      try {
        await file.writeAsBytes(await imageFile.readAsBytes());
      } catch (_) {}

      return file;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Interfaz(
        takePicture: _tomarImagen,
        cameraController: _controller,
        descripcion: _descripcion,
      ),
    );
  }
}