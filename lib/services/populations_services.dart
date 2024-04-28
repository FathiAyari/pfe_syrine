import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfe_syrine/models/population.dart';

import 'callapi.dart';

class PopulationsServices {
  getpopulation() async {
    var response = await CallApi().getData('getpopulations');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      List<Population> populations = ll.map<Population>((json) => Population.fromJson(json)).toList();
      return populations;
    } else {
      return [];
    }
  }

  Future<bool> createPopulation(Map data, VoidCallback refresh) async {
    try {
      var response = await CallApi().postData(data, 'createpopulation');
      if (response.statusCode == 200) {
        refresh();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updatePopulation(Map data, int populationId, VoidCallback refresh) async {
    try {
      var response = await CallApi().putData(data, 'updatepopulation/${populationId}');
      if (response.statusCode == 200) {
        refresh();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> deletePopulation(int populationId, VoidCallback test) async {
    try {
      var response = await CallApi().deleteData('deletepopulation/$populationId');
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
}
