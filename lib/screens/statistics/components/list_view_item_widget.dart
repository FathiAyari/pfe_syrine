import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

InkWell ListViewItem(Widget directionWidget, String image, String label, Color color, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => directionWidget));
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.03, vertical: Constants.screenHeight * 0.01),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: Constants.screenHeight * 0.13,
        child: ListTile(
          title: Row(
            children: [
              Container(
                height: Constants.screenHeight * 0.08,
                decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        "${image}",
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${label}",
                  style: TextStyle(fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                ),
              )
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
