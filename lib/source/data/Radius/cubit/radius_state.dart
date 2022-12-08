part of 'radius_cubit.dart';

@immutable
abstract class RadiusState {}

class RadiusInitial extends RadiusState {}

class RadiusLoding extends RadiusState {}

class RadiusLoded extends RadiusState {
  final int? radius, statusCode;

  RadiusLoded({this.radius, this.statusCode});
}
