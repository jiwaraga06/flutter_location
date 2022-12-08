import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/checkpoint_list_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/edit_checkpoint_cubit.dart';
import 'package:flutter_location/source/widget/custom_banner.dart';
import 'package:flutter_location/source/widget/custom_btnSave.dart';
import 'package:flutter_location/source/widget/custom_loading.dart';
import 'package:flutter_location/source/widget/custom_notefield.dart';
import 'package:flutter_location/source/widget/custom_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditCheckPoint extends StatefulWidget {
  dynamic data;
  EditCheckPoint({super.key, this.data});

  @override
  State<EditCheckPoint> createState() => _EditCheckPointState();
}

class _EditCheckPointState extends State<EditCheckPoint> {
  TextEditingController controllerLokasi = TextEditingController();
  TextEditingController controllerKet = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Position? currentPosition;
  LatLng? markerPosition;
  Completer<GoogleMapController> _controller = Completer();

  void getLocation() async {
    await Geolocator.getCurrentPosition().then((value) {
      setState(() {
        print('My Position: $value');
        currentPosition = value;
      });
    }).catchError((e) {
      print('Error Get Current Position: $e');
    });
  }

  Set<Marker> marker = HashSet<Marker>();
  BitmapDescriptor? icons, editIcons;
  bool userMaker = false;

  void markerAsset() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      "assets/img/marker3.png",
    );
    final icon2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      "assets/img/marker4.png",
    );
    setState(() {
      icons = icon;
      editIcons = icon2;
    });
  }

  void save() {
    getLocation();
    if (formKey.currentState!.validate()) {
      if (userMaker == true) {
        print('pakai marker');
        print(markerPosition);
        BlocProvider.of<EditCheckpointCubit>(context).editCheckpoint(
          widget.data['id'],
          controllerLokasi.text,
          controllerKet.text,
          markerPosition!.latitude,
          markerPosition!.longitude,
        );
      } else {
        print('pakai lokasi saat ini');
        print(currentPosition);
        BlocProvider.of<EditCheckpointCubit>(context).editCheckpoint(
          widget.data['id'],
          controllerLokasi.text,
          controllerKet.text,
          currentPosition!.latitude,
          currentPosition!.longitude,
        );
      }
    }
  }

  void setUp() {
    controllerLokasi = TextEditingController(text: widget.data['nama_lokasi']);
    controllerKet = TextEditingController(text: widget.data['keterangan']);
  }

  @override
  void initState() {
    super.initState();
    markerAsset();
    getLocation();
    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Lokasi'),
      ),
      body: BlocListener<EditCheckpointCubit, EditCheckpointState>(
        listener: (context, state)async {
          if (state is EditCheckpointLoading) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CustomLoading();
                });
          }
          if (state is EditCheckpointLoaded) {
            Navigator.pop(context);
            var json = state.json;
            var statusCode = state.statusCode;
            if (statusCode == 200) {
              Navigator.pop(context);
              final materialBanner = MyBanner.bannerSuccess(json.toString());
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showSnackBar(materialBanner);
                BlocProvider.of<CheckpointListCubit>(context).checkpoint();
                await Future.delayed(Duration(seconds: 2));
                Navigator.pop(context);
            } else {
              final materialBanner = MyBanner.bannerFailed('${json['message']} \n ${json['errors']}');
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showMaterialBanner(materialBanner);
            }
          }
        },
        child: Stack(
          children: [
            Container(
              // width: MediaQuery.of(context).size.width,
              // height: 500,
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                  // target: LatLng(-7.0474933, 107.7459708),
                  zoom: 16,
                ),
                buildingsEnabled: true,
                indoorViewEnabled: true,
                mapToolbarEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: userMaker == true
                    ? {
                        Marker(
                          draggable: true,
                          onDrag: (value) {
                            print('value');
                            print(value);
                            setState(() {
                              markerPosition = value;
                            });
                          },
                          markerId: MarkerId("Marker"),
                          position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                          icon: icons!,
                        ),
                        Marker(
                          onDrag: (value) {
                            print('value');
                            print(value);
                            setState(() {
                              markerPosition = value;
                            });
                          },
                          markerId: MarkerId("Marker Edit"),
                          position: LatLng(widget.data['lati'], widget.data['longi']),
                          icon: editIcons!,
                        )
                      }
                    : {
                        Marker(
                          markerId: MarkerId("Marker Edit"),
                          position: LatLng(widget.data['lati'], widget.data['longi']),
                          icon: editIcons!,
                        )
                      },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Positioned(
                bottom: 0.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      )),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Gunakan Marker Lokasi', style: TextStyle(fontSize: 16)),
                            CupertinoSwitch(
                                value: userMaker,
                                onChanged: (value) {
                                  setState(() {
                                    userMaker = value;
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        CustomFormField(
                          controller: controllerLokasi,
                          hint: 'Masukan Nama Lokasi',
                          iconLock: Icon(FontAwesomeIcons.locationDot),
                          msgError: 'Kolom Harus di Isi',
                        ),
                        const SizedBox(height: 8.0),
                        CustomNoteField(
                          controller: controllerKet,
                          hint: 'Masukan Keterangan',
                          iconLock: Icon(FontAwesomeIcons.noteSticky),
                          msgError: 'Kolom Harus di Isi',
                        ),
                        const SizedBox(height: 20.0),
                        CustomButtonSave(
                          text: 'SIMPAN',
                          onPressed: () {
                            save();
                          },
                          icon: Icon(FontAwesomeIcons.check, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
