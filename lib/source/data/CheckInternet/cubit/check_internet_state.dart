part of 'check_internet_cubit.dart';

@immutable
abstract class CheckInternetState {}

class CheckInternetInitial extends CheckInternetState {}
class CheckInternetStatus extends CheckInternetState {
  final bool? status;
  final String? valStatus;

  CheckInternetStatus({this.status, this.valStatus});
}
