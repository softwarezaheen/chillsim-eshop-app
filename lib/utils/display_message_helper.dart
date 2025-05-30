import "dart:async";

import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

class DisplayMessageHelper {
  static void toast(String msg) {
    unawaited(Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 16,
      backgroundColor: Colors.black,
    ),);
  }
}
