import 'package:flutter/material.dart';
import 'package:pfe_syrine/models/product.dart';

class ProductDetials extends StatefulWidget {
  final Product product;
  const ProductDetials({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetials> createState() => _ProductDetialsState();
}

class _ProductDetialsState extends State<ProductDetials> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: const Color(0xff7ea4f3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Product name : ${widget.product.name}",
                style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Product available space : ${widget.product.availableSpace}",
                style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Quantity in the stock : ${widget.product.quantity}",
                style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "You are able to make an order with  :  ${widget.product.quantity} units maximum",
                style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
