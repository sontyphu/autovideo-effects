# Xem may dang co gi, thieu gi - khong cai gi ca
#   irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/kiem-tra.ps1 | iex

$SKILL = Join-Path $env:USERPROFILE ".claude\skills\video-use"
function Co-Lenh($ten) { $null -ne (Get-Command $ten -ErrorAction SilentlyContinue) }

function Dong($ten, $dat, $ghiChu) {
    if ($dat) { Write-Host ("  [x] " + $ten.PadRight(34) + $ghiChu) -ForegroundColor Green }
    else      { Write-Host ("  [ ] " + $ten.PadRight(34) + $ghiChu) -ForegroundColor DarkGray }
}

Write-Host ""
Write-Host "  HIEN TRANG CAI DAT - KHOA AUTOVIDEO" -ForegroundColor White
Write-Host ""

# --- Ve vao lop
$ve = @(
    @{ ten = "Claude Desktop"; dat = (Test-Path (Join-Path $env:USERPROFILE ".claude")); ghi = "" }
    @{ ten = "Node.js";        dat = (Co-Lenh node); ghi = $(if (Co-Lenh node) { node -v } else { "tai tai nodejs.org" }) }
    @{ ten = "Git";            dat = (Co-Lenh git);  ghi = $(if (Co-Lenh git) { (git --version) -replace 'git version ','' } else { "tai tai git-scm.com" }) }
)
$veDat = ($ve | Where-Object { $_.dat }).Count
Write-Host "  CHUAN BI TRUOC KHOA  [$veDat/3]" -ForegroundColor Cyan
$ve | ForEach-Object { Dong $_.ten $_.dat $_.ghi }

# --- Goi Cat + Giong
Write-Host ""
$g2 = @(
    @{ ten = "FFmpeg";                dat = (Co-Lenh ffmpeg); ghi = "cat ghep video" }
    @{ ten = "uv";                    dat = (Co-Lenh uv);     ghi = "quan ly moi truong Python" }
    @{ ten = "Bo cong cu video";      dat = (Test-Path (Join-Path $SKILL "helpers\timeline_view.py")); ghi = "boc loi, doc khung hinh" }
    @{ ten = "10 cong cu tieng Viet"; dat = (Test-Path (Join-Path $SKILL "helpers\tim_tu_dem.py"));    ghi = "tim tu dem, cat theo ranh gioi cau" }
    @{ ten = "yt-dlp";                dat = (Co-Lenh yt-dlp); ghi = "tai video tu lien ket" }
    @{ ten = "Chia khoa ElevenLabs";  dat = (Test-Path (Join-Path $SKILL ".env")); ghi = "boc loi va tong hop giong doc" }
)
$g2Dat = ($g2 | Where-Object { $_.dat }).Count
$g2Trang = if ($g2Dat -eq 6) { "Du dieu kien cho buoi 1 va 2" } else { "Chua du, xem chi tiet ben duoi" }
Write-Host "  GOI CAT VA GIONG  [$g2Dat/6]  $g2Trang" -ForegroundColor Cyan
$g2 | ForEach-Object { Dong $_.ten $_.dat $_.ghi }

# --- Goi Hieu ung
Write-Host ""
$g3 = @(
    @{ ten = "HyperFrames"; dat = (Co-Lenh hyperframes); ghi = "chen chu dong va hieu ung" }
    @{ ten = "Chrome ngam"; dat = (Test-Path (Join-Path $env:USERPROFILE ".cache\hyperframes\chrome")); ghi = "thanh phan ket xuat (~150 MB)" }
)
$g3Dat = ($g3 | Where-Object { $_.dat }).Count
$g3Trang = if ($g3Dat -eq 2) { "Du dieu kien cho buoi 3" } else { "Cai truoc buoi 3" }
Write-Host "  GOI HIEU UNG  [$g3Dat/2]  $g3Trang" -ForegroundColor Cyan
$g3 | ForEach-Object { Dong $_.ten $_.dat $_.ghi }

# --- Viec tiep theo
Write-Host ""
if ($veDat -lt 3) {
    Write-Host "  BUOC TIEP THEO: hoan tat phan chuan bi truoc khoa" -ForegroundColor Yellow
    Write-Host "  https://sontyphu.github.io/hoc-auto-video/chuan-bi/" -ForegroundColor Cyan
} elseif ($g2Dat -lt 6) {
    Write-Host "  BUOC TIEP THEO: cai Goi Cat va Giong" -ForegroundColor Yellow
    Write-Host "  irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.ps1 | iex" -ForegroundColor Cyan
} elseif ($g3Dat -lt 2) {
    Write-Host "  Du dieu kien cho buoi 1 va 2. Cai Goi Hieu ung truoc buoi 3:" -ForegroundColor Green
    Write-Host "  https://github.com/sontyphu/autovideo-effects" -ForegroundColor Cyan
} else {
    Write-Host "  Da cai day du ba goi. San sang cho toan khoa hoc." -ForegroundColor Green
}
Write-Host ""
