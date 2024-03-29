import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_location/source/data/Offline/Sql/sql.dart';
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
    "autoConnect": false
  });
  // IO.Socket socket = IO.io('https://api2.sipatex.co.id:2053', IO.OptionBuilder().setTransports(["websocket"]).build());
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  var listHistory = [];

  void getInfoAll() async {
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
    final db = await SQLHelper.db();
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
      location.changeNotificationOptions(title: 'Security Point', channelName: 'Notif', subtitle: 'Tracking Location | Berjalan');
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
        await SQLHelper.insertHistory(barcode, nama, currentLocation.latitude, currentLocation.longitude, warna, gender, DateTime.now().toString());
        final result = await db.query('history');
        // print(result.length);

        var body = {
          'data_lokasi': result.map((e) {
            var a = {
              "barcode": e['barcode'],
              "nama": e['nama'],
              "lat": e['lat'],
              "lng": e['lng'],
              "warna": e['warna'],
              "gender": e['gender'],
              'waktu': e['waktu']
            };
            return a;
          }).toList()
        };
        var encode = jsonEncode(body);
        print("Result length: ${result.length}");
        if (result.length >= 10) {
          // Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
          // whenevery connection status is changed.
          // print('Status Koneksi: $result');
          // if (connectivityResult == ConnectivityResult.mobile) {
          myReposity!.postHistoryLokasiSecurity(encode).then((value) async {
            var json = jsonDecode(value.body);
            var statusCode = value.statusCode;
            if (statusCode == 200) {
              await SQLHelper.deleteHistory();
            } else if (json == 'Holding') {
              print('di holding');
            }
            print('MSG POST HISTORY: $json');
          });
          // }
          // else if (connectivityResult == ConnectivityResult.wifi) {
          //   myReposity!.postHistoryLokasiSecurity(encode).then((value) async {
          //     var json = jsonDecode(value.body);
          //     var statusCode = value.statusCode;
          //     if (statusCode == 200) {
          //       await SQLHelper.deleteHistory();
          //     } else if (json == 'Holding') {
          //       print('di holding');
          //     }
          //     print('MSG POST HISTORY: $json');
          //   });
          // }
          // });
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
      if (backgroundExecution) {}
    } else {
      print('not granted');
    }
  }

  void permissionCheck() async {
    print('Background');
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
      if (backgroundExecution) {}
    } else {
      print('not granted');
    }
  }
}
