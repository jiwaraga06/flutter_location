import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/HistoryAbsen/cubit/history_absen_cubit.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTimeRange? _selectedDateRange;
  var tanggalAwal, tanggalAkhir;
  void show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021, 1, 1),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      print(result.start.toString());
      print(result.end.toString());
      setState(() {
        _selectedDateRange = result;
        tanggalAwal = _selectedDateRange!.start.toString().split(' ')[0];
        tanggalAkhir = _selectedDateRange!.end.toString().split(' ')[0];
      });
      BlocProvider.of<HistoryAbsenCubit>(context).getHistory(tanggalAwal, tanggalAkhir);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: show,
                child: const Text(
                  'Pilih Tanggal',
                  style: TextStyle(color: Colors.white),
                )),
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Column(
              children: [
                _selectedDateRange == null
                    ? Container()
                    : Text(
                        'Periode',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                const SizedBox(height: 8.0),
                Text(
                  _selectedDateRange == null ? 'Anda Belum Memilih Range Tanggal' : '$tanggalAwal - $tanggalAkhir',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2.0),
                const Divider(thickness: 2),
              ],
            ),
          ),
          BlocBuilder<HistoryAbsenCubit, HistoryAbsenState>(
            builder: (context, state) {
              if (state is HistoryAbsenLoading) {
                return SizedBox(
                  height: 80,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              if (state is HistoryAbsenLoaded == false) {
                return Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: Text('Data False'),
                );
              }
              var data = (state as HistoryAbsenLoaded).json;
              if (data.isEmpty) {
                return SizedBox(
                  height: 80,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Tidak Ada Data'),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
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
                      headerPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      children: [
                        AccordionSection(
                          header: Text(
                            a['nama_lokasi'],
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
                                        'Nama',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      a['nama'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]),
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
                                  TableRow(children: [
                                    SizedBox(
                                      height: 35,
                                      child: Text(
                                        'Absen',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      a['tgl_absen'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: a['task'].length,
                                itemBuilder: (context, index2) {
                                  var b = a['task'][index2];
                                  return Accordion(
                                      disableScrolling: true,
                                      scaleWhenAnimating: true,
                                      openAndCloseAnimation: true,
                                      headerBackgroundColor: const Color(0XFF3E6D9C),
                                      contentBorderColor: const Color(0XFF3E6D9C),
                                      children: [
                                        AccordionSection(
                                          header: Text(
                                            b['nama_task'],
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
                                                        'Detail',
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    Text(
                                                      ':',
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(
                                                      b['nama_sub_task'],
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
                                                    b['checklist'] == 1
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
                                                    Image.network(
                                                      b['photo'],
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
