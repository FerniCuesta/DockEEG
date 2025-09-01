# PowerShell script to run Ubuntu container tests (Windows version)
param(
    [string]$BaseDir = "docker-examples/ubuntu-no-gpu",
    [string]$WorkDir = "",
    [string]$ResultsDir = "results",
    [string]$Exec = "bin/hpmoon",
    [string]$LogDir = "logs"
)

if (-not $WorkDir) { $WorkDir = "$BaseDir/Hpmoon" }
$Config = "$WorkDir/config.xml"
$Image = "ferniicueesta/hpmoon-ubuntu-no-gpu:v0.0.7-log"

# Test parameters
$ContainerList = @("docker", "podman")
$Nodes = @(1, 2, 4, 8, 16)
$ThreadsList = @(1, 2, 4, 8, 16)

# Create directories if they do not exist
New-Item -ItemType Directory -Path $ResultsDir -Force | Out-Null
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

foreach ($Container in $ContainerList) {
    $Results = "$ResultsDir/thread-sweep/windows_${Container}.csv"
    "nodes,threads,time,max_memory,cpu_percentage" | Set-Content $Results

    foreach ($Threads in $ThreadsList) {
        Write-Host "------------------------------------------------------------"
        $TotalThreads = $Threads * $Nodes[0]
        Write-Host "Starting test with $($Nodes[0]) nodes and $Threads threads ($Container, total threads: $TotalThreads)..."

        # Change the number of threads in the configuration file
        (Get-Content $Config) -replace '<CpuThreads>\d+</CpuThreads>', "<CpuThreads>$Threads</CpuThreads>" | Set-Content $Config

        # Change the logfile name to include the number of threads and container
        $LogFile = "$LogDir/thread-sweep/windows_${Container}_${Threads}threads.log"

        # Run the program in Docker or Podman and save the log
        Write-Host "Running the program in $Container and saving log to $LogFile"
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $mount = "$PWD\$Config" + ":/root/Hpmoon/config.xml"
        & $Container run --rm -v $mount $Image *>&1 | Tee-Object -FilePath $LogFile
        $sw.Stop()
        $elapsed = $sw.Elapsed.ToString()

        # Extract metrics from the log file (adjust patterns as needed)
        $logContent = Get-Content $LogFile
        $maxMemory = ($logContent | Select-String "Maximum resident set size" | ForEach-Object { $_.ToString().Split()[-1] }) -join ""
        $cpuPercentage = ($logContent | Select-String "Percent of CPU this job got" | ForEach-Object { $_.ToString().Split(":")[-1].Trim().TrimEnd("%") }) -join ""

        # Log the results
        "$Nodes,$Threads,$elapsed,$maxMemory,$cpuPercentage" | Add-Content $Results

        Write-Host "Test with $Threads threads ($Container) finished."
    }
}

Write-Host "------------------------------------------------------------"
Write-Host "All tests have finished. Results in $Results"
