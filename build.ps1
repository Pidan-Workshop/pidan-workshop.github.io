# PowerShell build script for Pidan Workshop (Windows compatible)
# Usage: .\build.ps1 -Task <task-name>

param(
    [Parameter(Position = 0)]
    [string]$Task = "help"
)

function Show-Help {
    Write-Host "Pidan Workshop Development Commands:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  .\build.ps1 generate    - Generate language-specific pages from templates"
    Write-Host "  .\build.ps1 dev         - Start development server with auto-regeneration"
    Write-Host "  .\build.ps1 serve       - Start Jekyll server only (without watching templates)"
    Write-Host "  .\build.ps1 build       - Build the site for production"
    Write-Host "  .\build.ps1 clean       - Clean generated files"
    Write-Host "  .\build.ps1 help        - Show this help message"
    Write-Host ""
}

function Invoke-Generate {
    Write-Host "Generating pages from templates..." -ForegroundColor Yellow
    ruby scripts/generate_pages.rb
}

function Invoke-CleanLanguages {
    Write-Host "Cleaning up temporary language directories..." -ForegroundColor Yellow
    if (Test-Path "en") {
        Remove-Item -Recurse -Force "en" -ErrorAction SilentlyContinue
        Write-Host "Removed en"
    }
    if (Test-Path "zh") {
        Remove-Item -Recurse -Force "zh" -ErrorAction SilentlyContinue
        Write-Host "Removed zh"
    }
}

function Invoke-Dev {
    try {
        Invoke-Generate
        Write-Host "Starting development environment..." -ForegroundColor Green
        Write-Host "Jekyll will serve at http://localhost:4000"
        Write-Host ""
        bundle exec jekyll serve --livereload
    }
    finally {
        Invoke-CleanLanguages
    }
}

function Invoke-Serve {
    Write-Host "Starting Jekyll server..." -ForegroundColor Green
    bundle exec jekyll serve --livereload
}

function Invoke-Build {
    Invoke-Generate
    Write-Host "Building site for production..." -ForegroundColor Green
    bundle exec jekyll build
    Invoke-CleanLanguages
}

function Invoke-Clean {
    Write-Host "Cleaning generated files..." -ForegroundColor Yellow
    
    # Remove directories if they exist
    if (Test-Path "_site") {
        Remove-Item -Recurse -Force "_site" -ErrorAction SilentlyContinue
        Write-Host "Removed _site"
    }
    
    Invoke-CleanLanguages
    
    Write-Host "Done!" -ForegroundColor Green
}

# Main task router
switch ($Task.ToLower()) {
    "help" { Show-Help }
    "generate" { Invoke-Generate }
    "dev" { Invoke-Dev }
    "serve" { Invoke-Serve }
    "build" { Invoke-Build }
    "clean" { Invoke-Clean }
    default {
        Write-Host "Unknown task: $Task" -ForegroundColor Red
        Write-Host ""
        Show-Help
        exit 1
    }
}
