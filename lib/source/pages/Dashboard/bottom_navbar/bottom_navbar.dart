import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/Radius/cubit/radius_cubit.dart';
import 'package:flutter_location/source/data/TabBar/cubit/tab_bar_cubit.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/checkpoint.dart';
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
    FontAwesomeIcons.qrcode,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.user,
  ];
  List<String> textIcon = ['Home', 'Checkpoint', 'QR', 'History', 'Profile'];
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Checkpoint(),
    ScanQR(),
    History(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TabBarCubit>(context).background();
    BlocProvider.of<TabBarCubit>(context).getInfoAll();
    BlocProvider.of<TabBarCubit>(context).socketConnect();
    BlocProvider.of<RadiusCubit>(context).getRadius();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TabBarCubit, TabBarState>(
      listener: (context, state) {
        if (state is TabBarLoaded) {
          var user_roles = jsonDecode(state.user_roles);
          print(user_roles);
        }
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(_bottomNavIndex),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: const Color(0xFF27496D),
        //   onPressed: () {
        //     Navigator.pushNamed(context, SCAN_QR);
        //   },
        //   child: const Icon(FontAwesomeIcons.qrcode),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            currentIndex: _bottomNavIndex,
            onTap: (value) {
              setState(() {
                _bottomNavIndex = value;
              });
            },
            selectedItemColor: Color(0XFF27496D),
            selectedLabelStyle: TextStyle(fontSize: 15, color: Color(0XFF27496D)),
            unselectedLabelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            items: [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.locationDot),
                activeIcon: Icon(
                  FontAwesomeIcons.locationDot,
                  color: Color(0XFF27496D),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.listCheck),
                activeIcon: Icon(
                  FontAwesomeIcons.listCheck,
                  color: Color(0XFF27496D),
                ),
                label: 'Checkpoint',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.qrcode),
                activeIcon: Icon(
                  FontAwesomeIcons.qrcode,
                  color: Color(0XFF27496D),
                ),
                label: 'Scan QR',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.calendar),
                activeIcon: Icon(
                  FontAwesomeIcons.calendar,
                  color: Color(0XFF27496D),
                ),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                activeIcon: Icon(
                  FontAwesomeIcons.user,
                  color: Color(0XFF27496D),
                ),
                label: 'Profile',
              ),
            ]),
        // bottomNavigationBar: AnimatedBottomNavigationBar(
        //   icons: iconList,

        //   activeIndex: _bottomNavIndex,
        //   notchSmoothness: NotchSmoothness.defaultEdge,
        //   gapLocation: GapLocation.end,
        //   // activeColor: Color(0XFF27496D),
        //   // inactiveColor: Colors.grey,
        //   // leftCornerRadius: 32,
        //   // rightCornerRadius: 32,
        //   onTap: (index) => setState(() => _bottomNavIndex = index),
        // ),
      ),
    );
  }
}
