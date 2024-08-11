//import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
//import 'package:google_gemini/google_gemini.dart';


Future<String> obtenerDescripcionGemini(String imagePath) async {
  try {
    final archivo = File(imagePath);
    
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: "api key");
    final response = await model.generateContent([
      Content.text("Describe la imagen en español"),
      Content.data("image/image.png", archivo.readAsBytesSync()),
    ]);
    return response.text.toString();
  } catch (error) {
    print('Error al generar la descripción: $error');
    return 'No se pudo obtener una descripción en este momento. Intenta nuevamente más tarde.';
  }
}