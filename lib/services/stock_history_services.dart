import 'dart:convert';

import 'package:pfe_syrine/models/historic_stock.dart';

import 'callapi.dart';

class StockHistoryServices {
  Future<List<StockHistoryModel>> getStockHistory() async {
    var response = await CallApi().getData('stock_history');

    if (response.statusCode == 200) {
      List<StockHistoryModel> stockHistoryList = [];
      for (var history in jsonDecode(response.body)) {
        stockHistoryList.add(StockHistoryModel.fromjosn(history));
      }
      return stockHistoryList;
    } else {
      return [];
    }
  }
}
