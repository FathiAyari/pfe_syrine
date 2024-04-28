import 'dart:convert';
import 'dart:ui';

import 'package:pfe_syrine/models/activite.dart';

import 'callapi.dart';

class ActivitiesServices {
  Future<List<Activite>> getActivities(int status) async {
    try {
      var response = await CallApi().getData('activities/${status}');
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        Iterable ll = jsondata;
        List<Activite> acts = ll.map<Activite>((json) => Activite.fromJson(json)).toList();
        return acts;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> createActivity(Map data, VoidCallback test) async {
    try {
      var response = await CallApi().postData(data, 'postactivites');
      if (response.statusCode == 200) {
        test();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> deleteActivity(int activityId, VoidCallback test) async {
    try {
      var response = await CallApi().deleteData('deleteactivity/$activityId');
      if (response.statusCode == 200) {
        test();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> updateActivity(Map data, int activityId) async {
    try {
      var response = await CallApi().postData(data, 'updateactivity/$activityId');
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
