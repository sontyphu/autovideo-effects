# Goi Hieu ung - lop Autovideo (Windows)
# Chay bang 1 dong:
#   irm https://raw.githubusercontent.com/sontyphu/autovideo-effects/main/cai-dat.ps1 | iex

$ErrorActionPreference = "Stop"

# --- Ban ghim: doc tu may thay Son 07/08/2026
$BAN_HF   = "0.7.88"
$KHO_NAY  = "https://github.com/sontyphu/autovideo-effects"
$SKILL_G1 = Join-Path $env:USERPROFILE ".claude\skills\video-use"
$DICH     = Join-Path $env:USERPROFILE "autovideo-effects"

function Chay-Ngoai {
    param([scriptblock]$Lenh)
    $cu = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try { & $Lenh 2>&1 | Out-Null; return $LASTEXITCODE }
    finally { $ErrorActionPreference = $cu }
}

function Tieu-De($chu) { Write-Host "`n=== $chu ===" -ForegroundColor Cyan }
function Dat($chu)     { Write-Host "  [DAT] $chu" -ForegroundColor Green }
function Thieu($chu)   { Write-Host "  [THIEU] $chu" -ForegroundColor Yellow }
function Hong($chu)    { Write-Host "  [HONG] $chu" -ForegroundColor Red }
function Co-Lenh($ten) { $null -ne (Get-Command $ten -ErrorAction SilentlyContinue) }

Write-Host ""
Write-Host "  GOI HIEU UNG - LOP AUTOVIDEO" -ForegroundColor White
Write-Host "  Le Thanh Son" -ForegroundColor DarkGray
Write-Host ""

# ------------------------------------------------- 0. Goi truoc da cai chua
Tieu-De "Buoc 0/4 - Kiem goi truoc"

if (-not (Co-Lenh node)) {
    Hong "Chua co Node.js - thuoc ve vao lop"
    Write-Host "  https://sontyphu.github.io/hoc-auto-video/chuan-bi/" -ForegroundColor Cyan
    Write-Host ""
    return
}
Dat "Node.js da co: $(node -v)"

if (-not (Test-Path (Join-Path $SKILL_G1 "helpers\transcript_hyperframes.py"))) {
    Write-Host ""
    Hong "Chua cai Goi Cat + Giong"
    Write-Host ""
    Write-Host "  Goi Hieu ung can Goi Cat + Giong chay truoc, vi phan boc loi" -ForegroundColor Yellow
    Write-Host "  tieng Viet nam o goi do. Cai goi kia truoc roi quay lai day:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.ps1 | iex" -ForegroundColor Cyan
    Write-Host ""
    return
}
Dat "Goi Cat + Giong da co"

# ------------------------------------------------- 1. HyperFrames
Tieu-De "Buoc 1/4 - Phan mem chen hieu ung"

$banDangCo = ""
if (Co-Lenh hyperframes) { $banDangCo = (hyperframes --version) }

if ($banDangCo -eq $BAN_HF) {
    Dat "Da co dung ban ghim: $BAN_HF"
} else {
    if ($banDangCo) { Write-Host "  Dang co ban $banDangCo, se dua ve ban ghim $BAN_HF..." }
    else { Write-Host "  Dang cai (khoang 2 phut)..." }
    $ma = Chay-Ngoai { npm install -g "hyperframes@$BAN_HF" }
    if ($ma -ne 0) {
        Hong "Cai that bai - thuong la do thieu quyen"
        Write-Host ""
        Write-Host "  Cach xu: bam chuot phai vao PowerShell chon 'Run as administrator'," -ForegroundColor Yellow
        Write-Host "  roi chay lai dung lenh nay." -ForegroundColor Yellow
        Write-Host ""
        return
    }
    if ((Co-Lenh hyperframes) -and ((hyperframes --version) -eq $BAN_HF)) { Dat "Da cai ban $BAN_HF" }
    else { Hong "Cai xong ma may chua nhan - dong PowerShell mo lai roi chay lai"; return }
}

# ------------------------------------------------- 2. Bo chu tieng Viet
Tieu-De "Buoc 2/4 - Bo chu tieng Viet"

if (Test-Path (Join-Path $DICH ".git")) {
    Push-Location $DICH
    Chay-Ngoai { git pull --quiet } | Out-Null
    Pop-Location
    Dat "Da cap nhat: $DICH"
} else {
    if (Test-Path $DICH) { Remove-Item $DICH -Recurse -Force }
    $maC = Chay-Ngoai { git clone --quiet $KHO_NAY $DICH }
    if ($maC -ne 0) { Hong "Tai bo chu that bai - kiem lai mang"; return }
    Dat "Da tai ve: $DICH"
}

# ------------------------------------------------- 3. Chrome ngam
Tieu-De "Buoc 3/4 - Chrome ngam (de dung hinh)"

$khoChrome = Join-Path $env:USERPROFILE ".cache\hyperframes\chrome"
if (Test-Path $khoChrome) {
    Dat "Da co san"
} else {
    Thieu "Chua co - may se tu tai ~150 MB o lan dau dung video"
    Write-Host "  Do la binh thuong, khong phai may treo. Cu de chay." -ForegroundColor DarkGray
}

# ------------------------------------------------- 4. Kiem tra
Tieu-De "Buoc 4/4 - Kiem tra"

$diem = 0
if ((Co-Lenh hyperframes) -and ((hyperframes --version) -eq $BAN_HF)) { Dat "Phan mem chen hieu ung ($BAN_HF)"; $diem++ } else { Thieu "phan mem chen hieu ung" }
if (Test-Path (Join-Path $DICH "hyperframes-viet\fonts\be-vietnam-pro.css")) { Dat "Bo chu tieng Viet"; $diem++ } else { Thieu "bo chu tieng Viet" }
if (Test-Path (Join-Path $DICH "hyperframes-viet\DOC-TRUOC.md")) { Dat "Bang 13 loi (doc truoc khi lam video)"; $diem++ } else { Thieu "bang 13 loi" }

Write-Host ""
Write-Host "  $diem/3 muc dat" -ForegroundColor White
Write-Host ""
Write-Host "  DOC TRUOC KHI LAM VIDEO - 3 phut, do mat vai tieng:" -ForegroundColor Yellow
Write-Host "  $DICH\hyperframes-viet\DOC-TRUOC.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Bat dau du an moi thi chay:" -ForegroundColor DarkGray
Write-Host "  $DICH\hyperframes-viet\vao-viec.ps1 -DuAn `"duong\dan\du-an`" -KemKhuonMau" -ForegroundColor DarkGray
Write-Host ""
