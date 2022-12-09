part of 'absen_lokal_cubit.dart';

@immutable
abstract class AbsenLokalState {}

class AbsenLokalInitial extends AbsenLokalState {}
class AbsenLokalLoading extends AbsenLokalState {}
class AbsenLokalLoaded extends AbsenLokalState {
  final int? statusCode;
  dynamic json;

  AbsenLokalLoaded({this.statusCode, this.json});
}
