<#
FormsMenu.ps1

Wayne Lindimore
wlindimore@gmail.com
AdminsCache.Wordpress.com

7-26-14
PowerShell WinForms Menu Demo
#>

# Install .Net Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()


#
# source variables
if (!(Test-Path "$CURRENTLOCATION\variables.ps1")) {
  Write-Warning "Cannot source variables - exiting."
  exit 1
}
else {
  if(Test-Path "$CURRENTLOCATION\variables.ps1") { . "$CURRENTLOCATION\variables.ps1" }
}

#
# we need a default dir
If(test-path $STEAMINSTALLDIR -PathType container)
{ 
 write-host "Directory $STEAMINSTALLDIR already existing"
}
else
{
 write-host "Creating $STEAMINSTALLDIR"
 mkdir $STEAMINSTALLDIR
}

# WinForm Setup
################################################################## Objects
# Main Form .Net Objects
$mainForm         = New-Object System.Windows.Forms.Form
$menuMain         = New-Object System.Windows.Forms.MenuStrip
$menuFile         = New-Object System.Windows.Forms.ToolStripMenuItem
$menuView         = New-Object System.Windows.Forms.ToolStripMenuItem
$menuTools        = New-Object System.Windows.Forms.ToolStripMenuItem
$menuOpen         = New-Object System.Windows.Forms.ToolStripMenuItem

$menuSteamCMD     = New-Object System.Windows.Forms.ToolStripMenuItem
$menuInstContent  = New-Object System.Windows.Forms.ToolStripMenuItem
$menuDLCInfo      = New-Object System.Windows.Forms.ToolStripMenuItem

$menuSave         = New-Object System.Windows.Forms.ToolStripMenuItem
$menuSaveAs       = New-Object System.Windows.Forms.ToolStripMenuItem
$menuFullScr      = New-Object System.Windows.Forms.ToolStripMenuItem
$menuOptions      = New-Object System.Windows.Forms.ToolStripMenuItem
$menuOptions1     = New-Object System.Windows.Forms.ToolStripMenuItem
$menuOptions2     = New-Object System.Windows.Forms.ToolStripMenuItem
$menuExit         = New-Object System.Windows.Forms.ToolStripMenuItem
$menuHelp         = New-Object System.Windows.Forms.ToolStripMenuItem
$menuAbout        = New-Object System.Windows.Forms.ToolStripMenuItem
$mainToolStrip    = New-Object System.Windows.Forms.ToolStrip
$toolStripOpen    = New-Object System.Windows.Forms.ToolStripButton
$toolStripSave    = New-Object System.Windows.Forms.ToolStripButton
$toolStripSaveAs  = New-Object System.Windows.Forms.ToolStripButton
$toolStripFullScr = New-Object System.Windows.Forms.ToolStripButton
$toolStripAbout   = New-Object System.Windows.Forms.ToolStripButton
$toolStripExit    = New-Object System.Windows.Forms.ToolStripButton
$statusStrip      = New-Object System.Windows.Forms.StatusStrip
$statusLabel      = New-Object System.Windows.Forms.ToolStripStatusLabel

################################################################## Icons
# WinForms Icons
# Create Icon Extractor Assembly
$code = @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;

namespace System
{
	public class IconExtractor
	{

	 public static Icon Extract(string file, int number, bool largeIcon)
	 {
	  IntPtr large;
	  IntPtr small;
	  ExtractIconEx(file, number, out large, out small, 1);
	  try
	  {
	   return Icon.FromHandle(largeIcon ? large : small);
	  }
	  catch
	  {
	   return null;
	  }

	 }
	 [DllImport("Shell32.dll", EntryPoint = "ExtractIconExW", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
	 private static extern int ExtractIconEx(string sFile, int iIndex, out IntPtr piLargeVersion, out IntPtr piSmallVersion, int amountIcons);

	}
}
"@
Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing

# Extract PowerShell Icon from PowerShell Exe
$iconPS   = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)

##################################################################
###
### Main Form
###

# textBox inside the choices' window
#$textBox = ""
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20,75)
$textBox.Size = New-Object System.Drawing.Size(740,250)
$textBox.Multiline = $True
$textBox.AcceptsReturn = $True
$textBox.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$textBox.Scrollbars = "Vertical"
$textBox.Text = "rF2 Dedicated Server Manager" 

$textBox.AppendText("`r`n`r`n")
$textBox.AppendText("If you like to contribute drop me an email to info@simracingjustfair.org`r`n with subject `'rF2srvmgr contribution`'.")
$textBox.AppendText("`r`n`r`nThanks for using, Stone")

$mainForm.Height          = 400
$mainForm.Icon            = $iconPS
$mainForm.MainMenuStrip   = $menuMain
$mainForm.Width           = 800
$mainForm.StartPosition   = "CenterScreen"
$mainForm.Text            = "rF2 Dedicated Server Manager"
$mainForm.Controls.Add($menuMain)


$mainForm.Controls.Add($textBox)

##################################################################
###
### Main ToolStrip
###
[void]$mainForm.Controls.Add($mainToolStrip)

# Main Menu Bar
[void]$mainForm.Controls.Add($menuMain)

# Menu Installation - Dedicated Server
$menuFile.Text = "&Installation"
[void]$menuMain.Items.Add($menuFile)

# Menu Installation - SteamCMD Install
$menuSteamCMD.Image        = [System.IconExtractor]::Extract("shell32.dll", 122, $true)
$menuSteamCMD.ShortcutKeys = "Control, S"
$menuSteamCMD.Text         = "&Install SteamCMD"
$menuSteamCMD.Add_Click({InstallSteamCMD})
[void]$menuFile.DropDownItems.Add($menuSteamCMD)

# Menu Installation - DS / Install
$menuOpen.Image        = [System.IconExtractor]::Extract("shell32.dll", 122, $true)
$menuOpen.ShortcutKeys = "Control, I"
$menuOpen.Text         = "&Install rF2 DS"
$menuOpen.Add_Click({ InstallDS })
[void]$menuFile.DropDownItems.Add($menuOpen)

# Menu Installation - DS / Update
$menuSave.Image        = [System.IconExtractor]::Extract("shell32.dll", 146, $true)
$menuSave.ShortcutKeys = "Control, U"
$menuSave.Text         = "&Update"
$menuSave.Add_Click({SaveFile})
[void]$menuFile.DropDownItems.Add($menuSave)

# Menu Installation - DS / Exit
$menuExit.Image        = [System.IconExtractor]::Extract("shell32.dll", 27, $true)
$menuExit.ShortcutKeys = "Control, X"
$menuExit.Text         = "&Exit"
$menuExit.Add_Click({$mainForm.Close()})
[void]$menuFile.DropDownItems.Add($menuExit)

# Menu Options - Content
$menuView.Text      = "&Content"
[void]$menuMain.Items.Add($menuView)

# Menu Options - Content / Install
$menuInstContent.Image        = [System.IconExtractor]::Extract("shell32.dll", 122, $true)
$menuInstContent.ShortcutKeys = "Control, C"
$menuInstContent.Text         = "&Install"
$menuInstContent.Add_Click({InstallContent})
[void]$menuView.DropDownItems.Add($menuInstContent)

# Menu Options - Content / Install
$menuDLCInfo.Image        = [System.IconExtractor]::Extract("shell32.dll", 14, $true)
$menuDLCInfo.ShortcutKeys = "Control, P"
$menuDLCInfo.Text         = "&Get DLC info"
$menuDLCInfo.Add_Click({DLCInfo})
[void]$menuView.DropDownItems.Add($menuDLCInfo)

# Menu Options - Tools
$menuTools.Text      = "&Tools"
[void]$menuMain.Items.Add($menuTools)

# Menu Options - Tools / Options
$menuOptions.Image     = [System.IconExtractor]::Extract("shell32.dll", 21, $true)
$menuOptions.Text      = "&Options"
[void]$menuTools.DropDownItems.Add($menuOptions)

# Menu Options - Tools / Options / Options 1
$menuOptions1.Image     = [System.IconExtractor]::Extract("shell32.dll", 33, $true)
$menuOptions1.Text      = "&Options 1"
$menuOptions1.Add_Click({Options1})
[void]$menuOptions.DropDownItems.Add($menuOptions1)

# Menu Options - Tools / Options / Options 2
$menuOptions2.Image     = [System.IconExtractor]::Extract("shell32.dll", 35, $true)
$menuOptions2.Text      = "&Options 2"
$menuOptions2.Add_Click({Options2})
[void]$menuOptions.DropDownItems.Add($menuOptions2)

# Menu Options - Help
$menuHelp.Text      = "&Help"
[void]$menuMain.Items.Add($menuHelp)

# Menu Options - Help / About
$menuAbout.Image     = [System.Drawing.SystemIcons]::Information
$menuAbout.Text      = "About rF2srvmgr"
$menuAbout.Add_Click({About})
[void]$menuHelp.DropDownItems.Add($menuAbout)

################################################################## 
### 
### Status Bar
###
[void]$statusStrip.Items.Add($statusLabel)
$statusLabel.AutoSize  = $true
$statusLabel.Text      = "Ready"
$mainForm.Controls.Add($statusStrip)

################################################################## 
###
### Functions
###

. $RF2SRVMGRDIR\pwshfunctions\installds.ps1

. $RF2SRVMGRDIR\pwshfunctions\installsteamcmd.ps1

. $RF2SRVMGRDIR\pwshfunctions\installcontent.ps1

. $RF2SRVMGRDIR\pwshfunctions\about.ps1

. $RF2SRVMGRDIR\pwshfunctions\dlcinfo.ps1


function SaveAs {
    $statusLabel.Text = "Save As"
    $selectSaveAsForm = New-Object System.Windows.Forms.SaveFileDialog
	$selectSaveAsForm.Filter = "All Files (*.*)|*.*"
	$selectSaveAsForm.InitialDirectory = ".\"
	$selectSaveAsForm.Title = "Select a File to Save"
	$getKey = $selectSaveAsForm.ShowDialog()
	If ($getKey -eq "OK") {
            $outputFileName = $selectSaveAsForm.FileName
	}
    $statusLabel.Text = "Ready"
}


function SaveFile {
}

function FullScreen {
}

function Options1 {
}

function Options2 {
}

# Show Main Form
[void] $mainForm.ShowDialog()
