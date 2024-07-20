function About {
    $statusLabel.Text = "About"
    # About Form Objects
    $aboutForm          = New-Object System.Windows.Forms.Form
    $aboutFormExit      = New-Object System.Windows.Forms.Button
    $aboutFormImage     = New-Object System.Windows.Forms.PictureBox
    $aboutFormNameLabel = New-Object System.Windows.Forms.Label
    $aboutFormText      = New-Object System.Windows.Forms.Label

    # About Form
    $aboutForm.AcceptButton  = $aboutFormExit
    $aboutForm.CancelButton  = $aboutFormExit
    $aboutForm.ClientSize    = "350, 150"
    $aboutForm.ControlBox    = $false
    $aboutForm.ShowInTaskBar = $false
    $aboutForm.StartPosition = "CenterParent"
    $aboutForm.Text          = "rF2 Dedicated Server Manager"
    $aboutForm.Add_Load($aboutForm_Load)

    # About PictureBox
    $aboutFormImage.Image    = $iconPS.ToBitmap()
    $aboutFormImage.Location = "55, 15"
    $aboutFormImage.Size     = "32, 32"
    $aboutFormImage.SizeMode = "StretchImage"
    $aboutForm.Controls.Add($aboutFormImage)

    # About Name Label
    $aboutFormNameLabel.Font     = New-Object Drawing.Font("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
    $aboutFormNameLabel.Location = "110, 20"
    $aboutFormNameLabel.Size     = "200, 36"
    $aboutFormNameLabel.Text     = "          rFactor 2`n`rDedicated Server Manager"
    $aboutForm.Controls.Add($aboutFormNameLabel)

    # About Text Label
    $aboutFormText.Location = "100, 58"
    $aboutFormText.Size     = "300, 60"
    $aboutFormText.Text     = "UI based on WinForms Menu Demo `n`r       from Wayne Lindimore `n`r    AdminsCache.WordPress.com"
    $aboutForm.Controls.Add($aboutFormText)

    # About Exit Button
    $aboutFormExit.Location = "135, 128"
    $aboutFormExit.Text     = "OK"
    $aboutForm.Controls.Add($aboutFormExit)

    [void]$aboutForm.ShowDialog()
    $statusLabel.Text = "Ready"
} # End About