import 'package:flutter/material.dart';

const String baseURL = "http://192.168.239.10:3000/api/"; //emulator localhost
const String assetsUrl = "http://192.168.239.10:3000"; //emulator localhost

const Map<String, String> headers = {"Content-Type": "application/json"};
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';
errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}
