# Bo cai XUONG CANH TRAM B-ROLL (skill dung-broll-collage) - Windows
# Hoc vien KHONG chay tay file nay. Tro ly AI tu chay khi ban dan cau lenh cai.
Write-Host ""
Write-Host "=== BO CAI NAY DANG NANG CAP - TAM DUNG ==="
Write-Host "Xuong canh tram dang duoc chuyen sang HyperFrames cho dong bo voi lop."
Write-Host "Cho thong bao moi tren trang hoc roi hay cai. Chua cai gi len may ban."
Write-Host ""
exit 1


$ErrorActionPreference = 'Stop'
Write-Host ""
Write-Host "=== Cai Xuong canh tram B-roll (cat dan giay) ==="
Write-Host ""

# 1. Kiem do nghe nen
$thieu = @()
try { $null = & node --version 2>$null } catch { $thieu += 'Node.js' }
try { $null = & npm --version 2>$null }  catch { $thieu += 'npm' }
try { $null = & ffmpeg -version 2>$null } catch { $thieu += 'ffmpeg' }
try { $null = & ffprobe -version 2>$null } catch { $thieu += 'ffprobe' }
if ($thieu.Count -gt 0) {
  Write-Host "THIEU: $($thieu -join ', ')"
  Write-Host "Node.js (kem npm): https://nodejs.org  |  ffmpeg + ffprobe: https://ffmpeg.org (ban essentials)"
  exit 1
}
Write-Host "Node.js, npm, ffmpeg, ffprobe: DA CO"

# Python: uu tien python cua may, khong co thi dung ban do uv quan ly
$py = $null
foreach ($ten in @('python', 'python3')) {
  try { $v = & $ten --version 2>&1 | Out-String; if ($v -match 'Python 3') { $py = $ten; break } } catch {}
}
if (-not $py) {
  try { $null = & uv --version 2>$null; $py = 'uv-managed' } catch {}
}
if (-not $py) {
  Write-Host "THIEU Python 3. Cai tai https://python.org (nho tick 'Add to PATH') roi chay lai."
  exit 1
}
Write-Host "Python: DA CO"

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
if (-not (Test-Path $dich)) { New-Item -ItemType Directory -Force -Path $dich | Out-Null }
else { Write-Host "Da co ban cu - thay bang ban moi" }
Copy-Item (Join-Path $nguon '*') $dich -Recurse -Force
Remove-Item $tam -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Da dat skill vao: $dich"

# 3. Dung xuong ve hinh (npm install 1 lan, cac lan sau tai dung)
$xuong = 'E:\Video-Projects\_broll-collage-xuong'
if (-not (Test-Path 'E:\')) { $xuong = Join-Path $env:USERPROFILE 'Video-Projects\_broll-collage-xuong' }
Write-Host ""
Write-Host "Dang dung xuong ve hinh tai: $xuong"
Write-Host "(lan dau tai thu vien ve may, cham vai phut - cac lan sau khong phai lam nua)"
New-Item -ItemType Directory -Force -Path $xuong | Out-Null
Copy-Item (Join-Path $dich 'assets\template\*') $xuong -Recurse -Force
Push-Location $xuong
try {
  & npm install --silent 2>&1 | Out-Null
  if ($LASTEXITCODE -ne 0) { Write-Host "npm install loi - chay lai 'npm install' trong $xuong"; exit 1 }
} finally { Pop-Location }
Write-Host "Xuong ve hinh: XONG"

# 4. Chay thu 1 canh that de chung minh cai dung
Write-Host ""
Write-Host "Dang lam thu mot canh tram de kiem..."
$thu = Join-Path $env:TEMP 'broll-thu.mp4'
$sc  = Join-Path $dich 'scripts\lam_broll.py'
$env:BROLL_XUONG = $xuong
if ($py -eq 'uv-managed') { & uv run python $sc --loi "kiem tra cai dat" --giay 2 --ra $thu | Out-Null }
else { & $py $sc --loi "kiem tra cai dat" --giay 2 --ra $thu | Out-Null }

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
