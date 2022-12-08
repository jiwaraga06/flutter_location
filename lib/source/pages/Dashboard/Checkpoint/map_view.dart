import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/checkpoint_list_cubit.dart';
import 'package:flutter_location/source/data/Location/location_data.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  StreamSubscription? connection;
  bool isoffline = false;
  // LocationData? currentPosition;
  Position? currentPosition;
  Location location = Location();
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> marker = HashSet<Marker>();
  bool showMarker = false;
  // icon
  BitmapDescriptor? icons;

  void getLocation() async {
    // MyLocation().getMyLocation().then((value) {
    //   currentPosition = value;
    // });
    await Geolocator.getCurrentPosition().then((value) {
      setState(() {
        print('My Position: $value');
        currentPosition = value;
      });
    }).catchError((e) {
      print('Error Get Current Position: $e');
    });
    // currentPosition = await location.getLocation();
    // print(currentPosition);
  }

  void markerAsset() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      "assets/img/marker3.png",
    );
    setState(() async {
      icons = icon;
      // await Future.delayed(Duration(seconds: 2));
      // showMarker = true;
    });
  }

  @override
  void initState() {
    super.initState();
    markerAsset();
    getLocation();
    connection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      print('Status Koneksi: $result');
      if (result == ConnectivityResult.none) {
        BlocProvider.of<CheckpointListCubit>(context).checkpointOffline();
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        BlocProvider.of<CheckpointListCubit>(context).checkpoint();
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        BlocProvider.of<CheckpointListCubit>(context).checkpoint();
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CheckpointListCubit, CheckpointListState>(
        builder: (context, state) {
          if (state is CheckpointListLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is CheckpointListLoaded == false) {
            return Container(
              alignment: Alignment.center,
              child: Text('Data False'),
            );
          }
          var data = (state as CheckpointListLoaded).json;
          data.forEach((e) {
            marker.add(Marker(
              markerId: MarkerId('${e['id']}'),
              position: LatLng(e['lati'], e['longi']),
              // icon: customMarker! == null ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(customMarker!)
              icon: icons!,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Center(
                          child: Text(
                        e['nama_lokasi'],
                        style: TextStyle(fontSize: 20),
                      )),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12.0),
                          Table(
                            columnWidths: const {
                              0: FixedColumnWidth(80),
                              1: FixedColumnWidth(5),
                            },
                            children: [
                              TableRow(children: [
                                SizedBox(
                                  height: 35,
                                  child: Text(
                                    'Koordinat',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Text(':', style: TextStyle(fontSize: 16)),
                                Text('${e['lati']} - ${e['longi']}', style: TextStyle(fontSize: 16)),
                              ]),
                              TableRow(children: [
                                SizedBox(height: 35, child: Text('Keterangan', style: TextStyle(fontSize: 16))),
                                Text(':', style: TextStyle(fontSize: 16)),
                                Text(e['keterangan'], style: TextStyle(fontSize: 16)),
                              ]),
                              TableRow(children: [
                                SizedBox(height: 35, child: Text('Dibuat By', style: TextStyle(fontSize: 16))),
                                Text(':', style: TextStyle(fontSize: 16)),
                                Container(
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[600],
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(e['user_creator'], style: TextStyle(fontSize: 16, color: Colors.black))),
                              ]),
                              TableRow(children: [
                                SizedBox(height: 35, child: Text('Dibuat', style: TextStyle(fontSize: 16))),
                                Text(':', style: TextStyle(fontSize: 16)),
                                Container(
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[600],
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(e['created_at'], style: TextStyle(fontSize: 16, color: Colors.white))),
                              ]),
                              TableRow(children: [
                                SizedBox(height: 35, child: Text('DiUbah', style: TextStyle(fontSize: 16))),
                                Text(':', style: TextStyle(fontSize: 16)),
                                Container(
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.teal[600],
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(e['updated_at'], style: TextStyle(fontSize: 16, color: Colors.white))),
                              ]),
                            ],
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, EDIT_CHECKPOINT, arguments: {
                                'id': e['id'],
                                'nama_lokasi': e['nama_lokasi'],
                                'keterangan': e['keterangan'],
                                'lati': e['lati'],
                                'longi': e['longi'],
                              });
                            },
                            child: Text('Ubah Lokasi')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Tutup')),
                      ],
                    );
                  },
                );
              },
            ));
          });
          var statusCode = (state as CheckpointListLoaded).statusCode;
          if (data.isEmpty) {
            return Container(
              alignment: Alignment.center,
              child: Text('Data Kosong \n ketuk layar untuk refresh'),
            );
          }
          if (statusCode != 200) {
            return Container(
              alignment: Alignment.center,
              child: Text(data.toString()),
            );
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                // target: LatLng(-7.0474933, 107.7459708),
                zoom: 16,
              ),
              zoomControlsEnabled: false,
              buildingsEnabled: true,
              indoorViewEnabled: true,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: marker,
              //   markers: {
              //      Marker(
              //   markerId: MarkerId("merah"),
              //   position: LatLng(-7.0474933, 107.7459708),
              // ),
              //   },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          );
        },
      ),
    );
  }
}
