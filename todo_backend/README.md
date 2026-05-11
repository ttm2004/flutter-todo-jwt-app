# Todo Backend API

REST API với JWT Authentication cho Flutter Todo App.

## Tech Stack
- Node.js + Express
- MongoDB (Atlas)
- JWT Authentication
- bcryptjs (password hashing)

## API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/auth/register | Đăng ký tài khoản |
| POST | /api/auth/login | Đăng nhập |
| GET | /api/auth/me | Lấy thông tin user (cần token) |

### Todos (cần Bearer token)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/todos | Lấy danh sách todos |
| POST | /api/todos | Tạo todo mới |
| PUT | /api/todos/:id | Cập nhật todo |
| DELETE | /api/todos/:id | Xóa todo |
| PATCH | /api/todos/:id/toggle | Toggle hoàn thành |

---

## Hướng dẫn Deploy lên Render.com (Miễn phí)

### Bước 1: Tạo MongoDB Atlas (Database miễn phí)

1. Truy cập https://www.mongodb.com/atlas
2. Đăng ký tài khoản miễn phí
3. Tạo cluster **M0 Free Tier**
4. Vào **Database Access** → Add user → tạo username/password
5. Vào **Network Access** → Add IP Address → chọn **Allow Access from Anywhere** (0.0.0.0/0)
6. Vào **Clusters** → Connect → **Connect your application** → copy connection string
   - Dạng: `mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/todo_db`

### Bước 2: Push code lên GitHub

```bash
cd todo_backend
git init
git add .
git commit -m "Initial backend"
git remote add origin https://github.com/your-username/todo-backend.git
git push -u origin main
```

### Bước 3: Deploy lên Render.com

1. Truy cập https://render.com → Đăng ký miễn phí
2. Click **New** → **Web Service**
3. Connect GitHub repo `todo-backend`
4. Cấu hình:
   - **Name**: `todo-api` (hoặc tên bạn muốn)
   - **Runtime**: Node
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
5. Thêm **Environment Variables**:
   ```
   MONGODB_URI = mongodb+srv://...  (connection string từ Atlas)
   JWT_SECRET  = your_random_secret_key_here_make_it_long
   JWT_EXPIRES_IN = 7d
   PORT = 3000
   ```
6. Click **Create Web Service**
7. Đợi deploy xong → copy URL dạng: `https://todo-api.onrender.com`

### Bước 4: Cập nhật Flutter App

Mở file `flutter_todo_app_with_jwt/lib/config/api_config.dart`:

```dart
static const String baseUrl = 'https://todo-api.onrender.com'; // URL của bạn
```

---

## Chạy local để test

```bash
# Copy file env
cp .env.example .env
# Điền thông tin vào .env

# Cài dependencies
npm install

# Chạy dev server
npm run dev
```

Server sẽ chạy tại http://localhost:3000
