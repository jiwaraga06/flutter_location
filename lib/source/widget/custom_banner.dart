import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class MyBanner {
  static bannerSuccess(message) {
    return MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: 'Oh Hey!!',
        message: message,
        contentType: ContentType.success,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );
  }
  static bannerFailed(message) {
    return MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: 'Oh Hey!!',
        message: message,
        contentType: ContentType.failure,
        inMaterialBanner: true,
      ),
      actions:  [SizedBox.shrink()],
    );
  }
}
