import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class MyBanner {
  static bannerSuccess(message) {
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      // forceActionsBelow: true,
      duration: Duration(seconds: 1),
      content: AwesomeSnackbarContent(
        title: 'Oh Hey!!',
        message: message,
        contentType: ContentType.success,
        inMaterialBanner: true,
      ),
      // actions: const [SizedBox.shrink()],
    );
  }
  static bannerFailed(message) {
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: 2),
      // forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: 'Ups Error',
        message: message,
        contentType: ContentType.failure,
        inMaterialBanner: true,
      ),
      // actions:  [SizedBox.shrink()],
    );
  }
}
