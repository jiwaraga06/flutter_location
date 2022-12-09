import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/AbsenLokal/cubit/absen_lokal_cubit.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AbsenLokalSatpam extends StatefulWidget {
  const AbsenLokalSatpam({super.key});

  @override
  State<AbsenLokalSatpam> createState() => _AbsenLokalSatpamState();
}

class _AbsenLokalSatpamState extends State<AbsenLokalSatpam> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AbsenLokalCubit>(context).getAbsenLokal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absen lokal'),
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
      body: BlocBuilder<AbsenLokalCubit, AbsenLokalState>(
        builder: (context, state) {
          if (state is AbsenLokalLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is AbsenLokalLoaded == false) {
            return Center(
              child: Text('data false'),
            );
          }
          var data = (state as AbsenLokalLoaded).json;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var a = data[index];
              return Accordion(
                paddingListBottom: 2,
                disableScrolling: true,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                headerBackgroundColor: const Color(0XFF6D9886),
                contentBorderColor: const Color(0xFF497174),
                children: [
                  AccordionSection(
                    header: Text(
                      a['nama_task'],
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    content: Column(
                            children: [
                              Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(70),
                                  1: FixedColumnWidth(10),
                                },
                                children: [
                                  TableRow(children: [
                                    SizedBox(
                                      height: 35,
                                      child: Text(
                                        'Barcode',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      a['barcode'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: a['tasks'].length,
                                itemBuilder: (context, index2) {
                                  var b = a['tasks'][index2];
                                  return Accordion(
                                      disableScrolling: true,
                                      scaleWhenAnimating: true,
                                      openAndCloseAnimation: true,
                                      headerBackgroundColor: const Color(0XFF3E6D9C),
                                      contentBorderColor: const Color(0XFF3E6D9C),
                                      children: [
                                        AccordionSection(
                                          header: Text(
                                            'Isian',
                                            style: const TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                          content: Column(
                                            children: [
                                              Table(
                                                columnWidths: const {
                                                  0: FixedColumnWidth(70),
                                                  1: FixedColumnWidth(10),
                                                },
                                                children: [
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 35,
                                                      child: Text(
                                                        'Sub Task',
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    Text(
                                                      ':',
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(
                                                      b['sub_task_id'].toString(),
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 35,
                                                      child: Text(
                                                        'Note',
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    Text(
                                                      ':',
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(
                                                      b['note'],
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 35,
                                                      child: Text(
                                                        'Check',
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    Text(
                                                      ':',
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                    ),
                                                    b['checklist'] == '1'
                                                        ? Row(
                                                            children: [
                                                              Text('Sudah di Checklist', style: TextStyle(fontSize: 16)),
                                                              const SizedBox(width: 8),
                                                              Icon(
                                                                FontAwesomeIcons.squareCheck,
                                                                size: 20,
                                                                color: Colors.blue,
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Text('Tidak di Checklist', style: TextStyle(fontSize: 16)),
                                                              const SizedBox(width: 8),
                                                              Icon(
                                                                FontAwesomeIcons.circleXmark,
                                                                size: 17,
                                                                color: Colors.red,
                                                              ),
                                                            ],
                                                          )
                                                  ]),
                                                  TableRow(children: [
                                                    Text(
                                                      'Photo',
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(
                                                      ':',
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                    ),
                                                    Image.memory(
                                                      Base64Decoder().convert(b['photo'].toString().split(',')[1]),
                                                      height: 250,
                                                      errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                        return Text('Photo Gagal Memuat Data');
                                                      },
                                                    )
                                                    // Container(
                                                    //   height: 150,
                                                    //   decoration: BoxDecoration(
                                                    //       image: DecorationImage(
                                                    //     image: NetworkImage(b['photo']),
                                                    //     fit: BoxFit.contain,
                                                    //   )),
                                                    // ),
                                                  ]),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]);
                                },
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
