import 'package:flutter/material.dart';

class CustomStatusKoneksi extends StatelessWidget {
  final Color? color;
  const CustomStatusKoneksi({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      width: 24,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
      margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color!,
        borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}