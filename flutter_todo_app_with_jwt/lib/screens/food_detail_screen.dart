import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../store/app_store.dart';
import '../models/food_model.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  bool _isAdding = false;

  Future<void> _addToCart() async {
    setState(() => _isAdding = true);
    final store = context.read<AppStore>();
    final err = await store.addToCart(widget.food.id, quantity: _quantity);
    if (!mounted) return;
    setState(() => _isAdding = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(err ?? 'Đã thêm vào giỏ hàng'),
      backgroundColor: err != null ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    ));
    if (err == null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: food.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.orange[50],
                  child: const Icon(Icons.fastfood, size: 80, color: Colors.orange),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(food.formattedPrice,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  const SizedBox(height: 16),

                  if (food.description.isNotEmpty) ...[
                    const Text('Mô tả',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(food.description,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.5)),
                    const SizedBox(height: 24),
                  ],

                  // Quantity selector
                  const Text('Số lượng',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Container(
                        width: 48,
                        alignment: Alignment.center,
                        child: Text('$_quantity',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const Spacer(),
                      Text(
                        '= ${FoodModel(
                          id: food.id, name: food.name, description: food.description,
                          price: food.price * _quantity, image: food.image,
                          categoryId: food.categoryId, categoryName: food.categoryName,
                        ).formattedPrice}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isAdding ? null : _addToCart,
                      icon: _isAdding
                          ? const SizedBox(width: 20, height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.add_shopping_cart),
                      label: const Text('Thêm vào giỏ hàng', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
