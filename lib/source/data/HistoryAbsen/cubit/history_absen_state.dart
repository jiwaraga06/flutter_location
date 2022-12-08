part of 'history_absen_cubit.dart';

@immutable
abstract class HistoryAbsenState {}

class HistoryAbsenInitial extends HistoryAbsenState {}
class HistoryAbsenLoading extends HistoryAbsenState {}
class HistoryAbsenDate extends HistoryAbsenState {
  final String? date;

  HistoryAbsenDate({this.date});
}
class HistoryAbsenLoaded extends HistoryAbsenState {
  final int? statusCode;
  dynamic json;

  HistoryAbsenLoaded({this.statusCode, this.json});
}
