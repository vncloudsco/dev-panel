# Telegram Backup Feature

## Tính năng Backup lên Telegram

### Mô tả
Tính năng backup dữ liệu lên Telegram cho phép bạn:
- Backup dữ liệu website trực tiếp lên Telegram Bot
- Tự động chia tách file lớn hơn 2GB thành nhiều phần nhỏ
- Đặt tên file theo cấu trúc: `domain-dd-mm-yyyy-hhmmss-type.tar.gz`
- Hỗ trợ 3 loại backup: Full, Source code only, Database only
- Tự động setup cronjob cho backup định kỳ

### Cách sử dụng

#### 1. Cấu hình Telegram Bot
1. Tạo bot Telegram:
   - Mở Telegram và tìm @BotFather
   - Gửi lệnh: `/newbot`
   - Đặt tên cho bot và username
   - Lưu lại Bot Token được cung cấp

2. Lấy Chat ID:
   - Gửi tin nhắn cho bot vừa tạo
   - Truy cập: `https://api.telegram.org/bot<BOT_TOKEN>/getUpdates`
   - Tìm `"chat":{"id": YOUR_CHAT_ID}`

#### 2. Cấu hình trong Panel
1. Vào menu: `Backup/Restore > Connect Telegram`
2. Nhập Bot Token và Chat ID
3. Hệ thống sẽ test kết nối và lưu cấu hình

#### 3. Backup thủ công
1. Vào menu: `Backup/Restore > Backup Data`
2. Chọn location: `Telegram`
3. Chọn loại backup: Full/Source/Database
4. Hệ thống sẽ tự động backup và gửi lên Telegram

#### 4. Backup tự động (Cronjob)
1. Vào menu: `Backup/Restore > Auto Backup > Cronjob backup to Telegram`
2. Chọn backup theo domain hoặc tất cả domain
3. Chọn thời gian backup: Hàng ngày/tuần/tháng/năm
4. Chọn loại backup
5. Cronjob sẽ được tạo tự động

### Tính năng đặc biệt

#### Chia tách file lớn
- File lớn hơn 1.9GB sẽ được tự động chia thành nhiều phần
- Mỗi phần có tên: `domain-dd-mm-yyyy-hhmmss-type.part1.tar.gz`, `part2.tar.gz`, v.v.
- Telegram sẽ nhận từng phần riêng biệt

#### Định dạng tên file
```
domain-dd-mm-yyyy-hhmmss-type.tar.gz
```
Ví dụ: `example.com-20-06-2025-143022-full.tar.gz`

#### Thông tin backup
Mỗi lần backup thành công, Telegram sẽ nhận được thông báo bao gồm:
- Tên domain
- Loại backup
- Kích thước file
- Ngày giờ backup
- IP server

### Lưu ý
- Telegram giới hạn file tối đa 2GB
- Bot cần được thêm vào chat/group trước khi sử dụng
- Cấu hình được lưu tại: `/var/hostvn/telegram/.telegram_backup_config`
- File backup tạm sẽ được xóa sau khi gửi thành công
- Có thể sử dụng cùng lúc với các phương thức backup khác (Google Drive, OneDrive, Local)

### Troubleshooting

#### Lỗi kết nối Telegram
- Kiểm tra Bot Token có đúng không
- Kiểm tra Chat ID có đúng không
- Đảm bảo bot đã được start trong chat

#### File quá lớn
- Hệ thống sẽ tự động chia tách file > 1.9GB
- Nếu vẫn gặp lỗi, hãy loại trừ cache và file tạm trong source code

#### Cronjob không chạy
- Kiểm tra crontab: `crontab -l`
- Kiểm tra log: `/var/log/cron.log`
- Đảm bảo cấu hình Telegram vẫn hợp lệ
