import 'package:flutter_location/source/network/network.dart';

class MyReposity {
  final MyNetwork? myNetwork;

  MyReposity({required this.myNetwork});

  Future login(username,password, device_uuid) async {
    var body= {
      'barcode': "$username",
      'password': "$password",
      'device_uuid': "$device_uuid"
      // 'device_uuid': '06f2a2278d890a7d'
    };
    final json= await myNetwork!.login(body);
    return json;
  }
}