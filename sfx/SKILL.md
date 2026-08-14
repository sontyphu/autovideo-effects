---
name: kho-am-thanh
description: Kho 63 hiệu ứng âm thanh đã lọc cho video doanh nhân/đào tạo, kèm luật chọn tiếng theo tông và liều lượng. Dùng bất cứ khi nào cần gắn/thêm hiệu ứng âm thanh (sound effect, SFX) vào video đang dựng - chuyển cảnh, chữ hiện, thẻ từ khóa, cảnh phụ vào, câu chốt, nói về tiền, cảnh báo rủi ro. Kể cả khi người dùng chỉ nói "thêm tiếng động cho video", "cho hiệu ứng âm thanh vào", "video nghe trống quá" - dùng skill này. KHÔNG dùng để chọn nhạc nền (kho này không chứa nhạc nền) hay tạo giọng đọc.
---

# Kho âm thanh - gắn hiệu ứng có kỷ luật

File tiếng nằm ngay trong thư mục skill này, tên theo chuẩn `nhóm_mô-tả[-độ-dài]` - chọn bằng cách ĐỌC TÊN, không cần nghe.

## Quy trình 5 bước (làm đúng thứ tự)

**Bước 1 - Bắt TÔNG video trước.** Đọc kịch bản/transcript, xác định tông (truyền cảm hứng / vui / nghiêm túc / cảnh báo / bán hàng) rồi CHỈ chọn tiếng cùng tông - bảng tông và tiếng phải tránh ở `00-CACH-DUNG.md` mục 0. Video vui không tiếng buồn, video xúc động không tiếng giỡn.

**Bước 2 - Chỉ chọn điểm ĐẶC BIỆT QUAN TRỌNG.** Tiếng chỉ đi kèm sự kiện thị giác (chuyển cảnh, chữ/thẻ hiện, cảnh phụ vào) - nhưng sự kiện thị giác là điều kiện cần chưa phải đủ: chỉ gắn ở mở chủ đề, khúc quặt, câu chốt. Chuỗi sự kiện lặp cùng loại chỉ gắn cái ĐẦU TIÊN. Video ~30 giây: 3-4 tiếng. Video 1-2 phút: tối đa 5-7. Video màn hình tĩnh chỉ có lời nói: KHÔNG gắn gì.

**Bước 3 - Tra bảng chọn tiếng cụ thể.** Mở `00-DANH-MUC.md`: bảng 63 dòng, mỗi tiếng ghi rõ độ dài + đặt vào đoạn nào + dòng nào là MẶC ĐỊNH. Mỗi video chỉ 1 kiểu whoosh + 1 kiểu ding + 1 kiểu pop, lặp có chủ đích.

**Bước 4 - Gắn đúng kỹ thuật.**
- Dò lặng đầu file tiếng bằng `ffmpeg -af silencedetect` rồi cắt (`atrim`) - nhiều file lặng 0,1-0,4s đầu, không cắt là tiếng lệch khỏi sự kiện.
- Đặt tiếng vào khe lặng giữa các câu (theo mốc transcript), không đè lời nói.
- Âm lượng: tiếng gõ/vụt `volume=0.4-0.5`; tiếng vào êm dần (lung-linh, riser) phải 0.6-0.7 mới nổi; luôn thấp hơn lời thoại rõ rệt.
- Trộn bằng `adelay` + `amix=normalize=0`; video sắp hết mà tiếng còn ngân thì thêm `afade=t=out`.

**Bước 5 - Đo bằng chứng.** Sau khi render, đo `volumedetect` 0.3-0.5s tại TỪNG mốc, so bản trước/sau: mốc nào không tăng dB là tiếng chưa vào thật - sửa rồi đo lại. Không nghiệm thu bằng cảm giác.

## Cấm

- Không dùng file ngoài kho này khi chưa rõ giấy phép; kho chỉ nhận thêm nguồn miễn phí thương mại không cần ghi công (Pixabay, Mixkit) + đặt tên đúng chuẩn + thêm dòng vào `00-DANH-MUC.md`.
- Không gắn tiếng để "cho có" - tiếng nào không trả lời được "giúp người xem chú ý vào cái gì?" thì bỏ.
