# 🍔 Food Delivery App

Ứng dụng đặt đồ ăn trực tuyến trên thiết bị di động (Bài tập lớn Mobile).

---

## 📌 Mục lục
- [Giới thiệu](#-giới-thiệu)
- [Tính năng chính](#-tính-năng-chính)
- [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
- [Thành viên nhóm & Phân công](#-thành-viên-nhóm--phân-công)
- [Hướng dẫn cài đặt & Chạy dự án](#-hướng-dẫn-cài-đặt--chạy-dự-án)
- [Quy trình đóng góp (Git Workflow & Pull Request)](#-quy-trình-đóng-góp-git-workflow--pull-request)

---

## 📖 Giới thiệu
**Food Delivery App** là giải pháp hỗ trợ người dùng tìm kiếm món ăn, đặt hàng trực tuyến từ các nhà hàng, theo dõi đơn hàng và thanh toán nhanh chóng, tiện lợi ngay trên thiết bị di động.

---

## ✨ Tính năng chính
- 🔐 **Xác thực người dùng:** Đăng ký, đăng nhập, quên mật khẩu, quản lý hồ sơ cá nhân.
- 🔍 **Tìm kiếm & Phân loại:** Danh mục món ăn phong phú, tìm kiếm theo tên, gợi ý món bán chạy.
- 🛒 **Giỏ hàng & Đặt hàng:** Tùy chọn topping/số lượng, thêm/sửa/xóa món, áp dụng mã giảm giá.
- 📍 **Địa chỉ & Giao hàng:** Định vị, chọn địa chỉ giao hàng linh hoạt.
- 💳 **Thanh toán:** Tích hợp ví điện tử, thanh toán khi nhận hàng (COD).
- 📦 **Theo dõi đơn hàng:** Xem trạng thái đơn hàng (Đang chuẩn bị, Đang giao, Đã giao).

---

## 🛠 Công nghệ sử dụng
- **Mobile Client:** React Native / Flutter (tùy chỉnh theo stack thực tế)
- **Backend / Database:** Node.js / Firebase / MongoDB
- **Quản lý mã nguồn:** Git & GitHub

---

## 👥 Thành viên nhóm & Phân công

| STT | Họ và tên | MSSV | Vai trò | Trách nhiệm chính |
|:---:|:---|:---:|:---|:---|
| 1 | **[Trưởng nhóm]** | ... | Team Leader / Fullstack | Quản lý dự án, thiết kế kiến trúc, review PR |
| 2 | **[Thành viên 2]** | ... | Frontend Developer | Phát triển giao diện người dùng (UI/UX) |
| 3 | **[Thành viên 3]** | ... | Backend Developer | Xây dựng API, quản lý cơ sở dữ liệu |
| 4 | **[Thành viên 4]** | ... | Tester / Developer | Kiểm thử, viết tài liệu, hỗ trợ tính năng |

*(Vui lòng cập nhật lại thông tin chi tiết tên và MSSV của các thành viên trong nhóm)*

---

## 🚀 Hướng dẫn cài đặt & Chạy dự án

### 1. Yêu cầu hệ thống
- Đã cài đặt **Git**, **Node.js** (LTS) hoặc **Flutter SDK** (tùy công nghệ dự án).
- Trình giả lập Android/iOS (Android Studio / Xcode) hoặc điện thoại thật.

### 2. Clone mã nguồn
```bash
git clone https://github.com/Khacsy05/food-delivery-app.git
cd food-delivery-app
```

### 3. Cài đặt thư viện phụ thuộc
```bash
# Đối với React Native / Node
npm install
# hoặc
yarn install

# Đối với Flutter
flutter pub get
```

### 4. Cấu hình biến môi trường
- Sao chép file mẫu:
```bash
cp .env.example .env
```
- Điền các thông tin cấu hình API, Firebase keys,... cần thiết vào file `.env`.

### 5. Khởi chạy ứng dụng
```bash
# React Native (Android)
npm run android

# Flutter
flutter run
```

---

## 🌿 Quy trình đóng góp (Git Workflow & Pull Request)

Nhằm đảm bảo chất lượng source code, nhóm áp dụng quy trình làm việc chuẩn thông qua Pull Request:

1. **Không commit/push trực tiếp lên nhánh `main`**.
2. **Quy tắc đặt tên nhánh:**
   - Tính năng mới: `feature/ten-tinh-nang` (VD: `feature/login`, `feature/cart`)
   - Sửa lỗi: `bugfix/ten-loi`
   - Tối ưu code: `refactor/mo-ta`
3. **Các bước làm việc:**
   ```bash
   # Cập nhật mã nguồn mới nhất từ main
   git checkout main
   git pull origin main

   # Tạo nhánh mới để làm việc
   git checkout -b feature/ten-tinh-nang

   # Sau khi hoàn thành code, commit và push nhánh
   git add .
   git commit -m "feat: mô tả công việc vừa làm"
   git push origin feature/ten-tinh-nang
   ```
4. **Tạo Pull Request (PR):**
   - Truy cập GitHub repo, bấm **Compare & pull request**.
   - Điền template PR (mô tả tính năng, ảnh chụp màn hình nếu có).
   - Chọn Reviewer (ít nhất 1 thành viên review và approve trước khi merge).
   - Merge vào nhánh `main` sau khi đã kiểm tra không có xung đột.