import 'dart:convert';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final MyReposity? myReposity;
  AuthCubit({required this.myReposity}) : super(AuthInitial());

  void splash(context) async {
    await Future.delayed(const Duration(seconds: 2));
    // Navigator.pushReplacementNamed(context, LOGIN);
    Navigator.pushNamedAndRemoveUntil(context, LOGIN, (route) => false);
  }

  void login(username, password) async {
    emit(LoginLoading());
    var device_uuid = "06f2a2278d890a7d";
    myReposity!.login(username, password, device_uuid).then((value) {
      var status = value.statusCode;
      var json = jsonDecode(value.body);
      print(status.toString());
      emit(LoginLoaded(json: json, statusCode: status));
      print("JSON: $json");
      // if (status == 200) {}
    });
  }
}
