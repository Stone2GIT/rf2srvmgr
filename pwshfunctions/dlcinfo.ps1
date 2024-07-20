#Requires -Version 7.0

#
# Simple script to get (paid) content information by Steam API
#
# Author: Dietmar Stein, info@simracingjustfair.org
#

function DLCInfo {

$statusLabel.Text = "Please wait until finished ..."

$textBox.Text = "Getting actual DLC content information."

#
# source variables
if (!(Test-Path "$HOME\rf2srvmgr\VARIABLES_SOURCE_FILE.ps1")) {
  Write-Warning "Cannot source variables - exiting."
  exit 1
}
else {
  if(Test-Path "$HOME\rf2srvmgr\VARIABLES_SOURCE_FILE.ps1") { . "$HOME\rf2srvmgr\VARIABLES_SOURCE_FILE.ps1" }
}

"Running $PSVersionTable"

rm $RF2SRVMGRDIR\csvfiles\paid_cars.*
rm $RF2SRVMGRDIR\csvfiles\paid_tracks.*

$textBox.AppendText("`r`n`r`nRequesting information from Steam.")

$url="https://api.steampowered.com/IGameInventory/GetItemDefArchive/v1/?key=3C91FAD203AF1D98082A3BCF8ABEE6C6&appid=365960&digest=23462F47FC86B89FDAA5E05D11471EE1DB726E33"
[Array]$test = Invoke-RestMethod $url
$test | ConvertTo-Json -Depth 2 | Out-File $JSONCONTENTFILE -Encoding UTF8
$test  |Export-Csv -NoTypeInformation -Path "$CSVCONTENTFILE" -Delimiter "," -Encoding UTF8

"""CarName"",""SteamId""" | Out-File $CSVCARFILE -Append
"""TrackName"",""SteamId""" | Out-File $CSVTRACKFILE -Append

$textBox.AppendText("`r`nProcessing information.")
ForEach($CSVCONTENTENTRY in Import-CSV $CSVCONTENTFILE)
{

if($CSVCONTENTENTRY.store_tags -eq "cars")
   {
   $CARNAME=$CSVCONTENTENTRY.name
   $CARWORKSHOPID=$CSVCONTENTENTRY.workshopid
   """$CARNAME"",""$CARWORKSHOPID"""| Out-File $CSVCARFILE -Append
   #$CSVCONTENTENTRY.CarName+","+$CSVCONTENTENTRY.SteamId # | Export-Csv -Path paid_cars.csv -Append
   }

if($CSVCONTENTENTRY.store_tags -eq "tracks")
   {
   $TRACKNAME=$CSVCONTENTENTRY.name
   $TRACKWORKSHOPID=$CSVCONTENTENTRY.workshopid
   """$TRACKNAME"",""$TRACKWORKSHOPID"""| Out-File $CSVTRACKFILE -Append
   #$CSVCONTENTENTRY.TrackName+","+$CSVCONTENTENTRY.SteamId # | Export-Csv -Path paid_tracks.csv -Append
   }

}

$textBox.AppendText("`r`n`r`nFinished getting information.")

$statusLabel.Text = "Finished."
}