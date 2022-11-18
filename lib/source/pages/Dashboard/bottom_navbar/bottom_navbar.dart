import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/TabBar/cubit/tab_bar_cubit.dart';
import 'package:flutter_location/source/pages/Dashboard/checkpoint.dart';
import 'package:flutter_location/source/pages/Dashboard/history.dart';
import 'package:flutter_location/source/pages/Dashboard/home.dart';
import 'package:flutter_location/source/pages/Dashboard/profile.dart';
import 'package:flutter_location/source/pages/Dashboard/scan_qr.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  var role = [];
  var _bottomNavIndex = 0;
  final iconList = <IconData>[
    FontAwesomeIcons.locationDot,
    FontAwesomeIcons.listCheck,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.user,
  ];
  List<String> textIcon = ['Home', 'Checkpoint', 'History', 'Profile'];
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Checkpoint(),
    History(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TabBarCubit>(context).getInfoAll();
    return BlocListener<TabBarCubit, TabBarState>(
      listener: (context, state) {
        if(state is TabBarLoaded){
          var user_roles = state.user_roles;
          print(user_roles);
        }
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(_bottomNavIndex),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF27496D),
          onPressed: () {
            Navigator.pushNamed(context, SCAN_QR);
          },
          child: const Icon(FontAwesomeIcons.qrcode),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? const Color(0XFF27496D) : Colors.grey;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    textIcon[index],
                    maxLines: 1,
                    style: TextStyle(color: color),
                  ),
                )
              ],
            );
          },

          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          // activeColor: Color(0XFF27496D),
          // inactiveColor: Colors.grey,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => _bottomNavIndex = index),
        ),
      ),
    );
  }
}
