import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visual_ia/interfaz.dart';
import 'package:visual_ia/gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  final FlutterTts flutterTts = FlutterTts();
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

Future _reproducirVoz(String text) async {
  try {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(2.0);
    await flutterTts.speak(text);
  } catch (e) {
    print('Error reproducir voz: $e');
  }
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
        _reproducirVoz(_descripcion);
      }
      
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<File?> guardarImagenGaleria(XFile imageFile) async {

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