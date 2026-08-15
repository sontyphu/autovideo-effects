#!/usr/bin/env bash
# Bo cai XUONG CANH TRAM B-ROLL (skill dung-broll-collage) - Mac / Linux
# Hoc vien KHONG chay tay file nay. Tro ly AI tu chay khi ban dan cau lenh cai.
# Chay bang HyperFrames da cai o bai 01 - KHONG cai them thu vien nao.
set -e

echo ""
echo "=== Cài Xưởng cảnh trám B-roll ==="
echo "Xưởng này vẽ cảnh minh hoạ cắt dán giấy để chèn vào video của bạn."
echo ""

# ---------- 1. Kiểm đồ nghề ----------
echo "[1/4] Kiểm đồ nghề trên máy..."
thieu=()
command -v node    >/dev/null 2>&1 || thieu+=("Node.js")
command -v ffmpeg  >/dev/null 2>&1 || thieu+=("ffmpeg")
command -v ffprobe >/dev/null 2>&1 || thieu+=("ffprobe")
if [ ${#thieu[@]} -gt 0 ]; then
  echo ""
  echo "  Máy bạn còn thiếu: ${thieu[*]}"
  echo "  Cài bằng lệnh: brew install node ffmpeg"
  echo "  Cài xong mở lại Claude Code rồi dán câu lệnh này một lần nữa."
  exit 1
fi
echo "      Node.js, ffmpeg, ffprobe: đã có"

PY=""; PY_ARGS=""
for t in python3 python; do
  if command -v "$t" >/dev/null 2>&1 && "$t" -c 'import sys; sys.exit(0 if sys.version_info[0]==3 else 1)' 2>/dev/null; then
    PY="$t"; break
  fi
done
if [ -z "$PY" ] && command -v uv >/dev/null 2>&1; then
  PY="uv"; PY_ARGS="run python"
fi
if [ -z "$PY" ]; then
  echo ""
  echo "  Máy bạn chưa gọi được Python."
  echo "  Cài bằng lệnh: brew install python"
  echo "  Cài xong mở lại Claude Code rồi dán câu lệnh này một lần nữa."
  exit 1
fi
echo "      Python: đã có"

if ! npx hyperframes --version >/dev/null 2>&1; then
  echo ""
  echo "  Máy bạn chưa có HyperFrames - đây là phần dựng hình của xưởng."
  echo "  Hãy làm BÀI 01 của nhóm 'Cài đặt trước buổi 3' trước"
  echo "  (bài cài Gói Hiệu ứng và Kho âm thanh), rồi quay lại bài này."
  exit 1
fi
echo "      HyperFrames: đã có"

# ---------- 2. Tải xưởng về máy ----------
echo ""
echo "[2/4] Tải xưởng cảnh trám về máy..."
DICH="$HOME/.claude/skills/dung-broll-collage"
TAM="$(mktemp -d)"
git clone --depth 1 --quiet https://github.com/sontyphu/autovideo-effects.git "$TAM" >/dev/null 2>&1 || true
NGUON="$TAM/broll-collage"
if [ ! -f "$NGUON/SKILL.md" ]; then
  echo ""
  echo "  Tải không được. Kiểm tra lại mạng rồi dán câu lệnh này một lần nữa."
  exit 1
fi
[ -d "$DICH" ] && echo "      Đã có bản cũ - thay bằng bản mới"
mkdir -p "$DICH"
cp -R "$NGUON/." "$DICH/"
rm -rf "$TAM"
echo "      Đã đặt xưởng vào máy"

# ---------- 3. Kiểm phần vẽ ----------
echo ""
echo "[3/4] Kiểm phần vẽ..."
if [ ! -f "$DICH/vendor/gsap.min.js" ]; then
  echo "  Thiếu phần làm động. Dán lại câu lệnh cài một lần nữa."
  exit 1
fi
echo "      Đầy đủ - xưởng chạy được cả khi máy không có mạng"

# ---------- 4. Vẽ thử một cảnh ----------
echo ""
echo "[4/4] Vẽ thử một cảnh để chắc chắn chạy được..."
echo "      (lần đầu hơi lâu vì máy chuẩn bị phần dựng hình, các lần sau nhanh)"
THU="${TMPDIR:-/tmp}/broll-thu.mp4"
"$PY" $PY_ARGS "$DICH/scripts/lam_broll.py" --loi "kiem tra cai dat" --giay 2 --ra "$THU" >/dev/null

if [ -f "$THU" ]; then
  rm -f "$THU"
  echo ""
  echo "=================================================="
  echo " XONG. Xưởng đã vẽ thử một cảnh dài đúng 2 giây."
  echo "=================================================="
  echo ""
  echo "Thử ngay: nhắn với trợ lý một câu như thế này"
  echo ""
  echo '   Làm cho tôi một cảnh trám b-roll cắt dán, dài 3 giây, khung ngang,'
  echo '   cho câu: "mỗi ngày bạn mất 2 tiếng dựng video thủ công"'
  echo ""
else
  echo ""
  echo "  Vẽ thử chưa ra file. Chụp màn hình này gửi nhóm lớp để được hỗ trợ."
  exit 1
fi
