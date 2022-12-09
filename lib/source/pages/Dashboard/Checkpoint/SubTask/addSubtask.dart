import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/checkpoint_list_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataSubTask/cubit/add_subtask_cubit.dart';
import 'package:flutter_location/source/data/Offline/Sql/sql.dart';
import 'package:flutter_location/source/widget/custom_banner.dart';
import 'package:flutter_location/source/widget/custom_btnSave.dart';
import 'package:flutter_location/source/widget/custom_loading.dart';
import 'package:flutter_location/source/widget/custom_notefield.dart';
import 'package:flutter_location/source/widget/custom_text_field.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddSubTask extends StatefulWidget {
  dynamic data;
  AddSubTask({super.key, this.data});

  @override
  State<AddSubTask> createState() => _AddSubTaskState();
}

class _AddSubTaskState extends State<AddSubTask> {
  TextEditingController controllerSubTask = TextEditingController();
  TextEditingController controllerKet = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isAktif = false;
  int is_aktif = 0;

  void save() {
    print('save online');
    BlocProvider.of<AddSubtaskCubit>(context).addSubTask(
      widget.data['id_task'],
      controllerSubTask.text,
      controllerKet.text,
      is_aktif,
    );
  }

  void saveOffline() async {
    print('save offline');
    await SQLHelper.insertSubTaskForm(
        widget.data['id_task'], controllerSubTask.text, controllerKet.text, is_aktif, DateTime.now().toString(), DateTime.now().toString(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Detail Task'),
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
        return BlocListener<AddSubtaskCubit, AddSubtaskState>(
          listener: (context, state) async {
            if (state is AddSubtaskLoading) {
              showDialog(
                context: context,
                builder: (context) {
                  return const CustomLoading();
                },
              );
            }
            if (state is AddSubtaskLoaded) {
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
          child: ListView(
            children: [
              const SizedBox(height: 12.0),
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: isAktif ? Colors.green[700] : Colors.red[700], borderRadius: BorderRadius.circular(8.0), boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 1.3,
                    spreadRadius: 1.3,
                    offset: Offset(1, 3),
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAktif == true ? 'STATUS TASK | AKTIF' : 'STATUS TASK | TIDAK AKTIF',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    CupertinoSwitch(
                      value: isAktif,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          isAktif = value;
                          if (value == true) {
                            is_aktif = 1;
                          } else {
                            is_aktif = 0;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      const SizedBox(height: 12.0),
                      CustomFormField(
                        controller: controllerSubTask,
                        iconLock: Icon(FontAwesomeIcons.list),
                        hint: 'Masukan Detail Task',
                      ),
                      const SizedBox(height: 12.0),
                      CustomNoteField(
                        controller: controllerKet,
                        iconLock: Icon(FontAwesomeIcons.noteSticky),
                        hint: 'Isi keterangan Detail Task',
                      ),
                      const SizedBox(height: 8.0),
                      const Divider(thickness: 2),
                      const SizedBox(height: 20.0),
                      CustomButtonSave(
                        onPressed: status == true
                            ? () {
                                save();
                              }
                            : () {
                                saveOffline();
                              },
                        text: 'SIMPAN',
                        icon: Icon(FontAwesomeIcons.check),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
