import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';

part 'edit_subtask_state.dart';

class EditSubtaskCubit extends Cubit<EditSubtaskState> {
  final MyReposity? myReposity;
  EditSubtaskCubit({required this.myReposity}) : super(EditSubtaskInitial());
  void editSubTask(id_sub_task, id_task, sub_task, keterangan, is_aktif) async {
    emit(EditSubtaskLoading());
    var body = {
      'id': '$id_sub_task',
      'id_task': '$id_task',
      'sub_task': '$sub_task',
      'keterangan': '$keterangan',
      'is_aktif': '$is_aktif',
    };
    print(body);
    myReposity!.editSubTask(body).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('JSON EDIT SUBTASK code: $statusCode');
      print('JSON EDIT SUBTASK: $json');
      emit(EditSubtaskLoaded(json: json, statusCode: statusCode));
    });
  }
}
