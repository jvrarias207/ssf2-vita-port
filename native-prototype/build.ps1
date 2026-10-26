$ErrorActionPreference='Stop'
Push-Location $PSScriptRoot
try {
    & '..\toolchain\zig-x86_64-windows-0.15.2\zig.exe' c++ main.cpp -std=c++17 -O2 -lgdiplus -lgdi32 -luser32 -lole32 '-Wl,--subsystem,windows' -o ssf2-prototype.exe
    if($LASTEXITCODE -ne 0){throw 'Build failed'}
    $test=Start-Process -FilePath (Join-Path $PSScriptRoot 'ssf2-prototype.exe') -ArgumentList '--test' -WindowStyle Hidden -Wait -PassThru
    Get-Content 'test-results.txt'
    if($test.ExitCode -ne 0){throw 'Simulation tests failed'}
} finally {Pop-Location}
