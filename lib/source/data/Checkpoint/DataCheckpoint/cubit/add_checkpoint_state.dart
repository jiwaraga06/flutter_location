part of 'add_checkpoint_cubit.dart';

@immutable
abstract class AddCheckpointState {}

class AddCheckpointInitial extends AddCheckpointState {}
class AddCheckpointLoading extends AddCheckpointState {}
class AddCheckpointLoaded extends AddCheckpointState {
  final int? statusCode;
  dynamic json;

  AddCheckpointLoaded({this.statusCode, this.json});
}
