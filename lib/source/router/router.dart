import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location/source/pages/Auth/ganti_password.dart';
import 'package:flutter_location/source/pages/Auth/login.dart';
import 'package:flutter_location/source/pages/Auth/splash_Screen.dart';
import 'package:flutter_location/source/pages/Dashboard/bottom_navbar/bottom_navbar.dart';
import 'package:flutter_location/source/pages/Dashboard/checkpoint.dart';
import 'package:flutter_location/source/pages/Dashboard/history.dart';
import 'package:flutter_location/source/pages/Dashboard/home.dart';
import 'package:flutter_location/source/pages/Dashboard/profile.dart';
import 'package:flutter_location/source/pages/Dashboard/scan_qr.dart';
import 'package:flutter_location/source/router/string.dart';

class RouterNavigation {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        // return MaterialPageRoute(builder: (context) => const SplashScreen());
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case LOGIN:
        return MaterialPageRoute(builder: (context) => const Login());
      case GANTI_PASSWORD:
        return MaterialPageRoute(builder: (context) => const GantiPassword());
      case BOTTOM_TABBAR:
        return MaterialPageRoute(builder: (context) => const CustomBottomNavBar());
      case HOME:
        return MaterialPageRoute(builder: (context) => const Home());
      case CHECKPOINT:
        return MaterialPageRoute(builder: (context) => const Checkpoint());
      case SCAN_QR:
        return MaterialPageRoute(builder: (context) => const ScanQR());
      case HISTORY:
        return MaterialPageRoute(builder: (context) => const History());
      case PROFILE:
        return MaterialPageRoute(builder: (context) => const Profile());

      default:
        return null;
    }
  }
}
