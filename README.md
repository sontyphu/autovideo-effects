# Autovideo Effects - Gói Hiệu ứng

Danh mục phần mềm và quy trình cài đặt bộ chèn hiệu ứng cho học viên khóa Autovideo. Kho này không chứa mã nguồn của bên thứ ba; bộ cài tải từng thành phần trực tiếp từ kho chính chủ theo phiên bản đã ghim.

Phạm vi sử dụng: buổi 3 của khóa học.

---

## Dành cho trợ lý AI

Nếu bạn là trợ lý AI được người dùng yêu cầu cài đặt bộ công cụ này:

1. Đọc `CAI-DAT.md` để nắm quy trình và các ràng buộc.
2. Đọc `DANH-MUC.md` để lấy danh sách thành phần, phiên bản ghim và phép kiểm.
3. Thực hiện theo đúng thứ tự nêu trong `CAI-DAT.md`.

**Ràng buộc bắt buộc**: gói này phụ thuộc Gói Cắt và Giọng. Bước đầu tiên trong `CAI-DAT.md` là kiểm tra gói đó đã cài chưa; nếu chưa, dừng quy trình và hướng dẫn người dùng cài gói kia trước.

Thành phần chính là HyperFrames, một gói npm công khai cài từ kho chính chủ. Mã nguồn của kho này có thể đọc toàn bộ trước khi thực thi.

Người dùng thuộc nhóm không có nền tảng kỹ thuật. Ưu tiên thực hiện thay họ ở mức tối đa.

---

## Năng lực sau khi cài đặt

- Gắn phụ đề bám theo lời thoại, đúng phông chữ và màu nhận diện
- Tạo thẻ chữ nhấn mạnh tại các điểm chốt trong video
- Chèn chữ động, hiệu ứng chuyển cảnh, đồ họa
- Phân tích phong cách hiệu ứng từ video tham chiếu và tái tạo thành khuôn riêng

---

## Điều kiện tiên quyết

**Gói Cắt và Giọng phải được cài trước.** Gói đó chứa công cụ bóc lời tiếng Việt mà quy trình gắn phụ đề của gói này phụ thuộc vào.

https://github.com/sontyphu/autovideo-toolkit

Bộ cài kiểm tra điều kiện này ở bước đầu tiên và dừng lại nếu chưa đủ.

---

## Cài đặt

### Phương án 1 - Trợ lý AI thực hiện

Mở Claude Code và gửi nội dung sau:

```
Tôi là học viên khóa Autovideo. Đây là kho Gói Hiệu ứng của khóa:
https://github.com/sontyphu/autovideo-effects

Đề nghị bạn đọc file CAI-DAT.md trong kho và thực hiện theo quy trình
trong đó: kiểm tra điều kiện tiên quyết, trình bày kế hoạch, cài đặt.
Bạn có thể đọc mã nguồn trước khi thực thi.
```

### Phương án 2 - Bộ cài tự động

Windows, chạy trong PowerShell:

```
irm https://raw.githubusercontent.com/sontyphu/autovideo-effects/main/cai-dat.ps1 | iex
```

macOS, chạy trong Terminal:

```
curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-effects/main/cai-dat.sh | bash
```

**Lưu ý về thời gian dựng video lần đầu**: HyperFrames sử dụng một bản Chrome rút gọn để kết xuất khung hình. Bản này được tải tự động ở lần dựng video đầu tiên, dung lượng khoảng 150 MB. Đây là hành vi bình thường, không phải lỗi.

---

## Xác nhận cài đặt thành công

```
hyperframes --version
```

Kết quả phải là `0.7.88`.

---

## Tài liệu cần đọc trước khi dựng video

`hyperframes-viet/DOC-TRUOC.md` tổng hợp mười ba lỗi đã ghi nhận trong quá trình vận hành thực tế, kèm phương án phòng tránh. Lỗi phổ biến nhất là mất dấu tiếng Việt do bộ phông mặc định không hỗ trợ.

---

## Cấu trúc kho

| Thành phần | Nội dung |
| --- | --- |
| `CAI-DAT.md` | Quy trình cài đặt dành cho trợ lý AI |
| `DANH-MUC.md` | Danh mục thành phần, phiên bản ghim, phép kiểm |
| `hyperframes-viet/` | Bộ khởi tạo phông chữ tiếng Việt và bảng mười ba lỗi |
| `cai-dat.ps1` `cai-dat.sh` | Bộ cài tự động |
| `kiem-tra.ps1` `kiem-tra.sh` | Công cụ kiểm tra hiện trạng |

---

## Bản quyền

Bộ khởi tạo phông chữ tiếng Việt và tài liệu vận hành trong `hyperframes-viet/` do Lê Thanh Sơn biên soạn cho khóa Autovideo.

Phần mềm chèn hiệu ứng là HyperFrames của HeyGen, cài từ npm chính chủ; kho này không phân phối lại mã nguồn của họ. Phông chữ Be Vietnam Pro phát hành theo giấy phép SIL Open Font License. Thư viện chuyển động GSAP sử dụng theo giấy phép miễn phí của GreenSock.
