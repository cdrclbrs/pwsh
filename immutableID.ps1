# Title: Immutable ID checker
# Author: cdrc lbrs
# Contact: [email protected]
# Date Created: 2023-11-16
# Date Modified: 2023-11-16
# Version: 1.0
# Synopsis: This script compare immutable ID and propose and update if mismatch detected
# Description: It takes as entry a user principal name and then looks for msDSconsistencyGUID on the on-prem AD, the it converts it to base64 format and compare it to the same UPN synced on the CLoud (Azure). If a mismatch is detected it propose to copy the new value from on-prem to cloud
# Disclaimer: This script is provided as-is, with no warranties or guarantees.

Import-Module ActiveDirectory
Import-Module AzureAD
#Connect-AzureAD

function Compare-UIDs {
    param (
        [string]$uid1,
        [string]$uid2,
        [string]$userObjectId
    )

    if ($uid1 -eq $uid2) {
        Write-Host "MATCH" -ForegroundColor White -BackgroundColor Green
    } else {
        Write-Host "Mismatch!" -ForegroundColor Red 
        $response = Read-Host "Do You Want to Fix it? (Y/N)"
        if ($response -eq 'Y') {
            Set-AzureADUser -ObjectId $userObjectId -ImmutableId $uid2
            Write-Host "Immutable ID updated for the user." -ForegroundColor Green
        }
    }
}

do {
    $domain = Read-Host -Prompt "Enter the domain name (e.g., europe.quiksilver.corp)"
    $UserPrincipalName = Read-Host -Prompt "Enter the SAM Account Name"

    Write-Progress -Activity "Retrieving User Information" -Status "Please wait..."

    $msDSGuid = Get-ADuser -Filter {mail -like $UserPrincipalName} -Server $domain -Properties samaccountname,UserPrincipalName,mS-DS-ConsistencyGuid | Select-Object samaccountname,UserPrincipalName, @{N="mS-DS-ConsistencyGuid";E={$_.'mS-DS-ConsistencyGuid'}}

    $hexString = ($msDSGuid.'mS-DS-ConsistencyGuid' | ForEach-Object { $_.ToString("X2") }) -join " "
    $cleanHexString = $hexString.Replace(" ", "")
    $byteArray = [byte[]]::new(($cleanHexString.Length / 2))
    for ($i = 0; $i -lt $byteArray.Length; $i++) {
        $byteArray[$i] = [Convert]::ToByte($cleanHexString.Substring($i * 2, 2), 16)
    }
    $base64String = [System.Convert]::ToBase64String($byteArray)

    $userAD = Get-AzureADUser -ObjectId $UserPrincipalName
    if ($null -eq $userAD) {
        Write-Host "User not found on AAD. Please check the Sync or User Principal Name."
    } else {
        Write-Host "Immutable ID for User: $UserPrincipalName"
        Write-Host "------------------------------------------"
        $immutableId = $userAD.ImmutableId
        Write-Host "Azure AD Immutable ID : $immutableId" -ForegroundColor White -BackgroundColor Blue
        Write-Host "Source Anchor (Base64): $base64String" -ForegroundColor White -BackgroundColor DarkMagenta
        Compare-UIDs -uid1 $immutableId -uid2 $base64String -userObjectId $userAD.ObjectId
    }

    Write-Progress -Activity "Retrieving User Information" -Status "Completed" -Completed
    $userChoice = Read-Host "Press 1 to scan another UserName, Press 2 to quit"

    if ($userChoice -eq '2') {
        Clear-Host
        break
    }
} while ($userChoice -eq '1')
 
