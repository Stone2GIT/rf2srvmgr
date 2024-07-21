#
# Simple script to extract RFCMPs with QuickBMS
#
# Author: Dietmar Stein, info@simracingjustfair.org
#
# TODO: 
# - respect other types than vehicles and tracks
#
#
# I think using QuickBMS is illegal, so we need to remove this ...
$STEAMID=$args[0]

#
# source variables
if (!(Test-Path "$HOME\rf2srvmgr\VARIABLES_SOURCE_FILE.ps1")) {
  Write-Warning "Cannot source variables - exiting."
  exit 1
}
else {
  if(Test-Path "$HOME\rf2srvmgr\VARIABLES_SOURCE_FILE.ps1") { . "$HOME\rf2srvmgr\VARIABLES_SOURCE_FILE.ps1" }
}

#
# generating symlinks for the modmgr
$RFCMPS=(gci $STEAMINSTALLDIR\steamapps\workshop\content\365960\$STEAMID *.rfcmp -recurse|select -Expand FullName)

#
# Extract them RFCMPs
ForEach($RFCMP in $RFCMPS)
{
 write-host "Extracting "$RFCMP
 $ARGUMENTS=" -o -Y -Q -R ""$QUICKDIR\rfactor2.bms"" ""$RFCMP"" ""$TMPDIR"""
 start-process -FilePath "$QUICKDIR\quickbms_4gb_files.exe" -ArgumentList $ARGUMENTS -Wait -WindowStyle hidden|out-null
 cd $TMPDIR

#
# read in MFT file from extracted RFCMP and analyze it
$mftcontent = Get-Content *.mft

$string = ($mftcontent| Select-String -Pattern "Name=")
$dirname = $string -split "="

$string = ($mftcontent| Select-String -Pattern "Version=")
$version = $string -split "="

$string = ($mftcontent| Select-String -Pattern "Type=")
$type = $string -split "="

If($type[1] -eq "2")
{
    $type[1] = 'Vehicles'
}

If($type[1] -eq "1")
{
    $type[1] = 'Locations'
}

#
# tracks ...
If($type[1] -eq "Locations")
{
    # wir lesen die Namen der mas Datein im temp directory ein
    # 
    $FILES=gci $TMPDIR\*.mas|select -Expand fullname
    
    # fuer jede Datei in FILES 
    #
    foreach($FILE in $FILES)
    {

    #
    $ARGUMENTS="-q -x""$FILE"" *.gdb -o""$TMPDIR"""
    #echo "Argumente fuer modmgr.exe zur Suche gdb Dateien "$ARGUMENTS
    start-process -FilePath "$RF2ROOT\bin64\ModMgr.exe" -ArgumentList $ARGUMENTS -Wait -WindowStyle hidden|out-null
     
       # wir lesen die Dateinamen der gdb Dateien ein
       #
       $GDBFILES=gci $TMPDIR\*.gdb |select -Expand fullname

       # fuer jede gdb Datei in GDBFILES ...
       #
       foreach($GDBFILE in $GDBFILES)
       {

       # die gdb Datei enthält einen Wert SettingsFolder, der den Namen des Tracks enthaelt
       #
       $TRACKFOLDER=(Get-Content $GDBFILE |select-String SettingsFolder) | ForEach-Object { ($_ -split "=")[1] } | foreach-object { $_ -replace "\s+",'' }

       del $GDBFILE
      }
   
    } 

 # Windows Server Cache ... es kommt immer wieder zu Fehlermeldungen, die Dateien seien noch in Benutzung
 # Fehler taucht dann im Step "move" auf ... :-(
 #
 timeout /t 1 |out-null
}

# Wechsel nach $RF2ROOTDIR\Installed
# 
cd $RF2ROOT\Installed

# type directories muessen vorher existieren ... 
#
If(!(test-path $type[1] -PathType container))
{
    mkdir $type[1]
}

# Wechsel in Installed\<Locations|Vehicles>
#
cd $type[1]

# wenn das Verzeichnis fuer den Content nicht existiert, legen wir es an ... 
# 
If(!(test-path -PathType container $dirname[1]))
{
      New-Item -ItemType Directory -Path $dirname[1]
}

# Wechsel nach Installed\<Locations|Vehicles>\<Contentname>
#
cd $dirname[1]

# wenn das Verzeichnis der Version des Content nicht existiert, legen wir es an ... 
# 
If(!(test-path -PathType container $version[1]))
{
      New-Item -ItemType Directory -Path $version[1]

# Wechsel nach Installed\<Locations|Vehicles>\<Contentname>\<Version>
#
cd $version[1]

# der Windows Cache ... wenn wir die Datei verschieben scheint es ein sync I/O zu geben
#
echo "Moving MAS files from tmp to installed ..."
move -Path $TMPDIR\*.mas . -force
move -Path $TMPDIR\*.mft . -force
}

# loeschen ...
#
rm $TMPDIR\*.mas
rm $TMPDIR\*.mft

# der cache ...
#
timeout /t 3|out-null

# zurueck ins Hauptverzeichnis und von vorn ...
# 
cd $QUICKDIR
}
