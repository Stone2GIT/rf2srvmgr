#
# Simple script for sourcing variables
#
# Author: Dietmar Stein, info@simracingjustfair.org
#

#
# variables

#
# Working directory
#$WORKDIR=$pwd.Path
$WORKDIR="$HOME\rf2srvmgr"
$RF2SRVMGRDIR="$WORKDIR"

# 
# Steam and rF2 related
$STEAMINSTALLDIR="C:\Users\srjfmundd\SteamCMD"
$RF2INSTALLDIR="C:\Users\srjfmundd\SteamCMD\steamapps\rFactor2DS"
$RF2BETAVERSION="none"

#
# car and track locations
$RF2VEH=$RF2INSTALLDIR+"Installed\Vehicles"
$RF2LOC=$RF2INSTALLDIR+"Installed\Locations"

#
# QuickBMS related
$QUICKDIR="$RF2SRVMGRDIR\QuickBMS"
$TMPDIR="$QUICKDIR\tmp"

#
# CSV and JSON files etc.
$CSVCARFILE="$RF2SRVMGRDIR\csvfiles\paid_cars.csv"
$CSVTRACKFILE="$RF2SRVMGRDIR\csvfiles\paid_tracks.csv"

$CSVCONTENTFILE="$RF2SRVMGRDIR\csvfiles\content.csv"
$JSONCONTENTFILE="$RF2SRVMGRDIR\csvfiles\content.json"

#
# historic ... get rid of it ...
#$BASELW="c:\"
$RFACTORDIR="$RF2INSTALLDIR"
$RFACTORCONTENT="$RF2INSTALLDIR\Installed"

$STEAMLW="d:"
$STEAMCONTENT="$STEAMLW\workshop\content\365960"
$PACKAGESDIR="$STEAMLW\common\rFactor 2\Packages"
