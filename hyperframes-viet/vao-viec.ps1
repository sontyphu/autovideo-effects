# Bo khoi dong tieng Viet cho HyperFrames
# Chep bo chu co dau + thu vien chuyen dong vao mot du an HyperFrames moi,
# de khong vap 3 loi da gap (chu mat dau / qua han 10 giay / thieu thu vien).
#
# Cach dung:
#   .\vao-viec.ps1 -DuAn "C:\Users\...\Documents\Video-Projects\ten-du-an"
#   .\vao-viec.ps1 -DuAn . -KemKhuonMau

param(
    [Parameter(Mandatory = $true)]
    [string]$DuAn,

    # Chep kem 2 khuon mau da chay duoc (the nhan ban + lop trong suot)
    [switch]$KemKhuonMau
)

$ErrorActionPreference = "Stop"
$goc = $PSScriptRoot

if (-not (Test-Path $DuAn)) {
    Write-Error "Khong thay thu muc du an: $DuAn"
}

$dich = Resolve-Path $DuAn

New-Item -ItemType Directory -Force "$dich\assets\fonts" | Out-Null
New-Item -ItemType Directory -Force "$dich\assets\js" | Out-Null

Copy-Item "$goc\fonts\*" "$dich\assets\fonts\" -Force
Copy-Item "$goc\vendor\gsap.min.js" "$dich\assets\js\" -Force

$soFont = (Get-ChildItem "$dich\assets\fonts" -Filter *.woff2).Count
Write-Host "  bo chu tieng Viet: $soFont file -> assets\fonts"
Write-Host "  thu vien chuyen dong -> assets\js\gsap.min.js"

if ($KemKhuonMau) {
    New-Item -ItemType Directory -Force "$dich\compositions" | Out-Null
    Copy-Item "$goc\khuon-mau\*" "$dich\compositions\" -Force
    Write-Host "  2 khuon mau -> compositions\"
}

Write-Host ""
Write-Host "XONG. Dan 3 dong nay vao <head> cua file dung:"
Write-Host ""
Write-Host '  <link rel="stylesheet" href="./assets/fonts/be-vietnam-pro.css" />'
Write-Host '  <link rel="stylesheet" href="./assets/gu.css" />'
Write-Host '  <script src="./assets/js/gsap.min.js"></script>'
Write-Host ""
Write-Host "BUOC TIEP THEO BAT BUOC - ap gu (mau + font):"
Write-Host ""
Write-Host "  .claude\kho-gu\ap-gu.ps1 -Liet                      # xem co nhung gu nao"
Write-Host "  .claude\kho-gu\ap-gu.ps1 -Gu <ten> -DuAn `"$dich`""
Write-Host ""
Write-Host "Chua ap gu thi KHONG CO gu.css -> video ra mat mau."
Write-Host ""
Write-Host 'Trong CSS dung bien: background: var(--nen); color: var(--chu); var(--nhan)'
Write-Host 'DUNG dan <link> font tu fonts.googleapis.com - se qua han 10 giay.'
