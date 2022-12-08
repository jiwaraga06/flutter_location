import 'package:location/location.dart';

class MyLocation {
  Location location = Location();
  Future getMyLocation() async {
    return await location.getLocation();
  }
}
