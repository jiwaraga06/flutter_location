import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/Auth/cubit/ganti_password_cubit.dart';
import 'package:flutter_location/source/data/CheckInternet/cubit/check_internet_cubit.dart';
import 'package:flutter_location/source/widget/custom_banner.dart';
import 'package:flutter_location/source/widget/custom_button.dart';
import 'package:flutter_location/source/widget/custom_loading.dart';
import 'package:flutter_location/source/widget/custom_text_field.dart';
import 'package:flutter_location/source/widget/custom_text_field_pass.dart';
import 'package:flutter_location/source/widget/status_koneksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

class GantiPassword extends StatefulWidget {
  dynamic data;
  GantiPassword({super.key, this.data});

  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  TextEditingController controllerOldPass = TextEditingController();
  TextEditingController controllerNewPass = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool passOld = true;
  bool passNew = true;
  void showPassOld() {
    setState(() {
      passOld = !passOld;
    });
  }

  void showPassNew() {
    setState(() {
      passNew = !passNew;
    });
  }

  void changePw() {
    BlocProvider.of<GantiPasswordCubit>(context).gantiPassword(
      widget.data['barcode'],
      controllerOldPass.text,
      controllerNewPass.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Kembali"),
          elevation: 0.0,
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
        body: BlocListener<GantiPasswordCubit, GantiPasswordState>(
          listener: (context, state) async {
            if (state is GantiPasswordLoading) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomLoading();
                  });
            }
            if (state is GantiPasswordLoaded) {
              Navigator.pop(context);
              var json = state.json;
              var statusCode = state.statusCode;
              if (statusCode == 200) {
                final materialBanner = MyBanner.bannerSuccess(json['message']);
                ScaffoldMessenger.of(context)
                  ..hideCurrentMaterialBanner()
                  ..showSnackBar(materialBanner);
                await Future.delayed(Duration(seconds: 1));
                Navigator.pop(context);
              } else if (statusCode == 500) {
                final materialBanner = MyBanner.bannerFailed("${json['message']}");
                ScaffoldMessenger.of(context)
                  ..hideCurrentMaterialBanner()
                  ..showMaterialBanner(materialBanner);
              } else {
                final materialBanner = MyBanner.bannerFailed("""${json['message']} \n 
                ${json['errors'].toString()} \n """);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password,",
                            style: GoogleFonts.lato(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Ganti Password User",
                            style: GoogleFonts.lato(color: Colors.grey, fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                enabled: false,
                                initialValue: widget.data['barcode'],
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  prefixIcon: Icon(FontAwesomeIcons.idCardClip, color: Colors.grey[400]),
                                  prefixIconConstraints: BoxConstraints(minWidth: 60),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Divider(thickness: 2),
                              const SizedBox(height: 20),
                              CustomTextFielPass(
                                controller: controllerOldPass,
                                hint: "Masukan Password Lama",
                                label: "Password Lama",
                                iconLock: Icon(FontAwesomeIcons.key),
                                showPass: showPassOld,
                                iconPass: passOld,
                              ),
                              const SizedBox(height: 20),
                              CustomTextFielPass(
                                controller: controllerNewPass,
                                hint: "Masukan Password Baru",
                                label: "Password Baru",
                                iconLock: Icon(FontAwesomeIcons.key),
                                showPass: showPassNew,
                                iconPass: passNew,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        onPressed: () {
                          changePw();
                        },
                        text: "SAVE",
                      ),
                      SizedBox(
                          height: 50,
                          child: Marquee(
                            text: "IT DEPARTEMENT | PT SIPATEX PUTRI LESTARI",
                            blankSpace: 50,
                            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700),
                          )),
                      //  Text(
                      //       "IT DEPARTEMENT | PT SIPATEX PURTI LESTARI",
                      //     ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
