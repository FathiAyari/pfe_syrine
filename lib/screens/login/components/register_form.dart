import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_syrine/components/rounded_button.dart';
import 'package:pfe_syrine/components/rounded_input.dart';

import '../../../services/api.dart';
import '../../../services/auth_services.dart';
import '../../planning/planning.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController job = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;
  createAccountPressed() async {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text);

    if (emailValid) {
      setState(() {
        loading = true;
      });
      http.Response response = await AuthServices.register(firstname.text, lastname.text, email.text, password.text);

      if (response.statusCode == 200) {
        Map responseMap = jsonDecode(response.body);
        GetStorage().write('user', {
          'firstname': responseMap['user']["firstname"],
          'email': responseMap['user']["email"],
          'lastname': responseMap['user']["lastname"],
          'role': responseMap['user']["role"],
          'population': responseMap['user']["population"],
          'id': responseMap['user']["id"],
          'token': responseMap["token"],
        });
        setState(() {
          loading = false;
        });
        Get.to(CalendarPage());
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "An account with the same email exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      errorSnackBar(context, 'Email invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: widget.size.width,
            height: widget.defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Welcome',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 40),
                  RoundedInput(
                    icon: Icons.person,
                    hint: 'First Name',
                    controller: firstname,
                  ),
                  RoundedInput(
                    icon: Icons.face_rounded,
                    hint: 'Last Name',
                    controller: lastname,
                  ),
                  RoundedInput(
                    icon: Icons.mail,
                    hint: 'Email',
                    controller: email,
                  ),
                  RoundedInput(
                    icon: Icons.password,
                    hint: 'Password',
                    controller: password,
                  ),
                  SizedBox(height: 10),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RoundedButton(
                          title: 'SIGN UP',
                          ontap: () {
                            createAccountPressed();
                          },
                        ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
