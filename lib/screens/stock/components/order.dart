import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/models/company.dart';
import 'package:pfe_syrine/screens/stock/home_stock.dart';

import '../../../constants.dart';
import '../../../models/order.dart';
import '../../../services/bill_services.dart';
import '../../../services/callapi.dart';
import '../../../services/order_services.dart';
import 'list_item_widget.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({Key? key}) : super(key: key);

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  int? selectedValue;
  var user = GetStorage().read("user");
  Company? company;
  bool loading = false;
  List<Company> companies = [];

  getCompanies() async {
    var response = await CallApi().getData('companies');
    var result = jsonDecode(response.body);
    List<Company> listOfCompanies = [];
    for (var data in result) {
      listOfCompanies.add(Company.FromJson(data));
    }
    setState(() {
      companies = listOfCompanies;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeStock()),
            );
          },
        ),
        backgroundColor: Color(0xff7ea4f3),
        title: Text("Order Product"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      hintText: "Select Company",
                    ),
                    items: companies
                        .map((item) => DropdownMenuItem<int>(
                              value: item.id,
                              child: Text(
                                item.name,
                                style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      for (var data in companies) {
                        if (data.id == value as int) {
                          setState(() {
                            company = data;
                          });
                        }
                      }
                      setState(() {
                        selectedValue = value as int;
                      });
                    },
                  ),
                ),
                Expanded(
                    child: FutureBuilder(
                  future: OrderServices().getOrders(user['id']),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Order> orders = List<Order>.from(snapshot.data);
                      if (snapshot.data.length != 0) {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  if (orders[orders.length - 1].id != orders[index].id) {
                                    return ListItemDetails(
                                      order: orders[index],
                                      refresh: () {
                                        setState(() {});
                                      },
                                      updateOrder: () {
                                        setState(() {});
                                      },
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        ListItemDetails(
                                          order: orders[index],
                                          refresh: () {
                                            setState(() {});
                                          },
                                          updateOrder: () {
                                            setState(() {});
                                          },
                                        ),
                                        Container(
                                          height: Constants.screenHeight * 0.07,
                                          width: Constants.screenWidth * 0.5,
                                        ),
                                      ],
                                    );
                                  }
                                }),
                            if (orders.length != 0) ...[
                              loading
                                  ? Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1)
                                  : Container(
                                      height: Constants.screenHeight * 0.07,
                                      width: Constants.screenWidth * 0.7,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (selectedValue != null) {
                                              setState(() {
                                                loading = true;
                                              });

                                              OrderServices().finishOrder(user['id'], company!.name).then((value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                                for (var data in orders) {
                                                  if (data.quantity > data.product.quantity) {
                                                    orders.remove(data);
                                                  }
                                                }
                                                if (value && orders.isNotEmpty) {
                                                  BillServices().createPDF(orders, company!);
                                                }
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Select a company",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Color(0xffed6591),
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          },
                                          child: Text("Validate")))
                            ]
                          ],
                        );
                      } else {
                        return ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Center(
                                  child: Column(
                                children: [
                                  Lottie.asset("assets/empty.json"),
                                  Text(
                                    "There is no orders in hold yet ",
                                    style:
                                        TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
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
              ],
            )),
      ),
    ));
  }
}
