import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_location/source/widget/custom_button.dart';
import 'package:flutter_location/source/widget/custom_text_field.dart';
import 'package:flutter_location/source/widget/custom_text_field_pass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

class GantiPassword extends StatefulWidget {
  const GantiPassword({super.key});

  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  TextEditingController controllerOldPass = TextEditingController();
  TextEditingController controllerNewPass = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool passOld = true;
  bool passNew = true;
  void showPassOld(){
    setState(() {
      passOld = !passOld;
    });
  }
  void showPassNew(){
    setState(() {
      passNew = !passNew;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kembali"),
        elevation: 0.0,
      ),
        body: CustomScrollView(
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
                        CustomTextFielPass(
                          controller: controllerOldPass,
                          hint: "Masukan Password Lama",
                          label: "Password Lama",
                          showPass: showPassOld,
                          iconPass: passOld,
                        ),
                      
                        const SizedBox(height: 20),
                        CustomTextFielPass(
                          controller: controllerNewPass,
                          hint: "Masukan Password Baru",
                          label: "Password Baru",
                          showPass: showPassNew,
                          iconPass: passNew,
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 50),
              CustomButton(
                onPressed: () {
                },
                text: "Ganti Password",
              ),
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
                //  Text(
                //       "IT DEPARTEMENT | PT SIPATEX PURTI LESTARI",
                //     ),
              ],
            ))
      ],
    ));
  }
}