class User {
  int id;
  String firstname;
  String lastname;
  String role;
  String email;
  int status;
  String? population;
  DateTime created_at;
  DateTime updated_at;

  User({
    required this.id,
    required this.firstname,
    required this.email,
    required this.lastname,
    required this.role,
    required this.status,
    this.population,
    required this.created_at,
    required this.updated_at,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json["population"] == null) {
      return User(
        id: json['id'],
        firstname: json['firstname'].toString(),
        email: json['email'].toString(),
        lastname: json['lastname'].toString(),
        role: json['role'].toString(),
        status: json['status'],
        created_at: DateTime.parse(json['created_at']),
        updated_at: DateTime.parse(json['updated_at']),
      );
    } else {
      return User(
        id: json['id'],
        firstname: json['firstname'].toString(),
        email: json['email'].toString(),
        lastname: json['lastname'].toString(),
        role: json['role'].toString(),
        population: json['population'].toString(),
        status: json['status'],
        created_at: DateTime.parse(json['created_at']),
        updated_at: DateTime.parse(json['updated_at']),
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "email": email,
        "lastname": lastname,
        "role": role,
        "status": status,
        "population": population,
        "created_at": created_at,
        "updated_at": updated_at,
      };
}
