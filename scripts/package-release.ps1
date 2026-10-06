param(
    [string]$OutputDirectory = "",
    [string]$BinaryPath = ""
)
$ErrorActionPreference = "Stop"
$repoDir = Split-Path $PSScriptRoot -Parent
$versionSource = Get-Content (Join-Path $repoDir "version\version.go") -Raw
if ($versionSource -notmatch 'Version = "(v[^\"]+)"') { throw "Cannot read release version" }
$releaseVersion = $Matches[1]
if ($OutputDirectory -eq "") { $OutputDirectory = Join-Path $repoDir "dist" }
if ($BinaryPath -eq "") { $BinaryPath = Join-Path $repoDir "qzone-history-gui.exe" }
$OutputDirectory = [IO.Path]::GetFullPath($OutputDirectory)
$BinaryPath = [IO.Path]::GetFullPath($BinaryPath)
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$bundleName = "qzone-history-$releaseVersion-windows-amd64"
$bundleDir = Join-Path $OutputDirectory $bundleName
New-Item -ItemType Directory -Path $bundleDir -Force | Out-Null
$exePath = Join-Path $OutputDirectory "qzone-history-gui.exe"
Copy-Item -LiteralPath $BinaryPath -Destination $exePath -Force
Copy-Item -LiteralPath $BinaryPath -Destination (Join-Path $bundleDir "qzone-history-gui.exe") -Force
Copy-Item -LiteralPath (Join-Path $repoDir "LICENSE") -Destination (Join-Path $bundleDir "LICENSE") -Force
Copy-Item -LiteralPath (Join-Path $repoDir "docs\release-windows.txt") -Destination (Join-Path $bundleDir "README.txt") -Force
$utf8 = New-Object System.Text.UTF8Encoding($false)
$exeHash = (Get-FileHash -LiteralPath $exePath -Algorithm SHA256).Hash.ToLowerInvariant()
[IO.File]::WriteAllText((Join-Path $bundleDir "SHA256SUMS.txt"), "$exeHash  qzone-history-gui.exe`n", $utf8)
$bundleFiles = @("qzone-history-gui.exe", "LICENSE", "README.txt", "SHA256SUMS.txt") | ForEach-Object { Join-Path $bundleDir $_ }
$zipPath = Join-Path $OutputDirectory "$bundleName.zip"
Compress-Archive -LiteralPath $bundleFiles -DestinationPath $zipPath -Force
$zipHash = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
[IO.File]::WriteAllText((Join-Path $OutputDirectory "SHA256SUMS.txt"), "$exeHash  qzone-history-gui.exe`n$zipHash  $bundleName.zip`n", $utf8)
Write-Host "Packaged ${releaseVersion}: $zipPath"
