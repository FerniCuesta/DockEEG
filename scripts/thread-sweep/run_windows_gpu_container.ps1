# PowerShell script to run Ubuntu container tests (Windows version)
param(
    [string]$BaseDir = "docker-examples/ubuntu-gpu",
    [string]$WorkDir = "",
    [string]$ResultsDir = "results",
    [string]$Exec = "bin/hpmoon",
    [string]$LogDir = "logs"
)

if (-not $WorkDir) { $WorkDir = "$BaseDir/Hpmoon" }
$Config = "$WorkDir/config.xml"
$Image = "ferniicueesta/hpmoon-ubuntu-gpu:v0.0.1-log"

# Test parameters
$ContainerList = @("docker", "podman")
$Nodes = @(1, 2, 4, 8, 16)
$ThreadsList = @(1, 2, 4, 8, 16)

# Create directories if they do not exist
New-Item -ItemType Directory -Path $ResultsDir -Force | Out-Null
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

foreach ($Container in $ContainerList) {
    $Results = "$ResultsDir/thread-sweep/windows_gpu_${Container}.csv"
    "nodes,threads,time_seconds" | Set-Content $Results

    foreach ($NodesCount in $Nodes) {
        foreach ($Threads in $ThreadsList) {
            Write-Host "------------------------------------------------------------"
            $TotalThreads = $NodesCount * $Threads
            Write-Host "Starting test with $NodesCount nodes and $Threads threads ($Container, total threads: $TotalThreads)..."

            # Change the number of threads in the configuration file
            (Get-Content $Config) -replace '<CpuThreads>\d+</CpuThreads>', "<CpuThreads>$Threads</CpuThreads>" | Set-Content $Config

            # Build the hosts string
            $Hosts = [string]::Join(",", (1..$NodesCount | ForEach-Object { "localhost" }))

            # Change the logfile name to include the number of threads, nodes, and container
            $LogFile = "$LogDir/thread-sweep/windows_gpu_${Container}_${NodesCount}nodes_${Threads}threads.log"

            Write-Host "Running the program in $Container and saving log to $LogFile"
            $mount = "$PWD\$Config" + ":/root/Hpmoon/config.xml"
            $dockerArgs = @(
                "run", "--rm",
                "-v", $mount,
                "-w", "/root/Hpmoon",
                $Image,
                "mpirun", "--bind-to", "none", "--allow-run-as-root", "--map-by", "node",
                "--host", $Hosts,
                "./bin/hpmoon", "-conf", "config.xml"
            )
            $startTime = Get-Date

            # Run the container and capture output
            $output = & $Container @dockerArgs *>&1 | Tee-Object -FilePath $LogFile

            $endTime = Get-Date
            $elapsed = $endTime - $startTime
            $TimeSeconds = $elapsed.TotalSeconds

            # Write metrics to the results file
            Write-Host "Writing metrics in $Results"
            "$NodesCount,$Threads,$TimeSeconds" | Add-Content $Results

            Write-Host "Test with $NodesCount nodes and $Threads threads ($Container) finished."
        }
    }
}

Write-Host "------------------------------------------------------------"
Write-Host "All tests have finished. Results in $Results"
