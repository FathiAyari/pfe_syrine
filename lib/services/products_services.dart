import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_syrine/models/product.dart';

import 'callapi.dart';

class ProductsServices {
  static Products() async {
    try {
      http.Response response = await CallApi().getData('products');
      var result = jsonDecode(response.body);
      List<Product> listOfProducts = [];
      for (var data in result) {
        listOfProducts.add(Product.fromJson(data));
      }
      return listOfProducts;
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> addProduct(Product product) async {
    try {
      var response = await CallApi().postData(product, 'create_product');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> supplyProduct(Map quantity, VoidCallback test) async {
    try {
      var response = await CallApi().postData(quantity, 'supply');

      if (response.statusCode == 200) {
        test();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> orderProducts(List data) async {
    try {
      var response = await CallApi().postData(data, 'order');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future getProduct(int id) async {
    var response = await CallApi().getData('product/${id}');
    var result = jsonDecode(response.body);
    return result;
  }
}
