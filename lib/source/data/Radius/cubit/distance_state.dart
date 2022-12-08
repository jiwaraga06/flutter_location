part of 'distance_cubit.dart';

@immutable
abstract class DistanceState {}

class DistanceInitial extends DistanceState {}

class DistanceLoading extends DistanceState {}

class DistanceLoaded extends DistanceState {
  dynamic data;
  DistanceLoaded({this.data});
}

class AbsenSecurityLoading extends DistanceState {}

class AbsenSecurityLoaded extends DistanceState {
  final int? statusCode;
  dynamic data;

  AbsenSecurityLoaded({this.statusCode, this.data});
}
