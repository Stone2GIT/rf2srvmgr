function InstallDS {

$statusLabel.Text = "Please wait until finished ..."

    $shell = New-Object -ComObject Shell.Application
    $RF2INSTALLDIR = $shell.BrowseForFolder( 0, 'Select a folder to install', 16, $shell.NameSpace( 17 ).Self.Path ).Self.Path

    if ( "$RF2INSTALLDIR" )
        {

    if ("$RF2INSTALLDIR" -eq "") { . "$RF2SRVMGRDIR\variables_source_file.ps1" }
       

    #ChooseInstallation "rFactor 2 Dedicated Server"

    $textBox.Text = "Starting rF2 dedicated server installation"

    #
    # installing rf2 dedicated server
    $textBox.AppendText("`r`n`r`nDownloading and extracting rFactor 2 dedicated server by SteamCMD")
    start-process $STEAMINSTALLDIR\steamcmd "+force_install_dir $RF2INSTALLDIR +login anonymous +app_update 400300 -beta $RF2BETAVERSION +quit 1> _output.txt 2>&1" -nonewwindow -wait|out-null
        
    (get-content "$RF2SRVMGRDIR\variables_source_file.ps1") -replace "RF2INSTALLDIR=.*","RF2INSTALLDIR=""$RF2INSTALLDIR""" | set-content -Path "$RF2SRVMGRDIR\variables_source_file.ps1"
    #Add-Content -Path $pwd\variables_source_file.ps1 -Value -Value "`$RF2INSTALLDIR=""$RF2INSTALLDIR""" -Encoding ASCII

    #
    # installing vcredist
    $textBox.AppendText("`r`nInstalling libc from rFactor 2 Dedicated Server tools directory (you will be asked for admin pw twice")
    start-process $RF2INSTALLDIR\support\runtimes\vcredist_2012_x64.exe " /install /quiet /log $HOME\Documents\vcredist2012.log" -Verb runAs -wait 
    start-process $RF2INSTALLDIR\support\runtimes\vcredist_2013_x64.exe " /install /quiet /log $HOME\Documents\vcredist2013.log" -Verb runAs -wait


    #
# taken from https://techexpert.tips/de/powershell-de/powershell-erstellen-einer-verknuepfung-unter-windows/
$textBox.AppendText("`r`nGenerating rFactor 2 dedicated server shortcut.")
$LNKFILE = "$RF2INSTALLDIR\bin64\rFactor2 Dedicated.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$LNKFILE")
$Shortcut.TargetPath = "$RF2INSTALLDIR\bin64\rfactor2 dedicated.exe"
$Shortcut.Arguments = "+path="".."""
$Shortcut.WorkingDirectory = "$RF2INSTALLDIR\bin64"
$Shortcut.Save()

$textBox.AppendText("`r`nDownloading car and track for initial mod.")

start-process $STEAMINSTALLDIR\steamcmd "+login anonymous +workshop_download_item 365960 2362626369 +quit" -nonewwindow -wait
start-process $STEAMINSTALLDIR\steamcmd "+login anonymous +workshop_download_item 365960 917386837 +quit" -nonewwindow -wait

$textBox.AppendText("`r`nStarting Mod Manager in order to set modmgr folders (closing in a couple of seconds).")
start-process $RF2INSTALLDIR\bin64\modmgr.exe "-q -c""$RF2INSTALLDIR"" "
#
# wait 10 seconds for start
timeout /t 5|out-null

#
# killing modmgr will write back path information
$textBox.AppendText("`r`nClosing mod manager.")
taskkill /IM modmgr.exe|out-null

#
# running extractor ...
$textBox.AppendText("`r`nExtracting and installing car and track package for initial mod.")
& $RF2SRVMGRDIR\helper\rfcmp_extractor.ps1|out-null

#
# we change dir which saves some options on modmgr
cd $RF2INSTALLDIR

#
# delete some files
#rm Packages\dummy.*

#
# create a dummy pkginfo.dat
$textBox.AppendText("`r`nGenerating info file for initial mod.")
$PKGINFO=@"
[Package]
Name=dummy
Type=0
Version=1.0
BaseVersion=
MinVersion=
Author=Stone of SRJF
Date=133380828671940000
ID=AAA9999
URL=simracingjustfair.org
Desc=Dummy mod from rFactor 2 dedicated server manager
Category=0
Origin=0
Flags=0
CurLocation=0
NumLocations=1
Location=$RF2INSTALLDIR\Packages\dummy.rfmod
CurRFM=0
NumRFM=1
RFM=$RF2INSTALLDIR\Packages\dummy.mas
NumTrackFiles=1
Track="AtlantaMP_2014 v1.31,0" "AtlantaMP -- Kart Layout A,0" "AtlantaMP -- Kart Layout B,0" "AtlantaMP -- Kart Layout B +,0" "AtlantaMP -- Kart Layout C,0" "AtlantaMP -- Race Track,1"
NumVehicleFiles=1
Vehicle="ER_AlpineSeries_rF2 v2.00,0" "18CUP| #02 Team CMR-CFF,1" "18CUP| #04 Racing Technology,1" "18CUP| #14 Autosport GP,1" "18CUP| #15 Milan Competition,1" "18CUP| #17 Autosport GP,1" "18CUP| #18 Autosport GP,1" "18CUP| #33 Team CMR GRR,1" "18CUP| #69 Autosport GP,1" "18CUP| #76 Team CMR,1" "18GT4FRA| #026 Team CMR,1" "18GT4FRA| #036 Team CMR,1" "18GT4FRA| #061 Zentech Sport,1" "18GT4INT| #036 Team CMR,1" "19CUP| #04 Racing Technology,1" "19CUP| #05 Racing Technology,1" "19CUP| #06 Milan Competition,1" "19CUP| #09 Milan Competition,1" "19CUP| #11 Racing Technology,1" "19CUP| #15 Team CMR,1" "19CUP| #21 Milan Competition,1" "19CUP| #29 Milan Competition,1" "19CUP| #64 Team CMR,1" "19GT4EUR| #009 Team CMR,1" "19GT4EUR| #048 Team CMR,1" "19GT4FRA| #002 Team Speed Car,1" "19GT4FRA| #007 Team Speed Car,1" "19GT4FRA| #008 Team Speed Car,1" "19GT4FRA| #035 Bodemer Auto,1" "19GT4FRA| #036 Team CMR,1" "19GT4FRA| #061 Zentech Sport,1" "19GT4FRA| #076 Bodemer Auto,1" "19GT4FRA| #616 Mirage Racing,1" "19GT4FRA| #919 Mirage Racing,1" "20CUP| #03 Racing Technology,1" "20CUP| #06 Tierce Racing,1" "20CUP| #44 Autosport GP,1" "20CUP| #69 Autosport GP,1" "20GT4FRA| #008 Speed Car,1" "20GT4FRA| #022 Mirage Racing,1" "20GT4FRA| #036 Team CMR,1" "20GT4FRA| #060 Team CMR,1" "21CUP| #001 Autosport GP,1" "21CUP| #002 BL Sport,1" "21CUP| #003 Chazel Technologie Course,1" "21CUP| #005 Herrero Racing,1" "21CUP| #007 Herrero Racing,1" "21CUP| #008 Autosport GP,1" "21CUP| #009 Chazel Technologie Course,1" "21CUP| #011 Herrero Racing,1" "21CUP| #018 Patrick Roger Autosport GT,1" "21CUP| #027 Herrero Racing,1" "21CUP| #031 Meric Competition,1" "21CUP| #033 Autosport GP,1" "21CUP| #040 Race Cars Consulting,1" "21CUP| #041 Race Cars Consulting,1" "21CUP| #044 Patrick Roger Autosport GT,1" "21CUP| #045 Herrero Racing,1" "21CUP| #063 Herrero Racing,1" "21CUP| #069 LSGROUP Autosport GP,1" "21CUP| #072 Autosport GP,1" "21CUP| #093 Chazel Technologie Course,1" "21CUP| #110 Chazel Technologie Course,1" "21GT4EUR| #030 Team CMR,1" "21GT4EUR| #036 Arkadia Racing,1" "21GT4FRA| #035 Bodemer Auto,1" "21GT4FRA| #036 Team CMR,1" "21GT4FRA| #076 Bodemer Auto,1" "21GT4FRA| #110 Team CMR,1"
NumOtherFiles=0
rFmFile=$RF2INSTALLDIR\Packages\default.rfm
IconFile=$RF2INSTALLDIR\Packages\icon.dds
SmallIconFile=$RF2INSTALLDIR\Packages\smicon.dds

CurPackage=0
"@

# New-Item -Path $RF2INSTALLDIR\Packages -Name "dummy.dat" -ItemType "file" -Value "$PKGINFO"
Set-Content -Path $RF2INSTALLDIR\Packages\dummy.dat -Value $PKGINFO -Encoding ASCII

timeout /t 5|out-null

ForEach($FILE in 'default.rfm', 'icon.dds', 'smicon.dds')
{
cp $RF2SRVMGRDIR\modfiles\$FILE $RF2INSTALLDIR\Packages
}

#
# create MAS file
$textBox.AppendText("`r`nCreating mas-file for initial mod.")
#& "$RF2INSTALLDIR\bin64\modmgr.exe" -c""$RF2INSTALLDIR"" -o""$RF2INSTALLDIR\Packages"" -m""dummy.mas"" ""$RF2INSTALLDIR\Packages\default.rfm"" ""$RF2INSTALLDIR\Packages\icon.dds"" ""$RF2INSTALLDIR\Packages\smicon.dds""
$ARGUMENTS="-q -c""$RF2INSTALLDIR"" -o""$RF2INSTALLDIR\Packages"" -m""dummy.mas"" ""$RF2INSTALLDIR\Packages\default.rfm"" ""$RF2INSTALLDIR\Packages\icon.dds"" ""$RF2INSTALLDIR\Packages\smicon.dds"" "
start-process -FilePath "$RF2INSTALLDIR\bin64\ModMgr.exe" -ArgumentList $ARGUMENTS -NoNewWindow -Wait

timeout /t  5|out-null

# create RFMOD package
$textBox.AppendText("`r`nCreating rfmod-file for initial mod.")
$ARGUMENTS="-q -c""$RF2INSTALLDIR"" -o""$RF2INSTALLDIR\Packages"" -b""$RF2INSTALLDIR\Packages\dummy.dat"" 0"
start-process -FilePath "$RF2INSTALLDIR\bin64\ModMgr.exe" -ArgumentList $ARGUMENTS -NoNewWindow -Wait

timeout /t 5|out-null

# 
# install RFMOD, TODO: respect exit codes
$textBox.AppendText("`r`nInstalling rfmod.")
$ARGUMENTS="-q -p""$RF2INSTALLDIR\Packages"" -i""dummy.rfmod"" -c""$RF2INSTALLDIR"" "
start-process -FilePath "$RF2INSTALLDIR\bin64\ModMgr.exe" -ArgumentList $ARGUMENTS -NoNewWindow -Wait

timeout /t 5|out-null

#
# open default firewall ports, UDP+TCP 54297 TCP 64297 UDP 64298 UDP 64299
$textBox.AppendText("`r`nOpen default firewall ports for rFactor 2 Dedicated Server")

#
# TCP
$ARGUMENTS="advfirewall firewall add rule name= ""rFactor 2 TCP ports"" dir=in action=allow protocol=TCP localport=54297,64297"
start-process "netsh" $ARGUMENTS -Verb runAs -wait

#
# UDP
$ARGUMENTS="advfirewall firewall add rule name= ""rFactor 2 UDP ports"" dir=in action=allow protocol=UDP localport=54297,64298,64299"
start-process "netsh" $ARGUMENTS -Verb runAs -wait

#
# start the rf2 dedicated server with dummy mod
#$ARGUMENTS=" +path="".."" +profile=player +rfm=dummy_10.rfm +oneclick"
$textBox.AppendText("`r`nStarting rFactor 2 dedicated server with initial mod.")
mkdir $RF2INSTALLDIR\Userdata\player| out-null
$ARGUMENTS=" +profile=player +rfm=dummy_10.rfm +oneclick"
#start-process -FilePath "$RF2INSTALLDIR\bin64\rFactor2 Dedicated.exe" -ArgumentList $ARGUMENTS -NoNewWindow -Wait
start-process -FilePath "$RF2INSTALLDIR\bin64\rFactor2 Dedicated.exe" -ArgumentList $ARGUMENTS -NoNewWindow

# back
cd $RF2SRVMGRDIR

$textBox.AppendText("`r`n`r`nFinished rFactor 2 dedicated server installation.")

    #InstallationFinished "rFactor 2 Dedicated Server"

}

else { $textBox.Text = "Installation of rFactor 2 dedicated server canceled." }

$statusLabel.Text = "Finished."

}
