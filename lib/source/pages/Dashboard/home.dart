import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Home/cubit/home_cubit.dart';
import 'package:flutter_location/source/data/Mqtt/cubit/mqtt_cubit.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription? connection;
  bool isoffline = false;
  @override
  void initState() {
    super.initState();

    BlocProvider.of<HomeCubit>(context).connectSocket();
    BlocProvider.of<MqttCubit>(context).connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          BlocBuilder<CheckInternetCubit, CheckInternetState>(
            builder: (context, state) {
              if (state is CheckInternetStatus == false) {
                return Container();
              }
              var status = (state as CheckInternetStatus).status;
              return CustomStatusKoneksi(color: status == false ? Colors.red[600] : Colors.green);
            },
          ),
        ],
      ),
      body: BlocBuilder<CheckInternetCubit, CheckInternetState>(builder: (context, state) {
        if (state is CheckInternetStatus == false) {
          return Container();
        }
        var status = (state as CheckInternetStatus).status;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    Text('Status Koneksi Tracking Lokasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoaded == false) {
                          return Container();
                        }
                        var status = (state as HomeLoaded).statusCode;
                        var nama = (state as HomeLoaded).status;
                        if (status == 0) {
                          return Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.signal_wifi_statusbar_null_sharp,
                                  size: 80,
                                  color: Color.fromARGB(255, 228, 161, 2),
                                ),
                                const SizedBox(height: 12),
                                Text('$nama', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          );
                        } else if (status == 1) {
                          return Container(
                            child: Column(
                              children: [
                                Icon(
                                  FontAwesomeIcons.circleCheck,
                                  size: 80,
                                  color: Colors.green[600],
                                ),
                                const SizedBox(height: 12),
                                Text('$nama', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          );
                        } else if (status == 2) {
                          return Container(
                            child: Column(
                              children: [
                                Icon(
                                  FontAwesomeIcons.circleXmark,
                                  size: 80,
                                  color: Colors.red[600],
                                ),
                                const SizedBox(height: 12),
                                Text('$nama', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          );
                        } else if (status == 3) {
                          return Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.wifi_off_outlined,
                                  size: 80,
                                  color: Colors.red[600],
                                ),
                                const SizedBox(height: 12),
                                Text('$nama', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          );
                        }
                        return Container(
                          child: Text('data'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  status == true
                      ? SizedBox(
                          height: 50,
                          child: Container(
                            color: Color(0XFF27496D),
                            child: BlocBuilder<MqttCubit, MqttState>(
                              builder: (context, state) {
                                if (state is MqttMessageLoad == false) {
                                  return Container();
                                }
                                var data = (state as MqttMessageLoad).message;
                                if (data!.length == 0) {
                                  return Marquee(
                                    text: "",
                                    blankSpace: 50,
                                    style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                                  );
                                }
                                return Marquee(
                                  text: '$data',
                                  blankSpace: 50,
                                  style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                                );
                              },
                            ),
                          ))
                      : Container()
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
