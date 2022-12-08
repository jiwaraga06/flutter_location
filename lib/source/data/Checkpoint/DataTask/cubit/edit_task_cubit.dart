import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final MyReposity? myReposity;
  EditTaskCubit({required this.myReposity}) : super(EditTaskInitial());
  void editTask(id_lokasi, id_task,task) async {
    emit(EditTaskLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    var body = {
      'id': '$id_task',
      'id_lokasi': '$id_lokasi',
      'task': '$task',
      'user_creator': '$barcode',
    };
    print(body);
    myReposity!.editTask(body).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Edit TASK code: $statusCode');
      print('Edit TASK: $json');
      emit(EditTaskLoaded(json: json, statusCode: statusCode));
    });
  }
}
