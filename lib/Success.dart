import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Success {
  void toastMessage(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Color(0xff1DB954),
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}