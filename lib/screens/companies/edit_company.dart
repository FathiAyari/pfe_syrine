import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/screens/companies/company.dart';

import '../../constants.dart';
import '../../models/company.dart';
import '../../services/company_services.dart';
import 'components/input_field.dart';

class EditCompany extends StatefulWidget {
  final Company company;

  const EditCompany({Key? key, required this.company}) : super(key: key);

  @override
  State<EditCompany> createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController taxIDController = TextEditingController();
  TextEditingController addresseController = TextEditingController();

  bool loading = false;

  fetchData() {
    setState(() {
      nameController.text = widget.company.name;
      phoneNumberController.text = widget.company.phoneNumber;
      taxIDController.text = widget.company.taxID;
      addresseController.text = widget.company.adresse;
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
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
                MaterialPageRoute(builder: (context) => CompanyScreen()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Color(0xff7ea4f3),
        title: Text("Edit Company"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputField(
                "Name",
                nameController,
              ),
              InputField(
                "Adresse",
                addresseController,
              ),
              InputField(
                "Phone Number",
                phoneNumberController,
              ),
              InputField(
                "Tax ID",
                taxIDController,
              ),
              Container(
                  child: _image == null
                      ? Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "${widget.company.url}",
                                fit: BoxFit.fill,
                                height: Constants.screenHeight * 0.2,
                                width: Constants.screenWidth * 0.3,
                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    getImage();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                    size: 25,
                                  )),
                            ),
                          ],
                        )
                      : Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.fill,
                                height: Constants.screenHeight * 0.2,
                                width: Constants.screenWidth * 0.3,
                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    getImage();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                    size: 25,
                                  )),
                            ),
                          ],
                        )),
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
                                Navigator.pop(context);
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
                                  if (_image == null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    CompanyServices().updateCompany({
                                      "name": nameController.text,
                                      "tax_id": taxIDController.text,
                                      "phone_number": phoneNumberController.text,
                                      "adresse": addresseController.text,
                                    }, widget.company.id, null).then((value) {
                                      setState(() {
                                        loading = false;
                                      });
                                      if (value) {
                                        Fluttertoast.showToast(
                                            msg: "Company updated successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(0xff69e5c8),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
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
                                    setState(() {
                                      loading = true;
                                    });
                                    CompanyServices().updateCompany({
                                      "name": nameController.text,
                                      "tax_id": taxIDController.text,
                                      "phone_number": phoneNumberController.text,
                                      "adresse": addresseController.text,
                                    }, widget.company.id, _image!.path).then((value) {
                                      setState(() {
                                        loading = false;
                                      });
                                      if (value) {
                                        Fluttertoast.showToast(
                                            msg: "Company updated successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(0xff69e5c8),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
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
    ));
  }
}
