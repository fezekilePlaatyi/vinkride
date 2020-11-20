import 'package:passenger/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Payment {
  prepareCheckout(Map<String, dynamic> paymentData) async {
    print("onSend Payment Proccess");
    final http.Response response = await http.post(
        '${Constants.PAYMENT_SERVER_ADDRESS}/app/paymentCheckout',
        body: paymentData);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return json.decode('Failed to send data to Server. Error');
    }
  }
}
