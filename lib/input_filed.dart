import 'package:flutter/material.dart';
import 'package:pfe_syrine/theme/theme.dart';
import 'package:textfield_search/textfield_search.dart';

class MyInputfiled extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  MyInputfiled({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            Container(
                height: 52,
                margin: EdgeInsets.only(top: 8.0),
                padding: EdgeInsets.only(left: 14),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      // width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Expanded(
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                          },
                          readOnly: widget == null ? false : true,
                          autofocus: false,
                          cursorColor: Colors.grey[700],
                          controller: controller,
                          style: subtitleStyle,
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: subtitleStyle,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                            ),
                          ))),
                  widget == null
                      ? Container()
                      : Container(
                          child: widget,
                        )
                ])),
          ],
        ),
      ),
    );
  }
}

class MyInputtext extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputtext({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
              height: 52,
              margin: EdgeInsets.only(top: 8.0),
              padding: EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    // width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is required";
                          }
                        },
                        maxLines: 15,
                        readOnly: widget == null ? false : true,
                        autofocus: false,
                        cursorColor: Colors.grey[700],
                        controller: controller,
                        style: subtitleStyle,
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: subtitleStyle,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ))),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ])),
        ],
      ),
    );
  }
}

class MyInputsearch extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  MyInputsearch({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  });
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  TextEditingController user = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
              height: 52,
              margin: EdgeInsets.only(top: 8.0),
              padding: EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    // width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Expanded(
                  child: TextFieldSearch(
                    // value: _customerName,
                    initialList: remindList,
                    controller: user, label: 'User',
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
