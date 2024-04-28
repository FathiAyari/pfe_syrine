class GeneralHistoricModel {
  String body;
  String type;

  GeneralHistoricModel({required this.body, required this.type});

  factory GeneralHistoricModel.fromJson(Map<String, dynamic> json) {
    return GeneralHistoricModel(body: json['body'], type: json['type']);
  }
}
