#Requires -Version 5.1
<#
.SYNOPSIS
    Installs the Catppuccin colour schemes into Xshell.

.DESCRIPTION
    Copies every "Catppuccin *.scs" file that sits next to this script into the Xshell user
    colour-scheme folder(s):

        %USERPROFILE%\Documents\NetSarang Computer\<version>\Xshell\ColorScheme Files

    All version folders that exist are handled, so Xshell 7 and 8 installs are both covered.
    Restart Xshell afterwards; the colour-scheme list is built at startup.

.PARAMETER Destination
    Install into this folder instead of the auto-detected Xshell folders.

.PARAMETER Uninstall
    Remove the Catppuccin schemes from the target folder(s).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\install.ps1

.EXAMPLE
    .\install.ps1 -Destination 'D:\backup\xshell-schemes'

.EXAMPLE
    .\install.ps1 -Uninstall
#>
[CmdletBinding()]
param(
    [string]$Destination,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

$source = $PSScriptRoot
if (-not $source) { $source = Split-Path -Parent $MyInvocation.MyCommand.Path }

$schemes = @(Get-ChildItem -LiteralPath $source -Filter 'Catppuccin *.scs' -File -ErrorAction SilentlyContinue)
if ($schemes.Count -eq 0) {
    throw "No 'Catppuccin *.scs' files found next to the script ('$source')."
}

function Get-XshellSchemeDirectories {
    $documents = [Environment]::GetFolderPath('MyDocuments')
    $root = Join-Path $documents 'NetSarang Computer'
    if (-not (Test-Path -LiteralPath $root)) { return @() }

    Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Join-Path $_.FullName 'Xshell\ColorScheme Files' } |
        Where-Object { Test-Path -LiteralPath $_ }
}

if ($Destination) {
    if (-not (Test-Path -LiteralPath $Destination)) {
        if ($Uninstall) {
            Write-Host ("Nothing to uninstall: '{0}' does not exist." -f $Destination) -ForegroundColor Yellow
            exit 0
        }
        [System.IO.Directory]::CreateDirectory($Destination) | Out-Null
    }
    $targets = @($Destination)
}
else {
    $targets = @(Get-XshellSchemeDirectories)
    if ($targets.Count -eq 0) {
        Write-Host ''
        if ($Uninstall) {
            Write-Host 'No Xshell colour-scheme folder found - nothing to uninstall.' -ForegroundColor Yellow
            exit 0
        }
        Write-Host 'No Xshell colour-scheme folder found.' -ForegroundColor Yellow
        Write-Host 'Expected something like:'
        Write-Host '  C:\Users\<you>\Documents\NetSarang Computer\8\Xshell\ColorScheme Files'
        Write-Host ''
        Write-Host 'Start Xshell once so it creates the folder, then run this script again,'
        Write-Host 'or pass an explicit folder with -Destination <path>.'
        exit 1
    }
}

Write-Host ("Catppuccin for Xshell - {0} scheme file(s)" -f $schemes.Count)
Write-Host ''

$changed = 0

foreach ($target in $targets) {
    Write-Host ("-> {0}" -f $target) -ForegroundColor Cyan

    if ($Uninstall) {
        foreach ($scheme in $schemes) {
            $file = Join-Path $target $scheme.Name
            if (Test-Path -LiteralPath $file) {
                Remove-Item -LiteralPath $file -Force
                Write-Host ("   removed  {0}" -f $scheme.Name)
                $changed++
            }
        }
    }
    else {
        foreach ($scheme in $schemes) {
            Copy-Item -LiteralPath $scheme.FullName -Destination (Join-Path $target $scheme.Name) -Force
            Write-Host ("   copied   {0}" -f $scheme.Name)
            $changed++
        }
    }
    Write-Host ''
}

if ($Uninstall) {
    if ($changed -eq 0) {
        Write-Host 'Nothing to uninstall - the schemes were not present.' -ForegroundColor Yellow
    }
    else {
        Write-Host ("Done. {0} file(s) removed. Restart Xshell to refresh the colour-scheme list." -f $changed)
    }
}
else {
    Write-Host ("Done. {0} file(s) installed. Now:" -f $changed) -ForegroundColor Green
    Write-Host '  1. Restart Xshell.'
    Write-Host '  2. Tools -> Color Schemes, pick "Catppuccin Mocha" (or another flavour).'
    Write-Host '  3. For one session only: right-click the session -> Properties -> Appearance.'
}
