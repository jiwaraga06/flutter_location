import 'dart:ui';

import 'package:flutter/material.dart';

class SpanButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final Color? color;
  final Icon? icon;

  const SpanButton({super.key, this.onTap, this.text, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color!, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          )
        ),
        child: Row(
          children: [
            icon!,
            Text(text!, style: TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
