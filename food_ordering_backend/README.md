# Food Ordering Backend API

REST API cho ứng dụng đặt đồ ăn trực tuyến với JWT Authentication.

## Tech Stack
- Node.js + Express
- MongoDB Atlas
- JWT Authentication
- bcryptjs (password hashing)

## API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/auth/register | Đăng ký tài khoản |
| POST | /api/auth/login | Đăng nhập |
| POST | /api/auth/forgot-password | Quên mật khẩu |
| GET | /api/auth/me | Lấy thông tin user (cần token) |

### Categories (cần Bearer token)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/categories | Lấy danh sách danh mục |

### Foods (cần Bearer token)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/foods | Lấy tất cả món ăn |
| GET | /api/foods?category=:id | Lấy món theo danh mục |
| GET | /api/foods/:id | Lấy chi tiết món |

### Cart (cần Bearer token)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/cart | Lấy giỏ hàng |
| POST | /api/cart | Thêm món vào giỏ |
| PUT | /api/cart/:foodId | Cập nhật số lượng |
| DELETE | /api/cart/:foodId | Xóa món khỏi giỏ |
| DELETE | /api/cart/clear | Xóa toàn bộ giỏ |

### Orders (cần Bearer token)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/orders | Tạo đơn hàng |
| GET | /api/orders | Lấy danh sách đơn hàng |

---

## Deploy lên Render.com (Miễn phí)

### Bước 1: Push code lên GitHub

```bash
cd food_ordering_backend
git init
git add .
git commit -m "Food ordering backend API"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/food-ordering-backend.git
git push -u origin main
```

### Bước 2: Deploy trên Render

1. Truy cập https://render.com → Đăng ký/Đăng nhập
2. Click **New** → **Web Service**
3. Connect GitHub repo `food-ordering-backend`
4. Render sẽ tự động phát hiện `render.yaml` và cấu hình

**Hoặc cấu hình thủ công:**
- **Name**: `food-ordering-api`
- **Runtime**: Node
- **Build Command**: `npm install`
- **Start Command**: `npm start`
- **Environment Variables**:
  ```
  MONGODB_URI = mongodb+srv://flutter-todo-jwt-app:kkk111@cluster0.sps96rn.mongodb.net/food_ordering_db?appName=Cluster0
  JWT_SECRET = food_ordering_jwt_super_secret_key_2024
  JWT_EXPIRES_IN = 7d
  ```

5. Click **Create Web Service**
6. Đợi deploy xong (3-5 phút)
7. Copy URL dạng: `https://food-ordering-api-xxxx.onrender.com`

### Bước 3: Cập nhật Flutter App

Mở file `flutter_todo_app_with_jwt/lib/config/api_config.dart`:

```dart
static const String baseUrl = 'https://food-ordering-api-xxxx.onrender.com';
```

---

## Chạy Local

```bash
# Copy file env
cp .env.example .env
# Điền thông tin MongoDB URI vào .env

# Cài dependencies
npm install

# Chạy dev server
npm run dev
```

Server sẽ chạy tại http://localhost:4000

---

## Seed Data

Backend tự động seed dữ liệu mẫu khi khởi động lần đầu:
- 5 danh mục: Món Việt, Món Nhật, Món Hàn, Đồ Uống, Tráng Miệng
- 15 món ăn với hình ảnh từ Unsplash

---

## Lưu ý Render Free Tier

- Server sẽ **sleep sau 15 phút không hoạt động**
- Request đầu tiên sau khi sleep sẽ mất ~30 giây để wake up
- Giới hạn 750 giờ/tháng (đủ dùng cho development)
