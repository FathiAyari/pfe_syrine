import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import '../login/login.dart';
import '../onboarding/on_boarding_page.dart';
import '../planning/components/my_plannings.dart';
import '../planning/planning.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplasScreenState createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplashScreen> {
  var seen = GetStorage().read("seen");
  var token = GetStorage().read("token");
  var user = GetStorage().read("user");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(user);
    Timer(
        Duration(seconds: 4),
        () => Get.to(seen == 1
            ? (user == null
                ? LoginScreen()
                : (user['role'] == "Super Admin" || user['role'] == "Admin")
                    ? CalendarPage()
                    : MyPlannings())
            : OnBoardingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/logo_ph_c.png",
                height: Constants.screenHeight * 0.3,
                width: Constants.screenWidth * 0.7,
              ),
              Lottie.asset(
                "assets/loading.json",
                height: Constants.screenWidth * 0.15,
              )
            ],
          ),
        ));
  }
}
