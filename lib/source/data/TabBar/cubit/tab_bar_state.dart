part of 'tab_bar_cubit.dart';

@immutable
abstract class TabBarState {}

class TabBarInitial extends TabBarState {}

class TabBarLoading extends TabBarState {}

class TabBarLoaded extends TabBarState {
  dynamic user_roles;
  dynamic data;

  TabBarLoaded({this.user_roles, this.data});
}
