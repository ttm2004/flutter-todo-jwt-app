import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../store/app_store.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';
import '../widgets/custom_header.dart';
import '../widgets/app_drawer.dart';
import 'food_detail_screen.dart';

class FoodListScreen extends StatefulWidget {
  final CategoryModel category;

  const FoodListScreen({super.key, required this.category});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final err = await context.read<AppStore>().fetchFoods(categoryId: widget.category.id);
    if (mounted) setState(() => _error = err);
  }

  Future<void> _addToCart(BuildContext ctx, FoodModel food) async {
    final store = ctx.read<AppStore>();
    final err = await store.addToCart(food.id);
    if (!ctx.mounted) return;
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(err ?? 'Đã thêm "${food.name}" vào giỏ hàng'),
      backgroundColor: err != null ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: CustomHeader(title: widget.category.name),
      drawer: const AppDrawer(),
      body: Consumer<AppStore>(builder: (_, store, __) {
        if (store.isLoadingFoods) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (store.danhSachMonAn.isEmpty) {
          return const Center(child: Text('Không có món ăn nào trong danh mục này'));
        }

        return RefreshIndicator(
          onRefresh: _load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: store.danhSachMonAn.length,
            itemBuilder: (_, i) => _FoodCard(
              food: store.danhSachMonAn[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FoodDetailScreen(food: store.danhSachMonAn[i]),
                ),
              ),
              onAddToCart: () => _addToCart(context, store.danhSachMonAn[i]),
            ),
          ),
        );
      }),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final FoodModel food;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _FoodCard({
    required this.food,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: food.image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 90, height: 90,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 90, height: 90,
                    color: Colors.orange[50],
                    child: const Icon(Icons.fastfood, size: 40, color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    if (food.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(food.description,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(food.formattedPrice,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )),
                        ElevatedButton.icon(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.add_shopping_cart, size: 16),
                          label: const Text('Thêm', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
