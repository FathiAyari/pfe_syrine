class PopulationConfig {
  int id;
  DateTime start;
  DateTime end;
  List days;

  PopulationConfig({required this.id, required this.start, required this.end, required this.days});

  factory PopulationConfig.fromJson(Map<String, dynamic> json) {
    return PopulationConfig(
        id: json['id'], start: DateTime.parse(json['start']), end: DateTime.parse(json['end']), days: json['days']);
  }
}
