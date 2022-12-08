import 'dart:async';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/checkpoint_list_cubit.dart';
import 'package:flutter_location/source/data/Location/location_data.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/data_view.dart';
import 'package:flutter_location/source/pages/Dashboard/Checkpoint/map_view.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:flutter_location/source/widget/span_button.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Checkpoint extends StatefulWidget {
  const Checkpoint({super.key});

  @override
  State<Checkpoint> createState() => _CheckpointState();
}

class _CheckpointState extends State<Checkpoint> with SingleTickerProviderStateMixin {
  int isMapview = 1;
  StreamSubscription? connection;
  bool isoffline = false;

  List view = [
    {'id': 0, 'nama': 'Tampilan Data'},
    {'id': 1, 'nama': 'Tampilan Map'}
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkpoint'),
        actions: [
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width * 0.30,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: DropdownButton(
              underline: Container(color: Colors.transparent),
              value: isMapview,
              style: TextStyle(color: Colors.white),
              // itemHeight: 40,
              hint: Text('Pilih Tampilan'),
              items: const [
                DropdownMenuItem(
                  child: Text(
                    "Data View",
                    style: TextStyle(color: Colors.black),
                  ),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text(
                    "Map View",
                    style: TextStyle(color: Colors.black),
                  ),
                  value: 2,
                )
              ],
              onChanged: (value) {
                setState(() {
                  isMapview = value!;
                });
              },
            ),
          ),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ADD_CHECKPOINT);
        },
        backgroundColor: Color(0xFF27496D),
        child: Icon(Icons.add),
      ),
      body: isMapview == 1 ? DataView() : MapView(),
    );
  }
}
