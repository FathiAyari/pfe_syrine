import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Padding InputField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Required field";
        }
      },
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff7ea4f3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ), //
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff7ea4f3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff7ea4f3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ), // OutlineInputBorder
        filled: true,
        fillColor: Colors.white,
        label: Text("$label"),
      ), // InputDecoration
    ),
  );
}
