import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/Offline/Sql/sql.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

part 'checkpoint_list_state.dart';

class CheckpointListCubit extends Cubit<CheckpointListState> {
  final MyReposity? myReposity;
  CheckpointListCubit({required this.myReposity}) : super(CheckpointListInitial());
  final Future<Database> dbFuture = SQLHelper.db();
  void checkpoint() {
    final Future<Database> dbFuture = SQLHelper.db();
    emit(CheckpointListLoading());
    myReposity!.checkpoint().then((value) async {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      // print('Checkpoint: $json');
      emit(CheckpointListLoaded(statusCode: statusCode, json: json));
      json.forEach((e) async {
        await SQLHelper.insertLokasi(
            e['id'], e['nama_lokasi'], e['lati'], e['longi'], e['keterangan'], e['created_at'], e['updated_at'], e['user_creator'], e['aktif']);
        e['tasks'].forEach((task) async {
          await SQLHelper.insertTask(task['id'], task['id_lokasi'], task['task'], task['created_at'], task['updated_at'], task['user_creator']);
          task['sub_task'].forEach((sub_task) async {
            await SQLHelper.insertSubTask(sub_task['id'], sub_task['id_task'], sub_task['sub_task'], sub_task['keterangan'], sub_task['is_aktif'],
                sub_task['created_at'], sub_task['updated_at']);
          });
        });
      });
    });
  }

  void checkpointOffline() {
    emit(CheckpointListLoading());
    Future join = SQLHelper.getLokasiTaskSubtask();
    join.then((value) {
      emit(CheckpointListLoaded(statusCode: 200, json: value));
    });
  }
}
