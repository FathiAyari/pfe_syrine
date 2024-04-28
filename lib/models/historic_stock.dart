class StockHistoryModel {
  String body;
  String type;

  StockHistoryModel({required this.body, required this.type});

  factory StockHistoryModel.fromjosn(Map<String, dynamic> json) {
    return StockHistoryModel(body: json['body'], type: json['type']);
  }
}
