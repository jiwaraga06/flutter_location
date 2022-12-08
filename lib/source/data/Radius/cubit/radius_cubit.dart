import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'radius_state.dart';

class RadiusCubit extends Cubit<RadiusState> {
  final MyReposity? myReposity;
  RadiusCubit({required this.myReposity}) : super(RadiusInitial());

  void getRadius() async {
    emit(RadiusLoding());
    SharedPreferences pref = await SharedPreferences.getInstance();
    myReposity!.getRadius().then((value) {
      var json = jsonDecode(value.body);
      pref.setInt('radius', json['radius']);
      var statusCode = value.statusCode;
      print('JSON RADIUS: $json');
      emit(RadiusLoded(radius: json['radius'], statusCode: statusCode));
    });
  }
}
