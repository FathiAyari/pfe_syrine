import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/screens/user/user.dart';
import 'package:pfe_syrine/services/user_services.dart';

import '../../../constants.dart';
import '../../../models/population.dart';
import '../../../services/callapi.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  int? populationId;
  Population? population;
  int? roleId;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Population> populations = [];
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  List roles = [
    {
      "label": "Super Admin",
      "id": 1,
    },
    {
      "label": "Admin",
      "id": 2,
    },
    {
      "label": "Employee",
      "id": 3,
    },
    {
      "label": "Stock Manager",
      "id": 4,
    }
  ];
  getpopulation() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getData('getpopulations');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;

      setState(() {
        populations = ll.map<Population>((json) => Population.fromJson(json)).toList();
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpopulation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => UsersScreen()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Color(0xff7ea4f3),
        title: Text("Add user"),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      inputFieldComponent(
                        controller: firstNameController,
                        label: "First Name",
                      ),
                      inputFieldComponent(
                        controller: lastNameController,
                        label: "Last Name",
                      ),
                      inputFieldComponent(
                        controller: emailController,
                        label: "Email",
                      ),
                      inputFieldComponent(
                        controller: passwordController,
                        label: "Password",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Select a population',
                          ),
                          items: populations
                              .map((item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                          fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: populationId,
                          onChanged: (value) {
                            for (var data in populations) {
                              if (data.id == value as int) {
                                setState(() {
                                  population = data;
                                });
                              }
                            }
                            setState(() {
                              populationId = value as int;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Select Role",
                          ),
                          items: roles
                              .map((item) => DropdownMenuItem<int>(
                                    value: item['id'],
                                    child: Text(
                                      item['label'],
                                      style: TextStyle(
                                          fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: roleId,
                          onChanged: (value) {
                            setState(() {
                              roleId = value as int;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loading
                            ? Lottie.asset(
                                "assets/loading.json",
                                height: Constants.screenWidth * 0.15,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          backgroundColor: Color(0xffed6591)),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Constants.screenHeight * 0.02, horizontal: Constants.screenWidth * 0.02),
                                        child: Text("Cancel"),
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          backgroundColor: Colors.green),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (roleId != null && populationId != null) {
                                            setState(() {
                                              loading = true;
                                            });
                                            UserServices().createUser({
                                              "firstname": firstNameController.text,
                                              "lastname": lastNameController.text,
                                              "email": emailController.text,
                                              "password": passwordController.text,
                                              "role_id": roleId,
                                              "population_id": populationId
                                            }).then((value) {
                                              setState(() {
                                                loading = false;
                                                firstNameController.text = "";
                                                lastNameController.text = "";
                                                passwordController.text = "";
                                                emailController.text = "";
                                                roleId = null;
                                                populationId = null;
                                              });
                                              if (value) {
                                                Fluttertoast.showToast(
                                                    msg: "User has been added successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Color(0xff69e5c8),
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "An account with the same email exists",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Color(0xff69e5c8),
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Missing fields",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Constants.screenHeight * 0.02, horizontal: Constants.screenWidth * 0.02),
                                        child: Text("Confirm"),
                                      )),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    ));
  }
}

class inputFieldComponent extends StatelessWidget {
  const inputFieldComponent({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
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
          hintText: label,
        ), // InputDecoration
      ),
    );
  }
}
