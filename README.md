# GPS Tracking Flutter App

Ứng dụng theo dõi tốc độ di chuyển bằng GPS, hỗ trợ nhiều tính năng hữu ích cho người dùng di động.

## Mục lục

- [Giới thiệu](#giới-thiệu)
- [Tính năng](#tính-năng)
- [Cài đặt](#cài-đặt)
- [Cấu trúc thư mục](#cấu-trúc-thư-mục)
- [Sử dụng](#sử-dụng)
- [Đóng góp](#đóng-góp)
- [Thông tin liên hệ](#thông-tin-liên-hệ)

## Giới thiệu

GPS Tracking là ứng dụng Flutter giúp theo dõi tốc độ di chuyển, vị trí, cảnh báo nguy hiểm, chia sẻ dữ liệu, và nhiều tiện ích khác. Ứng dụng hỗ trợ đa ngôn ngữ, giao diện hiện đại, tích hợp Firebase và Google Maps.

## Tính năng

- Hiển thị tốc độ di chuyển theo thời gian thực
- Theo dõi vị trí GPS, lưu lịch sử di chuyển
- Cảnh báo khu vực nguy hiểm
- Chia sẻ dữ liệu qua các nền tảng khác nhau
- Hỗ trợ đa ngôn ngữ (Anh, Việt, Nhật, Trung, Tây Ban Nha, Bồ Đào Nha, Hindi, Ả Rập)
- Tích hợp Google Maps
- Lưu trữ dữ liệu cục bộ bằng Hive và Shared Preferences
- Giao diện đẹp, dễ sử dụng
- Tích hợp Firebase Analytics & Crashlytics

## Cài đặt

### Yêu cầu

- Flutter >=3.2.3 <4.0.0
- Dart SDK phù hợp
- Android Studio hoặc Xcode (cho Android/iOS)

### Các bước cài đặt

1. Clone repo:
   ```bash
   git clone https://github.com/bossxomlut/gps_tracking.git
   cd gps_tracking
   ```
2. Cài đặt dependencies:
   ```bash
   flutter pub get
   ```
3. Chạy build runner (bắt buộc nếu có sử dụng code generation):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Chạy ứng dụng:
   ```bash
   flutter run
   ```
5. (Tuỳ chọn) Thiết lập Firebase:
   - Thêm file `google-services.json` vào `android/app/`
   - Thêm file `GoogleService-Info.plist` vào `ios/Runner/`

## Cấu trúc thư mục

```
lib/
  main.dart                // Điểm khởi động ứng dụng
  base_presentation/       // Giao diện, theme
  data/                    // Xử lý dữ liệu, models
  di/                      // Dependency injection
  feature/                 // Các tính năng chính
  firebase/                // Tích hợp Firebase
  internet_connect/        // Kiểm tra kết nối mạng
  main_setting/            // Cài đặt ứng dụng
  resource/                // Tài nguyên
  storage/                 // Lưu trữ dữ liệu
  util/                    // Tiện ích
  widget/                  // Widget dùng chung
assets/
  icons/                   // Icon SVG
  images/                  // Hình ảnh
  translations/            // File đa ngôn ngữ
test/                      // Unit test, widget test
android/                   // Source Android
ios/                       // Source iOS
pubspec.yaml               // Khai báo dependencies
```

## Sử dụng

1. Mở ứng dụng, cấp quyền truy cập vị trí
2. Theo dõi tốc độ, vị trí trên bản đồ
3. Chia sẻ dữ liệu hoặc xuất file nếu cần
4. Tuỳ chỉnh cài đặt, ngôn ngữ trong phần Settings

## Đóng góp

Mọi đóng góp đều được hoan nghênh! Vui lòng tạo pull request hoặc issue nếu bạn muốn cải thiện ứng dụng.

## Thông tin liên hệ

- Tác giả: bossxomlut
- Email: bossxomlut@gmail.com
- Github: [bossxomlut/gps_tracking](https://github.com/bossxomlut/gps_tracking)
