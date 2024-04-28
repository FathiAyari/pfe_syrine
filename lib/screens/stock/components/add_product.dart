import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pfe_syrine/constants.dart';
import 'package:pfe_syrine/models/product.dart';
import 'package:pfe_syrine/screens/stock/home_stock.dart';
import 'package:pfe_syrine/services/products_services.dart';

import '../../../components/will_pop.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController avilablePlaceController = TextEditingController();
  bool loading = false;
  bool done = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (quantityController.text.isNotEmpty ||
                  priceController.text.isNotEmpty ||
                  descriptionController.text.isNotEmpty ||
                  nameController.text.isNotEmpty ||
                  avilablePlaceController.text.isNotEmpty) {
                NAlertDialog(
                  title: WillPopTitle("You want to cancel ?", context),
                  actions: [
                    Negative(),
                    Positive(() {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
                  ],
                  blur: 2,
                ).show(context, transitionType: DialogTransitionType.Bubble);
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeStock()),
                );
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Color(0xff69e5c8),
        title: Text("Add Product"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required field";
                  }
                },
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), //
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), // OutlineInputBorder
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Name",
                ), // InputDecoration
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required field";
                  }
                },
                keyboardType: TextInputType.text,
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), //
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), // OutlineInputBorder
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Description",
                ), // InputDecoration
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required field";
                  }
                  if (!value.isNumericOnly) {
                    return "Please enter a valid number";
                  }
                },
                keyboardType: TextInputType.number,
                controller: avilablePlaceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), //
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), // OutlineInputBorder
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Available space",
                ), // InputDecoration
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required field";
                  }
                  if (!value.isNumericOnly) {
                    return "Please enter a valid number";
                  }
                },
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), //
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), // OutlineInputBorder
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Quantity",
                ), // InputDecoration
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required field";
                  }
                  if (!value.isNumericOnly) {
                    return "Please enter a valid number";
                  }
                },
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), // OutlineInputBorder
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff69e5c8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ), // OutlineInputBorder
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Price per unit in DT",
                ), // InputDecoration
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
                              if (quantityController.text.isNotEmpty ||
                                  priceController.text.isNotEmpty ||
                                  descriptionController.text.isNotEmpty ||
                                  nameController.text.isNotEmpty ||
                                  avilablePlaceController.text.isNotEmpty) {
                                NAlertDialog(
                                  title: WillPopTitle("You want to cancel ?", context),
                                  actions: [
                                    Negative(),
                                    Positive(() {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    })
                                  ],
                                  blur: 2,
                                ).show(context, transitionType: DialogTransitionType.Bubble);
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => HomeStock()),
                                );
                              }
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
                                if (int.parse(quantityController.text) <= int.parse(avilablePlaceController.text)) {
                                  setState(() {
                                    loading = true;
                                  });
                                  Future.delayed(Duration(seconds: 1), () async {
                                    await ProductsServices.addProduct(Product(
                                            name: nameController.text,
                                            description: descriptionController.text,
                                            quantity: int.parse(quantityController.text),
                                            availableSpace: int.parse(avilablePlaceController.text),
                                            price: double.parse(priceController.text)))
                                        .then((value) {
                                      setState(() {
                                        loading = false;
                                        nameController.text = "";
                                        descriptionController.text = "";
                                        quantityController.text = "";
                                        avilablePlaceController.text = "";
                                        priceController.text = "";
                                      });
                                      if (value) {
                                        Fluttertoast.showToast(
                                            msg: "Product has beed added successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(0xff69e5c8),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Error has been occured try later",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    });
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Quantity can't be greater than available space",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red.withOpacity(0.5),
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
    ));
  }
}
