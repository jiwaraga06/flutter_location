part of 'absen_lokasi_cubit.dart';

@immutable
abstract class AbsenLokasiState {}

class AbsenLokasiInitial extends AbsenLokasiState {}

class AbsenLokasiloading extends AbsenLokasiState {}

class AbsenLokasiloaded extends AbsenLokasiState {
  final int? statusCode;
  dynamic json;

  AbsenLokasiloaded({this.statusCode, this.json});
}
