import 'package:flutter/material.dart';

class CustomButtonSave extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Icon? icon;

  const CustomButtonSave({super.key, this.onPressed, this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        fixedSize: Size.fromHeight(50)
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
