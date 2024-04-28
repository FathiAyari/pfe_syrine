import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_syrine/components/rounded_button.dart';
import 'package:pfe_syrine/components/rounded_input.dart';
import 'package:pfe_syrine/screens/planning/components/my_plannings.dart';

import '../../../components/input_container.dart';
import '../../../constants.dart';
import '../../../models/api_services.dart';
import '../../../services/api.dart';
import '../../../services/auth_services.dart';
import '../../planning/planning.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
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
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  bool _isHidden = true;
  TextEditingController password = TextEditingController();
  bool loading = false;
  loginPressed() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      setState(() {
        loading = true;
      });
      ApiResponse apiResponse = ApiResponse();
      http.Response response = await AuthServices.login(email.text, password.text);
      print(response.body);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        GetStorage().write('user', {
          'firstname': responseMap['user']["firstname"],
          'email': responseMap['user']["email"],
          'lastname': responseMap['user']["lastname"],
          'role': responseMap['user']["role"],
          'population': responseMap['user']["population"],
          'id': responseMap['user']["id"],
          'token': responseMap["token"],
        });

        if (responseMap['user']["role"] == "Admin" || responseMap['user']["role"] == "Super Admin") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CalendarPage(),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MyPlannings(),
              ));
        }
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Invalid cridentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 1.0 : 0.0,
      duration: widget.animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: widget.size.width,
          height: widget.defaultLoginSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                SizedBox(height: 25),

                SvgPicture.asset('assets/login.svg'),

                SizedBox(height: 40),

                RoundedInput(
                  icon: Icons.mail,
                  hint: 'Email',
                  controller: email,
                ),
                // RoundedPassInput(icon: Icons.password, hint: 'Password', controller: password, isHidden: _isHidden, ontap: () {  _togglePasswordView();},),

                InputContainer(
                  child: TextFormField(
                    cursorColor: kPrimaryColor,
                    controller: password,
                    obscureText: _isHidden,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        icon: Icon(Icons.password, color: kPrimaryColor),
                        hintText: 'Password',
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                        border: InputBorder.none),
                  ),
                ),

                SizedBox(height: 10),

                loading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : RoundedButton(
                        title: 'LOGIN',
                        ontap: () {
                          loginPressed();
                        },
                      ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
