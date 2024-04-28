import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pfe_syrine/screens/planning/planning.dart';
import 'package:pfe_syrine/services/company_services.dart';

import '../../components/will_pop.dart';
import '../../constants.dart';
import '../../models/company.dart';
import 'components/input_field.dart';
import 'edit_company.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _SocieteState();
}

class _SocieteState extends State<CompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addCompanyBottomSheet(context, () {
            setState(() {});
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          size: 25.0,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text("Companies"),
        backgroundColor: Color(0xff7ea4f3),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder(
            future: CompanyServices.getCompanies(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Company> companies = [];
                List<Company> data = snapshot.data;
                for (var company in data) {
                  companies.add(company);
                }
                if (snapshot.data.length != 0) {
                  return ListView.builder(
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Slidable(
                              key: ValueKey(1),
                              startActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Color(0xffed6591),
                                    foregroundColor: Colors.white,
                                    icon: Icons.cancel,
                                    label: "Cancel",
                                    onPressed: (BuildContext context) {},
                                  ),
                                  SlidableAction(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: "Delete",
                                    onPressed: (ctx) {
                                      NAlertDialog(
                                        title: WillPopTitle("You want to delete this company ?", context),
                                        actions: [
                                          Negative(),
                                          Positive(() {
                                            CompanyServices.deleteCompany(companies[index].id, () {
                                              setState(() {});
                                            }).then((value) {
                                              if (value) {
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg: "Company deleted successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Color(0xff69e5c8),
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg: "Error has been occured",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            });
                                          })
                                        ],
                                        blur: 2,
                                      ).show(context, transitionType: DialogTransitionType.Bubble);
                                    },
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: "Edit",
                                    onPressed: (ctx) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => EditCompany(
                                                company: companies[index],
                                              )));
                                    },
                                  ),
                                  SlidableAction(
                                    backgroundColor: Color(0xffed6591),
                                    foregroundColor: Colors.white,
                                    icon: Icons.cancel,
                                    label: "Cancel",
                                    onPressed: (BuildContext context) {},
                                  ),
                                ],
                              ),
                              child: Container(
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              height: Constants.screenHeight * 0.1,
                                              width: Constants.screenWidth * 0.2,
                                              child: Image.network(
                                                companies[index].url,
                                                fit: BoxFit.fill,
                                              )),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Name : ${companies[index].name.toUpperCase()}",
                                                      style: TextStyle(
                                                          fontSize: 18, fontFamily: "AssistantLight", color: Color(0xff4d5251))),
                                                  Text("Adresse : ${companies[index].adresse.toUpperCase()}",
                                                      style: TextStyle(
                                                          fontSize: 18, fontFamily: "AssistantLight", color: Color(0xff4d5251))),
                                                  Text("Tax ID : ${companies[index].taxID}",
                                                      style: TextStyle(
                                                          fontSize: 18, fontFamily: "AssistantLight", color: Color(0xff4d5251))),
                                                  Text("Phone Number : ${companies[index].phoneNumber}",
                                                      style: TextStyle(
                                                          fontSize: 18, fontFamily: "AssistantLight", color: Color(0xff4d5251))),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        );
                      });
                } else {
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Center(
                            child: Column(
                          children: [
                            Lottie.asset("assets/empty.json"),
                            Text(
                              "There is no company yet ",
                              style: TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
                            )
                          ],
                        ));
                      });
                }
              } else {
                return Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1));
              }
            },
          )),
    );
  }

  addCompanyBottomSheet(BuildContext context, VoidCallback onPressed) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController adresseController = TextEditingController();
    TextEditingController taxIdNumberController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    bool isLoading = false;
    File? _image;
    final picker = ImagePicker();

    getImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }

    bool isDone = false;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              color: Colors.transparent,
              child: Container(
                height: Constants.screenHeight * 0.8,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 10),
                  child: isDone
                      ? doneSupply(context)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: 5,
                                    width: Constants.screenWidth * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Add Company", style: TextStyle(fontSize: 20, color: Color(0xff4d5251))),
                                  ),
                                  InputField("Compnay Name", nameController),
                                  InputField("Compnay Addresse", adresseController),
                                  InputField("Tax ID Number", taxIdNumberController),
                                  InputField("Phone Number", phoneNumberController),
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: _image == null
                                        ? Stack(
                                            children: [
                                              Image.asset(
                                                "assets/img.png",
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                  top: -5,
                                                  left: -10,
                                                  child: IconButton(
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        getImage().then((value) => setState(() {}));
                                                      },
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.green,
                                                      ))),
                                            ],
                                          )
                                        : Stack(
                                            children: [
                                              Image.file(
                                                _image!,
                                                fit: BoxFit.fill,
                                                height: 100,
                                                width: 100,
                                              ),
                                              Positioned(
                                                  top: -10,
                                                  left: -10,
                                                  child: IconButton(
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        setState(() {
                                                          _image = null;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ))),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            isLoading
                                ? Lottie.asset(
                                    "assets/loading.json",
                                    height: Constants.screenWidth * 0.15,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Text("Cancel"),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              if (_image != null) {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                CompanyServices().addCompany({
                                                  "name": nameController.text,
                                                  "adresse": adresseController.text,
                                                  "phone_number": phoneNumberController.text,
                                                  "tax_id": taxIdNumberController.text
                                                }, _image!.path, onPressed).then((value) {
                                                  if (value) {
                                                    setState(() {
                                                      isLoading = false;
                                                      isDone = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg: "Error has been occured",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Company logo is required",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            }
                                          },
                                          child: Text("Confirm"))
                                    ],
                                  ),
                          ],
                        ),
                ),
              ),
            );
          });
        });
  }

  Column doneSupply(BuildContext context) {
    return Column(
      children: [
        Lottie.asset("assets/success.json", height: Constants.screenHeight * 0.1, repeat: false),
        Text(
          "",
          style: TextStyle(fontSize: Constants.screenHeight * 0.02),
        ),
        SizedBox(
          height: Constants.screenHeight * 0.08,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Close"),
            ))
      ],
    );
  }
}
