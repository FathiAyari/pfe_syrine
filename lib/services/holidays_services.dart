import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

import '../models/holiday.dart';
import 'callapi.dart';

class HolidaysServices {
  Future<List<Holiday>> getHolidays(Map data) async {
    http.Response response = await CallApi().postData(data, 'holidays');
    try {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        Iterable ll = jsondata;
        List<Holiday> result = ll.map<Holiday>((json) => Holiday.fromJosn(json)).toList();
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

  Future<bool> deleteRequest(int holidayId, VoidCallback test) async {
    try {
      var response = await CallApi().deleteData('delete_request/${holidayId}');
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

  Future<bool> modifyRequest(Map data, VoidCallback test) async {
    try {
      var response = await CallApi().postData(data, 'update_request');
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

  Future<bool> createRequest(Map data) async {
    try {
      var response = await CallApi().postData(data, 'create_holiday');
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
