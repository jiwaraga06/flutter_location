import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/Offline/Sql/sql.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final MyReposity? myReposity;
  AddTaskCubit({required this.myReposity}) : super(AddTaskInitial());
  void addTask(id_lokasi, task) async {
    emit(AddTaskLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    var body = {
      'id_lokasi': '$id_lokasi',
      'task': '$task',
      'user_creator': '$barcode',
    };
    print(body);
    myReposity!.addTask(body).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('ADD TASK code: $statusCode');
      print('ADD TASK: $json');
      emit(AddTaskLoaded(json: json, statusCode: statusCode));
    });
  }

  void uploadTask(id, id_lokasi, task) async {
    emit(AddTaskLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    var body = {
      'id_lokasi': '$id_lokasi',
      'task': '$task',
      'user_creator': '$barcode',
    };
    print(body);
    myReposity!.addTask(body).then((value) async {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('ADD TASK code: $statusCode');
      print('ADD TASK: $json');
      if(statusCode == 200){
        await SQLHelper.deleteTask(id);
      }
      emit(AddTaskLoaded(json: json, statusCode: statusCode));
    });
  }
}
