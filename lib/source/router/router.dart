import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location/source/pages/Auth/ganti_password.dart';
import 'package:flutter_location/source/pages/Auth/login.dart';
import 'package:flutter_location/source/pages/Auth/splash_Screen.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/MenuCheckpoint/addCheckpoint.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/MenuCheckpoint/editCheckpoint.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/SubTask/addSubtask.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/SubTask/editSubtask.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/Task/addTask.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/Task/editTask.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/checkpoint_offline.dart';
import 'package:flutter_location/source/pages/Dashboard/absenCheckpoint.dart';
import 'package:flutter_location/source/pages/Dashboard/absen_lokal_satpam.dart';
import 'package:flutter_location/source/pages/Dashboard/bottom_navbar/bottom_navbar.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/checkpoint.dart';
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
        final data = settings.arguments;
        return MaterialPageRoute(builder: (context) => GantiPassword(data: data));
      case BOTTOM_TABBAR:
        return MaterialPageRoute(builder: (context) => const CustomBottomNavBar());
      case HOME:
        return MaterialPageRoute(builder: (context) => const Home());
      case HISTORY:
        return MaterialPageRoute(builder: (context) => const History());
      case PROFILE:
        return MaterialPageRoute(builder: (context) => const Profile());
      case SCAN_QR:
        return MaterialPageRoute(builder: (context) => const ScanQR());
      case ABSEN_SATPAM:
        final data = settings.arguments;
        return MaterialPageRoute(builder: (context) => AbsenCheckpoint(data: data));
      // LOKAL
      case CHECKPOINT_LOKAL:
        return MaterialPageRoute(builder: (context) => const CheckPointOffline());
      case ABSEN_LOKAL:
        return MaterialPageRoute(builder: (context) => const AbsenLokalSatpam());
      //LOKASI
      case CHECKPOINT:
        return MaterialPageRoute(builder: (context) => const Checkpoint());
      case ADD_CHECKPOINT:
        return MaterialPageRoute(builder: (context) => const AddCheckPoint());
      case EDIT_CHECKPOINT:
        final data = settings.arguments;
        return MaterialPageRoute(builder: (context) => EditCheckPoint(data: data));
      // TASK
      case ADD_TASK:
        final data = settings.arguments;
        return MaterialPageRoute(builder: (context) => AddTask(data: data));
      case EDIT_TASK:
        final data = settings.arguments;
        return MaterialPageRoute(builder: (context) => EditTask(data: data));
      // SUB TASK
      case ADD_SUB_TASK:
        final data = settings.arguments;
        return MaterialPageRoute(builder: (context) => AddSubTask(data: data));
      case EDIT_SUB_TASK:
        final data = settings.arguments;
        return MaterialPageRoute(builder: (context) => EditSubTask(data: data));

      default:
        return null;
    }
  }
}
