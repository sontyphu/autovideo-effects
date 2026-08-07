# Đọc trước khi làm video bằng HyperFrames

> 13 lỗi đã gặp thật ngày 01-02/08/2026, kèm cách né. Đọc 3 phút, đỡ mất vài tiếng.
> Nguồn: hai buổi chạy thật - viết tay và chạy qua quy trình dựng sẵn.

## Làm gì đầu tiên

```powershell
.\vao-viec.ps1 -DuAn "đường\dẫn\dự-án-mới" -KemKhuonMau
```

Lệnh này chép sẵn bộ chữ tiếng Việt và thư viện chuyển động vào dự án, né luôn 3 lỗi đầu bảng.

---

## Bảng 13 lỗi

### Nhóm 1 - Chữ tiếng Việt và mạng (lỗi 1-3, 8)

| # | Hiện tượng | Vì sao | Cách né |
|---|---|---|---|
| **1** | Chữ mất dấu: "vẫn nằm im" ra "vân năm im" | Bộ chữ máy tự lấy chỉ có chữ Tây, không có phần dấu tiếng Việt | Chạy `vao-viec.ps1`. Trong CSS ghi `font-family: "Be Vietnam Pro", Roboto, sans-serif` |
| **2** | Báo "Navigation timeout of 10000 ms exceeded", không dựng được | Trang chờ tải chữ từ mạng, máy chỉ chờ 10 giây | **Không** dán `<link>` tới `fonts.googleapis.com`. Dùng file chữ trong `assets/fonts` |
| **3** | Cũng quá hạn như trên, dù đã sửa chữ | Thư viện chuyển động cũng lấy từ mạng | Dùng `./assets/js/gsap.min.js`, không dùng địa chỉ `cdn.jsdelivr.net` |
| **8** | Khối tải từ kho về lại vấp lỗi 2 | Khối dựng sẵn của hãng vẫn dùng chữ từ mạng | Sau khi `hyperframes add ...`, mở file khối ra, xóa `<link>` Google Fonts, trỏ về `assets/fonts` |

### Nhóm 2 - Tiếng và giọng đọc (lỗi 4-5, 10)

| # | Hiện tượng | Vì sao | Cách né |
|---|---|---|---|
| **4** | **Video ra CÂM hoàn toàn** | Thẻ `<audio>` thiếu `id`, máy không thấy để trộn tiếng | Mỗi thẻ tiếng phải có `id` riêng: `<audio id="giong-doc" ...>` |
| **5** | Hai đường tiếng chồng nhau, méo | Hai thẻ tiếng đặt cùng một số lớp | Mỗi đường một `data-track-index` khác nhau |
| **10** | Bóc chữ báo `whisper_unavailable`, tắc ở bước 4 | Quy trình gốc gọi Whisper mà máy không có; model gốc lại là model **tiếng Anh** | Dùng `helpers/transcript_hyperframes.py` trong bộ này - nó bóc bằng ElevenLabs Scribe (chuẩn tiếng Việt) rồi xuất đúng định dạng bộ chèn đồ họa cần |

### Nhóm 3 - Nhân bản hàng loạt (lỗi 6-7)

| # | Hiện tượng | Vì sao | Cách né |
|---|---|---|---|
| **6** | "Batch output collision - Rows 0 and 1 both resolve to..." | Tên file ra giống nhau ở mọi dòng dữ liệu | Tên file phải có chỗ thay đổi: `-o "renders/chuong-{so_chuong}.mp4"` |
| **7** | Máy báo "Not a directory: ...\riêng" | Chữ tiếng Việt có dấu cách gõ thẳng vào lệnh bị vỡ chuỗi trên PowerShell | Để dữ liệu trong file `.json` rồi dùng `--variables-file bien.json` |
| **13** | Báo `Unexpected token '﻿', "﻿{"so_chuo"... is not valid JSON` | PowerShell `Set-Content -Encoding utf8` **chèn 3 ký tự ẩn ở đầu file** (gọi là BOM), máy đọc JSON không hiểu | Ghi file JSON bằng: `[System.IO.File]::WriteAllText($duong_dan, $noi_dung, (New-Object System.Text.UTF8Encoding $false))` |

### Nhóm 4 - Máy móc (lỗi 11-12)

| # | Hiện tượng | Vì sao | Cách né |
|---|---|---|---|
| **11** | Báo không nhận lệnh `python` | Python trên máy là bản rỗng của Windows Store | Dùng Python xách tay: `~\.claude\skillsutovideo-toolkit.venv\Scripts\python.exe` |
| **12** | Dựng giữa chừng báo hết chỗ trống | Ổ C đầy, chỗ chứa ảnh tạm nằm ở ổ C | Đặt biến `HYPERFRAMES_EXTRACT_CACHE_DIR` trỏ sang ổ khác |

### Nhóm 5 - Lỗi máy KHÔNG bắt được (lỗi 9)

| # | Hiện tượng | Vì sao | Cách né |
|---|---|---|---|
| **9** | Chữ to bị **cụt hai đầu** mà lệnh kiểm vẫn báo sạch | Lệnh kiểm không bắt được chữ tràn ngang | **Bắt buộc trích khung hình ra xem thật** trước khi giao. Lệnh kiểm không thay được mắt người |

---

## Ba việc bắt buộc trước khi giao video

1. **Chạy `npm run check`** - phải sạch lỗi. Nó bắt được: video câm tiếng, thẻ đè nhau, chữ khó đọc, chuyển động hỏng
2. **Trích ít nhất 4 khung hình ra xem thật** - vì lỗi 9
3. **Nếu có giọng đọc: nghe lại bằng máy** (bóc chữ ngược file thành phẩm, so với kịch bản gốc). Xem danh sách từ máy hay đọc sai trong trí nhớ về ElevenLabs

## Ba con số thật đo trên máy anh Sơn

| Việc | Thời gian |
|---|---|
| Video 30 giây, khung dọc 1080x1920 | 7 phút |
| Video 6 giây | 1 phút 10 |
| Cả quy trình dựng sẵn đầu-cuối cho video 20 giây | khoảng 15 phút |

Máy: card GT 1030. Máy khỏe hơn sẽ nhanh hơn.

## Cảnh báo: đừng để công cụ tự cập nhật

Một số bộ chèn đồ họa có dòng lệnh **tự cập nhật im lặng** ở đầu file hướng dẫn.
Chạy nó là **mọi chỉnh sửa tiếng Việt bạn vá vào sẽ bị ghi đè sạch** - đã gặp thật
ngày 02/08/2026, vá xong dùng một lần là mất.

Cách né: sau khi cài, mở file hướng dẫn của bộ đó ra, **xóa dòng lệnh tự cập nhật**.
Muốn lên bản mới thì cập nhật có chủ đích rồi vá lại, đừng để nó tự đổi dưới chân.
