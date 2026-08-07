#!/bin/bash
# Goi Hieu ung - lop Autovideo (Mac)
# Chay bang 1 dong:
#   curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-effects/main/cai-dat.sh | bash

set -u

# Phien ban ghim, kiem chung tren may tac gia 07/08/2026
BAN_HF="0.7.88"
KHO_NAY="https://github.com/sontyphu/autovideo-effects"
SKILL_G1="$HOME/.claude/skills/video-use"
DICH="$HOME/autovideo-effects"

tieu_de() { printf "\n\033[36m=== %s ===\033[0m\n" "$1"; }
dat()     { printf "  \033[32m[DAT]\033[0m %s\n" "$1"; }
thieu()   { printf "  \033[33m[THIEU]\033[0m %s\n" "$1"; }
hong()    { printf "  \033[31m[HONG]\033[0m %s\n" "$1"; }
co_lenh() { command -v "$1" >/dev/null 2>&1; }

printf "\n  AUTOVIDEO EFFECTS - GOI HIEU UNG\n  Le Thanh Son\n\n"

# ------------------------------------------------- 0. Goi truoc
tieu_de "Buoc 0/4 - Kiem dieu kien tien quyet"

if ! co_lenh node; then
  hong "Thieu Node.js - thuoc phan chuan bi truoc khoa hoc"
  echo "  https://sontyphu.github.io/hoc-auto-video/chuan-bi/"
  exit 1
fi
dat "Node.js da co: $(node -v)"

if [ ! -f "$SKILL_G1/helpers/transcript_hyperframes.py" ]; then
  printf "\n"; hong "Chua cai Goi Cat va Giong"
  printf "\n  Goi Hieu ung phu thuoc Goi Cat va Giong, vi phan boc loi\n"
  printf "  tieng Viet nam o goi do. Cai goi do truoc theo lien ket sau:\n\n"
  printf "  \033[36mcurl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.sh | bash\033[0m\n\n"
  exit 1
fi
dat "Goi Cat va Giong da cai"

# ------------------------------------------------- 1. HyperFrames
tieu_de "Buoc 1/4 - Phan mem chen hieu ung"

BAN_DANG_CO=""
co_lenh hyperframes && BAN_DANG_CO="$(hyperframes --version 2>/dev/null)"

if [ "$BAN_DANG_CO" = "$BAN_HF" ]; then
  dat "Da co dung ban ghim: $BAN_HF"
else
  if [ -n "$BAN_DANG_CO" ]; then echo "  Dang co ban $BAN_DANG_CO, se dua ve ban ghim $BAN_HF..."
  else echo "  Dang cai (khoang 2 phut)..."; fi
  if ! npm install -g "hyperframes@$BAN_HF" >/dev/null 2>&1; then
    hong "Cai dat that bai, thuong do thieu quyen quan tri"
    printf "\n  Khac phuc: chay lai voi quyen quan tri:\n"
    printf "  \033[36msudo npm install -g hyperframes@%s\033[0m\n\n" "$BAN_HF"
    exit 1
  fi
  if co_lenh hyperframes && [ "$(hyperframes --version)" = "$BAN_HF" ]; then dat "Da cai ban $BAN_HF"
  else hong "Da cai nhung he thong chua nhan. Dong Terminal, mo lai va chay lai"; exit 1; fi
fi

# ------------------------------------------------- 2. Bo chu tieng Viet
tieu_de "Buoc 2/4 - Bo chu tieng Viet"

if [ -d "$DICH/.git" ]; then
  git -C "$DICH" pull --quiet >/dev/null 2>&1
  dat "Da cap nhat: $DICH"
else
  rm -rf "$DICH"
  if ! git clone --quiet "$KHO_NAY" "$DICH" >/dev/null 2>&1; then
    hong "Tai bo phong chu that bai. Kiem tra ket noi mang"; exit 1
  fi
  dat "Da tai ve: $DICH"
fi

# ------------------------------------------------- 3. Chrome ngam
tieu_de "Buoc 3/4 - Chrome ngam (de dung hinh)"

if [ -d "$HOME/.cache/hyperframes/chrome" ]; then
  dat "Da co san"
else
  thieu "Chua co - may se tu tai ~150 MB o lan dau dung video"
  echo "  Day la hanh vi binh thuong o lan dung video dau tien."
fi

# ------------------------------------------------- 4. Kiem tra
tieu_de "Buoc 4/4 - Kiem tra"

DIEM=0
if co_lenh hyperframes && [ "$(hyperframes --version)" = "$BAN_HF" ]; then dat "Phan mem chen hieu ung ($BAN_HF)"; DIEM=$((DIEM+1)); else thieu "phan mem chen hieu ung"; fi
[ -f "$DICH/hyperframes-viet/fonts/be-vietnam-pro.css" ] && { dat "Bo chu tieng Viet"; DIEM=$((DIEM+1)); } || thieu "bo chu tieng Viet"
[ -f "$DICH/hyperframes-viet/DOC-TRUOC.md" ] && { dat "Bang 13 loi (doc truoc khi lam video)"; DIEM=$((DIEM+1)); } || thieu "bang 13 loi"

printf "\n  %s/3 muc dat\n\n" "$DIEM"
printf "\033[33m  TAI LIEU CAN DOC TRUOC KHI DUNG VIDEO:\033[0m\n"
printf "\033[36m  %s/hyperframes-viet/DOC-TRUOC.md\033[0m\n\n" "$DICH"
