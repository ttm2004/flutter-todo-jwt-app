class FoodModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String categoryId;
  final String categoryName;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.categoryId,
    required this.categoryName,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    return FoodModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      categoryId: category is Map ? category['_id'] ?? '' : category?.toString() ?? '',
      categoryName: category is Map ? category['name'] ?? '' : '',
    );
  }

  String get formattedPrice {
    final n = price.toInt();
    final s = n.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return '${buffer.toString()} đ';
  }
}
