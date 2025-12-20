# PowerShell build script for Pidan Workshop (Windows compatible)
# Usage: .\build.ps1 -Task <task-name>

param(
    [Parameter(Position = 0)]
    [string]$Task = "help"
)

function Show-Help {
    Write-Host "Pidan Workshop Development Commands:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  .\build.ps1 dev         - Start development server"
    Write-Host "  .\build.ps1 serve       - Start Jekyll server (alias for dev)"
    Write-Host "  .\build.ps1 build       - Build the site for production"
    Write-Host "  .\build.ps1 clean       - Clean generated files"
    Write-Host "  .\build.ps1 help        - Show this help message"
    Write-Host ""
    Write-Host "Note: Using _plugins for multi-language generation" -ForegroundColor Gray
    Write-Host "      No need to run generate manually" -ForegroundColor Gray
    Write-Host ""
}

function Invoke-Dev {
    Write-Host "Starting development environment..." -ForegroundColor Green
    Write-Host "Jekyll will serve at http://localhost:4000"
    Write-Host "Multi-language pages will be generated automatically by plugin" -ForegroundColor Gray
    Write-Host ""
    bundle exec jekyll serve --livereload
}

function Invoke-Serve {
    Invoke-Dev
}

function Invoke-Build {
    Write-Host "Building site for production..." -ForegroundColor Green
    Write-Host "Multi-language pages will be generated automatically by plugin" -ForegroundColor Gray
    bundle exec jekyll build
}

function Invoke-Clean {
    Write-Host "Cleaning generated files..." -ForegroundColor Yellow
    
    # Remove directories if they exist
    if (Test-Path "_site") {
        Remove-Item -Recurse -Force "_site" -ErrorAction SilentlyContinue
        Write-Host "Removed _site"
    }
    
    if (Test-Path ".jekyll-cache") {
        Remove-Item -Recurse -Force ".jekyll-cache" -ErrorAction SilentlyContinue
        Write-Host "Removed .jekyll-cache"
    }
    
    Write-Host "Done!" -ForegroundColor Green
}

# Main task router
switch ($Task.ToLower()) {
    "help" { Show-Help }
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
