# Builds dist\PersianAlert.exe from src\PersianAlert.ahk.
# Build tools are pinned to exact versions and verified by SHA-256 before use.
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$ToolsDir = Join-Path $PSScriptRoot ".tools"
$DistDir = Join-Path $PSScriptRoot "dist"
$Source = Join-Path $PSScriptRoot "src\PersianAlert.ahk"
$Output = Join-Path $DistDir "PersianAlert.exe"

$Tools = @(
    @{
        Name   = "AutoHotkey"
        Url    = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.30/AutoHotkey_2.0.30.zip"
        Sha256 = "1e0ece7ecb2d5646e55758150472677996a57f9db5c83d2996d8b47b9e2f31a4"
    },
    @{
        Name   = "Ahk2Exe"
        Url    = "https://github.com/AutoHotkey/Ahk2Exe/releases/download/Ahk2Exe1.1.37.02a2/Ahk2Exe1.1.37.02a2.zip"
        Sha256 = "c29b8c3a5124850d79fc9e66e2ca79677c377d7f31631ad3022ba159c5d9e3be"
    }
)

foreach ($tool in $Tools) {
    $dir = Join-Path $ToolsDir $tool.Name
    if (Test-Path $dir) { continue }

    New-Item -ItemType Directory -Force $ToolsDir | Out-Null
    $zip = "$dir.zip"
    Write-Host "Downloading $($tool.Name)..."
    Invoke-WebRequest -UseBasicParsing -Uri $tool.Url -OutFile $zip

    $hash = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($hash -ne $tool.Sha256) {
        Remove-Item $zip
        throw "$($tool.Name) download failed verification. Expected $($tool.Sha256), got $hash."
    }

    $staging = "$dir.staging"
    if (Test-Path $staging) { Remove-Item -Recurse -Force $staging }
    Expand-Archive -Path $zip -DestinationPath $staging
    Rename-Item $staging $dir
    Remove-Item $zip
}

New-Item -ItemType Directory -Force $DistDir | Out-Null
if (Test-Path $Output) { Remove-Item $Output }

$compiler = Join-Path $ToolsDir "Ahk2Exe\Ahk2Exe.exe"
$base = Join-Path $ToolsDir "AutoHotkey\AutoHotkey64.exe"
$log = Join-Path $DistDir "build.log"

Write-Host "Compiling..."
$process = Start-Process -FilePath $compiler -Wait -PassThru -NoNewWindow -RedirectStandardOutput $log -ArgumentList @(
    "/in", "`"$Source`"",
    "/out", "`"$Output`"",
    "/base", "`"$base`"",
    "/compress", "0",
    "/silent", "verbose"
)
Get-Content $log -ErrorAction SilentlyContinue | Write-Host
Remove-Item $log -ErrorAction SilentlyContinue

if ($process.ExitCode -ne 0 -or -not (Test-Path $Output)) {
    throw "Compilation failed (exit code $($process.ExitCode))."
}

$exeHash = (Get-FileHash $Output -Algorithm SHA256).Hash.ToLowerInvariant()
Set-Content -Path "$Output.sha256" -Value "$exeHash  PersianAlert.exe" -Encoding ascii
Write-Host "Built $Output"
Write-Host "SHA-256: $exeHash"
