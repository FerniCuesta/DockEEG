param(
    [string]$BaseDir = "docker-examples/ubuntu-no-gpu",
    [string]$WorkDir = "",
    [string]$ResultsDir = "results",
    [string]$Exec = "bin/hpmoon",
    [string]$LogDir = "logs"
)

if (-not $WorkDir) { $WorkDir = "$BaseDir/Hpmoon" }
$Config = "$WorkDir/config.xml"
$Image = "ferniicueesta/hpmoon-ubuntu-no-gpu:v0.0.7"

$ContainerList = @("docker", "podman")
$NodesList = @(1, 2, 4, 8, 16)
$ThreadsList = @(1, 2, 4, 8, 16)

# Create directories if they do not exist
New-Item -ItemType Directory -Path $ResultsDir -Force | Out-Null
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

foreach ($Container in $ContainerList) {
    $Results = "$ResultsDir/thread-sweep/windows_${Container}.csv"
    "nodes,threads,time" | Set-Content $Results

    foreach ($Nodes in $NodesList) {
        foreach ($Threads in $ThreadsList) {
            $TotalThreads = $Nodes * $Threads

            Write-Host "------------------------------------------------------------"
            Write-Host "Starting test with $Nodes nodes and $Threads threads ($Container, total threads: $TotalThreads)..."

            # Update the number of threads in the XML configuration file
            (Get-Content $Config) -replace '<CpuThreads>\d+</CpuThreads>', "<CpuThreads>$Threads</CpuThreads>" | Set-Content $Config

            # Build the hosts string
            $Hosts = [string]::Join(",", (1..$Nodes | ForEach-Object { "localhost" }))

            $LogFile = "$LogDir\thread-sweep\windows_${Container}_${Nodes}nodes_${Threads}threads.log"
            New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force | Out-Null

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

            & $Container @dockerArgs *>&1 | Tee-Object -FilePath $LogFile

            $endTime = Get-Date
            $elapsed = $endTime - $startTime
            $time = $elapsed.TotalSeconds

            # Write metrics to the results file
            Write-Host "Writing metrics in $Results"

            "$Nodes,$Threads,$time" | Add-Content $Results

            Write-Host "Test with $Nodes nodes and $Threads threads ($Container) finished."
        }
    }
}

Write-Host "------------------------------------------------------------"
Write-Host "All Ubuntu thread-sweep container tests have finished. Results in $Results"