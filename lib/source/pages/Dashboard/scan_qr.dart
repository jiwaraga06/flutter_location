import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Radius/cubit/distance_cubit.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:flutter_location/source/widget/custom_loading.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String? result;
  double? latQr, longQr;
  int? id_lokasi;
  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#332FD0', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    print(barcodeScanRes);
    setState(() async {
      result = stringToBase64.decode(barcodeScanRes);
      id_lokasi = int.parse(result!.split(';')[0]);
      latQr = double.parse(result!.split(';')[1]);
      longQr = double.parse(result!.split(';')[2]);
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        BlocProvider.of<DistanceCubit>(context).hitungJarak(id_lokasi, latQr, longQr, true);
      } else if (connectivityResult == ConnectivityResult.wifi) {
        BlocProvider.of<DistanceCubit>(context).hitungJarak(id_lokasi, latQr, longQr, true);
      } else if (connectivityResult == ConnectivityResult.none) {
        BlocProvider.of<DistanceCubit>(context).hitungJarak(id_lokasi, latQr, longQr, false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scanQR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absen Security'),
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
      body: ListView(
        shrinkWrap: true,
        children: [
          BlocListener<DistanceCubit, DistanceState>(listener: (context, state) {
            if (state is DistanceLoading) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return const CustomLoading();
                },
              );
            }
            if (state is DistanceLoaded) {
              Navigator.pop(context);
              var data = state.data;
              print(data);
              if (data['status'] == 0) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error !',
                  desc: 'Anda Terlalu Jauh dari Lokasi \n ${data['jarak']} m',
                  btnOkText: 'Scan Ulang',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    scanQR();
                  },
                ).show();
              }
            }
          }, child: BlocBuilder<DistanceCubit, DistanceState>(
            builder: (context, state) {
              if (state is AbsenSecurityLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (state is AbsenSecurityLoaded == false) {
                return Container(
                  alignment: Alignment.center,
                  // child: const Text('Data False'),
                );
              }
              var data = (state as AbsenSecurityLoaded).data;
              var statusCode = (state as AbsenSecurityLoaded).statusCode;
              if (statusCode != 200) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(data.toString()),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var a = data[index];
                  return Accordion(
                    paddingListBottom: 2,
                    disableScrolling: true,
                    scaleWhenAnimating: true,
                    openAndCloseAnimation: true,
                    headerBackgroundColor: const Color(0XFF10A19D),
                    contentBorderColor: const Color(0xFF10A19D),
                    headerPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    children: [
                      AccordionSection(
                        header: Text(
                          a['task'],
                          style: const TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, ABSEN_SATPAM, arguments: {
                                'id_lokasi': a['id_lokasi'],
                                'task': a['task'],
                                'sub_task': a['sub_task'],
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3D5656),
                              maximumSize: const Size.fromHeight(50),
                            ),
                            child: const Text('ISI TASK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
