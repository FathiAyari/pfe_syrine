class Product {
  int? id;
  String name;
  String description;
  int quantity;
  int availableSpace;

  double price;
  DateTime? createdAt;

  Product(
      {this.id,
      required this.name,
      required this.description,
      required this.quantity,
      required this.availableSpace,
      required this.price,
      this.createdAt});

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json['today_orders'] == null) {
      return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        quantity: json['quantity'],
        availableSpace: json['available_space'],
        price: json['price'].toDouble(),
        createdAt: DateTime.parse(json['created_at']),
      );
    } else {
      return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        quantity: json['quantity'],
        availableSpace: json['available_space'],
        price: json['price'].toDouble(),
        createdAt: DateTime.parse(json['created_at']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'available_space': availableSpace,
      'price': price,
    };
  }
}
