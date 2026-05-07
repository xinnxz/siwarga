$file = Get-Content 'e:\DATA\Ngoding\siwarga\index.html' -Encoding UTF8
$cssLines = @()
$jsLines = @()
$inCss = $false
$inJs = $false

foreach ($line in $file) {
    if ($line -match '^\s*<style>') { $inCss = $true }
    if ($line -match '^\s*</style>') { $cssLines += $line; $inCss = $false; continue }
    if ($inCss) { $cssLines += $line; continue }
    
    if ($line -match '^<script>') { $inJs = $true }
    if ($line -match '^</script>') { $jsLines += $line; $inJs = $false; continue }
    if ($inJs) { $jsLines += $line; continue }
}

$cssLines | Set-Content 'e:\DATA\Ngoding\siwarga\css.html' -Encoding UTF8
$jsLines | Set-Content 'e:\DATA\Ngoding\siwarga\js.html' -Encoding UTF8

Write-Host "css.html: $($cssLines.Count) lines"
Write-Host "js.html: $($jsLines.Count) lines"
