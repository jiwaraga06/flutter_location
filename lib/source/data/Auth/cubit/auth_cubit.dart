import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final MyReposity? myReposity;
  AuthCubit({required this.myReposity}) : super(AuthInitial());

  void splash(context) async {
    await Future.delayed(const Duration(seconds: 2));
    // Navigator.pushReplacementNamed(context, LOGIN);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString("barcode");
    if (barcode != null) {
      Navigator.pushNamedAndRemoveUntil(context, BOTTOM_TABBAR, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, LOGIN, (route) => false);
    }
  }

  void login(context, username, password) async {
    // var device_uuid = "06f2a2278d890a7d";
    var device_uuid;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      print(iosDeviceInfo.identifierForVendor);
      device_uuid = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print(androidDeviceInfo.id);
      device_uuid = androidDeviceInfo.id;
    }
    emit(LoginLoading());
    final pref = await SharedPreferences.getInstance();
    myReposity!.login(username, password, device_uuid).then((value) async {
      var status = value.statusCode;
      var json = jsonDecode(value.body);
      print(status);
      print(value.body);
      emit(LoginLoaded(json: json, statusCode: status));
      print("JSON: $json");
      if (status == 200 && json['message'] == "Berhasil login") {
        pref.setString("barcode", json['data']['barcode']);
        pref.setString("nama", json['data']['nama']);
        pref.setString("user_roles", jsonEncode(json['data']['user_roles']));
        pref.setString("warna", json['data']['line_color']);
        pref.setString("gender", json['data']['gender']);
        pref.setString("deviceID", json['data']['device_uuid']);
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(context, BOTTOM_TABBAR, (route) => false);
      }
    });
  }

  void logout(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    emit(LogoutLoading());
    var body = {'barcode': '$barcode'};
    myReposity!.logout(body).then((value) async {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('LOGOUT code: $statusCode');
      print('LOGOUT : $json');
      if (statusCode == 200) {
        pref.remove('barcode');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          autoHide: Duration(seconds: 2),
          dismissOnTouchOutside: false,
          title: 'Berhasil',
          desc: '${json['message']} \n Akun Logout Otomatis',
        ).show();
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushNamedAndRemoveUntil(context, LOGIN, (route) => false);
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          autoDismiss: true,
          title: 'Error !',
          desc: '${json['mesage']} \n ${json['errors']}',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      }
      emit(LogoutLoaded(json: json, statusCode: statusCode));
    });
  }
}
