class ApiConfig {
  static const String baseUrl = 'https://flutter-todo-jwt-app.onrender.com';

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
