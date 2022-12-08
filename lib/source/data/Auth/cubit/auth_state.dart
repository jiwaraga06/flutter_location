part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginLoaded extends AuthState {
  dynamic json;
  dynamic statusCode;
  LoginLoaded({this.json, this.statusCode});
}

class LoginMessage extends AuthState {}

class LogoutLoading extends AuthState {}

class LogoutLoaded extends AuthState {
  final int? statusCode;
  dynamic json;

  LogoutLoaded({this.statusCode, this.json});
}
