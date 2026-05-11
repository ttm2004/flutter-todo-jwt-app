import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';

class AppStore extends ChangeNotifier {
  // State
  UserModel? _userLogin;
  List<CategoryModel> _loaiMonAn = [];
  List<FoodModel> _danhSachMonAn = [];
  CartModel? _gioHang;

  bool _isLoadingAuth = false;
  bool _isLoadingCategories = false;
  bool _isLoadingFoods = false;
  bool _isLoadingCart = false;

  String? _authError;

  // Getters
  UserModel? get userLogin => _userLogin;
  List<CategoryModel> get loaiMonAn => _loaiMonAn;
  List<FoodModel> get danhSachMonAn => _danhSachMonAn;
  CartModel? get gioHang => _gioHang;

  bool get isLoadingAuth => _isLoadingAuth;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingFoods => _isLoadingFoods;
  bool get isLoadingCart => _isLoadingCart;

  String? get authError => _authError;
  bool get isAuthenticated => _userLogin != null;
  int get cartItemCount => _gioHang?.totalItems ?? 0;

  AppStore() {
    _restoreSession();
  }

  // Khôi phục session từ SharedPreferences khi khởi động
  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final id = prefs.getString('user_id');
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');

    if (token != null && id != null && name != null && email != null) {
      _userLogin = UserModel(id: id, name: name, email: email, token: token);
      notifyListeners();
      // Tải giỏ hàng từ server sau khi khôi phục session
      await fetchCart();
    }
  }

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', user.token);
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
  }

  void clearAuthError() {
    _authError = null;
    notifyListeners();
  }

  // ─── Auth ───────────────────────────────────────────────

  Future<bool> login({required String email, required String password}) async {
    _isLoadingAuth = true;
    _authError = null;
    notifyListeners();

    try {
      final api = ApiService();
      final data = await api.login(email: email, password: password);
      final token = data['token'] as String;
      _userLogin = UserModel.fromJson(data['user'], token);
      await _saveSession(_userLogin!);
      await fetchCart();
      return true;
    } on ApiException catch (e) {
      _authError = e.message;
      return false;
    } finally {
      _isLoadingAuth = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoadingAuth = true;
    _authError = null;
    notifyListeners();

    try {
      final api = ApiService();
      final data = await api.register(name: name, email: email, password: password);
      final token = data['token'] as String;
      _userLogin = UserModel.fromJson(data['user'], token);
      await _saveSession(_userLogin!);
      await fetchCart();
      return true;
    } on ApiException catch (e) {
      _authError = e.message;
      return false;
    } finally {
      _isLoadingAuth = false;
      notifyListeners();
    }
  }

  Future<String?> forgotPassword(String email) async {
    try {
      final api = ApiService();
      final data = await api.forgotPassword(email);
      return data['message'] as String?;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    _userLogin = null;
    _loaiMonAn = [];
    _danhSachMonAn = [];
    _gioHang = null;
    await _clearSession();
    notifyListeners();
  }

  // ─── Categories ─────────────────────────────────────────

  Future<String?> fetchCategories() async {
    if (_userLogin == null) return 'Chưa đăng nhập';
    _isLoadingCategories = true;
    notifyListeners();

    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.getCategories();
      _loaiMonAn = (data['categories'] as List)
          .map((c) => CategoryModel.fromJson(c))
          .toList();
      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 401) await logout();
      return e.message;
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // ─── Foods ──────────────────────────────────────────────

  Future<String?> fetchFoods({String? categoryId}) async {
    if (_userLogin == null) return 'Chưa đăng nhập';
    _isLoadingFoods = true;
    notifyListeners();

    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.getFoods(categoryId: categoryId);
      _danhSachMonAn = (data['foods'] as List)
          .map((f) => FoodModel.fromJson(f))
          .toList();
      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 401) await logout();
      return e.message;
    } finally {
      _isLoadingFoods = false;
      notifyListeners();
    }
  }

  // ─── Cart ────────────────────────────────────────────────

  Future<void> fetchCart() async {
    if (_userLogin == null) return;
    _isLoadingCart = true;
    notifyListeners();

    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.getCart();
      _gioHang = CartModel.fromJson(data['cart']);
    } on ApiException catch (e) {
      if (e.statusCode == 401) await logout();
    } finally {
      _isLoadingCart = false;
      notifyListeners();
    }
  }

  Future<String?> addToCart(String foodId, {int quantity = 1}) async {
    if (_userLogin == null) return 'Chưa đăng nhập';
    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.addToCart(foodId: foodId, quantity: quantity);
      _gioHang = CartModel.fromJson(data['cart']);
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 401) await logout();
      return e.message;
    }
  }

  Future<String?> updateCartItem(String foodId, int quantity) async {
    if (_userLogin == null) return 'Chưa đăng nhập';
    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.updateCartItem(foodId: foodId, quantity: quantity);
      _gioHang = CartModel.fromJson(data['cart']);
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 401) await logout();
      return e.message;
    }
  }

  Future<String?> removeFromCart(String foodId) async {
    if (_userLogin == null) return 'Chưa đăng nhập';
    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.removeFromCart(foodId);
      _gioHang = CartModel.fromJson(data['cart']);
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 401) await logout();
      return e.message;
    }
  }

  Future<void> clearCart() async {
    if (_userLogin == null) return;
    try {
      final api = ApiService(token: _userLogin!.token);
      await api.clearCart();
      _gioHang = CartModel(id: '', items: [], totalAmount: 0);
      notifyListeners();
    } on ApiException catch (e) {
      if (e.statusCode == 401) await logout();
    }
  }

  // ─── Orders ──────────────────────────────────────────────

  Future<Map<String, dynamic>?> createOrder() async {
    if (_userLogin == null) return null;
    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.createOrder();
      _gioHang = CartModel(id: '', items: [], totalAmount: 0);
      notifyListeners();
      return data;
    } on ApiException {
      rethrow;
    }
  }

  Future<List<dynamic>> fetchOrders() async {
    if (_userLogin == null) return [];
    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.getOrders();
      return data['orders'] as List;
    } on ApiException catch (e) {
      if (e.statusCode == 401) await logout();
      return [];
    }
  }

  // ─── Profile ─────────────────────────────────────────────

  Future<String?> updateProfile({
    String? name,
    String? currentPassword,
    String? newPassword,
  }) async {
    if (_userLogin == null) return 'Chưa đăng nhập';
    try {
      final api = ApiService(token: _userLogin!.token);
      final data = await api.updateProfile(
        name: name,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      // Cập nhật user local
      final updatedUser = UserModel.fromJson(data['user'], _userLogin!.token);
      _userLogin = updatedUser;
      await _saveSession(_userLogin!);
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }
}
