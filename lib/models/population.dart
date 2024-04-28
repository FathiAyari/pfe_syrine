import 'package:pfe_syrine/models/population_config.dart';

class Population {
  int id;
  String name;
  DateTime created_at;
  String updated_at;
  PopulationConfig? populationConfig;

  Population({
    required this.id,
    required this.name,
    required this.created_at,
    required this.updated_at,
    this.populationConfig,
  });
  factory Population.fromJson(Map<String, dynamic> json) {
    if (json['plage'] == null) {
      return Population(
        id: json['id'],
        name: json['name'].toString(),
        created_at: DateTime.parse(json['created_at']),
        updated_at: json['updated_at'].toString(),
      );
    } else {
      return Population(
        id: json['id'],
        name: json['name'].toString(),
        created_at: DateTime.parse(json['created_at']),
        updated_at: json['updated_at'].toString(),
        populationConfig: PopulationConfig.fromJson(json['plage']),
      );
    }
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": created_at,
        "updated_at": updated_at,
      };
}
