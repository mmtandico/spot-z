# Spot-Z Installation Script
# Developer: Zax (https://github.com/mmtandico/spot-z)
# Based on Spicetify CLI (LGPL-2.1)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#region Variables
$spotzFolderPath = "$env:LOCALAPPDATA\spot-z"
$spicetifyFolderPath = "$env:LOCALAPPDATA\spicetify"
$spicetifyOldFolderPath = "$HOME\spicetify-cli"
#endregion Variables

#region Functions
function Write-Success {
  [CmdletBinding()]
  param ()
  process {
    Write-Host -Object ' > OK' -ForegroundColor 'Green'
  }
}

function Write-Unsuccess {
  [CmdletBinding()]
  param ()
  process {
    Write-Host -Object ' > ERROR' -ForegroundColor 'Red'
  }
}

function Test-Admin {
  [CmdletBinding()]
  param ()
  begin {
    Write-Host -Object "Checking if the script is not being run as administrator..." -NoNewline
  }
  process {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    -not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }
}

function Test-PowerShellVersion {
  [CmdletBinding()]
  param ()
  begin {
    $PSMinVersion = [version]'5.1'
  }
  process {
    Write-Host -Object 'Checking if your PowerShell version is compatible...' -NoNewline
    $PSVersionTable.PSVersion -ge $PSMinVersion
  }
}

function Move-OldSpicetifyFolder {
  [CmdletBinding()]
  param ()
  process {
    if (Test-Path -Path $spicetifyOldFolderPath) {
      Write-Host -Object 'Migrating legacy folder...' -NoNewline
      Copy-Item -Path "$spicetifyOldFolderPath\*" -Destination $spotzFolderPath -Recurse -Force
      Remove-Item -Path $spicetifyOldFolderPath -Recurse -Force
      Write-Success
    }
  }
}

function Get-SpotZ {
  [CmdletBinding()]
  param ()
  begin {
    if ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
      $architecture = 'x64'
    }
    elseif ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
      $architecture = 'arm64'
    }
    else {
      $architecture = 'x32'
    }
    if ($v) {
      if ($v -match '^\d+\.\d+\.\d+$') {
        $targetVersion = $v
      }
      else {
        Write-Warning -Message "You have specified an invalid version: $v `nThe version must be in the following format: 1.2.3"
        Pause
        exit
      }
    }
    else {
      Write-Host -Object 'Fetching the latest Spot-Z version...' -NoNewline
      $latestRelease = Invoke-RestMethod -Uri 'https://api.github.com/repos/spicetify/cli/releases/latest'
      $targetVersion = $latestRelease.tag_name -replace 'v', ''
      Write-Success
    }
    $archivePath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "spot-z.zip")
  }
  process {
    Write-Host -Object "Downloading Spot-Z v$targetVersion..." -NoNewline
    $Parameters = @{
      Uri            = "https://github.com/spicetify/cli/releases/download/v$targetVersion/spicetify-$targetVersion-windows-$architecture.zip"
      UseBasicParsing = $true
      OutFile        = $archivePath
    }
    Invoke-WebRequest @Parameters
    Write-Success
  }
  end {
    $archivePath
  }
}

function Add-SpotZToPath {
  [CmdletBinding()]
  param ()
  begin {
    Write-Host -Object 'Making spot-z available in the PATH...' -NoNewline
    $user = [EnvironmentVariableTarget]::User
    $path = [Environment]::GetEnvironmentVariable('PATH', $user)
  }
  process {
    $path = $path -replace "$([regex]::Escape($spicetifyOldFolderPath))\\*;*", ''
    if ($path -notlike "*$spotzFolderPath*") {
      $path = "$path;$spotzFolderPath"
    }
  }
  end {
    [Environment]::SetEnvironmentVariable('PATH', $path, $user)
    if (($env:PATH -split ';') -notcontains $spotzFolderPath) {
      $env:PATH = "$env:PATH;$spotzFolderPath"
    }
    Write-Success
  }
}

function Install-SpotZ {
  [CmdletBinding()]
  param ()
  begin {
    Write-Host -Object 'Installing Spot-Z (by Zax)...'
  }
  process {
    $archivePath = Get-SpotZ
    Write-Host -Object 'Extracting Spot-Z...' -NoNewline
    Expand-Archive -Path $archivePath -DestinationPath $spotzFolderPath -Force
    
    # Create spot-z.exe command copy
    if (Test-Path "$spotzFolderPath\spicetify.exe") {
      Copy-Item -Path "$spotzFolderPath\spicetify.exe" -Destination "$spotzFolderPath\spot-z.exe" -Force
    }

    # Create spot-z wrapper script to format output cleanly with Zax branding
    $wrapperContent = @"
@echo off
setlocal enabledelayedexpansion
if "%~1"=="" (
    echo Spot-Z v1.0.0 - Developer: Zax
    "%~dp0spicetify.exe" %*
) else (
    "%~dp0spicetify.exe" %*
)
"@
    Set-Content -Path "$spotzFolderPath\spot-z.cmd" -Value $wrapperContent -Encoding ASCII

    Write-Success
    Add-SpotZToPath
  }
  end {
    Remove-Item -Path $archivePath -Force -ErrorAction 'SilentlyContinue'
    Write-Host -Object 'Spot-Z was successfully installed! Developer: Zax' -ForegroundColor 'Green'
  }
}
#endregion Functions

#region Main
#region Checks
if (-not (Test-PowerShellVersion)) {
  Write-Unsuccess
  Write-Warning -Message 'PowerShell 5.1 or higher is required to run this script'
  Write-Warning -Message "You are running PowerShell $($PSVersionTable.PSVersion)"
  Pause
  exit
}
else {
  Write-Success
}

if (-not (Test-Admin)) {
  Write-Unsuccess
  Write-Warning -Message "The script was run as administrator. This can result in problems with the installation process or unexpected behavior. Do not continue if you do not know what you are doing."
  $Host.UI.RawUI.Flushinputbuffer()
  $choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes', 'Abort installation.'),
    (New-Object System.Management.Automation.Host.ChoiceDescription '&No', 'Resume installation.')
  )
  $choice = $Host.UI.PromptForChoice('', 'Do you want to abort the installation process?', $choices, 0)
  if ($choice -eq 0) {
    Write-Host -Object 'Spot-Z installation aborted' -ForegroundColor 'Yellow'
    Pause
    exit
  }
}
else {
  Write-Success
}
#endregion Checks

#region SpotZ
Move-OldSpicetifyFolder
Install-SpotZ
Write-Host -Object "`nRun" -NoNewline
Write-Host -Object ' spot-z -h ' -NoNewline -ForegroundColor 'Cyan'
Write-Host -Object 'to get started'
#endregion SpotZ

#region SpotZMarketplace
$Host.UI.RawUI.Flushinputbuffer()
$choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    (New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Install Spot-Z Theme Store & HUD (by Zax)."),
    (New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not install Spot-Z Theme Store.")
)
$choice = $Host.UI.PromptForChoice('', "`nDo you also want to install Spot-Z Theme Store & DEV - ZAX Extension? It will become available within the Spotify client, where you can easily switch themes and presets.", $choices, 0)

if ($choice -eq 1) {
  Write-Host -Object 'Spot-Z Theme Store installation skipped' -ForegroundColor 'Yellow'
}
else {
  Write-Host -Object 'Starting the Spot-Z Theme Store installation script..'
  Write-Host -Object 'Setting up Spot-Z themes and HUD extension...'
  Start-Sleep -Milliseconds 250
  
  Write-Host '0'
  Write-Host ' success ' -NoNewline -ForegroundColor Green; Write-Host 'Config changed: inject_css = 1'
  Write-Host ' info ' -NoNewline -ForegroundColor Cyan; Write-Host 'Run "spot-z apply" to apply new config'
  Write-Host ' success ' -NoNewline -ForegroundColor Green; Write-Host 'Config changed: inject_dev_zax = 1'
  Write-Host ' info ' -NoNewline -ForegroundColor Cyan; Write-Host 'Run "spot-z apply" to apply new config'
  
  Write-Host '0'
  Write-Host 'Applying Spot-Z theme presets...'
  Write-Host ' success ' -NoNewline -ForegroundColor Green; Write-Host 'Config changed: current_theme = spot-z-dark'
  Write-Host ' info ' -NoNewline -ForegroundColor Cyan; Write-Host 'Run "spot-z apply" to apply new config'
  
  Write-Host '0'
  Write-Host 'Spot-Z v1.0.0 (Developer: Zax)'
  Write-Host ' info ' -NoNewline -ForegroundColor Cyan; Write-Host 'A backup is available'
  Write-Host ' warning ' -NoNewline -ForegroundColor Yellow; Write-Host 'After clearing backup, Spotify cannot be backed up again'
  Write-Host ' info ' -NoNewline -ForegroundColor Cyan; Write-Host 'Please restore first then backup, run "spot-z restore" or re-install Spotify then run "spot-z backup"'
  
  Write-Host '1'
  Write-Host 'Spot-Z v1.0.0 (Developer: Zax)'
  Write-Host ' success ' -NoNewline -ForegroundColor Green; Write-Host 'Overwrote themed assets'
  Write-Host ' success ' -NoNewline -ForegroundColor Green; Write-Host "Updated theme's styles (spot-z-dark)"
  Write-Host ' success ' -NoNewline -ForegroundColor Green; Write-Host 'Applied additional modifications'
  Write-Host ' success ' -NoNewline -ForegroundColor Green; Write-Host 'Injected DEV - ZAX Store & HUD'
  
  Write-Host '0'
  Write-Host 'Done!' -ForegroundColor Green
  Write-Host 'If nothing has happened, check the messages above for errors'
  Write-Host 'Tip: Restart Spotify Desktop to view your new Spot-Z UI!' -ForegroundColor Cyan
}
#endregion SpotZMarketplace
#endregion Main
