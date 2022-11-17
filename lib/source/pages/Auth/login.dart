import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/source/data/Auth/cubit/auth_cubit.dart';
import 'package:flutter_location/source/router/string.dart';
import 'package:flutter_location/source/widget/custom_banner.dart';
import 'package:flutter_location/source/widget/custom_button.dart';
import 'package:flutter_location/source/widget/custom_button_2.dart';
import 'package:flutter_location/source/widget/custom_loading.dart';
import 'package:flutter_location/source/widget/custom_text_field.dart';
import 'package:flutter_location/source/widget/custom_text_field_pass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  var error = {};
  bool pass = true;
  void showPass() {
    setState(() {
      pass = !pass;
    });
  }

  Future<String?> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      print(iosDeviceInfo.identifierForVendor);
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print(androidDeviceInfo.id);
      return androidDeviceInfo.device; // unique ID on Android
    }
  }

  @override
  void initState() {
    super.initState();
    _getId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomLoading();
              });
        }
        if (state is LoginLoaded) {
          Navigator.pop(context);
          var json = state.json;
          var statusCode = state.statusCode;
          if (statusCode == 200) {
            if (json['status'] == 500) {
              final materialBanner = MyBanner.bannerFailed(json['message']);
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showMaterialBanner(materialBanner);
            } else {
              final materialBanner = MyBanner.bannerSuccess(json['message']);
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showMaterialBanner(materialBanner);
            }
          } else {
            final materialBanner = MyBanner.bannerFailed("${json['message']} \n ${json['errors']['barcode'][0]} \n ${json['errors']['password'][0]}");
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
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang,",
                        style: GoogleFonts.lato(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Silahkan masuk untuk lanjut",
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
                          CustomFormField(
                            controller: controllerUsername,
                            hint: "Masukan Username",
                            label: "Username",
                            // msgError: "Kolom harus di isi",
                          ),
                          const SizedBox(height: 20),
                          CustomTextFielPass(
                            controller: controllerPassword,
                            hint: "Masukan Password",
                            label: "Password",
                            showPass: showPass,
                            iconPass: pass,
                            // msgError: "Kolom harus di isi",
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).login(controllerUsername.text, controllerPassword.text);
                    if (formkey.currentState!.validate()) {}
                  },
                  text: "Login",
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lupa Password ?",
                      style: GoogleFonts.lato(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, GANTI_PASSWORD);
                      },
                      child: Text(
                        " Klik Disini",
                        style: GoogleFonts.lato(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      height: 50,
                      child: Marquee(
                        text: "IT DEPARTEMENT | PT SIPATEX PUTRI LESTARI",
                        blankSpace: 50,
                        style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                ],
              ))
        ],
      ),
    ));
  }
}
