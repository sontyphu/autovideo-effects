# Xem may dang co gi, thieu gi - khong cai gi ca
#   irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/kiem-tra.ps1 | iex

$SKILL = Join-Path $env:USERPROFILE ".claude\skills\video-use"
function Co-Lenh($ten) { $null -ne (Get-Command $ten -ErrorAction SilentlyContinue) }

function Dong($ten, $dat, $ghiChu) {
    if ($dat) { Write-Host ("  [x] " + $ten.PadRight(34) + $ghiChu) -ForegroundColor Green }
    else      { Write-Host ("  [ ] " + $ten.PadRight(34) + $ghiChu) -ForegroundColor DarkGray }
}

Write-Host ""
Write-Host "  MAY BAN DANG O DAU - LOP AUTOVIDEO" -ForegroundColor White
Write-Host ""

# --- Ve vao lop
$ve = @(
    @{ ten = "Claude Desktop"; dat = (Test-Path (Join-Path $env:USERPROFILE ".claude")); ghi = "" }
    @{ ten = "Node.js";        dat = (Co-Lenh node); ghi = $(if (Co-Lenh node) { node -v } else { "tai o nodejs.org" }) }
    @{ ten = "Git";            dat = (Co-Lenh git);  ghi = $(if (Co-Lenh git) { (git --version) -replace 'git version ','' } else { "tai o git-scm.com" }) }
)
$veDat = ($ve | Where-Object { $_.dat }).Count
Write-Host "  VE VAO LOP  [$veDat/3]" -ForegroundColor Cyan
$ve | ForEach-Object { Dong $_.ten $_.dat $_.ghi }

# --- Goi Cat + Giong
Write-Host ""
$g2 = @(
    @{ ten = "FFmpeg";                dat = (Co-Lenh ffmpeg); ghi = "cat ghep video" }
    @{ ten = "uv";                    dat = (Co-Lenh uv);     ghi = "quan kho phan mem nen" }
    @{ ten = "Bo cong cu video";      dat = (Test-Path (Join-Path $SKILL "helpers\timeline_view.py")); ghi = "boc loi, nhin hinh" }
    @{ ten = "10 cong cu tieng Viet"; dat = (Test-Path (Join-Path $SKILL "helpers\tim_tu_dem.py"));    ghi = "tim am u, cat dung cau" }
    @{ ten = "yt-dlp";                dat = (Co-Lenh yt-dlp); ghi = "tai video tu link" }
    @{ ten = "Chia khoa ElevenLabs";  dat = (Test-Path (Join-Path $SKILL ".env")); ghi = "boc loi chuan + giong doc" }
)
$g2Dat = ($g2 | Where-Object { $_.dat }).Count
$g2Trang = if ($g2Dat -eq 6) { "San sang buoi 1 va 2" } else { "Con thieu - xem duoi" }
Write-Host "  GOI CAT + GIONG  [$g2Dat/6]  $g2Trang" -ForegroundColor Cyan
$g2 | ForEach-Object { Dong $_.ten $_.dat $_.ghi }

# --- Goi Hieu ung
Write-Host ""
$g3 = @(
    @{ ten = "HyperFrames"; dat = (Co-Lenh hyperframes); ghi = "chu dong, hieu ung" }
    @{ ten = "Chrome ngam"; dat = (Test-Path (Join-Path $env:USERPROFILE ".cache\hyperframes\chrome")); ghi = "de dung hinh (~150 MB)" }
)
$g3Dat = ($g3 | Where-Object { $_.dat }).Count
$g3Trang = if ($g3Dat -eq 2) { "San sang buoi 3" } else { "Cai truoc buoi 3" }
Write-Host "  GOI HIEU UNG  [$g3Dat/2]  $g3Trang" -ForegroundColor Cyan
$g3 | ForEach-Object { Dong $_.ten $_.dat $_.ghi }

# --- Viec tiep theo
Write-Host ""
if ($veDat -lt 3) {
    Write-Host "  VIEC TIEP THEO: cai not ve vao lop" -ForegroundColor Yellow
    Write-Host "  https://sontyphu.github.io/hoc-auto-video/chuan-bi/" -ForegroundColor Cyan
} elseif ($g2Dat -lt 6) {
    Write-Host "  VIEC TIEP THEO: cai Goi Cat + Giong" -ForegroundColor Yellow
    Write-Host "  irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.ps1 | iex" -ForegroundColor Cyan
} elseif ($g3Dat -lt 2) {
    Write-Host "  Du cho buoi 1 va 2. Truoc buoi 3 cai Goi Hieu ung:" -ForegroundColor Green
    Write-Host "  https://github.com/sontyphu/autovideo-effects" -ForegroundColor Cyan
} else {
    Write-Host "  DU CA BA GOI - san sang het ca khoa." -ForegroundColor Green
}
Write-Host ""
