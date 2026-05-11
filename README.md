# Ứng Dụng Bán Đồ Ăn Trực Tuyến

Ứng dụng di động Flutter kết nối với Node.js REST API server để đặt đồ ăn trực tuyến.

## Cấu Trúc Project

```
├── flutter_todo_app_with_jwt/   # Flutter mobile app
└── food_ordering_backend/       # Node.js REST API server
```

---

## Backend API

**Server:** https://flutter-todo-jwt-app.onrender.com

### Tech Stack
- Node.js + Express
- MongoDB Atlas
- JWT Authentication
- Deployed on Render.com

### API Endpoints

| Method | Endpoint | Auth | Mô tả |
|--------|----------|------|-------|
| POST | /api/auth/register | ❌ | Đăng ký tài khoản |
| POST | /api/auth/login | ❌ | Đăng nhập |
| POST | /api/auth/forgot-password | ❌ | Quên mật khẩu |
| GET | /api/auth/me | ✅ | Thông tin user |
| GET | /api/categories | ✅ | Danh sách danh mục |
| GET | /api/foods | ✅ | Danh sách món ăn |
| GET | /api/foods?category=:id | ✅ | Món ăn theo danh mục |
| GET | /api/cart | ✅ | Lấy giỏ hàng |
| POST | /api/cart | ✅ | Thêm vào giỏ hàng |
| PUT | /api/cart/:foodId | ✅ | Cập nhật số lượng |
| DELETE | /api/cart/:foodId | ✅ | Xóa khỏi giỏ hàng |
| DELETE | /api/cart/clear | ✅ | Xóa toàn bộ giỏ hàng |
| POST | /api/orders | ✅ | Tạo đơn hàng |
| GET | /api/orders | ✅ | Lịch sử đơn hàng |

---

## Flutter App

### Tech Stack
- Flutter + Dart
- Provider (state management)
- SharedPreferences (lưu JWT token)
- HTTP package (gọi API)
- CachedNetworkImage (hiển thị ảnh)

### Tính Năng
- ✅ Đăng ký / Đăng nhập / Quên mật khẩu
- ✅ Xem danh mục món ăn
- ✅ Xem danh sách và chi tiết món ăn
- ✅ Thêm vào giỏ hàng (từ danh sách và chi tiết)
- ✅ Quản lý giỏ hàng (tăng/giảm/xóa)
- ✅ Đặt hàng và xem xác nhận đơn hàng
- ✅ Drawer Navigator + Stack Navigator
- ✅ Tự động đăng nhập lại khi mở app (JWT lưu local)
- ✅ Xử lý lỗi mạng và timeout

### Màn Hình
| Màn hình | Mô tả |
|----------|-------|
| Login | Đăng nhập với email/mật khẩu |
| Register | Tạo tài khoản mới |
| Forgot Password | Khôi phục mật khẩu qua email |
| Category | Danh sách danh mục món ăn |
| Food List | Danh sách món theo danh mục |
| Food Detail | Chi tiết món + chọn số lượng |
| Cart | Giỏ hàng + thanh toán |
| Order Success | Xác nhận đơn hàng thành công |

---

## Chạy Local

### Backend
```bash
cd food_ordering_backend
npm install
# Tạo file .env từ .env.example và điền thông tin
npm run dev
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

---

## Build APK

```bash
cd flutter_todo_app_with_jwt
flutter build apk --release
```

File APK xuất ra tại:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Seed Data

Backend tự động tạo dữ liệu mẫu khi khởi động lần đầu:
- 5 danh mục: Món Việt, Món Nhật, Món Hàn, Đồ Uống, Tráng Miệng
- 15 món ăn với hình ảnh thực tế

---

## Lưu Ý

- Server dùng **Render.com free tier** — sẽ sleep sau 15 phút không có request
- Lần đầu gọi API sau khi server ngủ sẽ chờ ~30 giây để wake up
- JWT Token được lưu local bằng SharedPreferences, không cần đăng nhập lại mỗi lần mở app
