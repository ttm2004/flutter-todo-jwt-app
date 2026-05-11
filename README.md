# Ứng Dụng Bán Đồ Ăn Trực Tuyến

> Môn: Phát triển Ứng dụng Di động Đa nền tảng — Kiểm tra Giữa Kỳ

## Demo

[![▶ Xem Demo](https://img.shields.io/badge/▶%20Xem%20Demo-Google%20Drive-blue?style=for-the-badge&logo=google-drive)](https://drive.google.com/file/d/1SEa_En1XWEx3-WiTSs4Ao9-SIKCKcfd9/view?usp=sharing)

---

## Công Nghệ

- **Flutter** — giao diện mobile (Android)
- **Node.js + Express** — REST API server
- **MongoDB Atlas** — database trên cloud
- **Render.com** — deploy server lên internet

---

## Server Riêng (Public)

Server được deploy lên **Render.com** và có thể truy cập từ bất kỳ đâu:

> 🌐 **https://flutter-todo-jwt-app.onrender.com**

Toàn bộ dữ liệu (tài khoản, món ăn, giỏ hàng, đơn hàng) đều được lưu trên server và MongoDB Atlas — **không lưu gì trên thiết bị** ngoài JWT Token để duy trì phiên đăng nhập.

### Cách Hoạt Động

```
Flutter App  ──HTTPS──►  Node.js Server (Render.com)  ──►  MongoDB Atlas
             ◄──JSON──   (xử lý logic, xác thực JWT)  ◄──  (lưu dữ liệu)
```

1. Người dùng đăng nhập → server xác thực → trả về **JWT Token**
2. Token được lưu vào **SharedPreferences** trên thiết bị
3. Mọi request tiếp theo đều gửi kèm token trong header: `Authorization: Bearer <token>`
4. Server kiểm tra token → nếu hợp lệ thì xử lý, không hợp lệ trả về 401 → app tự logout

### API Endpoints

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| POST | `/api/auth/register` | Đăng ký |
| POST | `/api/auth/login` | Đăng nhập, nhận token |
| PUT | `/api/auth/profile` | Cập nhật thông tin |
| GET | `/api/categories` | Danh sách danh mục |
| GET | `/api/foods?category=:id` | Món ăn theo danh mục |
| GET/POST/PUT/DELETE | `/api/cart` | Quản lý giỏ hàng |
| POST/GET | `/api/orders` | Đặt hàng / lịch sử đơn |

---

## Các Màn Hình

| Màn hình | Chức năng |
|----------|-----------|
| Đăng nhập / Đăng ký | Xác thực người dùng qua API |
| Danh mục món ăn | Hiển thị danh mục, có Drawer và Header tùy chỉnh |
| Danh sách & Chi tiết món | Xem món, thêm vào giỏ hàng |
| Giỏ hàng | Chỉnh số lượng, xóa món, thanh toán |
| Đặt hàng thành công | Xác nhận đơn hàng từ server |
| Đơn hàng của tôi | Lịch sử đơn hàng |
| Thông tin tài khoản | Chỉnh tên, đổi mật khẩu |

---

## Lưu Ý

Server dùng **Render.com free tier** nên sẽ ngủ sau 15 phút không có request. Lần đầu mở app có thể chờ ~30 giây để server khởi động lại.
