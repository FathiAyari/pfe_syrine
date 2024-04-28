import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:pfe_syrine/models/company.dart';
import 'package:pfe_syrine/services/api.dart';

import 'callapi.dart';

class CompanyServices {
  static Future<List<Company>> getCompanies() async {
    try {
      var response = await CallApi().getData('companies');
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        List<Company> listOfCompanies = [];
        for (var data in result) {
          listOfCompanies.add(Company.FromJson(data));
        }
        return listOfCompanies;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<bool> deleteCompany(int companyId, VoidCallback test) async {
    try {
      var response = await CallApi().deleteData('delete_company/$companyId');
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

  Future<bool> addCompany(Map<String, String> body, String filepath, VoidCallback test) async {
    try {
      String addimageUrl = baseURL + 'create_company';
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      };
      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..fields.addAll(body)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('image', filepath));
      var response = await request.send();
      if (response.statusCode == 200) {
        test();
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

  Future<bool> updateCompany(Map<String, String> body, int id, String? filepath) async {
    try {
      String addimageUrl = baseURL + "update_company/${id}";
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      };
      if (filepath != null) {
        var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
          ..fields.addAll(body)
          ..headers.addAll(headers)
          ..files.add(await http.MultipartFile.fromPath('image', filepath!));
        var response = await request.send();
        if (response.statusCode == 200) {
          return true;
        } else {
          print(response.statusCode);
          return false;
        }
      } else {
        var response = await CallApi().postData(body, "update_company/${id}");
        if (response.statusCode == 200) {
          return true;
        } else {
          print(response.statusCode);
          return false;
        }
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
