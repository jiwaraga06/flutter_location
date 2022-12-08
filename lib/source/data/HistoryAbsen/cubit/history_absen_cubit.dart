import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'history_absen_state.dart';

class HistoryAbsenCubit extends Cubit<HistoryAbsenState> {
  final MyReposity? myReposity;
  HistoryAbsenCubit({required this.myReposity}) : super(HistoryAbsenInitial());

  void getHistory(tgl_awal, tgl_akhir) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var role = pref.getString('user_roles');
    var barcode = pref.getString('barcode');
    var decodeRole = jsonDecode(role.toString());
    print(decodeRole);
    emit(HistoryAbsenLoading());
    if (decodeRole.length == 2) {
      print('role2');
      myReposity!.getHistory(tgl_awal, tgl_akhir).then((value) {
        var json = jsonDecode(value.body);
        var statusCode = value.statusCode;
        print('History: $json');
        emit(HistoryAbsenLoaded(json: json, statusCode: statusCode));
      });
    } else if (decodeRole.length == 1) {
      if (decodeRole[0]=='security') {
        print('role security');
        myReposity!.getHistorybarcode(barcode, tgl_awal, tgl_akhir).then((value) {
          var json = jsonDecode(value.body);
          var statusCode = value.statusCode;
          print('History: $json');
          emit(HistoryAbsenLoaded(json: json, statusCode: statusCode));
        });
      } else if (decodeRole[0]=='admin_scr') {
        print('role admin_scr');
        myReposity!.getHistory(tgl_awal, tgl_akhir).then((value) {
          var json = jsonDecode(value.body);
          var statusCode = value.statusCode;
          print('History: $json');
          emit(HistoryAbsenLoaded(json: json, statusCode: statusCode));
        });
      }
    }
  }

  void getHistoryBarcode(tgl_awal, tgl_akhir) async {
    emit(HistoryAbsenLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    myReposity!.getHistorybarcode(barcode, tgl_awal, tgl_akhir).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('History: $json');
      emit(HistoryAbsenLoaded(json: json, statusCode: statusCode));
    });
  }
}
