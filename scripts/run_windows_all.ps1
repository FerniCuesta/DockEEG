# PowerShell script to run all Windows test scripts

# Configuration
$BaseDir = "docker-examples/ubuntu-no-gpu"
$WorkDir = "$BaseDir/Hpmoon"
$ResultsDir = "results"
$Exec = "bin/hpmoon"
$LogDir = "logs"

# Parameters
$Params = "$BaseDir $WorkDir $ResultsDir $Exec $LogDir"

# Script list
$Scripts = @(
    ".\scripts\single-node\run_windows_container.ps1"
    # ".\scripts\multi-node\run_windows_container.ps1"
    # ".\scripts\thread-sweep\run_windows_container.ps1"
)

# Execute script list
foreach ($script in $Scripts) {
    & $script $BaseDir $WorkDir $ResultsDir $Exec $LogDir
}

Write-Host "All scripts have finished."