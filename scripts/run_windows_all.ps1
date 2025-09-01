# PowerShell script to run all Windows test scripts (multi BASE_DIR)

# Configuration
$BaseDirNoGpu = "docker-examples/ubuntu-no-gpu"
$BaseDirGpu = "docker-examples/ubuntu-gpu"
$ResultsDir = "results"
$Exec = "bin/hpmoon"
$LogDir = "logs"

# Script list with associated BASE_DIR
$ScriptsAndBaseDirs = @(
    # @{ Script = ".\scripts\thread-sweep\run_windows_container.ps1"; BaseDir = $BaseDirNoGpu }
    @{ Script = ".\scripts\thread-sweep\run_windows_gpu_container.ps1"; BaseDir = $BaseDirGpu }
)

# Execute script list
foreach ($entry in $ScriptsAndBaseDirs) {
    $script = $entry.Script
    $baseDir = $entry.BaseDir
    $workDir = "$baseDir\Hpmoon"
    $params = @($baseDir, $workDir, $ResultsDir, $Exec, $LogDir)
    & $script @params
}

Write-Host "All scripts have finished."