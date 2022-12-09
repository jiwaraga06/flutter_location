import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'absen_lokal_state.dart';

class AbsenLokalCubit extends Cubit<AbsenLokalState> {
  AbsenLokalCubit() : super(AbsenLokalInitial());

  void getAbsenLokal() async {
    emit(AbsenLokalLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var datalokal = pref.getString('datalokal');
    var encode = jsonDecode(datalokal.toString());
    print('Data lokal');
    print(encode);
    emit(AbsenLokalLoaded(statusCode: 200, json: encode));
  }

}
