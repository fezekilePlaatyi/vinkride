import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Vinkdriver/constants.dart';

class DynamicLinks {
  Future createDynamicLink(String url) async {
    final http.Response response = await http.post(
      '${Constants.DYNAMIC_LINKS_CREATE_URL}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "longDynamicLink": "https://vinkapp.page.link/?link=$url"
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return json.decode('Failed to send data to Server. Error $response');
    }
  }
}
