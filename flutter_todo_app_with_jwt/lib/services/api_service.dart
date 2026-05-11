import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  final String? token;

  ApiService({this.token});

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      }
      throw ApiException(
        body['message'] ?? 'Đã xảy ra lỗi',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Lỗi xử lý dữ liệu');
    }
  }

  Future<T> _withTimeout<T>(Future<T> Function() fn) async {
    try {
      return await fn().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw ApiException('Yêu cầu hết thời gian chờ. Vui lòng thử lại.'),
      );
    } on TimeoutException {
      throw ApiException('Yêu cầu hết thời gian chờ. Vui lòng thử lại.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Không thể kết nối. Vui lòng kiểm tra kết nối mạng.');
    }
  }

  // Auth
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return _withTimeout(() async {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: _headers,
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      return _handleResponse(response);
    });
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return _withTimeout(() async {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      );
      return _handleResponse(response);
    });
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return _withTimeout(() async {
      final response = await http.post(
        Uri.parse(ApiConfig.forgotPassword),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );
      return _handleResponse(response);
    });
  }

  // Categories
  Future<Map<String, dynamic>> getCategories() async {
    return _withTimeout(() async {
      final response = await http.get(Uri.parse(ApiConfig.categories), headers: _headers);
      return _handleResponse(response);
    });
  }

  // Foods
  Future<Map<String, dynamic>> getFoods({String? categoryId}) async {
    return _withTimeout(() async {
      final url = categoryId != null
          ? ApiConfig.foodsByCategory(categoryId)
          : ApiConfig.foods;
      final response = await http.get(Uri.parse(url), headers: _headers);
      return _handleResponse(response);
    });
  }

  Future<Map<String, dynamic>> getFoodById(String id) async {
    return _withTimeout(() async {
      final response = await http.get(Uri.parse(ApiConfig.foodById(id)), headers: _headers);
      return _handleResponse(response);
    });
  }

  // Cart
  Future<Map<String, dynamic>> getCart() async {
    return _withTimeout(() async {
      final response = await http.get(Uri.parse(ApiConfig.cart), headers: _headers);
      return _handleResponse(response);
    });
  }

  Future<Map<String, dynamic>> addToCart({
    required String foodId,
    int quantity = 1,
  }) async {
    return _withTimeout(() async {
      final response = await http.post(
        Uri.parse(ApiConfig.cart),
        headers: _headers,
        body: jsonEncode({'foodId': foodId, 'quantity': quantity}),
      );
      return _handleResponse(response);
    });
  }

  Future<Map<String, dynamic>> updateCartItem({
    required String foodId,
    required int quantity,
  }) async {
    return _withTimeout(() async {
      final response = await http.put(
        Uri.parse(ApiConfig.cartItem(foodId)),
        headers: _headers,
        body: jsonEncode({'quantity': quantity}),
      );
      return _handleResponse(response);
    });
  }

  Future<Map<String, dynamic>> removeFromCart(String foodId) async {
    return _withTimeout(() async {
      final response = await http.delete(
        Uri.parse(ApiConfig.cartItem(foodId)),
        headers: _headers,
      );
      return _handleResponse(response);
    });
  }

  Future<void> clearCart() async {
    return _withTimeout(() async {
      final response = await http.delete(
        Uri.parse(ApiConfig.clearCart),
        headers: _headers,
      );
      await _handleResponse(response);
    });
  }

  // Orders
  Future<Map<String, dynamic>> createOrder() async {
    return _withTimeout(() async {
      final response = await http.post(
        Uri.parse(ApiConfig.orders),
        headers: _headers,
      );
      return _handleResponse(response);
    });
  }

  Future<Map<String, dynamic>> getOrders() async {
    return _withTimeout(() async {
      final response = await http.get(Uri.parse(ApiConfig.orders), headers: _headers);
      return _handleResponse(response);
    });
  }
}
