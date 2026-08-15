#!/usr/bin/env bash
# Bo cai XUONG CANH TRAM B-ROLL (skill dung-broll-collage) - Mac / Linux
# Hoc vien KHONG chay tay file nay. Tro ly AI tu chay khi ban dan cau lenh cai.
# Chay bang HyperFrames da cai o buoi 3 - KHONG cai them thu vien nao.
set -e

echo ""
echo "=== Cai Xuong canh tram B-roll (cat dan giay) ==="
echo ""

# 1. Kiem do nghe nen
thieu=()
command -v node    >/dev/null 2>&1 || thieu+=("Node.js")
command -v ffmpeg  >/dev/null 2>&1 || thieu+=("ffmpeg")
command -v ffprobe >/dev/null 2>&1 || thieu+=("ffprobe")
if [ ${#thieu[@]} -gt 0 ]; then
  echo "THIEU: ${thieu[*]}"
  echo "Cai bang Homebrew: brew install node ffmpeg"
  exit 1
fi
echo "Node.js, ffmpeg, ffprobe: DA CO"

PY=""; PY_ARGS=""
for t in python3 python; do
  if command -v "$t" >/dev/null 2>&1 && "$t" -c 'import sys; sys.exit(0 if sys.version_info[0]==3 else 1)' 2>/dev/null; then
    PY="$t"; break
  fi
done
if [ -z "$PY" ] && command -v uv >/dev/null 2>&1; then
  PY="uv"; PY_ARGS="run python"
  echo "Khong goi duoc python truc tiep - dung Python cua uv"
fi
if [ -z "$PY" ]; then
  echo "THIEU Python 3. Cai bang: brew install python"
  exit 1
fi
echo "Python 3: DA CO"

if ! npx hyperframes --version >/dev/null 2>&1; then
  echo "THIEU HyperFrames. Hay lam bai 01 cua nhom 'Cai dat truoc buoi 3' truoc"
  echo "(bo hieu ung + kho am thanh), roi quay lai cai xuong canh tram."
  exit 1
fi
echo "HyperFrames: DA CO"

# 2. Dat skill vao dung cho de tro ly tu nhan
DICH="$HOME/.claude/skills/dung-broll-collage"
TAM="$(mktemp -d)"
echo "Dang tai xuong canh tram..."
git clone --depth 1 https://github.com/sontyphu/autovideo-effects.git "$TAM" >/dev/null 2>&1
NGUON="$TAM/broll-collage"
if [ ! -f "$NGUON/SKILL.md" ]; then
  echo "Tai khong duoc. Kiem tra mang roi thu lai."
  exit 1
fi
[ -d "$DICH" ] && echo "Da co ban cu - thay bang ban moi"
mkdir -p "$DICH"
cp -R "$NGUON/." "$DICH/"
rm -rf "$TAM"
echo "Da dat skill vao: $DICH"

# 3. Lam thu mot canh that de chung minh cai dung
echo ""
echo "Dang lam thu mot canh tram de kiem (lan dau Chrome ngam co the tai them, hoi lau)..."
THU="${TMPDIR:-/tmp}/broll-thu.mp4"
"$PY" $PY_ARGS "$DICH/scripts/lam_broll.py" --loi "kiem tra cai dat" --giay 2 --ra "$THU" >/dev/null

if [ -f "$THU" ]; then
  KHUNG=$(ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -of csv=p=0 "$THU")
  echo ""
  echo "DAT - da lam duoc canh tram thu nghiem ($KHUNG khung hinh, dung 2 giay)."
  rm -f "$THU"
else
  echo "CHUA DAT - khong ra file. Chup man hinh gui nhom lop."
  exit 1
fi

echo ""
echo "=== XONG. Tu nay chi can noi voi tro ly: 'lam b-roll cat dan cho cau nay' ==="
