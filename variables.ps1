#
# Simple script for sourcing variables
#
# Author: Dietmar Stein, info@simracingjustfair.org
#

#
# variables

#
# Working directory
$CURRENTLOCATION=((Get-Location).Path)

# 
# Steam and rF2 related
$STEAMINSTALLDIR="$CURRENTLOCATION\SteamCMD"
$RF2ROOT="$HOME\rf2ds"
$RF2BETAVERSION="none"

#
# car and track locations
$RF2VEH=$RF2ROOT+"Installed\Vehicles"
$RF2LOC=$RF2ROOT+"Installed\Locations"

#
# QuickBMS related
$QUICKDIR="$CURRENTLOCATION\QuickBMS"
$TMPDIR="$QUICKDIR\tmp"

#
# CSV and JSON files etc.
$CSVCARFILE="$CURRENTLOCATION\csvfiles\paid_cars.csv"
$CSVTRACKFILE="$CURRENTLOCATION\csvfiles\paid_tracks.csv"

$CSVCONTENTFILE="$CURRENTLOCATION\csvfiles\content.csv"
$JSONCONTENTFILE="$CURRENTLOCATION\csvfiles\content.json"

#
# historic ... get rid of it ...
$RFACTORDIR="$RF2ROOT"
$RFACTORCONTENT="$RF2ROOT\Installed"

$STEAMCONTENT="$RF2ROOT\steamapps\workshop\content\365960"
$PACKAGESDIR="$RF2ROOT\Packages"
