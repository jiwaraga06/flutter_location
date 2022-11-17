import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location/source/pages/Auth/ganti_password.dart';
import 'package:flutter_location/source/pages/Auth/login.dart';
import 'package:flutter_location/source/pages/Auth/splash_Screen.dart';
import 'package:flutter_location/source/router/string.dart';

class RouterNavigation {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
        case LOGIN:
        return MaterialPageRoute(builder: (context) => const Login());
        case GANTI_PASSWORD:
        return MaterialPageRoute(builder: (context) => const GantiPassword());
      default:
        return null;
    }
  }
}
