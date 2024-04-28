import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/constants.dart';
import 'package:pfe_syrine/models/product.dart';
import 'package:pfe_syrine/screens/stock/components/order.dart';
import 'package:pfe_syrine/services/products_services.dart';

import '../../services/callapi.dart';
import '../../services/order_services.dart';
import '../planning/planning.dart';
import 'components/add_product.dart';
import 'components/product_details.dart';

class HomeStock extends StatefulWidget {
  const HomeStock({Key? key}) : super(key: key);

  @override
  State<HomeStock> createState() => _HomeStockState();
}

class _HomeStockState extends State<HomeStock> {
  TextEditingController searchController = TextEditingController();
  List<Product> products = [];
  List<Product> result = [];
  late bool loading = false;
  getProducts() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getData('products');
    var results = jsonDecode(response.body);
    List<Product> listOfProducts = [];
    for (var data in results) {
      listOfProducts.add(Product.fromJson(data));
    }
    setState(() {
      products = listOfProducts;
      result = products;
      loading = false;
    });
  }

  filterData() {
    if (searchController.text != "") {
      List<Product> filtered = [];
      for (var product in products) {
        if (product.name.toLowerCase().contains(searchController.text.toLowerCase())) {
          filtered.add(product);
        }
      }
      setState(() {
        result = filtered;
      });
    } else {
      setState(() {
        result = products;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(() {
      filterData();
      print(searchController.text);
    });

    getProducts();
  }

  List<int> productToOrder = [];
  bool multiSelectActive = false;
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddProduct(),
              ));
        },
        backgroundColor: Color(0xff7ea4f3),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_sharp),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => OrderProduct()),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CalendarPage()),
            );
          },
        ),
        backgroundColor: Color(0xff7ea4f3),
        title: Text("Stock"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getProducts();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchController.text = "";
                        FocusScope.of(context).unfocus();
                      });
                    },
                    icon: Icon(Icons.close_sharp),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff7ea4f3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff7ea4f3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Visibility(
                      visible: multiSelectActive,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                        onPressed: () {
                          setState(() {
                            multiSelectActive = false;
                            productToOrder.clear();
                          });
                        },
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: multiSelectActive,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                        onPressed: () {
                          if (productToOrder.length > 0) {
                            OrderServices().addOrders(productToOrder, user['id']).then((value) {
                              setState(() {
                                multiSelectActive = false;
                                productToOrder.clear();
                              });
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderProduct()));
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please select product",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {
                              multiSelectActive = false;
                            });
                          }
                        },
                        child: Icon(
                          Icons.shopping_cart_sharp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              loading
                  ? Expanded(child: Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1)))
                  : (result.length != 0
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01),
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
                                            backgroundColor: Color(0xff69e5c8),
                                            foregroundColor: Colors.white,
                                            icon: Icons.arrow_downward,
                                            label: "Supply",
                                            onPressed: (context) {
                                              bottomSheetBooking(context, result[index], () {
                                                setState(() {
                                                  getProducts();
                                                });
                                              });
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
                                            icon: Icons.more_vert_sharp,
                                            label: "Details",
                                            onPressed: (BuildContext context) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) => ProductDetials(
                                                      product: result[index],
                                                    ),
                                                  ));
                                            },
                                          ),
                                          SlidableAction(
                                            backgroundColor: Color(0xffed6591),
                                            foregroundColor: Colors.white,
                                            icon: Icons.cancel,
                                            label: "Cancel",
                                            onPressed: (context) async {},
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xff7ea4f3)),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            result[index].name,
                                            style:
                                                TextStyle(fontFamily: "NunitoBold", fontSize: 16.0, fontWeight: FontWeight.w500),
                                          ),
                                          trailing: Container(
                                            child: Visibility(
                                              visible: productToOrder.contains(products[index].id),
                                              child: Icon(Icons.check_circle, color: Color(0xff056CF2)),
                                            ),
                                          ),
                                          onTap: () {
                                            if (multiSelectActive) {
                                              if (productToOrder.contains(products[index].id)) {
                                                productToOrder.remove(products[index].id);
                                              } else {
                                                productToOrder.add(products[index].id!);
                                              }
                                              setState(() {});
                                            }
                                          },
                                          onLongPress: () {
                                            if (!multiSelectActive) {
                                              productToOrder.add(products[index].id!);
                                              setState(() {
                                                multiSelectActive = true;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Center(
                          child: Column(
                          children: [
                            Lottie.asset("assets/empty.json"),
                            Text(
                              "Sorry  there is no product yet ",
                              style: TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
                            )
                          ],
                        ))),
            ],
          ),
        ),
      ),
    ));
  }

  bottomSheetBooking(BuildContext context, Product product, VoidCallback onPressed) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController QuantityController = TextEditingController();

    bool isLoading = false;

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
                height: Constants.screenHeight * 0.6,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 50),
                  child: isDone
                      ? doneSupply(context)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Supply Products",
                              style: TextStyle(color: Color(0xff056CF2), fontFamily: "NunitoBold"),
                            ),
                            Text(
                              "Value limit : ${product.availableSpace - product.quantity}",
                              style: TextStyle(color: Color(0xff056CF2), fontFamily: "NunitoBold"),
                            ),
                            Form(
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
                                        if (!value.isNumericOnly || int.parse(value) <= 0) {
                                          return "Please enter a valid number";
                                        }
                                        if (int.parse(value) + product.quantity > product.availableSpace) {
                                          return "Quantity is greater than available space";
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      controller: QuantityController,
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
                                              setState(() {
                                                isLoading = true;
                                              });
                                              ProductsServices().supplyProduct(
                                                  {"id": product.id, "quantity": int.parse(QuantityController.text)},
                                                  onPressed).then((value) {
                                                setState(() {
                                                  isLoading = false;
                                                  isDone = true;
                                                  setState(() {});
                                                });
                                              });
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
/*      title: ExpansionTile(
                                            title: Text(
                                              result[index].name,
                                              style: TextStyle(
                                                  fontFamily: "NunitoBold", fontSize: 16.0, fontWeight: FontWeight.w500),
                                            ),
                                            children: <Widget>[
                                              Container(
                                                child: ListTile(
                                                  title: Text(
                                                    "Created At : ${DateFormat('dd/MM/yyyy').format(result[index].createdAt!)}",
                                                    style: TextStyle(fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: ListTile(
                                                  title: Text(
                                                    "Stock status : ${result[index].quantity < (result[index].availableSpace / 4) ? "Lack" : "Good"}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: "NunitoBold",
                                                        color: result[index].quantity < (result[index].availableSpace / 4)
                                                            ? Colors.red
                                                            : Colors.green),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: ListTile(
                                                  title: Text(
                                                    "Quantity : ${result[index].quantity}",
                                                    style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: ListTile(
                                                  title: Text(
                                                    "Available space : ${result[index].availableSpace}",
                                                    style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: ListTile(
                                                  title: Text(
                                                    "Description : ${result[index].description}",
                                                    style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),*/
