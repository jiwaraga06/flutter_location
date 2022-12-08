part of 'add_subtask_cubit.dart';

@immutable
abstract class AddSubtaskState {}

class AddSubtaskInitial extends AddSubtaskState {}
class AddSubtaskLoading extends AddSubtaskState {}
class AddSubtaskLoaded extends AddSubtaskState {
  final int? statusCode;
  dynamic json;

  AddSubtaskLoaded({this.statusCode, this.json});
}
