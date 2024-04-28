import '../services/api.dart';

class Company {
  int id;
  String name;
  String adresse;
  String taxID;
  String phoneNumber;
  String url;

  Company(
      {required this.id,
      required this.name,
      required this.adresse,
      required this.url,
      required this.phoneNumber,
      required this.taxID});

  factory Company.FromJson(Map<String, dynamic> json) {
    return Company(
        id: json['id'],
        name: json['name'],
        adresse: json['adresse'],
        phoneNumber: json['phone_number'],
        taxID: json['tax_id'],
        url: assetsUrl + "/storage/images/companies/" + json['url']);
  }
}
