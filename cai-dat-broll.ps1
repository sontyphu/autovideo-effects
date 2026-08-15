# Bo cai XUONG CANH TRAM B-ROLL (skill dung-broll-collage) - Windows
# Hoc vien KHONG chay tay file nay. Tro ly AI tu chay khi ban dan cau lenh cai.
# Chay bang HyperFrames da cai o buoi 3 - KHONG cai them thu vien nao.

$ErrorActionPreference = 'Stop'
Write-Host ""
Write-Host "=== Cai Xuong canh tram B-roll (cat dan giay) ==="
Write-Host ""

# 1. Kiem do nghe nen (deu da co tu cac buoi truoc)
$thieu = @()
try { $null = & node --version 2>$null } catch { $thieu += 'Node.js' }
try { $null = & ffmpeg -version 2>$null } catch { $thieu += 'ffmpeg' }
try { $null = & ffprobe -version 2>$null } catch { $thieu += 'ffprobe' }
if ($thieu.Count -gt 0) {
  Write-Host "THIEU: $($thieu -join ', ')"
  Write-Host "Node.js: https://nodejs.org  |  ffmpeg + ffprobe: https://ffmpeg.org (ban essentials)"
  exit 1
}
Write-Host "Node.js, ffmpeg, ffprobe: DA CO"

# Python (de chay cong cu)
$py = $null
foreach ($ten in @('python', 'python3')) {
  try { $v = & $ten --version 2>&1 | Out-String; if ($v -match 'Python 3') { $py = $ten; break } } catch {}
}
if (-not $py) {
  Write-Host "THIEU Python 3. Cai tai https://python.org (nho tick 'Add to PATH') roi chay lai."
  exit 1
}
Write-Host "Python 3: DA CO"

# HyperFrames - da cai o bai 01 buoi 3
$hf = $false
try { $hfv = & npx hyperframes --version 2>&1 | Out-String; if ($hfv -match '\d+\.\d+') { $hf = $true } } catch {}
if (-not $hf) {
  Write-Host "THIEU HyperFrames. Hay lam bai 01 cua nhom 'Cai dat truoc buoi 3' truoc"
  Write-Host "(bo hieu ung + kho am thanh), roi quay lai cai xuong canh tram."
  exit 1
}
Write-Host "HyperFrames: DA CO"

# 2. Dat skill vao dung cho de tro ly tu nhan
$dich = Join-Path $env:USERPROFILE '.claude\skills\dung-broll-collage'
$tam  = Join-Path $env:TEMP ('broll-' + [guid]::NewGuid().ToString('N').Substring(0,8))

Write-Host "Dang tai xuong canh tram..."
& git clone --depth 1 https://github.com/sontyphu/autovideo-effects.git $tam 2>&1 | Out-Null
$nguon = Join-Path $tam 'broll-collage'
if (-not (Test-Path (Join-Path $nguon 'SKILL.md'))) {
  Write-Host "Tai khong duoc. Kiem tra mang roi thu lai."
  exit 1
}
if (Test-Path $dich) { Write-Host "Da co ban cu - thay bang ban moi" }
else { New-Item -ItemType Directory -Force -Path $dich | Out-Null }
Copy-Item (Join-Path $nguon '*') $dich -Recurse -Force
Remove-Item $tam -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Da dat skill vao: $dich"

# 3. Lam thu mot canh that de chung minh cai dung
Write-Host ""
Write-Host "Dang lam thu mot canh tram de kiem (lan dau Chrome ngam co the tai them, hoi lau)..."
$thu = Join-Path $env:TEMP 'broll-thu.mp4'
& $py (Join-Path $dich 'scripts\lam_broll.py') --loi "kiem tra cai dat" --giay 2 --ra $thu | Out-Null

if (Test-Path $thu) {
  $khung = & ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -of csv=p=0 $thu
  Write-Host ""
  Write-Host "DAT - da lam duoc canh tram thu nghiem ($khung khung hinh, dung 2 giay)."
  Remove-Item $thu -Force -ErrorAction SilentlyContinue
} else {
  Write-Host "CHUA DAT - khong ra file. Chup man hinh gui nhom lop."
  exit 1
}

Write-Host ""
Write-Host "=== XONG. Tu nay chi can noi voi tro ly: 'lam b-roll cat dan cho cau nay' ==="
