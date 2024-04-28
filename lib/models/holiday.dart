import 'package:pfe_syrine/models/user.dart';

class Holiday {
  int id;
  int status;
  DateTime start;
  DateTime end;
  String raison;
  String label;
  User? user;

  Holiday(
      {required this.id,
      required this.status,
      required this.start,
      required this.end,
      required this.raison,
      this.user,
      required this.label});
  factory Holiday.fromJosn(Map<String, dynamic> json) {
    if (json['user'] != null) {
      return Holiday(
          id: json['id'],
          label: json['label'],
          status: json['status'],
          start: DateTime.parse(json['start']),
          end: DateTime.parse(json['end']),
          raison: json['raison'],
          user: User.fromJson(json['user']));
    } else {
      return Holiday(
        id: json['id'],
        label: json['label'],
        status: json['status'],
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
        raison: json['raison'],
      );
    }
  }
}
