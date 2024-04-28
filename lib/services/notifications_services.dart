import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/notifications.dart';
import 'callapi.dart';

class NotifServices {
  Future<List<Notif>> getNotifs() async {
    http.Response response = await CallApi().getData('notifications');
    try {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        Iterable ll = jsondata;
        List<Notif> result = ll.map<Notif>((json) => Notif.fromJson(json)).toList();
        print(result);
        return result;
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> seeNotif() async {
    try {
      var response = await CallApi().getData('see');
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
