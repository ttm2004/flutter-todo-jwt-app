import 'food_model.dart';

class CartItemModel {
  final FoodModel food;
  final int quantity;
  final double subtotal;

  CartItemModel({
    required this.food,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      food: FoodModel.fromJson(json['food']),
      quantity: json['quantity'] ?? 1,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }
}

class CartModel {
  final String id;
  final List<CartItemModel> items;
  final double totalAmount;

  CartModel({
    required this.id,
    required this.items,
    required this.totalAmount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List? ?? [])
        .map((item) => CartItemModel.fromJson(item))
        .toList();
    return CartModel(
      id: json['_id'] ?? '',
      items: items,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    );
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  String get formattedTotal {
    final n = totalAmount.toInt();
    final s = n.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return '${buffer.toString()} đ';
  }
}
