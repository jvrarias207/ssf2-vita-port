# Package audio files for transfer to Vita
# Usage: powershell -ExecutionPolicy Bypass -File .\package-audio.ps1
# Copy the collected directory contents to ux0:data/SSF2/ on your Vita.

$sourceDir = "ux0_data_SSF2_jpexs"
if (Test-Path "ux0_data_SSF2_jpexs_v2") { $sourceDir = "ux0_data_SSF2_jpexs_v2" }
if (Test-Path "ux0_data_SSF2_jpexs_v3") { $sourceDir = "ux0_data_SSF2_jpexs_v3" }
if (!(Test-Path $sourceDir)) { $sourceDir = "assets" }
$audioDir = "SSF2-audio-transfer"
New-Item -ItemType Directory -Force -Path $audioDir | Out-Null

# Copy verified/extracted PCM files to a clean transfer folder
Get-ChildItem -Path $sourceDir -Filter "*.pcm" | ForEach-Object {
    Copy-Item $_.FullName -Destination $audioDir
}

$count = (Get-ChildItem -Path $audioDir -Filter "*.pcm").Count
if ($count -ne 71) { throw "Expected 63 Mario sounds, 7 source swing/grab/throw sounds and one Brawl music PCM from $sourceDir; found $count" }
Write-Host "Packaged $count PCM files from $sourceDir into $audioDir/"
Write-Host "Copy contents of $audioDir/ to ux0:data/SSF2/ on your Vita"
