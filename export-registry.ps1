# ==============================================================================================
# Export HKEY_USERS to .reg File in D:\Folder_XXX
# Hecktor95 01.12.2021 Version 1.04
# ==============================================================================================

# Mount HKU in Powershell
New-PSDrive -PSProvider Registry -Name HKU_Mount_Name -Root HKEY_USERS

#Create Fodler for Export
$null = New-Item -ItemType Directory -Path "D:\Folder_XXX\$((Get-Date).ToString('yyyy-MM-dd'))" 

#Benutzer-SID ohne die Benutzerkennung (letzte Stellen)
$SID = "S-X-X-XX-XXXXXXXXXX-XXXXXXXX-XXXXXXXXXX-"

#Hier alle Benutzernamen (AD) auflisten, die für den Export berücksichtigt werden sollen
$users = @("USER_A","USER_B","USER_B")

#Andhand des Usernamens nun die SID herausfinden
Foreach ($i in $users) {
$strSID = (New-Object System.Security.Principal.NTAccount("$i")).Translate([System.Security.Principal.SecurityIdentifier]).Value
#Nun die SID beschneiden, sodass nur die letzten Stellen übrig bleiben (Benutzerkennung)
$strSID_ID = $strSID.Replace("S-X-X-XX-XXXXXXXXXX-XXXXXXXX-XXXXXXXXXX-","")

#Pfadvariable
$Pfad_Test = "HKU_Mount_Name:\" +$SID
$Pfad_Test_merge = $Pfad_Test + $strSID_ID
#Pfad-Test ob der User noch angemeldet und ob noch in Registry vorhanden ist, wenn nicht, dann ELSE 
$Pfad_Test_Users = test-path "$Pfad_Test_merge" 


If ($Pfad_Test_Users -eq $true) {
$strExportRegKey1 = "HKEY_USERS\" +$SID   
$strExportRegKey2 = "\Software\XXX\XXX\XXX" 
$strExportRegKey3 = $strExportRegKey1 + $strSID_ID + $strExportRegKey2 
$strExportPath = "D:\Folder_XXX\$((Get-Date).ToString('yyyy-MM-dd'))" 
$strExportFileName = "backup_XXX_" +$strSID_ID +".reg"

reg export $strExportRegKey3 $strExportPath\$strExportFileName
}ELSE{
#Wenn User bereits abgemeldet ist, dann wird die NTUSER.DAT aus dem Benutzerverzeichnis gemountet und das Backup erstellt. Danach unmount
    $strExportRegKeyElse1 = "HKU\backup_winout-" 
    $strExportRegKeyElse2 = "\Software\XXX\XXX\XXX"
    $strExportRegKeyElse3 = $strExportRegKeyElse1 +$strSID_ID +$strExportRegKeyElse2
    $strExportPathElse = "D:\Folder_XXX\$((Get-Date).ToString('yyyy-MM-dd'))" 
    $strExportFileNameElse1 = "backupXXXt-"
    $strExportFileNameElse2 = "-ntuser.reg"
    $strExportFileNameElse3 = $strExportFileNameElse1 +$strSID_ID +$strExportFileNameElse2
    $strExportFileNameElse4 = $strExportFileNameElse1 +$strSID_ID
    $strExportFileNameElse5 = "HKU\" +$strExportFileNameElse4
    $strExportntuserSIDElse = $SID +$strSID_ID
    $strExportntuserElse1 = "C:\Users\"
    $strExportntuserElse2 = "\NTUSER.DAT"
    $strSID = ((New-Object System.Security.Principal.SecurityIdentifier($strExportntuserSIDElse)).Translate([System.Security.Principal.NTAccount]).Value)
    $strSIDName = $strSID.Replace("DELTAT\","")
    $strExportntuserElse3 = $strExportntuserElse1 +$strSIDName +$strExportntuserElse2

    reg load $strExportFileNameElse5 $strExportntuserElse3
    reg export $strExportRegKeyElse3 $strExportPathElse\$strExportFileNameElse3
    reg unload $strExportFileNameElse5
}
}
Remove-PSDrive -Name HKU_Mount_Name 
