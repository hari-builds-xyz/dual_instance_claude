param([string]$Name = 'Claude Work')
$ErrorActionPreference = 'Stop'

$exe = $null

# 1) Classic installer locations
$classic = @(
  "$env:LOCALAPPDATA\AnthropicClaude\claude.exe",
  "$env:LOCALAPPDATA\Programs\Claude\Claude.exe"
)
$exe = $classic | Where-Object { Test-Path $_ } | Select-Object -First 1

# 2) Microsoft Store (MSIX): use the app execution alias, which accepts flags
if (-not $exe) {
  $pkg = Get-AppxPackage -Name '*Claude*' | Select-Object -First 1
  if ($pkg) {
    $xml = Get-Content (Join-Path $pkg.InstallLocation 'AppxManifest.xml') -Raw
    $aliases = [regex]::Matches($xml, 'Alias="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
    $wa = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps'
    foreach ($a in $aliases) {
      $p = Join-Path $wa $a
      if (Test-Path $p) { $exe = $p; break }
    }
  }
}
if (-not $exe) { throw 'Could not find Claude Desktop.' }

$data = Join-Path $env:LOCALAPPDATA ($Name -replace '\s', '-')
$lnk  = Join-Path ([Environment]::GetFolderPath('Desktop')) "$Name.lnk"

$s = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
$s.TargetPath = $exe
$s.Arguments  = "--user-data-dir=`"$data`""
$s.Save()

Write-Host "Created: $lnk`nProfile folder: $data"
