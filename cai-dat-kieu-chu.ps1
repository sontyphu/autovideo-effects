# Bo cai KHO KIEU CHU PHU DE - Windows
# Hoc vien KHONG chay tay file nay. Tro ly AI tu chay khi ban dan cau lenh cai.

$ErrorActionPreference = 'Stop'
Write-Host ""
Write-Host "=== Cai Kho kieu chu phu de ==="
Write-Host ""

# 1. Kiem may co du do nghe chua
$thieu = @()
try { $null = & node --version 2>$null } catch { $thieu += 'Node.js' }
$coFfmpeg = $false
try { $v = & ffmpeg -version 2>&1 | Out-String; $coFfmpeg = $true } catch { $thieu += 'ffmpeg' }
if ($thieu.Count -gt 0) {
  Write-Host "THIEU: $($thieu -join ', ')"
  Write-Host "Node.js: https://nodejs.org  |  ffmpeg: https://ffmpeg.org (lay ban essentials)"
  exit 1
}
if ($coFfmpeg -and $v -notmatch 'libass') {
  Write-Host "CANH BAO: ffmpeg tren may KHONG co libass - se khong nuong duoc phu de."
  Write-Host "Hay cai lai ban ffmpeg day du (ban essentials cua gyan.dev) roi chay lai."
  exit 1
}
Write-Host "Node.js va ffmpeg (co libass): DA CO"

# 2. Dat skill vao dung cho de tro ly tu nhan
$dich = Join-Path $env:USERPROFILE '.claude\skills\tao-kieu-chu-caption'
$tam  = Join-Path $env:TEMP ('kieuchu-' + [guid]::NewGuid().ToString('N').Substring(0,8))

Write-Host "Dang tai bo cong cu..."
& git clone --depth 1 https://github.com/sontyphu/autovideo-effects.git $tam 2>&1 | Out-Null
$nguon = Join-Path $tam 'kieu-chu-caption'
if (-not (Test-Path (Join-Path $nguon 'SKILL.md'))) {
  Write-Host "Tai khong duoc. Kiem tra mang roi thu lai."
  exit 1
}

# Giu lai kieu chu nguoi dung tu tao: chung nam ngoai skill (~\.kho-kieu-chu)
# nen cap nhat khong dung toi. O day chi thay phan may moc va kho font.
if (-not (Test-Path $dich)) { New-Item -ItemType Directory -Force -Path $dich | Out-Null }
else { Write-Host "Da co ban cu - chi thay phan may moc, giu nguyen kieu chu ban tu tao" }
Remove-Item (Join-Path $dich 'scripts') -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $nguon '*') $dich -Recurse -Force
Remove-Item $tam -Recurse -Force -ErrorAction SilentlyContinue

# 3. Chay bai tu kiem de chung minh cai dung
Write-Host ""
Write-Host "Dang chay bai tu kiem (dung that tung kieu chu roi do bang may)..."
Push-Location $dich
try { & node scripts\tu-kiem.mjs } finally { Pop-Location }
