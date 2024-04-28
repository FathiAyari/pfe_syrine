class Notif {
  int id;
  int status;
  String body;
  String type;
  DateTime createdAt;

  Notif({required this.id, required this.status, required this.body, required this.createdAt, required this.type});

  factory Notif.fromJson(Map<String, dynamic> json) {
    return Notif(
        id: json['id'],
        status: json['status'],
        body: json['body'],
        createdAt: DateTime.parse(json['created_at']),
        type: json['type']);
  }
}
