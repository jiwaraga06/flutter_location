part of 'edit_subtask_cubit.dart';

@immutable
abstract class EditSubtaskState {}

class EditSubtaskInitial extends EditSubtaskState {}
class EditSubtaskLoading extends EditSubtaskState {}
class EditSubtaskLoaded extends EditSubtaskState {
  final int? statusCode;
  dynamic json;

  EditSubtaskLoaded({this.statusCode, this.json});
}
