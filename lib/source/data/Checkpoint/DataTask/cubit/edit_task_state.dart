part of 'edit_task_cubit.dart';

@immutable
abstract class EditTaskState {}

class EditTaskInitial extends EditTaskState {}
class EditTaskLoading extends EditTaskState {}
class EditTaskLoaded extends EditTaskState {
  final int? statusCode;
  dynamic json;

  EditTaskLoaded({this.statusCode, this.json});
}
