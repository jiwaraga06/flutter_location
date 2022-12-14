import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataCheckpoint/cubit/checkpoint_list_cubit.dart';
import 'package:flutter_location/source/data/Checkpoint/DataTask/cubit/add_task_cubit.dart';
import 'package:flutter_location/source/data/Offline/Sql/sql.dart';
import 'package:flutter_location/source/widget/custom_banner.dart';
import 'package:flutter_location/source/widget/custom_btnSave.dart';
import 'package:flutter_location/source/widget/custom_loading.dart';
import 'package:flutter_location/source/widget/custom_text_field.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddTask extends StatefulWidget {
  dynamic data;
  AddTask({super.key, this.data});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController controllerTask = TextEditingController();
  final formkey = GlobalKey<FormState>();
  void save() {
    print('save online');
    BlocProvider.of<AddTaskCubit>(context).addTask(widget.data['id_lokasi'], controllerTask.text);
  }

  void saveOffline() async{
    print('save offline');
    await SQLHelper.insertTaskForm(widget.data['id_lokasi'], controllerTask.text, DateTime.now().toString(), DateTime.now().toString(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Task'),
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
        return BlocListener<AddTaskCubit, AddTaskState>(
          listener: (context, state) async {
            if (state is AddTaskLoading) {
              showDialog(
                context: context,
                builder: (context) {
                  return const CustomLoading();
                },
              );
            }
            if (state is AddTaskLoaded) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        CustomFormField(
                          hint: 'Masukan Task',
                          controller: controllerTask,
                          iconLock: Icon(FontAwesomeIcons.listCheck),
                        ),
                        const SizedBox(height: 12.0),
                        CustomButtonSave(
                          onPressed: status == true ? () {
                            save();
                          } : () {
                            saveOffline();
                          },
                          text: 'SIMPAN',
                          icon: const Icon(FontAwesomeIcons.check, color: Colors.white),
                        )
                      ],
                    )),
              ),
            ],
          ),
        );
      }),
    );
  }
}
