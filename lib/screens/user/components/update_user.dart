import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/screens/user/user.dart';

import '../../../constants.dart';
import '../../../models/population.dart';
import '../../../models/user.dart';
import '../../../services/callapi.dart';
import '../../../services/user_services.dart';
import 'add_user.dart';

class UpdateUser extends StatefulWidget {
  final User user;
  const UpdateUser({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  int? populationId;
  Population? population;
  int? roleId;
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
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Population> populations = [];
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  Future getpopulation() async {
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

  fetchedUser() {
    setState(() {
      firstNameController.text = widget.user.firstname;
      lastNameController.text = widget.user.lastname;
      emailController.text = widget.user.email;
    });

    for (var population in populations) {
      if (population.name == widget.user.population) {
        setState(() {
          populationId = population.id;
        });
      }
    }

    for (var role in roles) {
      if (role['label'] == widget.user.role) {
        setState(() {
          roleId = role['id'];
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpopulation().then((value) {
      fetchedUser();
    });
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
        title: Text("Update user"),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
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
                            hintText: "Password",
                          ), // InputDecoration
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  size: 16,
                                  color: Color(0xff7ea4f3),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    "Select Population",
                                    style: TextStyle(
                                        fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
                            customButton: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  size: 16,
                                  color: Color(0xff7ea4f3),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    "Select Role",
                                    style: TextStyle(
                                        fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
                            customButton: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),
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
                                            UserServices().updateUser({
                                              "firstname": firstNameController.text,
                                              "lastname": lastNameController.text,
                                              "email": emailController.text,
                                              "password": passwordController.text,
                                              "role_id": roleId,
                                              "population_id": populationId
                                            }, widget.user.id).then((value) {
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
                                                    msg: "User has been updated successfully",
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
