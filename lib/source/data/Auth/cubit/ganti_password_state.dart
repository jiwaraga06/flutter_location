part of 'ganti_password_cubit.dart';

@immutable
abstract class GantiPasswordState {}

class GantiPasswordInitial extends GantiPasswordState {}
class GantiPasswordLoading extends GantiPasswordState {}
class GantiPasswordLoaded extends GantiPasswordState {
  final int? statusCode;
  dynamic json;

  GantiPasswordLoaded({this.statusCode, this.json});
}
