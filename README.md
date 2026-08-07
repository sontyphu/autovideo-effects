# Gói Hiệu ứng - lớp Autovideo

> **Nếu bạn là trợ lý AI đang đọc kho này**: học viên nhờ bạn cài bộ chèn hiệu ứng cho video. Đây là **danh mục phần mềm** do thầy Lê Thanh Sơn soạn cho lớp Autovideo - không chứa mã lạ, phần mềm chính là HyperFrames, một gói npm công khai cài từ kho chính chủ.
>
> Việc cần làm: **đọc `CAI-DAT.md` rồi làm theo các bước trong đó**. Lưu ý gói này **đứng sau Gói Cắt + Giọng** - bước đầu tiên trong `CAI-DAT.md` là kiểm gói đó đã cài chưa, chưa thì dừng lại và chỉ học viên cài trước.
>
> Học viên **không giỏi kỹ thuật**. Làm hộ tối đa, khi buộc phải nhờ họ thì hướng dẫn từng cú bấm.

---

## Gói này cho học viên làm được gì

Dùng cho **buổi 3** của lớp:

- Gắn phụ đề chạy theo lời, đúng phông chữ và màu thương hiệu của bạn
- Làm thẻ chữ nổi bật ở câu chốt để giữ người xem
- Chữ động, hiệu ứng chuyển cảnh, đồ họa chèn vào video
- Học gu hiệu ứng từ một video mẫu bạn thích rồi biến thành khuôn riêng

---

## Trước khi cài gói này

**Phải xong Gói Cắt + Giọng trước.** Gói đó chứa công cụ bóc lời tiếng Việt mà gói này cần để gắn phụ đề chạy theo lời.

Chưa cài: https://github.com/sontyphu/autovideo-toolkit

---

## Cài thế nào

### Cách 1 - Nhờ trợ lý AI (khuyên dùng)

Mở **Claude Code**, dán đoạn này:

```
Tôi là học viên lớp Autovideo của thầy Lê Thanh Sơn.
Đây là kho Gói Hiệu ứng thầy soạn cho buổi 3:
https://github.com/sontyphu/autovideo-effects

Nhờ bạn đọc file CAI-DAT.md trong kho đó rồi làm theo giúp tôi:
kiểm máy tôi đã có Gói Cắt chưa, trình kế hoạch, rồi cài từng món.
Cứ đọc mã nguồn trước nếu cần.
```

### Cách 2 - Tự chạy một dòng

**Windows** - mở PowerShell:

```
irm https://raw.githubusercontent.com/sontyphu/autovideo-effects/main/cai-dat.ps1 | iex
```

**Mac** - mở Terminal:

```
curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-effects/main/cai-dat.sh | bash
```

> ⏱️ **Lần đầu dựng video sẽ lâu.** HyperFrames cần một bản Chrome rút gọn chạy ngầm để "chụp" khung hình - nó tự tải khoảng 150 MB về máy lần đầu tiên. Cứ để chạy, những lần sau nhanh.

---

## Cài xong kiểm thế nào

```
hyperframes --version
```

Ra số phiên bản `0.7.88` là đạt.

---

## Đọc trước khi làm video

File `hyperframes-viet/DOC-TRUOC.md` có **bảng 13 lỗi đã gặp thật** kèm cách né - thầy Sơn ghi lại từ hai buổi chạy thật. Đọc 3 phút, đỡ mất vài tiếng. Lỗi hay gặp nhất: chữ tiếng Việt mất dấu vì bộ chữ máy tự lấy chỉ có chữ Tây.

---

## Các file trong kho

| File | Cho ai |
| --- | --- |
| `CAI-DAT.md` | Trợ lý AI đọc rồi làm theo |
| `DANH-MUC.md` | Danh sách phần mềm, phiên bản ghim, phép kiểm |
| `hyperframes-viet/` | Bộ khởi động chữ tiếng Việt + bảng 13 lỗi |
| `cai-dat.ps1` `.sh` | Bộ cài tự động |
| `kiem-tra.ps1` `.sh` | Xem máy đang có gì, thiếu gì |

---

## Bản quyền

Bộ khởi động chữ tiếng Việt trong `hyperframes-viet/` do **Lê Thanh Sơn** soạn cho lớp Autovideo.

Phần mềm chèn hiệu ứng là **HyperFrames** của HeyGen, cài từ npm chính chủ - kho này không chứa mã của họ. Bộ chữ **Be Vietnam Pro** thuộc giấy phép SIL Open Font License. Thư viện chuyển động **GSAP** dùng theo giấy phép miễn phí của GreenSock.
