import 'dart:convert';
import 'dart:io';
//import 'package:google_generative_ai/google_generative_ai.dart';
//import 'package:google_gemini/google_gemini.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final gemini = Gemini.instance;
//gemini.init(
  //apiKey: "AIzaSyCuuIS_FK2qqmqSkuAvzXxSUA_QL6dRu6E",
  //model: "gemini-1.5-pro");
//const apiKey = ''; 

Future<String> obtenerDescripcionGemini(String imagePath) async {
  final rutaImagen = imagePath;
  print(rutaImagen);
  try {
    final archivo = File('./assets/negro.jpg');
    //final bytes = archivo.readAsBytesSync();
    //final cadenaBase64 = base64Encode(bytes);
    //final bytesBase64 = base64.decode(cadenaBase64);
  final descripcion = await gemini.textAndImage(text: "Describe esta imagen en detalle", 
    images: [archivo.readAsBytesSync()]);

    //final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    //final response = await model.genera(
   //  [Content([bytesBase64, ])]
    print('esta es la descripcio:${descripcion}');
    return descripcion?.content?.parts?.last.text ?? 'No se pudo obtener una descripción';
  } catch (error) {
    print('Error al generar la descripción: $error');
    return 'No se pudo obtener una descripción en este momento. Intenta nuevamente más tarde.';
  }
}



