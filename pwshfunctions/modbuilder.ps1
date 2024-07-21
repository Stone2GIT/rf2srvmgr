#
# Simple script to display a GUI to download (paid) content
#
# Author: Dietmar Stein, info@simracingjustfair.org
#

. $HOME\rf2srvmgr\variables.ps1

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
$INSTALLEDCARS=(Get-ChildItem -Directory $RF2ROOT\Installed\Vehicles\| Select-Object -Expand Name | select-string -Pattern "CorvetteC6_PC" -notmatch | sort)
$INSTALLEDTRACKS=(Get-ChildItem -Directory $RF2ROOT\Installed\Locations\| Select-Object -Expand Name | sort)

@($INSTALLEDCARS) | ForEach-Object {[void] $listBox.Items.Add($_)}
@($INSTALLEDTRACKS) | ForEach-Object {[void] $listBox1.Items.Add($_)}

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
# if cancel was pressed
  } elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
    {
    $textBox.AppendText("`r`nNo items chosen, installation canceled.")
    exit
    }

    $textBox.AppendText("`r`n`r`nFinished content installation.")
    $statusLabel.Text = "Finished."

