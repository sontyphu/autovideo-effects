#!/usr/bin/env bash
# Bo cai KHO KIEU CHU PHU DE - Mac va Linux
# Hoc vien KHONG chay tay file nay. Tro ly AI tu chay khi ban dan cau lenh cai.
set -e
echo ""
echo "=== Cai Kho kieu chu phu de ==="
echo ""

thieu=""
command -v node   >/dev/null 2>&1 || thieu="$thieu Node.js"
command -v ffmpeg >/dev/null 2>&1 || thieu="$thieu ffmpeg"
if [ -n "$thieu" ]; then
  echo "THIEU:$thieu"
  echo "Mac: brew install node ffmpeg   |   Linux: sudo apt install nodejs ffmpeg"
  exit 1
fi
if ! ffmpeg -version 2>&1 | grep -q libass; then
  echo "CANH BAO: ffmpeg tren may KHONG co libass - se khong nuong duoc phu de."
  echo "Mac: brew reinstall ffmpeg   |   Linux: cai ban ffmpeg day du"
  exit 1
fi
echo "Node.js va ffmpeg (co libass): DA CO"

dich="$HOME/.claude/skills/tao-kieu-chu-caption"
tam="$(mktemp -d)"

echo "Dang tai bo cong cu..."
git clone --depth 1 https://github.com/sontyphu/autovideo-effects.git "$tam/kho" >/dev/null 2>&1
nguon="$tam/kho/kieu-chu-caption"
if [ ! -f "$nguon/SKILL.md" ]; then
  echo "Tai khong duoc. Kiem tra mang roi thu lai."
  exit 1
fi

# Kieu chu nguoi dung tu tao nam o ~/.kho-kieu-chu, ngoai skill -> cap nhat khong dung toi
if [ -d "$dich" ]; then echo "Da co ban cu - chi thay phan may moc, giu nguyen kieu chu ban tu tao"; fi
mkdir -p "$dich"
rm -rf "$dich/scripts"
cp -R "$nguon/." "$dich/"
rm -rf "$tam"

echo ""
echo "Dang chay bai tu kiem (dung that tung kieu chu roi do bang may)..."
cd "$dich" && node scripts/tu-kiem.mjs
