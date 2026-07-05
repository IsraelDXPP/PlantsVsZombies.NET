param(
    [ValidateSet("PCDX", "PCGL", "All")]
    [string]$Target = "All",
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Debug",
    [switch]$NoRestore,
    [switch]$Publish
)

$ErrorActionPreference = "Stop"
$rootDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$projects = @{
    PCDX = "Lawn_PCDX\Lawn_PCDX.csproj"
    PCGL = "Lawn_PCGL\Lawn_PCGL.csproj"
}

function Build-Project {
    param($Name, $ProjectPath)
    
    Write-Host "`n============================================" -ForegroundColor Cyan
    Write-Host "Building $Name ($ProjectPath)" -ForegroundColor Cyan
    Write-Host "Configuration: $Configuration" -ForegroundColor Cyan
    Write-Host "============================================`n" -ForegroundColor Cyan
    
    $restoreArg = if ($NoRestore) { "--no-restore" } else { "" }
    
    if ($Publish) {
        dotnet publish $ProjectPath -c $Configuration $restoreArg
    } else {
        dotnet build $ProjectPath -c $Configuration $restoreArg
    }
    
    if ($LASTEXITCODE -ne 0) {
        throw "$Name build failed with exit code $LASTEXITCODE"
    }
    
    Write-Host "`n$Name built successfully!" -ForegroundColor Green
}

Write-Host "PlantsVsZombies.NET Auto-Compiler" -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Yellow

if ($Target -eq "All") {
    foreach ($entry in $projects.GetEnumerator()) {
        Build-Project -Name $entry.Key -ProjectPath $entry.Value
    }
} else {
    Build-Project -Name $Target -ProjectPath $projects[$Target]
}

Write-Host "`nAll builds completed successfully!" -ForegroundColor Green
