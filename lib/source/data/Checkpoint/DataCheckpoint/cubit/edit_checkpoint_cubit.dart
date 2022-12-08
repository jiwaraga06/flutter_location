import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'edit_checkpoint_state.dart';

class EditCheckpointCubit extends Cubit<EditCheckpointState> {
  final MyReposity? myReposity;
  EditCheckpointCubit({required this.myReposity}) : super(EditCheckpointInitial());
  void editCheckpoint(id,nama_lokasi, keterangan, lati, longi) async {
    emit(EditCheckpointLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    var body = {
      'id': '$id',
      'user_creator': '$barcode',
      'nama_lokasi': '$nama_lokasi',
      'lati': '$lati',
      'longi': '$longi',
      'keterangan': '$keterangan',
    };
    print(body);
    myReposity!.updateCheckpoint(body).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('ADD LOKASI: $json');
      emit(EditCheckpointLoaded(json: json, statusCode: statusCode));
    });
  }
}
