import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/Auth/cubit/auth_cubit.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/data/Mqtt/cubit/mqtt_cubit.dart';
import 'package:flutter_location/source/data/TabBar/cubit/tab_bar_cubit.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:flutter_location/source/widget/custom_btnLogout.dart';
import 'package:flutter_location/source/widget/custom_loading.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controllerBerita = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TabBarCubit>(context).getInfoAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is LogoutLoading) {
            const CustomLoading();
          }
          if (state is LogoutLoaded) {
            var json = state.json;
            var statusCode = state.statusCode;
          }
        },
        child: BlocBuilder<TabBarCubit, TabBarState>(
          builder: (context, state) {
            if (state is TabBarLoading) {
              return Container(
                alignment: Alignment.center,
                child: const CupertinoActivityIndicator(),
              );
            }
            if (state is TabBarLoaded == false) {
              return Container(
                alignment: Alignment.center,
                child: const Text('data false'),
              );
            }
            var data = (state as TabBarLoaded).data;
            var role = jsonDecode((state as TabBarLoaded).user_roles);
            // var role = ['security'];
            if (data == null) {
              return Container(
                alignment: Alignment.center,
                child: const Text('Data kosong'),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Center(
                          child: Icon(FontAwesomeIcons.circleUser, size: 65, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 12),
                        const Divider(thickness: 3),
                        TextFormField(
                          enabled: false,
                          initialValue: data['barcode'],
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.idCardClip, color: Colors.indigo[600]),
                            prefixIconConstraints: const BoxConstraints(minWidth: 60),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          enabled: false,
                          initialValue: data['nama'],
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.barcode, color: Colors.grey[700]),
                            prefixIconConstraints: const BoxConstraints(minWidth: 60),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          enabled: false,
                          initialValue: data['gender'] == "l" ? "Pria" : "Wanita",
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            prefixIcon: data['gender'] == "l"
                                ? const Icon(
                                    FontAwesomeIcons.marsStroke,
                                    color: Colors.blue,
                                  )
                                : const Icon(
                                    FontAwesomeIcons.venus,
                                    color: Colors.pink,
                                  ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 60),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          enabled: false,
                          initialValue: role.toString(),
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.list, color: Colors.black),
                            prefixIconConstraints: BoxConstraints(minWidth: 60),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          enabled: false,
                          initialValue: data['warna'],
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.fill, color: Colors.brown[600]),
                            prefixIconConstraints: const BoxConstraints(minWidth: 60),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Divider(thickness: 2),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, GANTI_PASSWORD, arguments: {'barcode': data['barcode']});
                          },
                          splashColor: Colors.blue[300],
                          child: TextFormField(
                            enabled: false,
                            initialValue: 'Ganti Password | Klik disini',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(FontAwesomeIcons.key, color: Colors.grey[700]),
                              prefixIconConstraints: const BoxConstraints(minWidth: 60),
                            ),
                          ),
                        ),
                        role.length == 2
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: controllerBerita,
                                      decoration: InputDecoration(hintText: 'Masukan Isi Berita', prefixIcon: Icon(Icons.message)),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: TextButton(
                                          style: TextButton.styleFrom(backgroundColor: Colors.blue[50]),
                                          onPressed: () {
                                            BlocProvider.of<MqttCubit>(context).send(controllerBerita.text);
                                          },
                                          child: Text("Kirim Berita")),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, CHECKPOINT_LOKAL);
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                                        child: Text('Checkpoint Offline'),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, ABSEN_LOKAL);
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                                        child: Text('Absen Checkpoint Offline'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : role.length == 1
                                ? role[0] == 'admin_scr'
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: controllerBerita,
                                              decoration: InputDecoration(hintText: 'Masukan Isi Berita', prefixIcon: Icon(Icons.message)),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: TextButton(
                                                  style: TextButton.styleFrom(backgroundColor: Colors.blue[50]),
                                                  onPressed: () {
                                                    BlocProvider.of<MqttCubit>(context).send(controllerBerita.text);
                                                  },
                                                  child: Text("Kirim Berita")),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                                                child: Text('Checkpoint Offline'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                                          child: Text('Absen Checkpoint Offline'),
                                        ),
                                      )
                                : Container(),
                        const SizedBox(height: 8),
                        const Divider(thickness: 2),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        '''CATATAN: Jika Sudah Selesai Mengerjakan Tugas, 
Silahkan Hapus Aplikasi Security Point di Riwayat Aplikasi, 
Tidak Perlu Logout Akun
                      ''',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonLogout(
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Exit Account',
                              desc: 'Apakah Anda yakin ingin Keluar ?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                BlocProvider.of<AuthCubit>(context).logout(context);
                              },
                            ).show();
                          },
                          text: 'LOGOUT',
                          color: Colors.red[800],
                          icon: const Icon(FontAwesomeIcons.close),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
