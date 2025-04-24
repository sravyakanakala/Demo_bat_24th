$filePath = "C:\StartEventScripterRemote\ActiveHostMapping.txt"

$machines = Get-Content -Path $filePath | Select-Object -First 1

if ($machines -match ",") {
$parts = $machines -split ","
$ipAddress = $parts[0].Trim()
$password = $parts[1].Trim()

$trustedHosts = ($ipAddress -join ',')
Write-Host "Adding the following machines to the TrustedHosts list"

try {

     Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force
	Write-Host "Successfully updated the TrustedHosts list"
}  catch {
	Write-Host "Failed to Update TrustedHosts list"
}
} else {
	Write-Host "File not found"
}
Get-Item -Path WSMan:\localhost\Client\TrustedHosts

$User = "Administrator"

$SecurePassword = ConvertTo-SecureString "$Password" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($User, $SecurePassword)

Enter-PSSession -ComputerName $ipAddress -Credential $credential -ErrorAction Stop 
Test-Connection -ComputerName $ipAddress -Count 2




C:\StartEventScripterRemote\addLog.ps1 -logToWrite "Copying Event Scripter file $eventScriptFile to $hostname..."

$eventScriptFile = "FI_AllCustomers_20_script.xml"

$test_script = "C:\Users\Administrator\Documents\UIScripts\$eventScriptFile"

#$remoteSession = New-PSSession $hostName -Credential $Credential
#$remoteLocation = "C:\Users\Administrator\Documents\UIScripts"
#Copy-Item -Path $test_script  -ToSession $remoteSession -Destination $remoteLocation

#Remove-PSSession -Session $remoteSession

C:\StartEventScripterRemote\addLog.ps1 -logToWrite "Starting Event Scripter on $hostname using storm script $eventScriptFile..."

$block = {
    
    param($scriptName)

    $task_name = "EventScripter"
    $toolLocation  = "C:\eterra\Distribution\Client\bin\EventScripter.exe"
    $scriptLocation = "C:\Users\Administrator\Documents\FI_AllCustomers_20_script.xml"
    $netconfLocation = "C:\eterra\Distribution\FantasyIsland\config\client\netconfes_EC2AMAZ-081HM05.xml"

        
    $proc = get-process -Name $task_name -ErrorAction SilentlyContinue

    if ($proc -ne $null)
    {
        Write-Host "Event Scripter is found to be already running. Stopping it..."

        stop-Process -Name $task_name
    }

    Write-Host "Event Scripter is started. Running the script...."

    Start-Process -FilePath $toolLocation -ArgumentList "/NETCONF `"$netconfLocation`" /SCRIPT `"$scriptLocation`" /BATCH" -Wait -Verbose
    #Start-Process -FilePath $toolPath -Wait -Verbose
}

Invoke-Command -ComputerName $ipAddress -Credential $Credential -Command $block -ArgumentList $eventScriptFile  -Verbose

C:\StartEventScripterRemote\addLog.ps1 -logToWrite "Event Scripter run completed on $hostname..."