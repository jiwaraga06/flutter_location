import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFielPass extends StatelessWidget {
  final String? hint, label,msgError;
  final TextEditingController? controller;
  final Icon? iconLock;
  final VoidCallback? showPass;
  final bool? iconPass;

  const CustomTextFielPass({
    super.key,
    this.hint,
    this.label,
    this.controller,
    this.iconLock,
    this.showPass,
    this.iconPass,
    this.msgError,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Color(0xFF0D4C92),
      style: GoogleFonts.lato(),
      obscureText: iconPass!,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        errorStyle: GoogleFonts.lato(
          fontSize: 15
        ),
        suffixIcon: InkWell(
          onTap: showPass,
          child: iconPass! ? Icon(FontAwesomeIcons.lock) : Icon(FontAwesomeIcons.lockOpen),
        ),
        labelStyle: GoogleFonts.lato(
          color: Color(0xFF0D4C92),
        ),
        hintStyle: GoogleFonts.lato(),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: Color(0xFF0D4C92),
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        
      ),
      validator: (value){
        if(value == null || value.isEmpty){
          return msgError;
        }
        return null;
      },
    );
  }
}
