import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pfe_syrine/models/order.dart';

import '../../../components/will_pop.dart';
import '../../../constants.dart';
import '../../../services/order_services.dart';

class ListItemDetails extends StatefulWidget {
  final Order order;
  final VoidCallback refresh;
  final VoidCallback updateOrder;

  ListItemDetails({required this.order, required this.updateOrder, required this.refresh});

  @override
  State<ListItemDetails> createState() => _ListItemDetailsState();
}

class _ListItemDetailsState extends State<ListItemDetails> {
  bool addLoading = false;
  bool subsLoding = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Constants.screenHeight * 0.01,
        bottom: Constants.screenHeight * 0.01,
      ),
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
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: "Delete",
                onPressed: (ctx) {
                  NAlertDialog(
                    title: WillPopTitle("You want to delete this order ?", context),
                    actions: [
                      Negative(),
                      Positive(() {
                        OrderServices().deleteOrder(widget.order.id, () {
                          widget.refresh();
                        }).then((value) {
                          if (value) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Order deleted successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Error has been occured",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.03, vertical: Constants.screenHeight * 0.01),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              height: Constants.screenHeight * 0.18,
              child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Product Name : ${widget.order.product.name}",
                            style: TextStyle(
                                fontFamily: "NunitoBold",
                                color: Colors.black.withOpacity(0.7),
                                fontSize: Constants.screenHeight * 0.02),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Product Price : ${widget.order.product.price} DT",
                            style: TextStyle(
                                fontFamily: "NunitoBold",
                                color: Colors.black.withOpacity(0.7),
                                fontSize: Constants.screenHeight * 0.02),
                          ),
                        ),
                        widget.order.product.quantity > 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Product quantity : ${widget.order.product.quantity} Unit",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold",
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: Constants.screenHeight * 0.02),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Product quantity : OUT OF STOCK",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold", color: Colors.red, fontSize: Constants.screenHeight * 0.02),
                                ),
                              ),
                      ],
                    ),
                    Spacer(),
                    if (widget.order.product.quantity > 0) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.1,
                              blurRadius: 7,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                        ),
                        width: Constants.screenWidth * 0.14,
                        height: Constants.screenHeight * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            addLoading
                                ? Container(width: 40, height: Constants.screenHeight * 0.05, child: CircularProgressIndicator())
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        addLoading = true;
                                      });
                                      OrderServices().updateOrder(1, widget.order.id).then((value) {
                                        if (value) {
                                          addLoading = false;
                                          widget.updateOrder();
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      "assets/plus.png",
                                      height: Constants.screenHeight * 0.05,
                                    )),
                            Text(
                              "${widget.order.quantity}",
                              style: TextStyle(fontFamily: "NunitoBold"),
                            ),
                            subsLoding
                                ? Container(width: 50, height: Constants.screenHeight * 0.05, child: CircularProgressIndicator())
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        subsLoding = true;
                                      });
                                      OrderServices().updateOrder(-1, widget.order.id).then((value) {
                                        if (value) {
                                          subsLoding = false;
                                          widget.updateOrder();
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      "assets/minus.png",
                                      height: Constants.screenHeight * 0.05,
                                    )),
                          ],
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
