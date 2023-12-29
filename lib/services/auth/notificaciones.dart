import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> enviarNotificacion(String titulo, String contenido) async {
  var claveApi = 'NDA0MmZmYzktOTQzNS00ZWUzLTg3NzYtMGM4NzY4YTA3ZTg2'; // Asegúrate de reemplazar esto con tu clave real
  var claveApiBase64 = base64Encode(utf8.encode(claveApi));
  
  var headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization': 'Basic $claveApi'
  };


  var request = http.Request('POST', Uri.parse('https://onesignal.com/api/v1/notifications'));
  request.body = json.encode({
    "app_id": "96221739-4b13-46a8-825b-2987269a801b",
    "included_segments": ["Total Subscriptions"],
    "headings": {"en": titulo},
    "contents": {"en": contenido}
  });
  request.headers.addAll(headers);

  try {
    var responseStream = await request.send();
final response = await http.Response.fromStream(responseStream);

    if (response.statusCode == 200) {
  print('Notificación enviada con éxito');
} else {
  print('Error al enviar notificación: ${response.statusCode}');
  print('Respuesta del servidor: ${response.body}');
}
  } catch (e) {
    print('Error al enviar notificación: $e');
  }
}
