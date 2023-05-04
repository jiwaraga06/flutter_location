import 'dart:io';
import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/AbsenLokasi/cubit/absen_lokasi_cubit.dart';
import 'package:flutter_location/source/widget/custom_banner.dart';
import 'package:flutter_location/source/widget/custom_btnSave.dart';
import 'package:flutter_location/source/widget/custom_loading.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class IsiTask {
  int? id_sub_task;
  String? photo, checklist, note;

  IsiTask(this.id_sub_task, this.photo, this.checklist, this.note);
  Map toJson() => {
        'sub_task_id': id_sub_task,
        'photo': photo,
        'checklist': checklist,
        'note': note,
      };
  @override
  String toString() => '{sub_task_id: $id_sub_task, photo: $photo, checklist: $checklist, note: $note}';
}

class AbsenCheckpoint extends StatefulWidget {
  dynamic data;
  AbsenCheckpoint({super.key, this.data});

  @override
  State<AbsenCheckpoint> createState() => _AbsenCheckpointState();
}

class _AbsenCheckpointState extends State<AbsenCheckpoint> {
  TextEditingController controllerNote = TextEditingController();
  // List<List<bool>>? values;
  bool values = false;
  int valCheck = 0;
  List compareList = [];
  String? base64String;
  CroppedFile? cropedGambar;
  File? image;
  List<IsiTask> isiTask = [];
  Future pilihGambar() async {
    XFile? gambar = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 300,
      imageQuality: 100,
    );
    cropGambar(gambar!.path);
    // File imageResized = await FlutterNativeImage.compressImage(gambar.path, quality: 100, targetWidth: 120, targetHeight: 120);
    // List<int> imgByte = imageResized.readAsBytesSync();
    // base64String = 'data:image/png;base64,${base64Encode(imgByte)}';
    // print(base64String);
  }

  Future cropGambar(filePath) async {
    cropedGambar = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Gambar',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Gambar',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    print('Gambar');
    print(cropedGambar!.path);
    // File imageResized = await FlutterNativeImage.compressImage(cropedGambar!.path, quality: 100, targetWidth: 120, targetHeight: 120);
    final imageResized = File(cropedGambar!.path).readAsBytesSync();
    // final imgByte = imageResized.readAsBytesSync();
    base64String = 'data:image/png;base64,${Base64Encoder().convert(imageResized)}';
    // base64String = 'data:image/png;base64';
    setState(() {});
    // Base64Encoder().convert(imageResized);
  }

  void fillask(id_sub_task) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              height: 600,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          'Form Input',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const Divider(thickness: 2),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () async {
                            await pilihGambar();
                            setState(() {});
                          },
                          child: Container(
                            height: 320,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: cropedGambar == null
                                ? Icon(FontAwesomeIcons.images, size: 40)
                                : Image.file(
                                    File(cropedGambar!.path),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                        width: 100,
                                        height: 100,
                                        child: const Center(
                                          child: const Text('Error load image', textAlign: TextAlign.center),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: controllerNote,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Catatan',
                            prefixIcon: Icon(FontAwesomeIcons.noteSticky),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        
                        const SizedBox(height: 8.0),
                        Table(
                          columnWidths: const {
                            0: FixedColumnWidth(100),
                            1: FixedColumnWidth(10),
                          },
                          children: [
                            TableRow(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Text(
                                    'Checklist',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          values = !values;
                                        });
                                      },
                                      icon: values == true ? Icon(FontAwesomeIcons.squareCheck) : Icon(FontAwesomeIcons.square),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('BATAL', style: TextStyle(fontSize: 17))),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              var input = {'sub_task_id': id_sub_task, 'photo': '${base64String}', 'checklist': '$values', 'note': controllerNote.text};
                              // print(input);
                              var a = isiTask.indexWhere((element) => element.id_sub_task == id_sub_task);
                              print(a);
                              if (a != -1) {
                                setState(() {
                                  isiTask[a].photo = '${base64String}';
                                  isiTask[a].checklist = '1';
                                  isiTask[a].note = controllerNote.text;
                                });
                              } else if (a == -1) {
                                setState(
                                  () {
                                    IsiTask task = IsiTask(id_sub_task, '', '', '');
                                    task.id_sub_task = id_sub_task;
                                    task.photo = '${base64String}';
                                    task.checklist = '1';
                                    task.note = controllerNote.text;
                                    isiTask.add(task);
                                  },
                                );
                              }
                              isiTask;
                              setState(() {
                                isiTask;
                              });
                            },
                            child: Text('SIMPAN', style: TextStyle(fontSize: 17))),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }

  void compare() {
    widget.data['sub_task'].forEach((e) {
      if (e['is_aktif'] == 1) {
        compareList.add(e);
      }
    });
  }

  void save() {
    print(isiTask.length);
    if (isiTask.isEmpty) {
      final materialBanner = MyBanner.bannerFailed('Data Masih Kosong');
      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showMaterialBanner(materialBanner);
    }
    BlocProvider.of<AbsenLokasiCubit>(context).postAbsenLokasi(widget.data['id_lokasi'], isiTask.toList());
  }

  void saveOffline() {
    print('save offline');
    if (isiTask.isEmpty) {
      final materialBanner = MyBanner.bannerFailed('Data Masih Kosong');
      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showMaterialBanner(materialBanner);
    }
    BlocProvider.of<AbsenLokasiCubit>(context).postAbsenLokasiOffline(widget.data['id_lokasi'], widget.data['task'], isiTask.toList());
  }

  @override
  void initState() {
    super.initState();
    print(widget.data);
    compare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absen Checkpoint'),
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

        return BlocListener<AbsenLokasiCubit, AbsenLokasiState>(
          listener: (context, state) {
            if (state is AbsenLokasiloading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const CustomLoading();
                },
              );
            }
            if (state is AbsenLokasiloaded) {
              var json = state.json;
              var statusCode = state.statusCode;
              Navigator.pop(context);
              if (statusCode == 200) {
                Navigator.pop(context);
                final materialBanner = MyBanner.bannerSuccess(json['message'].toString());
                ScaffoldMessenger.of(context)
                  ..hideCurrentMaterialBanner()
                  ..showSnackBar(materialBanner);
              } else {
                final materialBanner = MyBanner.bannerFailed('${json['message']} \n ${json['errors'] != null ? json['errors'] : ''}');
                ScaffoldMessenger.of(context)
                  ..hideCurrentMaterialBanner()
                  ..showMaterialBanner(materialBanner);
              }
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // ElevatedButton(
                    //     onPressed: () {
                    //       // isiTask.clear();
                    //       // compare();
                    //       print(compareList);
                    //       print(isiTask);
                    //     },
                    //     child: Text('data')),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8.0), boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 1.3,
                          spreadRadius: 1.3,
                          offset: Offset(1, 3),
                        )
                      ]),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(80),
                          1: FixedColumnWidth(10),
                        },
                        children: [
                          TableRow(
                            children: [
                              SizedBox(
                                height: 35,
                                child: Text(
                                  'Task',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                              Text(
                                ':',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              Text(
                                widget.data['task'],
                                style: TextStyle(fontSize: 17, color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.data['sub_task'].length,
                      itemBuilder: (context, index) {
                        var sub = widget.data['sub_task'][index];
                        return Accordion(
                          paddingListBottom: 2,
                          disableScrolling: true,
                          scaleWhenAnimating: true,
                          openAndCloseAnimation: true,
                          headerBackgroundColor: sub['is_aktif'] == 1 ? Color(0XFF00ABB3) : Color(0xFFE0144C),
                          contentBorderColor: sub['is_aktif'] == 1 ? Color(0XFF00ABB3) : Color(0xFFE0144C),
                          headerPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          children: [
                            AccordionSection(
                              header: Text(
                                sub['sub_task'],
                                style: const TextStyle(color: Colors.white, fontSize: 17),
                              ),
                              content: Column(
                                children: [
                                  Table(
                                    columnWidths: const {
                                      0: FixedColumnWidth(100),
                                      1: FixedColumnWidth(10),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          SizedBox(
                                            height: 35,
                                            child: Text(
                                              'Keterangan',
                                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
                                            ),
                                          ),
                                          Text(
                                            ':',
                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
                                          ),
                                          Text(
                                            sub['keterangan'],
                                            style: TextStyle(fontSize: 17, color: Colors.black),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 12.0),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: sub['is_aktif'] == 1
                                          ? () {
                                              print(sub['id']);
                                              fillask(sub['id']);
                                            }
                                          : () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: sub['is_aktif'] == 1 ? Colors.teal : Color(0xFF9A1663),
                                        maximumSize: const Size.fromHeight(50),
                                      ),
                                      child: Text(sub['is_aktif'] == 1 ? 'ISI TASK' : 'TASK INACTIVE',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonSave(
                        onPressed: status == true
                            ? () {
                                save();
                              }
                            : () {
                                saveOffline();
                              },
                        text: 'SIMPAN',
                        icon: Icon(FontAwesomeIcons.check, color: Colors.white, size: 17),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
