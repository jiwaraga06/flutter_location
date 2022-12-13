import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/checkpoint_list_cubit.dart';
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
  static const List<Widget> _widgetOptions0 = <Widget>[
    Home(),
    History(),
    Profile(),
  ];
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Checkpoint(),
    ScanQR(),
    History(),
    Profile(),
  ];
  static const List<Widget> _widgetOptions1 = <Widget>[
    Home(),
    Checkpoint(),
    History(),
    Profile(),
  ];
  static const List<Widget> _widgetOptions2 = <Widget>[
    Home(),
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
    BlocProvider.of<CheckpointListCubit>(context).checkpoint();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBarCubit, TabBarState>(builder: (context, state) {
      if (state is TabBarLoaded == false) {
        return Container();
      }
      var user_roles = (state as TabBarLoaded).user_roles;
      var encode = jsonDecode(user_roles);
      // var encode = ['security'];
      print(user_roles);
      return Scaffold(
        body: encode.length == 2
            ? _widgetOptions.elementAt(_bottomNavIndex)
            : encode.length == 1
                ? encode[0] == 'admin_scr'
                    ? _widgetOptions1.elementAt(_bottomNavIndex)
                    : _widgetOptions2.elementAt(_bottomNavIndex)
                : _widgetOptions0.elementAt(_bottomNavIndex),
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
            items: encode.length == 2
                ? [
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
                  ]
                : encode.length == 1
                    ? encode[0] == 'admin_scr'
                        ? [
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
                          ]
                        : [
                            BottomNavigationBarItem(
                              icon: Icon(FontAwesomeIcons.locationDot),
                              activeIcon: Icon(
                                FontAwesomeIcons.locationDot,
                                color: Color(0XFF27496D),
                              ),
                              label: 'Home',
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
                          ]
                    : []),
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
      );
    });
  }
}
