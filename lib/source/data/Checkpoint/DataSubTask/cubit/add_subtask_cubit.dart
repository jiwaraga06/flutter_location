import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';

part 'add_subtask_state.dart';

class AddSubtaskCubit extends Cubit<AddSubtaskState> {
  final MyReposity? myReposity;
  AddSubtaskCubit({required this.myReposity}) : super(AddSubtaskInitial());
  void addSubTask(id_task, sub_task, keterangan, is_aktif) async {
    emit(AddSubtaskLoading());
    var body = {
      'id_task': '$id_task',
      'sub_task': '$sub_task',
      'keterangan': '$keterangan',
      'is_aktif': '$is_aktif',
    };
    print(body);
    myReposity!.addSubTask(body).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('JSON ADD SUBTASK code: $statusCode');
      print('JSON ADD SUBTASK: $json');
      emit(AddSubtaskLoaded(json: json, statusCode: statusCode));
    });
  }
}
