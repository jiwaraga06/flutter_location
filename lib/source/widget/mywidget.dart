import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomWidget {
  static Widget textfield(String hint, TextEditingController controller){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.lato(),
      ),
    );
  }
}