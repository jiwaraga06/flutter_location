import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';

part 'ganti_password_state.dart';

class GantiPasswordCubit extends Cubit<GantiPasswordState> {
  final MyReposity? myReposity;
  GantiPasswordCubit({required this.myReposity}) : super(GantiPasswordInitial());

  void gantiPassword(barcode, pass, new_pass) async {
    emit(GantiPasswordLoading());
    var body = {
      'barcode': '$barcode',
      'password': '$pass',
      'new_password': '$new_pass'
    };
    print(body);
    myReposity!.gantiPassword(body).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Ganti code: $statusCode');
      print('Ganti PW: $json');
      emit(GantiPasswordLoaded(json: json, statusCode: statusCode));
    });
  }
}
