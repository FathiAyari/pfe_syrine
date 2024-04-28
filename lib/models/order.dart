import 'package:pfe_syrine/models/product.dart';

class Order {
  Product product;
  int quantity;
  int id;
  Order({required this.product, required this.quantity, required this.id});
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
