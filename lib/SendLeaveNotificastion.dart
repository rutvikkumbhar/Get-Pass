import 'package:http/http.dart' as http;
import 'dart:convert';
import 'GetServerKey.dart';

Future<void> sendNotification({
  required String title,
  required String body,
  required String fcmToken,
}) async {
  String serverKey=await Getserverkey().getServerKeyToken();
  final url = Uri.parse('https://fcm.googleapis.com/v1/projects/get-pass-e77e5/messages:send');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $serverKey',
  };

  final payload = {
    "message":{
      "token":fcmToken,
      "notification":{
        "body":body,
        "title":title
      },
      "data": {
        "story_id": "story_12345"
      }
    }
  };

  final response = await http.post(
    url,
    headers: headers,
    body: json.encode(payload),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully!');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}
