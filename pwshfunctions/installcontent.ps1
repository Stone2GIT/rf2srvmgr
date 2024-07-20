#
# Simple script to display a GUI to download (paid) content
#
# Author: Dietmar Stein, info@simracingjustfair.org
#

function InstallContent {

$statusLabel.Text = "Please wait until finished ..."

$textBox.Text = "rFactor 2 content installation."
$textBox.AppendText("`r`n")

# Initialisierung Form
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# the window / frame itself
$form = New-Object System.Windows.Forms.Form
$form.Text = 'rFactor 2 Dedicated Server Manager'
$form.Size = New-Object System.Drawing.Size(535,600)
$form.StartPosition = 'CenterScreen'
$form.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

# OK button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(25,440)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'Install'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

# Cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(125,440)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

# window which will display choices
$label = ""
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(480,20)
$label.Text = 'Choose items to download (multiple selection possible)'
$form.Controls.Add($label)

# ListBox inside the choices' window
$listBox = ""
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(200,20)
$listBox.Height = 300
$listBox.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$listBox.SelectionMode = 'MultiExtended'

$listBox1 = ""
$listBox1 = New-Object System.Windows.Forms.ListBox
$listBox1.Location = New-Object System.Drawing.Point(210,40)
$listBox1.Size = New-Object System.Drawing.Size(200,200)
$listBox1.Height = 300
$listBox1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$listBox1.SelectionMode = 'MultiExtended'

# items for choice
$CSVCARENTRIES=Import-CSV $CSVCARFILE | sort CarName
$CSVTRACKENTRIES=Import-CSV $CSVTRACKFILE | sort TrackName

@($CSVCARENTRIES.CarName) | ForEach-Object {[void] $listBox.Items.Add($_)}
@($CSVTRACKENTRIES.TrackName) | ForEach-Object {[void] $listBox1.Items.Add($_)}

$form.Controls.Add($listBox)
$form.Controls.Add($listBox1)

$form.Topmost = $true

# display the whole form
$result = $form.ShowDialog()

#
# what to do after choice
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{

#
# be aware of the trailing s at Items ;-)
$CARSELECTION=$listBox.SelectedItems
$TRACKSELECTION=$listBox1.SelectedItems

#
# For each entry in CSV file ... compare ...
ForEach($CSVCARENTRY in Import-CSV $CSVCARFILE)
 {
  #
  # if the car name is like the vehicle we gonna check ...
  ForEach($OBJECT in $CARSELECTION)
  {
  if($CSVCARENTRY.CarName -match $OBJECT)
   {
    #
    # if there is a SteamID entry for the car we gonna download it
    if ($CSVCARENTRY.SteamID)
     {
      #
      # we need to use a substitute variable, because CSVENTRY.SteamId contains an array when used in ARGUMENTS
      $textBox.AppendText("`r`nDownloading and installing "+$CSVCARENTRY.CarName+".")
      $STEAMID=$CSVCARENTRY.SteamId
      
      $ARGUMENTS=" +login anonymous +workshop_download_item 365960 $STEAMID +quit"
      start-process "$STEAMINSTALLDIR\steamcmd" -ArgumentList $ARGUMENTS -NoNewWindow -wait
      #
      # extract and install ...
      & $RF2SRVMGRDIR\helper\rfcmp_extractor.ps1 $STEAMID
     }
   }
  }
 }

#
# For each entry in CSV file ... compare ...
ForEach($CSVTRACKENTRY in Import-CSV $CSVTRACKFILE)
 {
  
  #
  # if the track name is like the track we gonna check ...
  ForEach($OBJECT in $TRACKSELECTION)
  {
  if($CSVTRACKENTRY.TrackName -match $OBJECT)
   {
    #
    # if there is a SteamID entry for the car we gonna download it
    if ($CSVTRACKENTRY.SteamID)
     {
      #
      # we need to use a substitute variable, because CSVENTRY.SteamId contains an array when used in ARGUMENTS
      $textBox.AppendText("`r`nDownloading and installing "+$CSVTRACKENTRY.TrackName+".")
      $STEAMID=$CSVTRACKENTRY.SteamId
      
      $ARGUMENTS=" +login anonymous +workshop_download_item 365960 $STEAMID +quit"
      start-process "$STEAMINSTALLDIR\steamcmd" -ArgumentList $ARGUMENTS -NoNewWindow -wait
      #
      # extract and install ...
      & $RF2SRVMGRDIR\helper\rfcmp_extractor.ps1 $STEAMID
     }
   }
  }
 }

#
# if cancel was pressed
  } elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
    {
    $textBox.AppendText("`r`nNo items chosen, installation canceled.")
    exit
    }

    $textBox.AppendText("`r`n`r`nFinished content installation.")
    $statusLabel.Text = "Finished."

}
