part of 'add_task_cubit.dart';

@immutable
abstract class AddTaskState {}

class AddTaskInitial extends AddTaskState {}
class AddTaskLoading extends AddTaskState {}
class AddTaskLoaded extends AddTaskState {
  final int? statusCode;
  dynamic json;

  AddTaskLoaded({this.statusCode, this.json});
}
