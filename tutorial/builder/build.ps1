<#
.SYNOPSIS
Build a Windows executable and ZIP package from a LOVE2D .love file.

.DESCRIPTION
This script combines love.exe with a .love archive to produce a standalone .exe,
copies the required DLLs, creates a ZIP package, and cleans up temporary files.

.EXAMPLE
.\build.ps1 .\mygame.love
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$LoveFile
)

$ResolvedLoveFile = Resolve-Path -Path $LoveFile -ErrorAction Stop | Select-Object -First 1
if (-not $ResolvedLoveFile) {
    Write-Error "Could not resolve path for '$LoveFile'."
    exit 1
}

$LovePath = $ResolvedLoveFile.ProviderPath
$BaseName = [IO.Path]::GetFileNameWithoutExtension($LovePath)
if (-not $BaseName) {
    Write-Error "Invalid input file name: '$LovePath'."
    exit 1
}

$BuildRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$OutputExeName = "$BaseName.exe"
$OutputExe = Join-Path $BuildRoot $OutputExeName
$GameDir = Join-Path $BuildRoot "game"
$ZipFile = Join-Path $BuildRoot "$BaseName.zip"
$LoveExe = Join-Path $BuildRoot "love.exe"
$DllsDir = Join-Path $BuildRoot "dlls"

if (-not (Test-Path -Path $LoveExe)) {
    Write-Error "love.exe not found in the script folder: $BuildRoot"
    exit 1
}

if (-not (Test-Path -Path $DllsDir)) {
    Write-Error "dlls folder not found in the script folder: $BuildRoot"
    exit 1
}

Remove-Item -Path $OutputExe -Force -ErrorAction SilentlyContinue
Remove-Item -Path $ZipFile -Force -ErrorAction SilentlyContinue
Remove-Item -Path $GameDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Creating executable: $OutputExeName"
$loveData = [IO.File]::ReadAllBytes($LoveExe)
$bundleData = [IO.File]::ReadAllBytes($LovePath)
[IO.File]::WriteAllBytes($OutputExe, $loveData + $bundleData)

New-Item -ItemType Directory -Path $GameDir -Force | Out-Null
Copy-Item -Path (Join-Path $DllsDir "*") -Destination $GameDir -Recurse -Force
Move-Item -Path $OutputExe -Destination (Join-Path $GameDir $OutputExeName) -Force

Write-Host "Creating zip package: $ZipFile"

if (Test-Path -Path $ZipFile) {
    Remove-Item -Path $ZipFile -Force
}

if (Get-Command -Name Compress-Archive -ErrorAction SilentlyContinue) {
    Compress-Archive -Path (Join-Path $GameDir "*") -DestinationPath $ZipFile -Force
} else {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [IO.Compression.ZipFile]::CreateFromDirectory($GameDir, $ZipFile)
}

Remove-Item -Path $GameDir -Recurse -Force
Write-Host "Done!"
