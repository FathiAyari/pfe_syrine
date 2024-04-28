import 'dart:convert';

import 'package:pfe_syrine/models/general_historic.dart';

import 'callapi.dart';

class GeneralHistoricServices {
  static Future<List<GeneralHistoricModel>> getHistorics() async {
    try {
      var response = await CallApi().getData('general_history');

      if (response.statusCode == 200) {
        List<GeneralHistoricModel> generalHisrorics = [];
        for (var history in jsonDecode(response.body)) {
          generalHisrorics.add(GeneralHistoricModel.fromJson(history));
        }
        return generalHisrorics;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
