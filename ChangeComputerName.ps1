﻿##[Ps1 To Exe]
##
##NcDBCIWOCzWE8pGP3wFk4Fn9fkkvY8yVsKWz1oCo8PjQnyDKQo4bWWhEnyX5Cl+edNZcUO0Q1A==
##Kd3HDZOFADWE8uO1
##Nc3NCtDXTlaDjofG5iZk2WrqT2ElZ9aPq7ezy5OA2+//sDHWWaY9Slt5qQr0BUW6XNEdWOUAoNQDexwnKrwC4b2w
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ49I=
##OcrLFtDXTiS5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+VslQ=
##M9jHFoeYB2Hc8u+VslQ=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjofG5iZk2WrqT2ElZ9aPq7ezy5OA2+//sDHWWaY3QVV5kSzfC0atTOYXR9sUudQtdhUrIfUOwb3dC/K9QLAkk+56JeCWo9I=
##Kc/BRM3KXxU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
function Show-ChangeComputerName_psf
{
	# Import the Assemblies
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

	# Form Objects
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formChangeComputerName = New-Object 'System.Windows.Forms.Form'
	$groupbox1 = New-Object 'System.Windows.Forms.GroupBox'
	$radiobuttonStayOn = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonRestart = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonShutdown = New-Object 'System.Windows.Forms.RadioButton'
	$CopyPCName = New-Object 'System.Windows.Forms.Button'
	$textboxComputerName = New-Object 'System.Windows.Forms.TextBox'
	$labelEnterPCName = New-Object 'System.Windows.Forms.Label'
	$buttonOK = New-Object 'System.Windows.Forms.Button'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'

	# Script
	$formChangeComputerName_Load = {
	}
	
	$buttonOK_Click = {
		if ($radiobuttonShutdown.Checked) { $AfterShow = "Shutdown" }
		if ($radiobuttonRestart.Checked) { $AfterShow = "Restart" }
		if ($radiobuttonStayOn.Checked) { $AfterShow = "Stay On" }
		if ($textboxComputerName_TextChanged)
		{
			# Take the computer name from the text box
			$ComputerName = $textboxComputerName.Text
			
			# Ask to confrim the name change
			Add-Type -AssemblyName PresentationCore, PresentationFramework
			$ButtonType1 = [System.Windows.MessageBoxButton]::YesNo
			$MessageIcon1 = [System.Windows.MessageBoxImage]::None
			$MessageBody1 = "Computer Name: $ComputerName `n`nAfter: $AfterShow"
			$MessageTitle1 = "Confirm Settings"
			$msgBoxInput1 = [System.Windows.MessageBox]::Show($MessageBody1, $MessageTitle1, $ButtonType1, $MessageIcon1)
			switch ($msgBoxInput1)
			{
				# If click yes
				'Yes' {
					# Edit Registry files for changing the computer name
					New-PSDrive -name HKU -PSProvider "Registry" -Root "HKEY_USERS"
					
					Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname"
					Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname"
					Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername" -name "Computername" -value $ComputerName
					Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputername" -name "Computername" -value $ComputerName
					Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" -value $ComputerName
					Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" -value $ComputerName
					Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "AltDefaultDomainName" -value $ComputerName
					Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "DefaultDomainName" -value $ComputerName
					# Set-ItemProperty -path "HKU:\.Default\Software\Microsoft\Windows Media\WMSDK\General" -name "Computername" -value $ComputerName
					
					# Restart or Shutdown
					if ($radiobuttonRestart.Checked) {
						# & shutdown -f -r -t 15
						& $env:p2eincfilepath\SilentCMD.exe shutdown -f -r -t 15
						# Restart-Computer 
					}
					if ($radiobuttonShutdown.Checked) {
						# & shutdown -f -s -t 15
						& $env:p2eincfilepath\SilentCMD.exe shutdown -f -s -t 15
						# Stop-Computer 
					}
				}
				# If click No
				'No' { <# Do nothing #> }
			}
		}
	}
	
	$radiobuttonStayOn_CheckedChanged = { <# Empty #> }
	$radiobuttonRestart_CheckedChanged = { <# Empty #> }
	$radiobuttonShutdown_CheckedChanged = { <# Empty #> }
	$CopyPCName_Click = {
		$CurrentComputerName = $env:computername
		$textboxComputerName.Text = $CurrentComputerName
	}
	
	$textboxComputerName_TextChanged = { <# Empty #> }
	
	# Events
	$Form_StateCorrection_Load =
	{
		# Correct the initial state of the form to prevent the .Net maximized form issue
		$formChangeComputerName.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed =
	{
		# Remove all event handlers from the controls
		try
		{
			$radiobuttonStayOn.remove_CheckedChanged($radiobuttonStayOn_CheckedChanged)
			$radiobuttonRestart.remove_CheckedChanged($radiobuttonRestart_CheckedChanged)
			$radiobuttonShutdown.remove_CheckedChanged($radiobuttonShutdown_CheckedChanged)
			$CopyPCName.remove_Click($CopyPCName_Click)
			$textboxComputerName.remove_TextChanged($textboxComputerName_TextChanged)
			$buttonOK.remove_Click($buttonOK_Click)
			$formChangeComputerName.remove_Load($formChangeComputerName_Load)
			$formChangeComputerName.remove_Load($Form_StateCorrection_Load)
			$formChangeComputerName.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}

	# region Generated Form Code
	$formChangeComputerName.SuspendLayout()
	$groupbox1.SuspendLayout()

	# formChangeComputerName
	$formChangeComputerName.Controls.Add($groupbox1)
	$formChangeComputerName.Controls.Add($CopyPCName)
	$formChangeComputerName.Controls.Add($textboxComputerName)
	$formChangeComputerName.Controls.Add($labelEnterPCName)
	$formChangeComputerName.Controls.Add($buttonOK)
	$formChangeComputerName.AcceptButton = $buttonOK
	$formChangeComputerName.AutoScaleDimensions = '6, 13'
	$formChangeComputerName.AutoScaleMode = 'Font'
	$formChangeComputerName.ClientSize = '284, 207'
	$formChangeComputerName.FormBorderStyle = 'FixedDialog'
	$formChangeComputerName.MaximizeBox = $False
	$formChangeComputerName.MinimizeBox = $False
	$formChangeComputerName.Name = 'formChangeComputerName'
	$formChangeComputerName.StartPosition = 'CenterScreen'
	$formChangeComputerName.Text = 'Change Computer Name'
	$formChangeComputerName.add_Load($formChangeComputerName_Load)

	# groupbox1
	$groupbox1.Controls.Add($radiobuttonStayOn)
	$groupbox1.Controls.Add($radiobuttonRestart)
	$groupbox1.Controls.Add($radiobuttonShutdown)
	$groupbox1.Location = '6, 58'
	$groupbox1.Name = 'groupbox1'
	$groupbox1.Size = '272, 109'
	$groupbox1.TabIndex = 4
	$groupbox1.TabStop = $False
	$groupbox1.Text = 'After Name Change'
	$groupbox1.UseCompatibleTextRendering = $True

	# radiobuttonStayOn
	$radiobuttonStayOn.Location = '20, 79'
	$radiobuttonStayOn.Name = 'radiobuttonStayOn'
	$radiobuttonStayOn.Size = '104, 24'
	$radiobuttonStayOn.TabIndex = 2
	$radiobuttonStayOn.Text = 'Stay On'
	$radiobuttonStayOn.UseCompatibleTextRendering = $True
	$radiobuttonStayOn.UseVisualStyleBackColor = $True
	$radiobuttonStayOn.add_CheckedChanged($radiobuttonStayOn_CheckedChanged)

	# radiobuttonRestart
	$radiobuttonRestart.Location = '20, 49'
	$radiobuttonRestart.Name = 'radiobuttonRestart'
	$radiobuttonRestart.Size = '104, 24'
	$radiobuttonRestart.TabIndex = 1
	$radiobuttonRestart.Text = 'Restart'
	$radiobuttonRestart.UseCompatibleTextRendering = $True
	$radiobuttonRestart.UseVisualStyleBackColor = $True
	$radiobuttonRestart.add_CheckedChanged($radiobuttonRestart_CheckedChanged)
	$radiobuttonRestart.Checked = $True

	# radiobuttonShutdown
	$radiobuttonShutdown.Location = '20, 19'
	$radiobuttonShutdown.Name = 'radiobuttonShutdown'
	$radiobuttonShutdown.Size = '104, 24'
	$radiobuttonShutdown.TabIndex = 0
	$radiobuttonShutdown.Text = 'Shutdown'
	$radiobuttonShutdown.UseCompatibleTextRendering = $True
	$radiobuttonShutdown.UseVisualStyleBackColor = $True
	$radiobuttonShutdown.add_CheckedChanged($radiobuttonShutdown_CheckedChanged)

	# CopyPCName
	$CopyPCName.Location = '12, 29'
	$CopyPCName.Name = 'CopyPCName'
	$CopyPCName.Size = '86, 23'
	$CopyPCName.TabIndex = 3
	$CopyPCName.Text = 'Copy Name'
	$CopyPCName.UseCompatibleTextRendering = $True
	$CopyPCName.UseVisualStyleBackColor = $True
	$CopyPCName.add_Click($CopyPCName_Click)
	
	# textboxComputerName
	$textboxComputerName.Location = '104, 6'
	$textboxComputerName.Name = 'textboxComputerName'
	$textboxComputerName.Size = '174, 20'
	$textboxComputerName.TabIndex = 2
	$textboxComputerName.add_TextChanged($textboxComputerName_TextChanged)
	$CurrentComputerName = $env:computername
	$textboxComputerName.Text = $CurrentComputerName
	
	# labelEnterPCName
	$labelEnterPCName.AutoSize = $True
	$labelEnterPCName.Location = '12, 9'
	$labelEnterPCName.Name = 'labelEnterPCName'
	$labelEnterPCName.Size = '86, 17'
	$labelEnterPCName.TabIndex = 1
	$labelEnterPCName.Text = 'Enter PC Name:'
	$labelEnterPCName.UseCompatibleTextRendering = $True
	
	# buttonOK
	$buttonOK.Anchor = 'Bottom, Right'
	$buttonOK.DialogResult = 'OK'
	$buttonOK.Location = '197, 172'
	$buttonOK.Name = 'buttonOK'
	$buttonOK.Size = '75, 23'
	$buttonOK.TabIndex = 0
	$buttonOK.Text = '&OK'
	$buttonOK.UseCompatibleTextRendering = $True
	$buttonOK.UseVisualStyleBackColor = $True
	$buttonOK.add_Click($buttonOK_Click)
	$groupbox1.ResumeLayout()
	$formChangeComputerName.ResumeLayout()

	# Save the initial state of the form
	$InitialFormWindowState = $formChangeComputerName.WindowState
	# Init the OnLoad event to correct the initial state of the form
	$formChangeComputerName.add_Load($Form_StateCorrection_Load)
	# Clean up the control events
	$formChangeComputerName.add_FormClosed($Form_Cleanup_FormClosed)
	# Show the Form
	return $formChangeComputerName.ShowDialog()
}

# Call the form
Show-ChangeComputerName_psf | Out-Null
