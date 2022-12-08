part of 'checkpoint_list_cubit.dart';

@immutable
abstract class CheckpointListState {}

class CheckpointListInitial extends CheckpointListState {}
class CheckpointListLoading extends CheckpointListState {}
class CheckpointListLoaded extends CheckpointListState {
  final int? statusCode;
  dynamic json;

  CheckpointListLoaded({this.statusCode, this.json});
}
