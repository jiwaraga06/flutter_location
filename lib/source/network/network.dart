import 'package:flutter_location/source/network/api.dart';
import 'package:http/http.dart' as http;

class MyNetwork {
  Future login(body) async {
    try {
      var url = Uri.parse(MyApi.apilogin());
      var response = await http.post(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
        },
        body: body
      );
      return response;
    } catch (e) {
      print("ERROR network login: $e");
    }
  }
}
