import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showLoader(context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Dialog(
            insetPadding: const EdgeInsets.all(200.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              decoration: BoxDecoration(
                //color: Theme.of(context).hoverColor,
                borderRadius: BorderRadius.circular(7),
              ),
              width: 60,
              height: 60,
              child: const SpinKitSpinningLines(
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        );
      });
}
