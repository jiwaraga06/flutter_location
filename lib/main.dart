import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/locationTest.dart';
import 'package:flutter_location/source/data/AbsenLokal/cubit/absen_lokal_cubit.dart';
import 'package:flutter_location/source/data/Auth/cubit/auth_cubit.dart';
import 'package:flutter_location/source/data/Auth/cubit/ganti_password_cubit.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/AbsenLokasi/cubit/absen_lokasi_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/add_checkpoint_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/checkpoint_list_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/edit_checkpoint_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataSubTask/cubit/add_subtask_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataSubTask/cubit/edit_subtask_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataTask/cubit/add_task_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataTask/cubit/edit_task_cubit.dart';
import 'package:flutter_location/source/data/HistoryAbsen/cubit/history_absen_cubit.dart';
import 'package:flutter_location/source/data/Home/cubit/home_cubit.dart';
import 'package:flutter_location/source/data/Mqtt/cubit/mqtt_cubit.dart';
import 'package:flutter_location/source/data/Offline/Sql/sql.dart';
import 'package:flutter_location/source/data/Radius/cubit/distance_cubit.dart';
import 'package:flutter_location/source/data/Radius/cubit/radius_cubit.dart';
import 'package:flutter_location/source/data/TabBar/cubit/tab_bar_cubit.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:flutter_location/source/network/network.dart';
import 'package:flutter_location/source/router/router.dart';
// CHECK INTERNET
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  // runApp(MyApp(
  //   myReposity: MyReposity(myNetwork: MyNetwork()),
  //   router: RouterNavigation(),
  // ));
  runApp(MyApps(
    myReposity: MyReposity(myNetwork: MyNetwork()),
    router: RouterNavigation(),
  ));
}

class MyApp extends StatelessWidget {
  final RouterNavigation? router;
  final MyReposity? myReposity;
  const MyApp({super.key, this.router, this.myReposity});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (mqttcubit) => MqttCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (authcubit) => AuthCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (ganti_pwcubit) => GantiPasswordCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (tabbarcubit) => TabBarCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (homecubit) => HomeCubit(myReposity: myReposity),
        ),
        // ABSEN LOKASI
        BlocProvider(
          create: (radiuscubit) => RadiusCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (absen_lokasicubit) => AbsenLokasiCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (checkpointcubit) => CheckpointListCubit(myReposity: myReposity),
        ),
        // HITUNG JARAK
        BlocProvider(
          create: (distancecubit) => DistanceCubit(myReposity: myReposity),
        ),

        // LOKASI
        BlocProvider(
          create: (add_checkpointcubit) => AddCheckpointCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (edit_checkpointcubit) => EditCheckpointCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (historysubit) => HistoryAbsenCubit(myReposity: myReposity),
        ),
        // TASK
        BlocProvider(
          create: (add_task) => AddTaskCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (edit_task) => EditTaskCubit(myReposity: myReposity),
        ),
        // SUB TASK
        BlocProvider(
          create: (add_sub_task) => AddSubtaskCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (edit_sub_task) => EditSubtaskCubit(myReposity: myReposity),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router!.generateRoute,
        theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Color(0xFF27496D))),
      ),
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    //   home: const TesterLocation()
    // );
  }
}

class MyApps extends StatefulWidget {
  final RouterNavigation? router;
  final MyReposity? myReposity;

  const MyApps({super.key, this.router, this.myReposity});

  @override
  State<MyApps> createState() => _MyAppsState(myReposity: myReposity, router: router);
}

class _MyAppsState extends State<MyApps> {
  final RouterNavigation? router;
  final MyReposity? myReposity;

  _MyAppsState({this.router, this.myReposity});

  StreamSubscription? connection;
  bool isoffline = false;

  void getData() {
    final Future<Database> dbFuture = SQLHelper.db();
    dbFuture.then((database) {
      // print(database);
      Future lokasi = SQLHelper.createTables(database);
      Future tasks = SQLHelper.createTableTask(database);
      Future sub_task = SQLHelper.createTableSubTask(database);
      Future history = SQLHelper.createTableHistory(database);
      // Future join = SQLHelper.getLokasiTaskSubtask();
    });
  }

  @override
  void initState() {
    super.initState();
    
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (checkinternetcubit) => CheckInternetCubit(),
        ),
        BlocProvider(
          create: (checkinternetcubit) => AbsenLokalCubit(),
        ),
        BlocProvider(
          create: (mqttcubit) => MqttCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (authcubit) => AuthCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (ganti_pwcubit) => GantiPasswordCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (tabbarcubit) => TabBarCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (homecubit) => HomeCubit(myReposity: myReposity),
        ),
        // ABSEN LOKASI
        BlocProvider(
          create: (radiuscubit) => RadiusCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (absen_lokasicubit) => AbsenLokasiCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (checkpointcubit) => CheckpointListCubit(myReposity: myReposity),
        ),
        // HITUNG JARAK
        BlocProvider(
          create: (distancecubit) => DistanceCubit(myReposity: myReposity),
        ),

        // LOKASI
        BlocProvider(
          create: (add_checkpointcubit) => AddCheckpointCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (edit_checkpointcubit) => EditCheckpointCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (historysubit) => HistoryAbsenCubit(myReposity: myReposity),
        ),
        // TASK
        BlocProvider(
          create: (add_task) => AddTaskCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (edit_task) => EditTaskCubit(myReposity: myReposity),
        ),
        // SUB TASK
        BlocProvider(
          create: (add_sub_task) => AddSubtaskCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (edit_sub_task) => EditSubtaskCubit(myReposity: myReposity),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router!.generateRoute,
        theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Color(0xFF27496D))),
      ),
    );
  }
}
