# Regenerate Mario sounds from local SSF2 SWFs via JPEXS and ffmpeg.
# Produces a new transfer folder; never overwrites the user's existing PCM files.
# Usage: powershell -ExecutionPolicy Bypass -File .\extract-audio.ps1
param(
    [string]$Jpexs = 'C:\Program Files (x86)\FFDec\ffdec-cli.exe',
    [string]$Ffmpeg = 'C:\Users\javon\Downloads\ffmpeg-2026-10-22-git-bf0e831606-essentials_build\ffmpeg-2026-10-22-git-bf0e831606-essentials_build\bin\ffmpeg.exe',
    [string]$Destination = (Join-Path $PSScriptRoot 'ux0_data_SSF2_jpexs_v3')
)
$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot '..\prototype-assets\swf\DAT357.swf'
$sharedSource = Join-Path $PSScriptRoot '..\prototype-assets\swf\DAT141.swf'
$theme = Join-Path $PSScriptRoot 'assets\Main Theme - Super Smash Bros_ Brawl-soConvert.pcm'
if (!(Test-Path $source)) { throw "Mario SWF missing: $source" }
if (!(Test-Path $Jpexs)) { throw "JPEXS CLI missing: $Jpexs" }
if (!(Test-Path $Ffmpeg)) { throw "ffmpeg missing: $Ffmpeg" }
if (Test-Path $Destination) { throw "Transfer folder already exists; choose a new -Destination: $Destination" }
$temporary = Join-Path ([IO.Path]::GetTempPath()) ("opencode\ssf2-jpexs-" + [guid]::NewGuid().ToString('N'))
& $Jpexs -export sound $temporary $source
if ($LASTEXITCODE -ne 0) { throw "JPEXS failed with exit code $LASTEXITCODE" }
$sounds = @(Get-ChildItem $temporary -Filter '*.flv' | Where-Object { $_.Name -match '^\d+_' })
if ($sounds.Count -ne 63) { throw "Expected 63 exported Mario sounds; found $($sounds.Count)" }
New-Item -ItemType Directory -Path $Destination | Out-Null
foreach ($sound in $sounds) {
    $name = [IO.Path]::GetFileNameWithoutExtension($sound.Name) + '-soConvert.pcm'
    $output = Join-Path $Destination $name
    & $Ffmpeg -hide_banner -loglevel error -y -i $sound.FullName -f s16le -acodec pcm_s16le -ac 2 -ar 48000 $output
    if ($LASTEXITCODE -ne 0 -or !(Test-Path $output)) { throw "PCM conversion failed: $($sound.Name)" }
    $size = (Get-Item $output).Length
    if ($size -eq 0 -or $size % 4 -ne 0) { throw "Invalid stereo PCM: $output" }
}
$sharedTemp = $temporary + '-shared'
& $Jpexs -export sound $sharedTemp $sharedSource
if ($LASTEXITCODE -ne 0) { throw "JPEXS shared sound export failed with exit code $LASTEXITCODE" }
$sharedSounds = @('brawl_swing_s','brawl_swing_m','brawl_swing_l','grab_swing4','grab_swing6','throw_woosh','brawl_kick_l')
foreach ($name in $sharedSounds) {
    $sourceSound = Get-ChildItem $sharedTemp -Filter "*_$name.flv" | Select-Object -First 1
    if (!$sourceSound) { throw "JPEXS DAT141 sound missing: $name" }
    $output = Join-Path $Destination "$name-soConvert.pcm"
    & $Ffmpeg -hide_banner -loglevel error -y -i $sourceSound.FullName -f s16le -acodec pcm_s16le -ac 2 -ar 48000 $output
    if ($LASTEXITCODE -ne 0 -or !(Test-Path $output)) { throw "PCM conversion failed: $name" }
    $size = (Get-Item $output).Length
    if ($size -eq 0 -or $size % 4 -ne 0) { throw "Invalid stereo PCM: $output" }
}
if (Test-Path $theme) {
    # The requested Brawl Main Theme is not among DAT357's Mario sounds.
    # Use the already-supplied stage track without modifying its bytes.
    $themeOutput=Join-Path $Destination (Split-Path $theme -Leaf)
    & $Ffmpeg -hide_banner -loglevel error -y -f s16le -ar 44100 -ac 2 -i $theme -f s16le -acodec pcm_s16le -ac 2 -ar 48000 $themeOutput
    if($LASTEXITCODE -ne 0 -or !(Test-Path $themeOutput)){throw 'Brawl theme 48-kHz conversion failed'}
    Write-Host 'Included the separately supplied Brawl Main Theme PCM converted to 48 kHz.'
} else {
    Write-Warning 'Brawl Main Theme not found in assets; music will be silent until supplied.'
}
Write-Host "Extracted $($sounds.Count) Mario sounds and $($sharedSounds.Count) DAT141 swing/grab/throw sounds to $Destination"
Write-Host 'Copy the contents of that folder to ux0:data/SSF2/ on the Vita.'
