import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/Offline/Sql/sql.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'distance_state.dart';

class DistanceCubit extends Cubit<DistanceState> {
  final MyReposity? myReposity;
  DistanceCubit({required this.myReposity}) : super(DistanceInitial());

  void hitungJarak(id_lokasi, latQr, longQr, isOffline) async {
    emit(DistanceLoading());
    print('Is OFFLINE: $isOffline');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var radius = pref.getInt('radius');
    await Geolocator.getCurrentPosition().then((value) {
      print('LatQr: $latQr - LongQr: $longQr');
      print('My Position: $value');
      var valueDistance = Geolocator.distanceBetween(latQr!, longQr!, value.latitude, value.longitude);
      if (isOffline == true) {
        myReposity!.getRadius().then((value) async {
          var json = jsonDecode(value.body);
          pref.setInt('radius', json['radius']);
          var radius = pref.getInt('radius');
          var statusCode = value.statusCode;
          print('JSON RADIUS: $json');

          if (valueDistance <= json['radius']) {
            print('Dekat');
            emit(DistanceLoaded(data: {'jarak': valueDistance, 'status': 1}));
            getTaskByLokasi(id_lokasi);
          } else {
            print('Jauh');
            emit(DistanceLoaded(data: {'jarak': valueDistance, 'status': 0}));
          }
        });
      } else if (isOffline == false) {
        if (valueDistance <= radius!) {
          print('Dekat');
          emit(DistanceLoaded(data: {'jarak': valueDistance, 'status': 1}));
          getTaskByLokasiLokal(id_lokasi);
        } else {
          print('Jauh');
          emit(DistanceLoaded(data: {'jarak': valueDistance, 'status': 0}));
        }
      }
      print('Jarak: $valueDistance');
    }).catchError((e) {
      print('Error Get Current Position: $e');
    });
  }

  void getTaskByLokasi(id_lokasi) async {
    emit(AbsenSecurityLoading());
    myReposity!.getTaskByLokasi(id_lokasi).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('JSON TASK by id: $json');
      emit(AbsenSecurityLoaded(data: json, statusCode: statusCode));
    });
  }

  void getTaskByLokasiLokal(id_lokasi) async {
    emit(AbsenSecurityLoading());
    Future history = SQLHelper.getLokasiByID(id_lokasi);
    history.then((value) {
      print('value');
      print(value);
      emit(AbsenSecurityLoaded(data: value, statusCode: 200));
    });
  }
}
