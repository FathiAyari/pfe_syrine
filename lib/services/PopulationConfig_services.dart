import 'dart:ui';

import 'callapi.dart';

class PopulationConfigServices {
  Future<bool> createPopulationConfig(Map data, VoidCallback refresh) async {
    try {
      var response = await CallApi().postData(data, 'create_plage');
      if (response.statusCode == 200) {
        refresh();
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deletePopulationConfig(int configId, VoidCallback refresh) async {
    try {
      var response = await CallApi().deleteData('delete_config/${configId}');
      if (response.statusCode == 200) {
        refresh();
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updatePopulation(Map data, int popilationConfigId, VoidCallback refresh) async {
    try {
      var response = await CallApi().putData(data, 'update_config/${popilationConfigId}');
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
}
