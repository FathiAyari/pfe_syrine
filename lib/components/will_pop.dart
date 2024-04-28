import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import '../constants.dart';

class WillPop {
  showAlertDialog(BuildContext context, String title) {
    NAlertDialog(
      title: WillPopTitle(title, context),
      actions: [Negative(), Positive(() {})],
      blur: 2,
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }
}

WillPopTitle(String title, BuildContext context) {
  return Column(
    children: [
      Image.asset(
        "assets/warning.png",
        height: Constants.screenHeight * 0.06,
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontFamily: "NunitoBold",
        ),
      ),
    ],
  );
}

Widget Positive(VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xfff563a2),
      ),
      child: Container(
        height: 20,
        child: TextButton(
            onPressed: onPressed,
            child: Text(
              "Yes",
              style: TextStyle(
                fontFamily: "NunitoBold",
                color: Color(0xffEAEDEF),
              ),
            )),
      ),
    ),
  );
}

Widget Negative() {
  return Builder(builder: (context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff3dc295),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "No",
              style: TextStyle(
                fontFamily: "NunitoBold",
                color: Color(0xffEAEDEF),
              ),
            )),
      ),
    );
  });
}
