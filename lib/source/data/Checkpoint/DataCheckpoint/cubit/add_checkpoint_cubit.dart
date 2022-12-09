import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/Offline/Sql/sql.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'add_checkpoint_state.dart';

class AddCheckpointCubit extends Cubit<AddCheckpointState> {
  final MyReposity? myReposity;
  AddCheckpointCubit({required this.myReposity}) : super(AddCheckpointInitial());

  void addCheckpoint(nama_lokasi, keterangan, lati, longi) async {
    emit(AddCheckpointLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    var body = {
      'user_creator': '$barcode',
      'nama_lokasi': '$nama_lokasi',
      'lati': '$lati',
      'longi': '$longi',
      'keterangan': '$keterangan',
    };
    print(body);
    myReposity!.addCheckpoint(body).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('ADD LOKASI: $json');
      emit(AddCheckpointLoaded(json: json, statusCode: statusCode));
    });
  }

  void uploadCheckpoint(id,nama_lokasi, keterangan, lati, longi) async {
    emit(AddCheckpointLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    var body = {
      'user_creator': '$barcode',
      'nama_lokasi': '$nama_lokasi',
      'lati': '$lati',
      'longi': '$longi',
      'keterangan': '$keterangan',
    };
    print(body);
    myReposity!.addCheckpoint(body).then((value) async{
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('ADD LOKASI: $json');
      if(statusCode == 200){
        await SQLHelper.deleteLokasi(id);
      }
      emit(AddCheckpointLoaded(json: json, statusCode: statusCode));
    });
  }
}
