import 'dart:async';
import 'dart:convert';
import 'package:flutter_background/flutter_background.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tab_bar_state.dart';

class TabBarCubit extends Cubit<TabBarState> {
  final MyReposity? myReposity;
  TabBarCubit({required this.myReposity}) : super(TabBarInitial());
  IO.Socket socket = IO.io('https://api2.sipatex.co.id:2053', <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": true
  });
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  var listHistory = [];

  void getInfoAll() async {
    emit(TabBarLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString("barcode");
    var nama = pref.getString("nama");
    var user_roles = pref.getString("user_roles");
    var warna = pref.getString("warna");
    var gender = pref.getString("gender");
    if (user_roles != null) {
      emit(TabBarLoaded(user_roles: user_roles, data: {
        'barcode': barcode,
        'nama': nama,
        'warna': warna,
        'gender': gender,
      }));
    }
  }

  void socketConnect() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    var nama = pref.getString('nama');
    var warna = pref.getString('warna');
    var gender = pref.getString('gender');
    socket.connect();
    socket.on('connect', (data) {
      print("connect");
      print(data);
    });
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('granted');

        return;
      }
    }

    _locationData = await location.getLocation();
    if (barcode != null) {
      location.isBackgroundModeEnabled();
      location.changeNotificationOptions(title: 'Push', channelName: 'Notif',subtitle: 'subtitle');
      location.enableBackgroundMode(enable: true);
      location.onLocationChanged.listen((LocationData currentLocation) async {
        // print(currentLocation);
        // print("connect location");
        socket.emit('test', {
          "barcode": barcode,
          "nama": nama,
          "lat": currentLocation.latitude,
          "lng": currentLocation.longitude,
          "warna": warna,
          "gender": gender,
          'waktu': DateTime.now().toString()
        });
        //
        listHistory.add({
          "barcode": barcode,
          "nama": nama,
          "lat": currentLocation.latitude,
          "lng": currentLocation.longitude,
          "warna": warna,
          "gender": gender,
          'waktu': DateTime.now().toString()
        });
        var body = {'data_lokasi': listHistory.toList()};
        var encode = jsonEncode(body);
        // print(encode);
        if (listHistory.length >= 10) {
          myReposity!.postHistoryLokasiSecurity(encode).then((value) {
            var json = jsonDecode(value.body);
            var statusCode = value.statusCode;
            if (statusCode == 200) {
              listHistory.clear();
            }
            // print('MSG POST HISTORY: $json');
          });
        }
      });
    }
    socket.on('connect_error', (data) {
      // print("connect error");
      print(data);
    });
    socket.on('disconnect', (data) {
      // print("disconnect");
      print(data);
    });
    socket.on('error', (data) {
      // print("error");
      print(data);
    });
  }

  void background() async {
    print('Background');
    var hasPermissions = await FlutterBackground.hasPermissions;
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Security Point",
      notificationText: "Background notification for keeping the example app running in the background",
      notificationImportance: AndroidNotificationImportance.High,
      notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
    print(hasPermissions);
    if (hasPermissions) {
      final backgroundExecution = await FlutterBackground.enableBackgroundExecution();
      print('granted');
      // Timer.periodic(Duration(seconds: 2), (timer) {
      //   print("o");
      // });
      FlutterBackground.isBackgroundExecutionEnabled;
      if (backgroundExecution) {
        
      }
    } else {
      print('not granted');
    }
  }
  
}
