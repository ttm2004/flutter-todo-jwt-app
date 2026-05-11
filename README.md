# Ứng Dụng Bán Đồ Ăn Trực Tuyến

Ứng dụng di động Flutter kết nối với Node.js REST API server để đặt đồ ăn trực tuyến.

## Cấu Trúc Project

```
├── flutter_todo_app_with_jwt/   # Flutter mobile app (Android/iOS)
└── food_ordering_backend/       # Node.js REST API server
```

---

## Backend API

**Server public:** https://flutter-todo-jwt-app.onrender.com

### Tech Stack
- Node.js + Express
- MongoDB Atlas (cloud database)
- JWT Authentication
- Deployed on Render.com (free tier)

### API Endpoints

#### Auth
| Method | Endpoint | Auth | Mô tả |
|--------|----------|------|-------|
| POST | /api/auth/register | ❌ | Đăng ký tài khoản |
| POST | /api/auth/login | ❌ | Đăng nhập |
| POST | /api/auth/forgot-password | ❌ | Quên mật khẩu |
| GET | /api/auth/me | ✅ | Thông tin user hiện tại |
| PUT | /api/auth/profile | ✅ | Cập nhật tên / đổi mật khẩu |

#### Danh Mục & Món Ăn
| Method | Endpoint | Auth | Mô tả |
|--------|----------|------|-------|
| GET | /api/categories | ✅ | Danh sách danh mục |
| GET | /api/foods | ✅ | Tất cả món ăn |
| GET | /api/foods?category=:id | ✅ | Món ăn theo danh mục |
| GET | /api/foods/:id | ✅ | Chi tiết một món ăn |

#### Giỏ Hàng
| Method | Endpoint | Auth | Mô tả |
|--------|----------|------|-------|
| GET | /api/cart | ✅ | Lấy giỏ hàng hiện tại |
| POST | /api/cart | ✅ | Thêm món vào giỏ |
| PUT | /api/cart/:foodId | ✅ | Cập nhật số lượng |
| DELETE | /api/cart/:foodId | ✅ | Xóa một món khỏi giỏ |
| DELETE | /api/cart/clear | ✅ | Xóa toàn bộ giỏ hàng |

#### Đơn Hàng
| Method | Endpoint | Auth | Mô tả |
|--------|----------|------|-------|
| POST | /api/orders | ✅ | Tạo đơn hàng từ giỏ hàng |
| GET | /api/orders | ✅ | Lịch sử đơn hàng |

---

## Flutter App

### Tech Stack
- Flutter + Dart
- **Provider** — quản lý state toàn cục
- **SharedPreferences** — lưu JWT token local
- **HTTP** — gọi REST API
- **CachedNetworkImage** — hiển thị ảnh có cache

### Tính Năng
- ✅ Đăng ký / Đăng nhập / Quên mật khẩu
- ✅ Tự động đăng nhập lại khi mở app (JWT lưu local)
- ✅ Xem danh mục món ăn (grid view)
- ✅ Xem danh sách và chi tiết món ăn
- ✅ Thêm vào giỏ hàng từ danh sách và từ màn hình chi tiết
- ✅ Quản lý giỏ hàng (tăng/giảm số lượng, xóa món)
- ✅ Đặt hàng và xem xác nhận đơn hàng
- ✅ Lịch sử đơn hàng đã đặt (có thể expand xem chi tiết)
- ✅ Chỉnh sửa thông tin tài khoản (tên, mật khẩu)
- ✅ Drawer Navigator + Stack Navigator
- ✅ Xử lý lỗi mạng, timeout, 401 unauthorized

### Màn Hình

| Màn hình | File | Mô tả |
|----------|------|-------|
| Đăng nhập | `login_screen.dart` | Email + mật khẩu, link đến đăng ký và quên mật khẩu |
| Đăng ký | `register_screen.dart` | Tên, email, mật khẩu, xác nhận mật khẩu |
| Quên mật khẩu | `forgot_password_screen.dart` | Nhập email để khôi phục |
| Danh mục | `category_screen.dart` | Grid danh mục, Custom Header, Drawer |
| Danh sách món | `food_list_screen.dart` | Món ăn theo danh mục, nút thêm giỏ nhanh |
| Chi tiết món | `food_detail_screen.dart` | Ảnh lớn, mô tả, chọn số lượng, thêm giỏ |
| Giỏ hàng | `cart_screen.dart` | Danh sách món, tổng tiền, nút thanh toán |
| Đặt hàng thành công | `order_success_screen.dart` | Mã đơn, danh sách món, tổng tiền, thời gian |
| Đơn hàng của tôi | `order_history_screen.dart` | Lịch sử đơn, trạng thái, expand xem chi tiết |
| Thông tin tài khoản | `profile_screen.dart` | Chỉnh tên, đổi mật khẩu |

### Cấu Trúc Thư Mục Flutter

```
lib/
├── config/
│   └── api_config.dart          # Base URL và tất cả endpoints
├── models/
│   ├── user_model.dart
│   ├── category_model.dart
│   ├── food_model.dart
│   ├── cart_model.dart
│   └── order_model.dart
├── services/
│   └── api_service.dart         # HTTP client, timeout, error handling
├── store/
│   └── app_store.dart           # Global state (Provider/ChangeNotifier)
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── forgot_password_screen.dart
│   ├── category_screen.dart
│   ├── food_list_screen.dart
│   ├── food_detail_screen.dart
│   ├── cart_screen.dart
│   ├── order_success_screen.dart
│   ├── order_history_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── custom_header.dart       # AppBar với badge giỏ hàng + user menu
│   └── app_drawer.dart          # Drawer Navigator
└── main.dart
```

---

## Chạy Local

### Backend
```bash
cd food_ordering_backend
npm install
cp .env.example .env
# Điền MONGODB_URI và JWT_SECRET vào .env
npm run dev
# Server chạy tại http://localhost:4000
```

### Flutter
```bash
cd flutter_todo_app_with_jwt
flutter pub get
flutter run
```

> Khi chạy local, đổi `baseUrl` trong `lib/config/api_config.dart`:
> - Android Emulator: `http://10.0.2.2:4000`
> - iOS Simulator / Web: `http://localhost:4000`
> - Điện thoại thật (cùng WiFi): `http://192.168.x.x:4000`

---

## Build APK (Android)

```bash
cd flutter_todo_app_with_jwt
flutter build apk --release
```

File APK xuất ra tại:
```
build/app/outputs/flutter-apk/app-release.apk
```

Cài lên điện thoại: bật **"Cài từ nguồn không xác định"** trong Cài đặt → Bảo mật, rồi mở file APK.

---

## Seed Data

Backend tự động tạo dữ liệu mẫu khi khởi động lần đầu (nếu database trống):

**5 danh mục:** Món Việt, Món Nhật, Món Hàn, Đồ Uống, Tráng Miệng

**15 món ăn** với hình ảnh thực tế từ Unsplash, bao gồm:
- Phở Bò, Bún Bò Huế, Cơm Tấm Sườn, Bánh Mì Thịt
- Sushi Cá Hồi, Ramen Tonkotsu, Tempura Tôm
- Bibimbap, Tteokbokki, Gà Chiên Hàn
- Trà Sữa Trân Châu, Cà Phê Sữa Đá, Nước Ép Cam
- Chè Ba Màu, Bánh Flan

---

## Lưu Ý

> **Render free tier** sẽ sleep sau 15 phút không có request. Lần đầu mở app sau khi server ngủ sẽ chờ ~30 giây để wake up — đây là bình thường.

- JWT Token lưu bằng SharedPreferences → không cần đăng nhập lại mỗi lần mở app
- Timeout API: 60 giây (để chờ Render wake up)
- Tất cả dữ liệu (món ăn, giỏ hàng, đơn hàng) đều lưu trên server, không dùng local storage
