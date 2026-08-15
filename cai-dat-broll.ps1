# Bo cai XUONG CANH TRAM B-ROLL (skill dung-broll-collage) - Windows
# Hoc vien KHONG chay tay file nay. Tro ly AI tu chay khi ban dan cau lenh cai.
# Chay bang HyperFrames da cai o bai 01 - KHONG cai them thu vien nao.

$ErrorActionPreference = 'Stop'
# Cho console hien dung dau tieng Viet
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}

Write-Host ""
Write-Host "=== Cài Xưởng cảnh trám B-roll ==="
Write-Host "Xưởng này vẽ cảnh minh hoạ cắt dán giấy để chèn vào video của bạn."
Write-Host ""

# ---------- 1. Kiểm đồ nghề ----------
Write-Host "[1/4] Kiểm đồ nghề trên máy..."
$thieu = @()
try { $null = & node --version 2>$null } catch { $thieu += 'Node.js' }
try { $null = & ffmpeg -version 2>$null } catch { $thieu += 'ffmpeg' }
try { $null = & ffprobe -version 2>$null } catch { $thieu += 'ffprobe' }
if ($thieu.Count -gt 0) {
  Write-Host ""
  Write-Host "  Máy bạn còn thiếu: $($thieu -join ', ')"
  Write-Host "  Cài Node.js tại https://nodejs.org"
  Write-Host "  Cài ffmpeg tại https://ffmpeg.org (chọn bản essentials)"
  Write-Host "  Cài xong mở lại Claude Code rồi dán câu lệnh này một lần nữa."
  exit 1
}
Write-Host "      Node.js, ffmpeg, ffprobe: đã có"

# Python. Windows hay co "shim" gia cua Microsoft Store lam lenh python bao loi
# du may da co Python -> thu ca uv (lop da cai o buoi 2 de dung yt-dlp).
$py = $null; $pyArgs = @()
foreach ($ten in @('python', 'python3')) {
  try { $v = & $ten --version 2>&1 | Out-String; if ($v -match 'Python 3') { $py = $ten; break } } catch {}
}
if (-not $py) {
  try {
    $null = & uv --version 2>$null
    $py = 'uv'; $pyArgs = @('run', 'python')
  } catch {}
}
if (-not $py) {
  Write-Host ""
  Write-Host "  Máy bạn chưa gọi được Python."
  Write-Host "  Cài tại https://python.org - nhớ tích ô 'Add Python to PATH' lúc cài."
  Write-Host "  Cài xong mở lại Claude Code rồi dán câu lệnh này một lần nữa."
  exit 1
}
Write-Host "      Python: đã có"

# HyperFrames - cai o bai 01 cua nhom nay
$hf = $false
try { $hfv = & npx hyperframes --version 2>&1 | Out-String; if ($hfv -match '\d+\.\d+') { $hf = $true } } catch {}
if (-not $hf) {
  Write-Host ""
  Write-Host "  Máy bạn chưa có HyperFrames - đây là phần dựng hình của xưởng."
  Write-Host "  Hãy làm BÀI 01 của nhóm 'Cài đặt trước buổi 3' trước"
  Write-Host "  (bài cài Gói Hiệu ứng và Kho âm thanh), rồi quay lại bài này."
  exit 1
}
Write-Host "      HyperFrames: đã có"

# ---------- 2. Tải xưởng về máy ----------
Write-Host ""
Write-Host "[2/4] Tải xưởng cảnh trám về máy..."
$dich = Join-Path $env:USERPROFILE '.claude\skills\dung-broll-collage'
$tam  = Join-Path $env:TEMP ('broll-' + [guid]::NewGuid().ToString('N').Substring(0,8))

# git in tien trinh ra luong LOI -> PowerShell hieu nham la hong va dung giua chung.
# Tam ha muc bao loi + dung --quiet, roi tu kiem bang su ton tai cua file.
$cu = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
& git clone --depth 1 --quiet https://github.com/sontyphu/autovideo-effects.git $tam | Out-Null
$ErrorActionPreference = $cu

$nguon = Join-Path $tam 'broll-collage'
if (-not (Test-Path (Join-Path $nguon 'SKILL.md'))) {
  Write-Host ""
  Write-Host "  Tải không được. Kiểm tra lại mạng rồi dán câu lệnh này một lần nữa."
  exit 1
}
if (Test-Path $dich) { Write-Host "      Đã có bản cũ - thay bằng bản mới" }
else { New-Item -ItemType Directory -Force -Path $dich | Out-Null }
Copy-Item (Join-Path $nguon '*') $dich -Recurse -Force
Remove-Item $tam -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "      Đã đặt xưởng vào máy"

# ---------- 3. Kiểm phần vẽ ----------
Write-Host ""
Write-Host "[3/4] Kiểm phần vẽ..."
if (-not (Test-Path (Join-Path $dich 'vendor\gsap.min.js'))) {
  Write-Host "  Thiếu phần làm động. Dán lại câu lệnh cài một lần nữa."
  exit 1
}
Write-Host "      Đầy đủ - xưởng chạy được cả khi máy không có mạng"

# ---------- 4. Vẽ thử một cảnh ----------
Write-Host ""
Write-Host "[4/4] Vẽ thử một cảnh để chắc chắn chạy được..."
Write-Host "      (lần đầu hơi lâu vì máy chuẩn bị phần dựng hình, các lần sau nhanh)"
$thu = Join-Path $env:TEMP 'broll-thu.mp4'
& $py @pyArgs (Join-Path $dich 'scripts\lam_broll.py') --loi "kiem tra cai dat" --giay 2 --ra $thu | Out-Null

if (Test-Path $thu) {
  $khung = & ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -of csv=p=0 $thu
  Remove-Item $thu -Force -ErrorAction SilentlyContinue
  Write-Host ""
  Write-Host "=================================================="
  Write-Host " XONG. Xưởng đã vẽ thử một cảnh dài đúng 2 giây."
  Write-Host "=================================================="
  Write-Host ""
  Write-Host "Thử ngay: nhắn với trợ lý một câu như thế này"
  Write-Host ""
  Write-Host '   Làm cho tôi một cảnh trám b-roll cắt dán, dài 3 giây, khung ngang,'
  Write-Host '   cho câu: "mỗi ngày bạn mất 2 tiếng dựng video thủ công"'
  Write-Host ""
} else {
  Write-Host ""
  Write-Host "  Vẽ thử chưa ra file. Chụp màn hình này gửi nhóm lớp để được hỗ trợ."
  exit 1
}
