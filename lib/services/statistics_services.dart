import 'dart:convert';

import 'package:pfe_syrine/models/product.dart';

import '../screens/statistics/widgets/orders_screen.dart';
import 'callapi.dart';

class StatisticsServices {
  static StuffStats() async {
    var response = await CallApi().getData('stuff_stat');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      Map<String, int> data = {
        "admins": result['admins'],
        "super_admins": result['super_admins'],
        "employees": result['employees'],
        "stock_managers": result['stock_managers'],
        "companies": result['companies']
      };

      return data;
    } else {
      return {};
    }
  }

  static ProductsStats() async {
    var response = await CallApi().getData('products_stat');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List<Product> listOfProducts = [];
      for (var data in result) {
        listOfProducts.add(Product.fromJson(data));
      }
      print(listOfProducts);
      return listOfProducts;
    } else {}
  }

  static OrdersStats() async {
    try {
      var response = await CallApi().getData('orders_stats');
      var result = jsonDecode(response.body);
      List<OrdersData> listOfOrders = [];
      for (var data in result) {
        listOfOrders.add(OrdersData.fromJson(data));
      }
      print(listOfOrders);
      return listOfOrders;
    } catch (e) {
      print(e);
    }
  }

  static PlanningStats() async {
    try {
      var response = await CallApi().getData('planning_stats');
      var result = jsonDecode(response.body);
      List<OrdersData> listOfOrders = [];
      for (var data in result) {
        listOfOrders.add(OrdersData.fromJson(data));
      }
      print(listOfOrders);
      return listOfOrders;
    } catch (e) {
      print(e);
    }
  }
}
