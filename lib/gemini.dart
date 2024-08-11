import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String> obtenerDescripcionGemini(String imagePath) async {
  try {
    final archivo = File(imagePath);
    // final apiKey = Platform.environment['API_KEY'];
    // if (apiKey == null) {
    //   print('No \$API_KEY environment variable');
    //   exit(1);
    // }
    
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



