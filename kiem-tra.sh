#!/bin/bash
# Xem may dang co gi, thieu gi - khong cai gi ca
#   curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/kiem-tra.sh | bash

SKILL="$HOME/.claude/skills/video-use"
co_lenh() { command -v "$1" >/dev/null 2>&1; }

dong() { # $1 = dat(1/0)  $2 = ten  $3 = ghi chu
  if [ "$1" = "1" ]; then printf "  \033[32m[x]\033[0m %-32s %s\n" "$2" "$3"
  else printf "  \033[90m[ ] %-32s %s\033[0m\n" "$2" "$3"; fi
}

printf "\n  MAY BAN DANG O DAU - LOP AUTOVIDEO\n\n"

# --- Ve vao lop
VE=0
[ -d "$HOME/.claude" ] && CD=1 || CD=0; VE=$((VE+CD))
co_lenh node && ND=1 || ND=0; VE=$((VE+ND))
co_lenh git  && GT=1 || GT=0; VE=$((VE+GT))
printf "\033[36m  VE VAO LOP  [%s/3]\033[0m\n" "$VE"
dong "$CD" "Claude Desktop" ""
dong "$ND" "Node.js" "$(co_lenh node && node -v || echo 'tai o nodejs.org')"
dong "$GT" "Git" "$(co_lenh git && git --version | sed 's/git version //' || echo 'xcode-select --install')"

# --- Goi Cat + Giong
G2=0
co_lenh ffmpeg && FF=1 || FF=0; G2=$((G2+FF))
co_lenh uv     && UV=1 || UV=0; G2=$((G2+UV))
[ -f "$SKILL/helpers/timeline_view.py" ] && BC=1 || BC=0; G2=$((G2+BC))
[ -f "$SKILL/helpers/tim_tu_dem.py" ]    && VN=1 || VN=0; G2=$((G2+VN))
co_lenh yt-dlp && YT=1 || YT=0; G2=$((G2+YT))
[ -f "$SKILL/.env" ] && EL=1 || EL=0; G2=$((G2+EL))
if [ "$G2" = "6" ]; then T2="San sang buoi 1 va 2"; else T2="Con thieu - xem duoi"; fi
printf "\n\033[36m  GOI CAT + GIONG  [%s/6]  %s\033[0m\n" "$G2" "$T2"
dong "$FF" "FFmpeg" "cat ghep video"
dong "$UV" "uv" "quan kho phan mem nen"
dong "$BC" "Bo cong cu video" "boc loi, nhin hinh"
dong "$VN" "10 cong cu tieng Viet" "tim am u, cat dung cau"
dong "$YT" "yt-dlp" "tai video tu link"
dong "$EL" "Chia khoa ElevenLabs" "boc loi chuan + giong doc"

# --- Goi Hieu ung
G3=0
co_lenh hyperframes && HF=1 || HF=0; G3=$((G3+HF))
[ -d "$HOME/.cache/hyperframes/chrome" ] && CR=1 || CR=0; G3=$((G3+CR))
if [ "$G3" = "2" ]; then T3="San sang buoi 3"; else T3="Cai truoc buoi 3"; fi
printf "\n\033[36m  GOI HIEU UNG  [%s/2]  %s\033[0m\n" "$G3" "$T3"
dong "$HF" "HyperFrames" "chu dong, hieu ung"
dong "$CR" "Chrome ngam" "de dung hinh (~150 MB)"

# --- Viec tiep theo
printf "\n"
if [ "$VE" -lt 3 ]; then
  printf "\033[33m  VIEC TIEP THEO: cai not ve vao lop\033[0m\n"
  printf "\033[36m  https://sontyphu.github.io/hoc-auto-video/chuan-bi/\033[0m\n"
elif [ "$G2" -lt 6 ]; then
  printf "\033[33m  VIEC TIEP THEO: cai Goi Cat + Giong\033[0m\n"
  printf "\033[36m  curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.sh | bash\033[0m\n"
elif [ "$G3" -lt 2 ]; then
  printf "\033[32m  Du cho buoi 1 va 2. Truoc buoi 3 cai Goi Hieu ung:\033[0m\n"
  printf "\033[36m  https://github.com/sontyphu/autovideo-effects\033[0m\n"
else
  printf "\033[32m  DU CA BA GOI - san sang het ca khoa.\033[0m\n"
fi
printf "\n"
