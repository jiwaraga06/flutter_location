part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final String? status;
  final int? statusCode;

  HomeLoaded({this.status, this.statusCode});
}
