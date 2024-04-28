import 'dart:convert';

import '../models/user.dart';
import 'callapi.dart';

class UserServices {
  Future<List<User>> getusers(int userId) async {
    try {
      var response = await CallApi().getData('getusers/${userId}');
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        Iterable ll = jsondata;
        List<User> users = ll.map<User>((json) => User.fromJson(json)).toList();
        return users;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> createUser(Map data) async {
    try {
      var response = await CallApi().postData(data, 'createuser');
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

  Future<bool> updateUser(Map data, int id) async {
    try {
      var response = await CallApi().postData(data, 'updateuser/${id}');
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
}
