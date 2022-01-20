# powershell-export-registry

Mithilfe dieses Scripts lassen sich Elemente aus der Registry (HKU) auf einem Terminalserver exportieren.
Das Script überprüft, ob die Benutzer in $users noch angemeldet sind und in der Registry unter "HKEY_USERS\SID" eingebunden sind. Falls nicht, wird die NTUSER.DAT aus dem Benutzerprofil eingebunden und alle zuvor definierten Keys werden in den gewünschten Ordner exportiert.
