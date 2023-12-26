$Passwrod        = ""
$Username        = "cvega@inka628.onmicrosoft.com"
$EnvironmentName = "Default-7d404e27-f3ba-42fc-b5b6-4ec755d91974"
try{ 
Write-Host “Connecting Target Instance of PowerApps.” 
$pass = ConvertTo-SecureString $Passwrod -AsPlainText -Force 
Add-PowerAppsAccount -Username $Username -Password $pass 
Write-Host “Successfully Target Instance connected.” 
} 
catch 
{ 
Write-host $_.Exception.Message 
} 
try{ 
Write-Host “Connecting Environment.” 
$en=”$EnvironmentName” 
$environmentName=Get-PowerAppEnvironment $en | Select -ExpandProperty EnvironmentName 
Write-Host “Connected Environment.” $environmentName 
Get-FlowEnvironment $environmentName 
} 
catch 
{ 
Write-host $_.Exception.Message 
} 
$listOfMsFlow=""; 
$listOfMsFlow=Get-Flow -EnvironmentName $environmentName |where-object {!($_.Enabled -eq "True")} |Select FlowName 
$count=1;
foreach ($flow in $listOfMsFlow)
{ 
    try{
    Write-Host “Flow Name:” $flow.FlowName $count 
    Enable-AdminFlow -EnvironmentName $environmentName -FlowName $flow.FlowName 
    $count=$count+1; 
    } 
catch 
{ 
    Write-Host "Failed to Turn On." $flow.FlowName 
    Write-host $_.Exception.Message 
} 
}
