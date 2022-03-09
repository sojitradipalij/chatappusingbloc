import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const MaterialColor primaryMaterialColor = MaterialColor(
  0xff000000,
  <int, Color>{
    50: Color(0xff000000),
    100: Color(0xff000000),
    200: Color(0xff000000),
    300: Color(0xff000000),
    400: Color(0xff000000),
    500: Color(0xff000000),
    600: Color(0xff000000),
    700: Color(0xff000000),
    800: Color(0xff000000),
    900: Color(0xff000000),
  },
);

const primaryColor = Color(0xff000000);

var blackRegular14 = const TextStyle(
  color: Colors.black,
  fontSize: 14,
);

TextStyle blackBold14 = const TextStyle(
    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);

var blackRegular16 = const TextStyle(
  color: Colors.black,
  fontSize: 16,
);

var blackRegular18 = const TextStyle(
  color: Colors.black,
  fontSize: 18,
);

var blackBold16 = const TextStyle(
    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);

var blackBold18 = const TextStyle(
    color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);

var hintTextStyle = const TextStyle(
  color: Colors.grey,
  fontSize: 14,
);

var whiteRegular14 = const TextStyle(
  color: Colors.white,
  fontSize: 14,
);

var whiteBold14 = const TextStyle(
    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500);

var whiteRegular16 = const TextStyle(
  color: Colors.white,
  fontSize: 16,
);

var whiteBold16 = const TextStyle(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500);

Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

showToast(String text) {
  Fluttertoast.showToast(
      msg: text, toastLength: Toast.LENGTH_LONG, fontSize: 16);
}
