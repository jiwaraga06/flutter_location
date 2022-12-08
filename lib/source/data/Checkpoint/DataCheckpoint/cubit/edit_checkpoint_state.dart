part of 'edit_checkpoint_cubit.dart';

@immutable
abstract class EditCheckpointState {}

class EditCheckpointInitial extends EditCheckpointState {}
class EditCheckpointLoading extends EditCheckpointState {}
class EditCheckpointLoaded extends EditCheckpointState {
  final int? statusCode;
  dynamic json;

  EditCheckpointLoaded({this.statusCode, this.json});
}
