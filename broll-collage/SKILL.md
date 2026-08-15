---
name: dung-broll-collage
description: "CÔNG CỤ SINH CẢNH TRÁM B-ROLL phong cách cắt dán giấy (paper-collage stop-motion) để chèn vào video chính. Nhận câu thoại + độ dài + tỉ lệ khung → trả về file mp4 câm khớp ĐÚNG TỪNG KHUNG HÌNH; skill/agent biên tập tự ghép vào. Chạy 100% bằng Remotion trên máy, 0 đồng mỗi cảnh, KHÔNG gọi API trả phí (Gemini/Veo/OpenAI). Dùng skill này khi: skill hay agent biên tập video cần cảnh trám mà kho cảnh quay không có gì hợp (câu nói trừu tượng: quy trình, tiền bạc, thời gian, AI, sai lầm); hoặc anh Sơn nói 'làm b-roll cho đoạn này', 'trám cảnh vào giây X', 'cần cảnh minh hoạ cho câu này', 'sinh b-roll collage', 'làm cảnh chèn kiểu cắt dán'. Việc nối tiếp: 'đổi màu cảnh trám', 'làm lại dài hơn', 'đổi sang khung ngang' — đều dùng skill này. KHÔNG dùng để: tìm chỗ nào cần b-roll (việc của skill biên tập chính), ghép cảnh vào video (thay-ghep-canh-video / video-use), thay cảnh xấu đã có (thay-ghep-canh-video), dựng CẢ MỘT video tài liệu giấy cắt dán có lời dẫn và phụ đề (lam-video-vox), đắp chữ/hiệu ứng lên talking-head (hieu-ung-video-thuong-hieu), dựng animation thương hiệu (hyperframes)."
---

# Công cụ sinh cảnh trám B-roll cắt dán giấy

## Vai của skill này trong dây chuyền

Đây là **công cụ hậu kỳ nhỏ, được gọi** — không phải skill tự chạy một mình.

```
Skill/agent biên tập chính            dung-broll-collage (skill này)
─────────────────────────            ──────────────────────────────
1. Biên tập, quyết định đoạn
   nào cần b-roll
2. Ra lệnh: câu thoại + độ dài  ───►  3. Sinh cảnh trám đúng độ dài
   + tỉ lệ + fps + tông màu           (tự chọn ẩn dụ + màu theo câu nói)
5. Ghép cảnh vào video chính    ◄───  4. Trả file mp4 + bảng kê
```

**Skill này KHÔNG:** tự xem video để tìm chỗ trám · tự quyết định có nên chèn hay không · tự ghép vào video chính. Ba việc đó thuộc skill biên tập chính, vì chỉ nó nắm ý đồ tổng thể của video.

**Skill này CHỈ:** nhận yêu cầu → trả cảnh trám đạt chuẩn ghép.

## Ba luật cứng (sai là hỏng khi ghép)

1. **Số khung = làm tròn(số giây × fps).** Skill chính cần 3,7 giây thì trả đúng 3,7 giây — không làm tròn lên 4, không mặc định 5 giây. Ghép lệch là hỏng tiếng.
2. **fps phải bằng fps video chính.** Lệch fps thì ghép vào giật. Skill chính không nói fps → hỏi, đừng đoán.
3. **Cảnh trám luôn CÂM.** Tiếng của video chính chạy đè lên. Không bao giờ sinh tiếng.

## Hợp đồng giao nhận

**Skill chính đưa vào** (mỗi cảnh trám một dòng):

| Trường | Bắt buộc | Nghĩa |
|---|---|---|
| `loi` | Có | Câu thoại tại chỗ trám — dùng để chọn ẩn dụ hình + màu |
| `bat_dau` + `ket_thuc` | Một trong hai | Mốc trên video chính (giây) → độ dài = hiệu hai số |
| `giay` | Một trong hai | Hoặc đưa thẳng độ dài |
| `khung` | Không | `9:16` (mặc định) · `16:9` · `1:1` · `4:5` |
| `fps` | Nên có | Mặc định 30 — phải khớp video chính |
| `mau_nen` / `mau_nhan` / `mau_chot` | Không | Ép màu; bỏ trống thì tự chọn theo nghĩa câu nói |
| `canh` | Không | Tên ẩn dụ dựng sẵn (mặc định `quay-cat-xuat-ban`) |
| `ra` | Không | Đường dẫn file ra |

**Skill này trả về** — JSON in ra màn hình, skill chính đọc để ghép:

```json
{"so_canh": 2, "canh": [
  {"stt":1, "file":"...\\broll-01.mp4", "giay":3.2, "so_khung":96,
   "fps":30, "khung":"9:16", "mau_nen":"#1b7d70", "bat_dau":12.4, "ket_thuc":15.6}
]}
```

## Thư viện ẩn dụ hình (5 cảnh)

Đây là thứ quyết định chất lượng: **mỗi câu thoại ra một hình khác nhau**. Không có nó thì chèn 5 chỗ b-roll là 5 lần giống hệt — nhìn phát chán ngay.

| Tên cảnh | Kể chuyện gì | Hợp câu nói về |
|---|---|---|
| `quay-cat-xuat-ban` | máy quay nhả phim → kéo cắt đứt → tay đặt nút play | làm video, quy trình, các bước |
| `thoi-gian-troi` | đồng hồ kim quay loạn → lịch rơi → cát chảy → dấu X | mất thời gian, thủ công, chậm trễ |
| `hon-loan-ngan-nap` | giấy bay lung tung → tủ hồ sơ → giấy xếp vào ngăn → tick | kiến thức rải rác, hệ thống hoá, bộ não thứ 2 |
| `tang-truong` | 4 cột mọc lên → mũi tên leo → đồng xu nảy | doanh thu, tăng gấp đôi, kết quả |
| `may-lam-thay` | 4 bánh răng ăn khớp quay → tay buông ra → nút nguồn | AI, tự động hoá, máy làm thay |

Xem danh sách bằng `--list-canh`. Không ép thì công cụ **tự chọn theo nghĩa câu nói** và **tự tránh lặp cảnh liền trước**.

## Cách gọi

```bash
# Cả loạt — KHUYẾN DÙNG: nhanh hơn và tự tránh trùng cảnh/màu giữa các đoạn
python scripts/lam_broll.py --bang yeucau.json --thu-muc "E:/Video-Projects/<dự-án>/broll" --fps 30

# Một cảnh lẻ
python scripts/lam_broll.py --loi "AI cắt ghép thay bạn" --bat-dau 12.4 --ket-thuc 15.6 \
    --khung 16:9 --fps 30 --ra "E:/Video-Projects/<dự-án>/broll/b1.mp4"

# Duyệt RẺ trước khi render: chỉ ra 1 ảnh tĩnh khung cuối (~13 giây)
python scripts/lam_broll.py --loi "..." --giay 3 --ra out/a.mp4 --xem-truoc

# Xem có những ẩn dụ nào / ép dùng một ẩn dụ cụ thể
python scripts/lam_broll.py --list-canh
python scripts/lam_broll.py --loi "..." --giay 3 --canh tang-truong --ra out/a.mp4

# Bám tông màu video chính (trích khung tại mốc lấy màu)
python scripts/lam_broll.py --bang yeucau.json --thu-muc out --tu-video "video-chinh.mp4"
```

## Tự bảo vệ (khỏi phải nhớ)

1. **Tự đồng bộ khuôn.** Sửa khuôn trong skill xong không cần nhớ lệnh gì — công cụ so vân tay, khác là tự chép sang xưởng. *(Trước đây phải gọi `--dong-bo`; quên là render bằng khuôn cũ mà không báo lỗi.)*
2. **Tự kiểm mọi file** bằng ffprobe ngay sau render: đúng số khung chưa · đúng fps chưa · đúng kích thước chưa · có lẫn tiếng không. Lệch thì ghi vào `canh_bao`, đặt `dat_chuan: false`, và **thoát với mã lỗi 2** — skill chính biết mà không ghép bừa vào video.
3. **Tự gỡ luồng tiếng.** Remotion hay nhét luồng tiếng rỗng vào mp4; công cụ tự gỡ (chép luồng hình, không mã hoá lại).
4. **Báo lỗi rõ**: thiếu Node/npm, tên cảnh sai, thiếu độ dài — đều nói thẳng phải làm gì, không để chết lặng.

## Thêm ẩn dụ mới (3 bước)

1. Tạo `src/canh/<TenCanh>.tsx` — import chất liệu từ `../chatlieu` (`Piece`, `TamGiay`, `BanTay`, `usePop`, `HatNhan`, `Sao`), **đừng chép lại**.
2. Đăng ký vào `DS_CANH` trong `src/Collage.tsx`.
3. Thêm một dòng từ khoá vào `BANG_CANH` trong `scripts/lam_broll.py`.

Mỗi cảnh nhận `{ wide, square }` và tự xếp lại bố cục theo hướng khung.

File `yeucau.json`:
```json
[
  {"loi": "mỗi ngày bạn mất 2 tiếng dựng video thủ công", "bat_dau": 12.4, "ket_thuc": 15.6},
  {"loi": "AI làm thay bạn trong 5 phút", "giay": 3.5, "mau_nen": "#b3402e"}
]
```

**Xưởng dùng chung:** lần đầu chạy tự dựng `E:\Video-Projects\_broll-collage-xuong` và `npm install` (chỉ chậm lần này), các lần sau tái dùng. Sửa khuôn trong skill xong thì thêm `--dong-bo` để đẩy bản mới sang xưởng.

## Khi nào NÊN dùng cảnh trám collage

Skill chính cân nhắc trước khi gọi — collage hợp với **câu nói trừu tượng, không quay được**:

| Hợp | Không hợp |
|---|---|
| quy trình, hệ thống, các bước | cảnh có thật (sản phẩm, lớp học, khách hàng) |
| tiền bạc, thời gian, hiệu suất | mặt người, lời chứng |
| sai lầm, cảnh báo, rủi ro | thao tác màn hình (nên quay màn hình thật) |
| AI, tự động hoá, tương lai | địa điểm cụ thể |

Có cảnh quay thật hợp thì **luôn ưu tiên cảnh thật**. Collage là phương án khi kho cảnh bí.

## Màu tự chọn theo nghĩa câu nói

Skill chính không ép màu thì công cụ tự chọn, và **tự tránh trùng màu với cảnh liền trước** (chèn 5 cảnh cùng tông teal là rối mắt):

| Nghĩa câu nói | Nền |
|---|---|
| quy trình, hệ thống, dựng video | teal `#1b7d70` |
| sai lầm, cảnh báo, mất mát | đỏ gạch `#b3402e` |
| tiền, doanh thu, khách hàng, bán | mustard `#c9962e` |
| AI, công nghệ, tự động, tương lai | tím than `#3b3560` |

## Luật phong cách (giữ chất collage)

1. **3–6 vật chính**, mỗi vật một vai trong mạch — không nhồi.
2. **Ghép từ khung trống**: mảnh trượt/rơi/bật vào bằng lò xo. Không fade, không zoom trôi.
3. **Nhịp stop-motion**: thời gian lượng hoá 15fps + rung tay từng mảnh — có sẵn trong khuôn (`useQFrame`, `jit`), đừng gỡ.
4. **Mọi mảnh là giấy**: bóng đổ mềm, mép rách (`torn`), vật "ảnh" dùng pattern `halftone`.
5. **Kể một mạch**: mặc định *máy quay → phim chảy ra → kéo cắt đứt → tay đặt nút play* (= quay → dựng → xuất bản).
6. **Không chữ, không logo** trong hình — chữ là việc của skill chính (phụ đề đặt sau cùng).
7. **Cuối cảnh vẫn động nhẹ**: bob, lấp lánh, đèn REC nháy. Không đứng hình chết.

## Bố cục thích ứng theo khung (đã trả giá)

Hình gốc vẽ trên hệ toạ độ dọc 1080×1920. **Không được cắt xén** để ra khung ngang — cắt là mất máy quay và nút play (đã dính lỗi này khi làm). Khuôn xếp lại các cụm theo hướng khung:

- **Dọc 9:16** — máy quay trên, phim chảy xuống, dải phim + kéo dưới.
- **Ngang 16:9** — máy quay trái, **phim chảy sóng ngang sang phải** (bộ đường cong riêng `SEG*_W`), dải phim + kéo giữa phải, nút play dưới phải.
- **Vuông 1:1** — thu gọn cụm chính, dồn vào giữa.

Sửa bố cục ở biến `L` trong `Collage.tsx`.

## Tự kiểm trước khi trả kết quả

Bốn mục đầu **công cụ tự làm** rồi (xem `dat_chuan_het` trong bảng kê); ba mục cuối cần mắt người:

```
[x] Số khung = làm tròn(giây × fps) — máy đo bằng ffprobe
[x] fps + kích thước khung đúng yêu cầu — máy đo
[x] File câm, không luồng tiếng — máy đo và tự gỡ
[x] Khuôn mới nhất đã sang xưởng — máy so vân tay
[ ] Đã xem khung QA: không mảnh nào cắt cụt / đè lên vật chính
[ ] Nhiều cảnh một loạt: ẩn dụ và màu không lặp nhau liên tiếp
[ ] Ẩn dụ hợp nghĩa câu thoại (máy đoán theo từ khoá, người soi lại)
```

## Nâng cấp khi có ngân sách ảnh AI

Muốn chất "ảnh chụp thật cắt dán" như tool gốc `gbro-collage-broll`: dùng `tao-anh-ai` (OpenAI) sinh từng vật PNG **nền trong suốt, halftone đen trắng**, rồi thay `<image>` vào chỗ mảnh vector — chuyển động giữ nguyên. Chỉ làm khi key còn credit.

## Đừng lẫn với `lam-video-vox`

Hai skill cùng phong cách giấy cắt dán nhưng **khác hẳn vai**:

| | `dung-broll-collage` (skill này) | `lam-video-vox` |
|---|---|---|
| Ra cái gì | **một mẩu cảnh câm** vài giây, để chèn vào video khác | **cả một video hoàn chỉnh** có lời dẫn, nhạc, phụ đề |
| Ai dùng | skill biên tập gọi nó | anh Sơn gọi trực tiếp |
| Có tiếng | không bao giờ | có giọng đọc |

Cần một mẩu để trám vào chỗ trống → skill này. Cần cả một phóng sự → `lam-video-vox`.

## Gốc gác

Học cơ chế từ tool mã mở `gbro-collage-broll` (pyang5166) — nhưng tool gốc trả tiền Gemini Omni Flash mỗi clip và chỉ đẻ clip lẻ 5 giây. Bản này thay engine bằng Remotion (0 đồng, độ dài tuỳ ý, khớp từng khung) và đặt đúng vai công cụ trong dây chuyền biên tập. Chốt 15/08/2026.
