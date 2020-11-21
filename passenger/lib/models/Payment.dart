import 'dart:convert';
import 'package:http/http.dart' as http;

class Payment {
  prepareCheckout(Map<String, String> paymentData) async {
    print("onSend Payment Proccess");
    final http.Response response = await http.post(
      'https://us-central1-vink8-za.cloudfunctions.net/app/paymentCheckout',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(paymentData),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.body);
      return json.decode('Failed to send data to Server. Error');
    }
  }
}
