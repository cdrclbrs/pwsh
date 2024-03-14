$deviceName = [System.Net.Dns]::GetHostName()
$userName = [System.Environment]::UserName
$ipAddress = Test-Connection -ComputerName $deviceName -Count 1 | Select -ExpandProperty IPV4Address
$info = "Device Name: $deviceName`r`nUser Name: $userName`r`nIP Address: $ipAddress"
$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFile -Value $info
notepad $tempFile
