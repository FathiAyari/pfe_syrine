import 'dart:convert';
import 'dart:ui';

import '../models/order.dart';
import 'callapi.dart';

class OrderServices {
  Future<bool> addOrders(List productsId, int user_id) async {
    try {
      var response = await CallApi().postData({"products_id": productsId, "user_id": user_id}, 'add_order');
      if (response.statusCode == 200) {
        print(response.body.toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateOrder(int quantity, int id) async {
    try {
      var response = await CallApi().postData({"quantity": quantity}, 'update_order/${id}');
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

  Future<List<Order>> getOrders(int userId) async {
    try {
      var response = await CallApi().getData('preorders/$userId');
      var jsondata = jsonDecode(response.body);

      Iterable ll = jsondata;
      List<Order> orders = ll.map<Order>((json) => Order.fromJson(json)).toList();
      return orders;
    } catch (e) {
      print(e);

      return [];
    }
  }

  Future<bool> deleteOrder(int id, VoidCallback test) async {
    try {
      var response = await CallApi().deleteData('delete_order/${id}');
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

  Future<bool> finishOrder(int userId, String cmp) async {
    try {
      var response = await CallApi().getData('order/${userId}/${cmp}');
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
}
