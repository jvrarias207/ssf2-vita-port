$ErrorActionPreference='Stop'
$sdk=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..\vita-sdk'))
$env:VITASDK=$sdk
function Invoke-VitaTool([string]$tool,[string[]]$toolArgs){
    & (Join-Path $sdk "bin\$tool.exe") @toolArgs
    if($LASTEXITCODE -ne 0){throw "$tool failed with exit $LASTEXITCODE"}
}
Push-Location $PSScriptRoot
try {
    Invoke-VitaTool 'arm-vita-eabi-g++' @('main.cpp','-std=gnu++17','-O2','-fno-exceptions','-fno-rtti','-Wl,-q','-o','ssf2-vita.elf','-Wl,--start-group','-lvitaGL','-lmathneon','-lvitashark','-lSceShaccCgExt','-ltaihen_stub','-lSceShaccCg_stub','-lSceGxm_stub','-lSceDisplay_stub','-lSceSysmodule_stub','-lSceCtrl_stub','-lSceAudio_stub','-lSceAppMgr_stub','-lSceAppUtil_stub','-lSceCommonDialog_stub','-lSceKernelDmacMgr_stub','-lSceLibKernel_stub','-lm','-lc','-Wl,--end-group')
    Invoke-VitaTool 'vita-elf-create' @('ssf2-vita.elf','ssf2-vita.velf')
    Invoke-VitaTool 'vita-make-fself' @('-s','ssf2-vita.velf','eboot.bin')
    Invoke-VitaTool 'vita-mksfoex' @('-s','TITLE_ID=SSF2P0001','-s','APP_VER=00.52','SSF2 Prototype','param.sfo')
    Invoke-VitaTool 'vita-pack-vpk' @('-s','param.sfo','-b','eboot.bin','-a','assets/mario.rgba=assets/mario.rgba','-a','assets/font.rgba=assets/font.rgba','-a','sce_sys=sce_sys','SSF2-Vita-Prototype.vpk')
    Get-FileHash 'SSF2-Vita-Prototype.vpk' -Algorithm SHA256
} finally {Pop-Location}




