class ApiConfig {
  // Đang chạy local - Android emulator dùng 10.0.2.2, iOS/web dùng localhost
  // Sau khi deploy Render thì thay bằng URL thật
  static const String baseUrl = 'http://10.0.2.2:4000';

  // Auth
  static const String register = '$baseUrl/api/auth/register';
  static const String login = '$baseUrl/api/auth/login';
  static const String forgotPassword = '$baseUrl/api/auth/forgot-password';
  static const String me = '$baseUrl/api/auth/me';

  // Categories
  static const String categories = '$baseUrl/api/categories';

  // Foods
  static const String foods = '$baseUrl/api/foods';
  static String foodsByCategory(String categoryId) =>
      '$baseUrl/api/foods?category=$categoryId';
  static String foodById(String id) => '$baseUrl/api/foods/$id';

  // Cart
  static const String cart = '$baseUrl/api/cart';
  static String cartItem(String foodId) => '$baseUrl/api/cart/$foodId';
  static const String clearCart = '$baseUrl/api/cart/clear';

  // Orders
  static const String orders = '$baseUrl/api/orders';
}
