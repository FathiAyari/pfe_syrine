import 'package:pfe_syrine/models/activite.dart';
import 'package:pfe_syrine/models/user.dart';

class Planning {
  int id;

  User user;
  Activite activity;
  DateTime start_time;
  DateTime end_time;
  DateTime? real_end_time;
  DateTime? real_start_time;
  int status;
  String note;

  Planning({
    required this.id,
    this.real_end_time,
    this.real_start_time,
    required this.user,
    required this.end_time,
    required this.start_time,
    required this.activity,
    required this.status,
    required this.note,
  });
  factory Planning.fromJson(Map<String, dynamic> json) {
    if (json['real_start_time'] != null) {
      return Planning(
        id: json['id'],
        end_time: DateTime.parse(json['end_time']),
        start_time: DateTime.parse(json['start_time']),
        real_start_time: DateTime.parse(json['real_start_time']),
        activity: Activite.fromJson(json['activity']),
        note: json['note'].toString(),
        user: User.fromJson(json['user']),
        status: json['status'],
      );
    } else {
      return Planning(
        id: json['id'],
        end_time: DateTime.parse(json['end_time']),
        start_time: DateTime.parse(json['start_time']),
        activity: Activite.fromJson(json['activity']),
        note: json['note'].toString(),
        user: User.fromJson(json['user']),
        status: json['status'],
      );
    }
  }
}
