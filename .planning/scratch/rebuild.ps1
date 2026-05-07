$file = Get-Content 'e:\DATA\Ngoding\siwarga\index.html' -Encoding UTF8

$newLines = @()
$skipCss = $false
$skipJs = $false
$cssInserted = $false
$jsInserted = $false

foreach ($line in $file) {
    # Detect start of <style> block
    if ($line -match '^\s*<style>' -and -not $cssInserted) {
        $skipCss = $true
        $newLines += '  <?!= include("css"); ?>'
        $cssInserted = $true
        continue
    }
    # Detect end of </style> block
    if ($skipCss -and $line -match '^\s*</style>') {
        $skipCss = $false
        continue
    }
    # Skip CSS lines
    if ($skipCss) { continue }

    # Detect start of <script> block
    if ($line -match '^<script>' -and -not $jsInserted) {
        $skipJs = $true
        $newLines += '<?!= include("js"); ?>'
        $jsInserted = $true
        continue
    }
    # Detect end of </script> block
    if ($skipJs -and $line -match '^</script>') {
        $skipJs = $false
        continue
    }
    # Skip JS lines
    if ($skipJs) { continue }

    $newLines += $line
}

# Also remove the extra include line we accidentally added
$finalLines = $newLines | Where-Object { $_ -notmatch 'include\(.*css.*\).*\?>' -or $_ -match '^\s*<\?!= include' }

$newLines | Set-Content 'e:\DATA\Ngoding\siwarga\index.html' -Encoding UTF8

$htmlCount = ($newLines | Measure-Object).Count
Write-Host "index.html rebuilt: $htmlCount lines (was 1452)"
Write-Host "CSS inserted: $cssInserted"
Write-Host "JS inserted: $jsInserted"
