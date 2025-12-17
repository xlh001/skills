<#
GudaCC Skills Installer (Windows)
https://github.com/GuDaStudio/skills
#>

$ErrorActionPreference = "Stop"

# Colors
function Write-Color($Color, $Text) {
    Write-Host $Text -ForegroundColor $Color
}

# Available skills
$AVAILABLE_SKILLS = @(
    "collaborating-with-codex",
    "collaborating-with-gemini"
)

# Script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

function Usage {
    Write-Color Cyan "GudaCC Skills Installer (Windows)"
    Write-Host ""
    Write-Host "Usage: .\install.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -u, --user              Install to user-level (~\.claude\skills\)"
    Write-Host "  -p, --project           Install to project-level (.\.claude\skills\)"
    Write-Host "  -t, --target <path>     Install to custom target path"
    Write-Host "  -a, --all               Install all available skills"
    Write-Host "  -s, --skill <name>      Install specific skill (can be used multiple times)"
    Write-Host "  -l, --list              List available skills"
    Write-Host "  -h, --help              Show this help message"
    Write-Host ""
    Write-Host "Available skills:"
    $AVAILABLE_SKILLS | ForEach-Object { Write-Host "  - $_" }
}

function List-Skills {
    Write-Color Cyan "Available Skills:`n"
    foreach ($skill in $AVAILABLE_SKILLS) {
        $path = Join-Path $SCRIPT_DIR $skill
        if (Test-Path $path) {
            Write-Color Green "  ✓ $skill"
        } else {
            Write-Color Red "  ✗ $skill (not found in source)"
        }
    }
}

function Install-Skill($Skill, $TargetDir) {
    $SourceDir = Join-Path $SCRIPT_DIR $Skill
    $DestDir   = Join-Path $TargetDir $Skill

    if (-not (Test-Path $SourceDir)) {
        throw "Skill '$Skill' not found in source directory"
    }

    Write-Color Cyan "Installing $Skill -> $DestDir"

    if (Test-Path $DestDir) {
        Write-Color Yellow "  Removing existing installation..."
        Remove-Item -Recurse -Force $DestDir
    }

    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    Copy-Item -Recurse -Force $SourceDir $DestDir

    $GitPath = Join-Path $DestDir ".git"
    if (Test-Path $GitPath) {
        Remove-Item -Recurse -Force $GitPath
    }

    Write-Color Green "  ✓ Installed"
}

# ------------------------
# Argument parsing
# ------------------------
$TARGET_PATH = $null
$INSTALL_ALL = $false
$SELECTED_SKILLS = @()
$SCOPE = $null

$argsList = $args
for ($i = 0; $i -lt $argsList.Count; $i++) {
    switch ($argsList[$i]) {

        "-u" {
            if ($SCOPE) { throw "Only one install scope allowed" }
            $SCOPE = "user"
            $TARGET_PATH = Join-Path $HOME ".claude\skills"
        }
        "--user" {
            if ($SCOPE) { throw "Only one install scope allowed" }
            $SCOPE = "user"
            $TARGET_PATH = Join-Path $HOME ".claude\skills"
        }

        "-p" {
            if ($SCOPE) { throw "Only one install scope allowed" }
            $SCOPE = "project"
            $TARGET_PATH = ".\.claude\skills"
        }
        "--project" {
            if ($SCOPE) { throw "Only one install scope allowed" }
            $SCOPE = "project"
            $TARGET_PATH = ".\.claude\skills"
        }

        "-t" {
            if ($SCOPE) { throw "Only one install scope allowed" }
            if (-not $argsList[$i+1]) { throw "--target requires a path" }
            $SCOPE = "custom"
            $TARGET_PATH = $argsList[++$i]
        }
        "--target" {
            if ($SCOPE) { throw "Only one install scope allowed" }
            if (-not $argsList[$i+1]) { throw "--target requires a path" }
            $SCOPE = "custom"
            $TARGET_PATH = $argsList[++$i]
        }

        "-a" { $INSTALL_ALL = $true }
        "--all" { $INSTALL_ALL = $true }

        "-s" {
            if (-not $argsList[$i+1]) { throw "--skill requires a name" }
            $SELECTED_SKILLS += $argsList[++$i]
        }
        "--skill" {
            if (-not $argsList[$i+1]) { throw "--skill requires a name" }
            $SELECTED_SKILLS += $argsList[++$i]
        }

        "-l" { List-Skills; exit 0 }
        "--list" { List-Skills; exit 0 }

        "-h" { Usage; exit 0 }
        "--help" { Usage; exit 0 }

        default {
            throw "Unknown option: $($argsList[$i])"
        }
    }
}

if (-not $TARGET_PATH) {
    throw "Please specify installation target (-u, -p, or -t)"
}

if (-not $INSTALL_ALL -and $SELECTED_SKILLS.Count -eq 0) {
    throw "Please specify skills to install (-a or -s)"
}

$SKILLS_TO_INSTALL = if ($INSTALL_ALL) { $AVAILABLE_SKILLS } else { $SELECTED_SKILLS }

foreach ($skill in $SKILLS_TO_INSTALL) {
    if ($AVAILABLE_SKILLS -notcontains $skill) {
        throw "Unknown skill '$skill'"
    }
}

Write-Color Cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Color Cyan "GudaCC Skills Installer (Windows)"
Write-Color Cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""
Write-Color Green "Target: $TARGET_PATH"
Write-Color Green "Skills: $($SKILLS_TO_INSTALL -join ' ')"
Write-Host ""

foreach ($skill in $SKILLS_TO_INSTALL) {
    Install-Skill $skill $TARGET_PATH
}

Write-Host ""
Write-Color Green "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Color Green "Installation complete!"
Write-Color Green "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
