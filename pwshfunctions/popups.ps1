function ChooseInstallation ($INSTALLITEM){
    [void][System.Windows.MessageBox]::Show( "Start installation ...", "$INSTALLITEM", 0 )
}

function InstallationFinished ($INSTALLITEM){
    [void][System.Windows.MessageBox]::Show( "Finished installation ...", "$INSTALLITEM", 0 )
}