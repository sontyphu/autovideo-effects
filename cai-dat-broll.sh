#!/usr/bin/env bash
# Bo cai XUONG CANH TRAM B-ROLL (skill dung-broll-collage) - Mac / Linux
echo ""
echo "=== BO CAI NAY DANG NANG CAP - TAM DUNG ==="
echo "Xuong canh tram dang duoc chuyen sang HyperFrames cho dong bo voi lop."
echo "Cho thong bao moi tren trang hoc roi hay cai. Chua cai gi len may ban."
echo ""
exit 1

# Hoc vien KHONG chay tay file nay. Tro ly AI tu chay khi ban dan cau lenh cai.
set -e

echo ""
echo "=== Cai Xuong canh tram B-roll (cat dan giay) ==="
echo ""

# 1. Kiem do nghe nen
thieu=()
command -v node >/dev/null 2>&1 || thieu+=("Node.js")
command -v npm  >/dev/null 2>&1 || thieu+=("npm")
command -v ffmpeg  >/dev/null 2>&1 || thieu+=("ffmpeg")
command -v ffprobe >/dev/null 2>&1 || thieu+=("ffprobe")
if [ ${#thieu[@]} -gt 0 ]; then
  echo "THIEU: ${thieu[*]}"
  echo "Cai bang Homebrew: brew install node ffmpeg"
  exit 1
fi
echo "Node.js, npm, ffmpeg, ffprobe: DA CO"

PY=""
for t in python3 python; do
  if command -v "$t" >/dev/null 2>&1 && "$t" -c 'import sys; sys.exit(0 if sys.version_info[0]==3 else 1)' 2>/dev/null; then
    PY="$t"; break
  fi
done
if [ -z "$PY" ]; then
  echo "THIEU Python 3. Cai bang: brew install python"
  exit 1
fi
echo "Python: DA CO"

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

# 3. Dung xuong ve hinh (npm install 1 lan)
XUONG="$HOME/Video-Projects/_broll-collage-xuong"
echo ""
echo "Dang dung xuong ve hinh tai: $XUONG"
echo "(lan dau tai thu vien ve may, cham vai phut - cac lan sau khong phai lam nua)"
mkdir -p "$XUONG"
cp -R "$DICH/assets/template/." "$XUONG/"
( cd "$XUONG" && npm install --silent >/dev/null 2>&1 ) || { echo "npm install loi - chay lai 'npm install' trong $XUONG"; exit 1; }
echo "Xuong ve hinh: XONG"

# 4. Chay thu 1 canh that de chung minh cai dung
echo ""
echo "Dang lam thu mot canh tram de kiem..."
THU="${TMPDIR:-/tmp}/broll-thu.mp4"
export BROLL_XUONG="$XUONG"
"$PY" "$DICH/scripts/lam_broll.py" --loi "kiem tra cai dat" --giay 2 --ra "$THU" >/dev/null

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
