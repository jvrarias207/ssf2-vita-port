$ErrorActionPreference = 'Stop'
$gameRoot = 'C:\Users\javon\Desktop\SSF2\Super Smash Flash 2 Beta'
$outputRoot = Join-Path $PSScriptRoot 'prototype-assets'
New-Item -ItemType Directory -Force -Path "$outputRoot\originals", "$outputRoot\swf" | Out-Null
$resources = [ordered]@{
    DAT357 = 'Mario'
    DAT118 = 'Luigi'
    DAT213 = 'Final Destination'
    DAT51 = 'Resource mappings'
    DAT67 = 'Shared miscellaneous assets'
    DAT75 = 'Shared effects'
    DAT141 = 'Shared audio'
}
$inventory = foreach ($id in $resources.Keys) {
    $source = Join-Path $gameRoot "data\$id.ssf"
    $bytes = [IO.File]::ReadAllBytes($source)
    $inputStream = [IO.MemoryStream]::new($bytes)
    $inputStream.Position = 2
    $inflater = [IO.Compression.DeflateStream]::new($inputStream, [IO.Compression.CompressionMode]::Decompress)
    $expanded = [IO.MemoryStream]::new()
    try {
        $inflater.CopyTo($expanded)
        $raw = $expanded.ToArray()
    } finally {
        $inflater.Dispose()
        $inputStream.Dispose()
        $expanded.Dispose()
    }
    if ($raw.Length -lt 8) { throw "Truncated resource: $id" }
    $lengthBytes = $raw[0..3]
    $countBytes = $raw[4..7]
    [Array]::Reverse($lengthBytes)
    [Array]::Reverse($countBytes)
    $length = [BitConverter]::ToInt32($lengthBytes, 0)
    $count = [BitConverter]::ToInt32($countBytes, 0)
    $offset = 8L + 4L * $count
    if ($length -lt 8 -or $count -lt 0 -or $offset + $length -gt $raw.Length) {
        throw "Invalid resource payload bounds: $id"
    }
    $payload = [byte[]]::new($length)
    [Array]::Copy($raw, $offset, $payload, 0L, [long]$length)
    $signature = [Text.Encoding]::ASCII.GetString($payload, 0, 3)
    if ($signature -notin @('FWS', 'CWS', 'ZWS')) { throw "Not a SWF: $id" }
    Copy-Item -LiteralPath $source -Destination "$outputRoot\originals\$id.ssf"
    [IO.File]::WriteAllBytes("$outputRoot\swf\$id.swf", $payload)
    [PSCustomObject]@{
        id = $id
        description = $resources[$id]
        source = $source
        sourceBytes = $bytes.Length
        sha256 = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
        swfBytes = $length
        signature = $signature
    }
}
Copy-Item -LiteralPath "$gameRoot\SSF2.swf" -Destination "$outputRoot\originals\SSF2.swf"
Copy-Item -LiteralPath "$gameRoot\META-INF\AIR\application.xml" -Destination "$outputRoot\originals\application.xml"
$inventory | ConvertTo-Json -Depth 4 | Set-Content "$outputRoot\inventory.json" -Encoding UTF8
$inventory | Select-Object id, description, sourceBytes, swfBytes | Format-Table
