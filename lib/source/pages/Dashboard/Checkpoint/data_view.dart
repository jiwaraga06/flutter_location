import 'dart:async';

import 'package:accordion/accordion.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/checkpoint_list_cubit.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:flutter_location/source/widget/span_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> with SingleTickerProviderStateMixin {
  StreamSubscription? connection;
  bool isoffline = true;
  // refresh
  Animation<double>? _animation;
  AnimationController? _animationController;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  // location
  // Position? currentPosition;
  LocationData? currentPosition;
  Location location = Location();
  Completer<GoogleMapController> _controller = Completer();

  void getLocation() async {
    currentPosition = await location.getLocation();
    print(currentPosition);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
    final curvedAnimation = CurvedAnimation(curve: Curves.easeOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    // BlocProvider.of<CheckpointListCubit>(context).checkpoint();
    getLocation();
  }

  // @override
  // void dispose() {
  //   connection!.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CheckInternetCubit, CheckInternetState>(
        builder: (context, state) {
          if (state is CheckInternetStatus == false) {
            return Container();
          }
          var status = (state as CheckInternetStatus).status;
          if (status == true) {
            BlocProvider.of<CheckpointListCubit>(context).checkpoint();
          } else {
            BlocProvider.of<CheckpointListCubit>(context).checkpointOffline();
          }
          return BlocBuilder<CheckpointListCubit, CheckpointListState>(
            builder: (context, state) {
              if (state is CheckpointListLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (state is CheckpointListLoaded == false) {
                return Container(
                  alignment: Alignment.center,
                  child: const Text('Data False'),
                );
              }
              var data = (state as CheckpointListLoaded).json;
              var statusCode = (state as CheckpointListLoaded).statusCode;
              if (data.isEmpty) {
                return InkWell(
                  onTap: () {
                    if (status == true) {
                      BlocProvider.of<CheckpointListCubit>(context).checkpoint();
                    } else {
                      BlocProvider.of<CheckpointListCubit>(context).checkpointOffline();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text('Data Kosong \n ketuk layar untuk refresh'),
                  ),
                );
              }
              if (statusCode != 200) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(data.toString()),
                );
              }
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  if(status == true){
            BlocProvider.of<CheckpointListCubit>(context).checkpoint();
          } else {
            BlocProvider.of<CheckpointListCubit>(context).checkpointOffline();
          }
                },
                child: ListView.builder(
                    // shrinkWrap: true,
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
                        headerPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        children: [
                          // CHeckpoint
                          AccordionSection(
                              header: Text(
                                a['nama_lokasi'],
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              leftIcon: IconButton(
                                  onPressed: () {
                                    print('ID LOKASI: ${a['id']}');
                                    Navigator.pushNamed(context, EDIT_CHECKPOINT, arguments: {
                                      'id': a['id'],
                                      'nama_lokasi': a['nama_lokasi'],
                                      'keterangan': a['keterangan'],
                                      'lati': a['lati'],
                                      'longi': a['longi'],
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                              content: Column(
                                children: [
                                  Text(
                                    a['keterangan'],
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4.0),
                                  const Divider(thickness: 2, color: Colors.grey),
                                  const SizedBox(height: 4.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Task Checkpoint',
                                        style: TextStyle(color: Colors.black, fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: SpanButton(
                                          onTap: () {
                                            print('tambah task');
                                            Navigator.pushNamed(context, ADD_TASK, arguments: {
                                              'id_lokasi': a['id'],
                                            });
                                          },
                                          text: 'Tambah Task',
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  a['tasks'].length == 0
                                      ? Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          child: const Text('Task Kosong'),
                                        )
                                      : ListView.builder(
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
                                                
                                                leftIcon: IconButton(
                                                    onPressed: () {
                                                      print(b['id']);
                                                      Navigator.pushNamed(context, EDIT_TASK, arguments: {
                                                        'id_lokasi': a['id'],
                                                        'id_task': b['id'],
                                                        'task': b['task'],
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    )),
                                                headerPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                children: [
                                                  AccordionSection(
                                                      header: Text(
                                                        b['task'],
                                                        style: const TextStyle(color: Colors.white, fontSize: 16),
                                                      ),
                                                      content: Column(
                                                        children: [
                                                          const SizedBox(height: 4.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              const Text(
                                                                'Detail Sub Task',
                                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                              ),
                                                              SpanButton(
                                                                onTap: () {
                                                                  Navigator.pushNamed(context, ADD_SUB_TASK, arguments: {
                                                                    'id_task': b['id'],
                                                                  });
                                                                },
                                                                text: 'Tambah Sub Task',
                                                                icon: const Icon(
                                                                  Icons.add,
                                                                  color: Colors.white,
                                                                ),
                                                                color: Colors.blue,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 4.0),
                                                          const Divider(thickness: 2, color: Colors.grey),
                                                          const SizedBox(height: 4.0),
                                                          b['sub_task'].length == 0
                                                              ? Container(
                                                                  alignment: Alignment.center,
                                                                  height: 50,
                                                                  child: const Text('Sub Task Kosong'),
                                                                )
                                                              : ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                  itemCount: b['sub_task'].length,
                                                                  itemBuilder: (context, index3) {
                                                                    var c = b['sub_task'][index3];
                                                                    return Accordion(
                                                                      disableScrolling: true,
                                                                      headerBackgroundColor: c['is_aktif'] == 1 ? Colors.green[700] : Colors.red[700],
                                                                      contentBorderColor: c['is_aktif'] == 1 ? Colors.green[700] : Colors.red[700],
                                                                      leftIcon: IconButton(
                                                                          onPressed: () {
                                                                            print(c['id']);
                                                                            Navigator.pushNamed(context, EDIT_SUB_TASK, arguments: {
                                                                              'id_sub_task': c['id'],
                                                                              'id_task': b['id'],
                                                                              'sub_task': c['sub_task'],
                                                                              'keterangan': c['keterangan'],
                                                                              'is_aktif': c['is_aktif'],
                                                                            });
                                                                          },
                                                                          icon: const Icon(
                                                                            Icons.edit,
                                                                            color: Colors.white,
                                                                          )),
                                                                      children: [
                                                                        AccordionSection(
                                                                          header: Text(
                                                                            c['sub_task'],
                                                                            style: const TextStyle(color: Colors.white, fontSize: 16),
                                                                          ),
                                                                          content: Text(
                                                                            c['keterangan'],
                                                                            style: const TextStyle(color: Colors.black, fontSize: 16),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                    // return Container(
                                                                    //   margin: const EdgeInsets.all(8.0),
                                                                    //   padding: const EdgeInsets.all(8.0),
                                                                    //   decoration: BoxDecoration(
                                                                    //       color: c['is_aktif'] == 1 ? Colors.green[600] : Colors.red[700],
                                                                    //       borderRadius: BorderRadius.circular(8.0),
                                                                    //       boxShadow: [
                                                                    //         BoxShadow(
                                                                    //             color: Colors.grey.withOpacity(0.4), blurRadius: 1.2, spreadRadius: 1.2, offset: Offset(1, 2))
                                                                    //       ]),
                                                                    //   child: Column(
                                                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                                                    //     children: [
                                                                    //       Text(
                                                                    //         c['sub_task'],
                                                                    //         style: TextStyle(color: Colors.white, fontSize: 16),
                                                                    //       ),
                                                                    //       const SizedBox(height: 8.0),
                                                                    //       Text(
                                                                    //         c['keterangan'],
                                                                    //         style: TextStyle(color: Colors.white, fontSize: 16),
                                                                    //       ),
                                                                    //     ],
                                                                    //   ),
                                                                    // );
                                                                  },
                                                                ),
                                                        ],
                                                      )),
                                                ]);
                                          },
                                        ),
                                ],
                              )),
                        ],
                      );
                    }),
              );
            },
          );
        },
      ),
    );
  }
}
