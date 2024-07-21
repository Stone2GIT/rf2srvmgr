function InstallSteamCMD {

$statusLabel.Text = "Please wait until finished ..."

    $shell = New-Object -ComObject Shell.Application
    $STEAMINSTALLDIR = $shell.BrowseForFolder( 0, 'Select a folder to install', 16, $shell.NameSpace( 17 ).Self.Path ).Self.Path

        if ( "$STEAMINSTALLDIR" )
        {

       if ("$STEAMINSTALLDIR" -eq "") { . "$CURRENTLOCATION\variables.ps1" }

    #ChooseInstallation "SteamCMD"
    
    #
    # get steamcmd from the web
    $textBox.Text = "Starting SteamCMD installation."

    $textBox.AppendText("`r`n`r`nDownloading SteamCMD")
    start-process -FilePath powershell -ArgumentList "Invoke-RestMethod -Uri https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -OutFile $STEAMINSTALLDIR\steamcmd.zip" -NoNewWindow -Wait

    $textBox.AppendText("`r`nExtracting SteamCMD.")
    start-process -FilePath powershell -ArgumentList "Expand-Archive -Force $STEAMINSTALLDIR\steamcmd.zip -DestinationPath ""$STEAMINSTALLDIR""" -NoNewWindow -Wait

    (get-content "$CURRENTLOCATION\variables.ps1") -replace "STEAMINSTALLDIR=.*","STEAMINSTALLDIR=""$STEAMINSTALLDIR""" | set-content -Path "$CURRENTLOCATION\variables.ps1"
    #Add-Content -Path $pwd\variables_source_file-neu.ps1 -Value "`$STEAMINSTALLDIR=""$STEAMINSTALLDIR""" -Encoding ASCII

    #start-process -FilePath powershell -ArgumentList "$STEAMINSTALLDIR\steamcmd +login anonymous +quit" -NoNewWindow -Wait

    #InstallationFinished "SteamCMD"

    $textBox.AppendText("`r`n`r`nFinished SteamCMD installation.")

}
else { $textBox.Text = "Installation of SteamCMD canceled." }

$statusLabel.Text = "Finished."

}
