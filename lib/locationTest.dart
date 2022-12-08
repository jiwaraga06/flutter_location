import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TesterLocation extends StatefulWidget {
  const TesterLocation({super.key});

  @override
  State<TesterLocation> createState() => _TesterLocationState();
}

class _TesterLocationState extends State<TesterLocation> {
  IO.Socket socket = IO.io('https://api2.sipatex.co.id:2053', <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false
  });
  LocationData? _currentPosition;
  String? _address, _dateTime;
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    socket.connect();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    location.enableBackgroundMode();
    location.onLocationChanged.listen((LocationData currentLocation) async {
      print("${currentLocation.latitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        print("connect location");
        socket.emit('test', {
          "barcode": 202009016,
          "nama": "Raga Puteraku Dermawan",
          "lat": currentLocation.latitude,
          "lng": currentLocation.longitude,
          "warna": "blue",
          "gender": "l",
          'waktu': DateTime.now().toString()
        });
      });
    });
  }

  void belakang() async {
    var hasPermissions = await FlutterBackground.hasPermissions;
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "flutter_background example app",
      notificationText: "Background notification for keeping the example app running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      // notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
    if (hasPermissions) {
      final backgroundExecution = await FlutterBackground.enableBackgroundExecution();
      // Timer.periodic(Duration(seconds: 2), (timer) {
      //   print("o");
      // });

      if (backgroundExecution) {}
    }
    FlutterBackground.isBackgroundExecutionEnabled;
  }

  @override
  void initState() {
    super.initState();

    socket.connect();
    socket.on('connect', (data) {
      print("connect");
      print(data);
    });
    socket.on('connect_error', (data) {
      print("connect error");
      print(data);
    });
    socket.on('disconnect', (data) {
      print("disconnect");
      print(data);
    });
    socket.on('error', (data) {
      print("error");
      print(data);
    });
    print(DateTime.now());
    // socket.onConnect((data) {
    //   print("Status");
    //   print(data);
    // });
    getLoc();
    // belakang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Location"),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
