import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/locationTest.dart';
import 'package:flutter_location/source/data/Auth/cubit/auth_cubit.dart';
import 'package:flutter_location/source/data/TabBar/cubit/tab_bar_cubit.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:flutter_location/source/network/network.dart';
import 'package:flutter_location/source/router/router.dart';

void main() {
  runApp(MyApp(
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
          create: (authcubit) => AuthCubit(myReposity: myReposity),
        ),
        BlocProvider(
          create: (tabbarcubit) => TabBarCubit(myReposity: myReposity),
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
