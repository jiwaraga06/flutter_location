import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
               padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CupertinoActivityIndicator(radius: 16),
            SizedBox(height: 8),
            Text("Sedang Memuat")
          ],
        ),
      ),
    );
  }
}