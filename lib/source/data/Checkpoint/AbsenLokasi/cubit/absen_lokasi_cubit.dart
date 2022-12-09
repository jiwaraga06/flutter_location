import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'absen_lokasi_state.dart';

class AbsenLokasiCubit extends Cubit<AbsenLokasiState> {
  final MyReposity? myReposity;
  AbsenLokasiCubit({required this.myReposity}) : super(AbsenLokasiInitial());

  void postAbsenLokasi(id_lokasi, tasks) async {
    var tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var jam = DateFormat('HH:mm:ss').format(DateTime.now());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    emit(AbsenLokasiloading());
    await Geolocator.getCurrentPosition().then((value) {
      var body = {
        'data': [
          {
            'tgl_absen': '$tanggal $jam',
            'barcode': '$barcode',
            'id_lokasi': id_lokasi,
            'lati': '${value.latitude}',
            'longi': '${value.longitude}',
            'id_sync': null,
            'tasks': tasks,
          }
        ]
      };
      print('BODY: ${jsonEncode(body)}');
      var encode = jsonEncode(body);
      myReposity!.postAbsenLokasi(encode).then((value) {
        var json = jsonDecode(value.body);
        var statusCode = value.statusCode;
        print('JSON POST ABSEN code: $statusCode');
        print('JSON POST ABSEN: $json');
        emit(AbsenLokasiloaded(json: json, statusCode: statusCode));
      });
    }).catchError((onError) {
      print('Error Get Current Position: $onError');
    });
  }

  void postAbsenLokasiOffline(id_lokasi, nama_task, tasks) async {
    var tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var jam = DateFormat('HH:mm:ss').format(DateTime.now());
    var list = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    var dataLokal = pref.getString('datalokal');
    if (dataLokal != null) {
      var result = jsonDecode(dataLokal);
      list.add(result[0]);
    }
    emit(AbsenLokasiloading());
    await Geolocator.getCurrentPosition().then((value) async {
      var body = {
        'tgl_absen': '$tanggal $jam',
        'barcode': '$barcode',
        'id_lokasi': id_lokasi,
        'nama_task': nama_task,
        'lati': '${value.latitude}',
        'longi': '${value.longitude}',
        'id_sync': null,
        'tasks': tasks,
      };
      print('BODY: $body');
      list.add(body);
      await Future.delayed(Duration(seconds: 1));
      pref.setString('datalokal', jsonEncode(list));
      emit(AbsenLokasiloaded(json: {'message': 'Berhasil di simpan'}, statusCode: 200));
    }).catchError((onError) {
      print('Error Get Current Position: $onError');
    });
  }
}
