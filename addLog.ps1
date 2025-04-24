Param([string]$logToWrite)


<#*******************************************
	Script to write to log file
*********************************************#>



$logFile = "C:\StartEventScripterRemote\perflog.txt"

$dt = (Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt')

"`n$dt : $logToWrite" | Add-Content $logFile