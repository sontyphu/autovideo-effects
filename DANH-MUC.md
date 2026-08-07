# Danh mục phần mềm - Gói Hiệu ứng

> Bản ghim: **đúng phiên bản thầy Sơn đang chạy thật**, đọc từ máy thầy ngày **07/08/2026**.
> Thầy nâng bản thì cập nhật file này, cả lớp cài theo.

## Phải xong trước

| Gói | Ở đâu | Vì sao cần |
| --- | --- | --- |
| **Vé vào lớp** (Claude Pro, Node.js, Git) | https://sontyphu.github.io/hoc-auto-video/chuan-bi/ | HyperFrames cài bằng npm, mà npm đi kèm Node.js |
| **Gói Cắt + Giọng** | https://github.com/sontyphu/autovideo-toolkit | Chứa `transcript_hyperframes.py` - công cụ bóc lời tiếng Việt để gắn phụ đề chạy theo lời |

Thiếu một trong hai thì gói này cài xong cũng không dùng được với tiếng Việt.

---

## Ba món trong gói này

| # | Món | Để làm gì | Bản ghim | Ai cài |
| --- | --- | --- | --- | --- |
| 1 | **HyperFrames** | Phần mềm chèn chữ động, hiệu ứng, đồ họa vào video | 0.7.88 | Trợ lý AI |
| 2 | **Chrome ngầm** | HyperFrames dựng video bằng cách "chụp" trang web, nên cần một bản Chrome rút gọn chạy ngầm | tự tải lần đầu (~150 MB) | Tự động |
| 3 | **Bộ chữ Be Vietnam Pro** | Chữ tiếng Việt không mất dấu trên video | có sẵn trong kho | Trợ lý AI |

---

## Lệnh cài và phép kiểm

### 1. HyperFrames

**Kiểm đã có chưa:** `hyperframes --version`

```bash
npm install -g hyperframes@0.7.88
```

**Đạt khi:** `hyperframes --version` ra đúng `0.7.88`.

> ⚠️ **Ghim đúng bản 0.7.88.** Đừng cài `@latest` - hãng ra bản mới sửa gì hỏng là cả lớp tắc cùng lúc, mà thầy Sơn chưa chạy thử bản đó.
>
> ⚠️ Trên vài máy Windows, `npm install -g` đòi **quyền quản trị**. Báo lỗi quyền thì bảo học viên mở PowerShell bằng cách bấm chuột phải chọn *Run as administrator* rồi chạy lại đúng lệnh trên.

### 2. Chrome ngầm

Không có lệnh cài riêng. HyperFrames **tự tải** về `~/.cache/hyperframes/chrome/` ngay lần đầu dựng video.

**Đạt khi:** thư mục `~/.cache/hyperframes/chrome` tồn tại.

Muốn tải trước cho khỏi phải chờ giữa buổi học thì dựng thử một video ngắn ngay sau khi cài.

> ⏱️ Khoảng **150 MB**, mạng chậm thì vài phút. Học viên hay tưởng máy treo - báo trước cho họ biết.

### 3. Bộ chữ Be Vietnam Pro

Nằm sẵn trong `hyperframes-viet/fonts/`. Không cài vào máy, mà **chép vào từng dự án video**:

```powershell
.\hyperframes-viet\vao-viec.ps1 -DuAn "đường\dẫn\dự-án-mới" -KemKhuonMau
```

Lệnh này chép bộ chữ và thư viện chuyển động vào dự án, né sẵn 3 lỗi đầu bảng 13 lỗi.

**Đạt khi:** trong thư mục dự án có `assets/fonts/be-vietnam-pro.css`.

> ⚠️ **Trong CSS phải ghi** `font-family: "Be Vietnam Pro", Roboto, sans-serif` và **đừng dán `<link>` tới fonts.googleapis.com** - máy chỉ chờ tải chữ 10 giây rồi bỏ cuộc, video dựng hỏng.

---

## Bảng 13 lỗi - đọc trước khi làm video

`hyperframes-viet/DOC-TRUOC.md` ghi 13 lỗi thầy Sơn đã gặp thật, kèm cách né. Chia 5 nhóm: chữ tiếng Việt và mạng · tiếng và giọng đọc · nhân bản hàng loạt · máy móc · lỗi máy không tự bắt được.

Ba con số thật đo trên máy thầy (card GT 1030):

| Việc | Thời gian |
| --- | --- |
| Video 30 giây, khung dọc 1080x1920 | 7 phút |
| Video 6 giây | 1 phút 10 |
| Cả quy trình đầu-cuối cho video 20 giây | khoảng 15 phút |

Máy khỏe hơn sẽ nhanh hơn.

---

## Ba việc bắt buộc trước khi giao video

1. **Chạy `npm run check`** - phải sạch lỗi. Nó bắt được video câm tiếng, thẻ đè nhau, chữ khó đọc, chuyển động hỏng.
2. **Trích ít nhất 4 khung hình ra xem thật** - có loại lỗi máy không tự bắt được.
3. **Có giọng đọc thì nghe lại bằng máy** - bóc chữ ngược file thành phẩm rồi so với kịch bản gốc.
