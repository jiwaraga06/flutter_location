import 'package:flutter/material.dart';

class CustomButtonLogout extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Icon? icon;
  final Color? color;

  const CustomButtonLogout({super.key, this.onPressed, this.text, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color!,
        fixedSize: Size.fromHeight(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text!,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
