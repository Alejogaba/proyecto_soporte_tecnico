import 'dart:convert';
import 'package:http/http.dart' as http;
class Utilidades {
  String capitalizarPalabras(String texto) {
  List<String> palabras = texto.split(' ');
  for (int i = 0; i < palabras.length; i++) {
    String palabra = palabras[i];
    if (palabra.isNotEmpty) {
      palabras[i] = palabra[0].toUpperCase() + palabra.substring(1).toLowerCase();
    }
  }
  return palabras.join(' ');
}
Future<void> sendNotification(String token, String title, String body) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAJQiQggw:APA91bFOK9ueBLkt_tMxHlbNHo1MyNyuQRWgnOn9OUqPKNawk4cpa3pPE8luKS9wEr2eCiXZc3LFDzwK9R3m2xlBtjtAYmlHQw7uwp4kCnGZ1-GA8E6o0rTqZPQzLVU_GVHTQqGi4XeM',
    };

    final message = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(message),
    );

    if (response.statusCode == 200) {
      print('Notificación enviada correctamente');
    } else {
      print('Error al enviar la notificación');
    }
  } 
}