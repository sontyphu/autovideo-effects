# Danh mục thành phần - Gói Hiệu ứng

Phiên bản trong tài liệu này là phiên bản đã kiểm chứng trên máy tác giả ngày **07/08/2026**. Khi tác giả nâng cấp, tài liệu được cập nhật và toàn bộ học viên cài theo phiên bản mới.

---

## Điều kiện tiên quyết

| Gói | Vị trí | Vai trò |
| --- | --- | --- |
| Chuẩn bị trước khóa học | https://sontyphu.github.io/hoc-auto-video/chuan-bi/ | Cung cấp Node.js, kèm npm dùng để cài HyperFrames |
| Gói Cắt và Giọng | https://github.com/sontyphu/autovideo-toolkit | Cung cấp `transcript_hyperframes.py`, công cụ bóc lời tiếng Việt cho quy trình gắn phụ đề |

Thiếu một trong hai, gói này cài đặt được nhưng không vận hành đúng với nội dung tiếng Việt.

---

## Thành phần trong gói

| Thành phần | Vai trò | Phiên bản ghim | Người thực hiện |
| --- | --- | --- | --- |
| HyperFrames | Chèn chữ động, hiệu ứng và đồ họa vào video | 0.7.88 | Trợ lý AI |
| Chrome kết xuất | HyperFrames dựng video bằng cách kết xuất nội dung web, yêu cầu một bản Chrome rút gọn chạy nền | tải tự động, khoảng 150 MB | Tự động |
| Phông Be Vietnam Pro | Hiển thị tiếng Việt đầy đủ dấu trên video | có sẵn trong kho | Trợ lý AI |

---

## Cài đặt và kiểm tra từng thành phần

### HyperFrames

Kiểm tra hiện trạng: `hyperframes --version`

```bash
npm install -g hyperframes@0.7.88
```

**Phép kiểm**: `hyperframes --version` trả về đúng `0.7.88`.

**Lưu ý về phiên bản**: cài đúng `0.7.88`, không dùng `@latest`. Thay đổi từ nhà phát hành có thể phá vỡ quy trình đang vận hành, và sự cố sẽ xảy ra đồng loạt trên toàn lớp.

**Lưu ý về quyền**: trên một số máy Windows, `npm install -g` yêu cầu quyền quản trị. Trường hợp báo lỗi quyền, mở PowerShell bằng tùy chọn *Run as administrator* rồi chạy lại lệnh. Trên macOS, dùng `sudo npm install -g hyperframes@0.7.88`.

### Chrome kết xuất

Không có lệnh cài đặt riêng. HyperFrames tự tải về `~/.cache/hyperframes/chrome/` ở lần dựng video đầu tiên.

**Phép kiểm**: thư mục `~/.cache/hyperframes/chrome` tồn tại.

Để tránh thời gian chờ phát sinh trong buổi học, dựng thử một video ngắn ngay sau khi cài đặt nhằm tải trước thành phần này.

### Phông Be Vietnam Pro

Đặt sẵn trong `hyperframes-viet/fonts/`. Phông không cài vào hệ thống mà sao chép vào từng dự án video:

```powershell
.\hyperframes-viet\vao-viec.ps1 -DuAn "<đường dẫn dự án>" -KemKhuonMau
```

Lệnh này sao chép bộ phông và thư viện chuyển động vào dự án, đồng thời phòng tránh ba lỗi đầu trong bảng mười ba lỗi.

**Phép kiểm**: tồn tại `assets/fonts/be-vietnam-pro.css` trong thư mục dự án.

**Yêu cầu khai báo**: trong CSS dùng `font-family: "Be Vietnam Pro", Roboto, sans-serif`. Không dẫn `<link>` tới fonts.googleapis.com - quá trình kết xuất chỉ chờ tải phông trong mười giây rồi dừng, dẫn đến dựng video thất bại.

---

## Bảng mười ba lỗi

`hyperframes-viet/DOC-TRUOC.md` tổng hợp mười ba lỗi đã ghi nhận trong vận hành thực tế, kèm phương án phòng tránh. Phân theo năm nhóm: phông chữ tiếng Việt và phụ thuộc mạng, âm thanh và giọng đọc, kết xuất hàng loạt, môi trường máy, và nhóm lỗi hệ thống không tự phát hiện được.

Thời gian kết xuất tham chiếu, đo trên máy tác giả với card đồ họa GT 1030:

| Tác vụ | Thời gian |
| --- | --- |
| Video 30 giây, khung dọc 1080x1920 | 7 phút |
| Video 6 giây | 1 phút 10 giây |
| Quy trình đầu cuối cho video 20 giây | khoảng 15 phút |

Cấu hình mạnh hơn cho thời gian ngắn hơn.

---

## Quy trình nghiệm thu trước khi phát hành video

1. Chạy `npm run check`, yêu cầu không còn cảnh báo. Công cụ phát hiện video mất tiếng, các lớp chồng lấn, chữ khó đọc và chuyển động lỗi
2. Trích xuất tối thiểu bốn khung hình để kiểm tra trực quan. Một số lỗi hiển thị không được công cụ tự động phát hiện
3. Với video có giọng đọc, bóc lời ngược từ tệp thành phẩm và đối chiếu với kịch bản gốc
