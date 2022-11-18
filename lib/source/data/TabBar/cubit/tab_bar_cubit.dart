import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tab_bar_state.dart';

class TabBarCubit extends Cubit<TabBarState> {
  final MyReposity? myReposity;
  TabBarCubit({required this.myReposity}) : super(TabBarInitial());

  void getInfoAll() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString("barcode");
    var nama = pref.getString("nama");
    var user_roles = pref.getString("user_roles");
    var warna = pref.getString("warna");
    var gender = pref.getString("gender");
    if (user_roles != null) {
      emit(TabBarLoaded(user_roles:user_roles));
    }
  }
}
