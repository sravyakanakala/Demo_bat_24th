$dataCollectorSetName = "MyDataCollectorSet"
$logPath = "C:\PerfData"
$logFile = "$logPath\$dataCollectorSetName.csv"
if (-not (Test-Path $logPath)) {
	New-Item -Path $logPath -ItemType Directory
}
$counters = @(
"\Processor(_Total)\% Processor Time",
"\Memory\Available Mbytes",
"\Network Interface(*)\Bytes Received/sec",
"\Network Interface(*)\Bytes Sent/sec",
"\Network Interface(*)\Bytes Total/sec",
"\Network Interface(*)\Output Queue Length",
"\PhysicalDisk(_Total)\% Idle Time",
"\PhysicalDisk(_Total)\Current Disk Queue Length",
"\PhysicalDisk(_Total)\Avg. Disk sec/Read",
"\PhysicalDisk(_Total)\Avg. Disk sec/Write"
)
$counterString = $counters
$intervalInSeconds = "1"
#$duration = "00:00:10" 
logman create counter $dataCollectorSetName -f csv -o $logFile -counters $counterString -s "localhost" -si $intervalInSeconds
#logman update counter $dataCollectorSetName -update $intervalInSeconds
logman start $dataCollectorSetName
Write-Host "Started the collector. Press 'Esc' to stop the data collection."
#Start-Sleep -Seconds ([TimeSpan]::Parse($duration).TotalSeconds)
while ($true) {
	$key = [System.Console]::ReadKey($true)
if ($key.Key -eq [System.ConsoleKey]::Escape) {
	logman stop $dataCollectorSetName
	Write-Host "Data Collection Stopped."
	break
	}
}
logman stop $dataCollectorSetName
Write-Host "Stopped the collector."





