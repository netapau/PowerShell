<#

.SYNOPSIS
profile.ps1 version 0.1

.DESCRIPTION
Profile .ps1 >> @"C:\Users\(USER)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

.EXAMPLE
Run Powershell

.NOTES
Author : Tony Simoes | DateCreated: 09/07/2017  
 
.LINK
(Tony Simoes) https://netapau.github.io/net/

#>


# profile.ps1 version 0.2
Set-Alias -name Out-Clipboard -value 'c:\windows\system32\clip.exe'
Set-Alias -name grep -value select-string
$Racine = "\\Lune\!codes"
function goAngular {set-location "$Racine\Angular"; start .}
Set-Alias opan goAngular
#
function goBatch {set-location "$Racine\Batch"; start .}
Set-Alias opba goBatch
#
function goCsharp {set-location "$Racine\C#"; start .}
Set-Alias opcs goCsharp
#
function goCpp {set-location "$Racine\Cpp"; start .}
Set-Alias opcp goCpp
#
function goNode {set-location "$Racine\Node"; start .}
Set-Alias opno goNode
#
function goPowerShell {set-location "$Racine\PowerShell"; start .}
Set-Alias oppo goPowerShell
#
function goPython {set-location "$Racine\Python"; start .}
Set-Alias oppy goPython
#...
# Fais parler Virginie
function Parler($texte)
{
	$TTS = new-object -com SAPI.SpVoice
	$var = $TTS.Speak($texte, 2) 
}
#...
# Ouvre .txt dans Notepad++
function Note($arg1)
{
	$Command = "C:\Program Files\Notepad++\notepad++.exe "
	& "$Command" $arg1
}
#...
# Current Path
function monPath()
{
	$CurrentDir = $(get-location).Path
	Write-Host "$CurrentDir"
}
Set-Alias p monPath
#...
# Trafic des ports
function MesPorts()
{
	$CurrentDir = $(get-location).Path
	$file = "$CurrentDir/activity.txt"
	Netstat -abf > $file
	Note($file)	
	#del $file
	if ([System.Console]::ReadKey($true).Key -eq [System.ConsoleKey]::O) {
		write-chost " Bien compris ! , j'efface $file ...# "
		rem $file
	}
}
#...
# Customize window
function AdminWindow()
{
	$Shell = $Host.UI.RawUI
	$size = $Shell.WindowSize
	$size.width=80
	$size.height=35
	$Shell.WindowSize = $size
	$size = $Shell.BufferSize
	$size.width=80
	$size.height=5000
	$Shell.BufferSize = $size
}
AdminWindow
#...
# Modification des variables de preference
$VerbosePreference 	= 'continue'		#par defaut silentlycontinue
$DebugPreference 	= 'continue'
$WarningPreference 	= 'continue'
#...
#Message d'accueuil personnalisé
$UserType = 'Utilisateur'
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = new-object System.security.Principal.windowsprincipal($CurrentUser)
if ($principal.IsInRole('Administrateurs'))
{
	$UserType = 'Admin'
	$host.ui.RawUI.BackGroundColor = 'Red' #'Gray'
	$host.ui.RawUI.ForeGroundColor = 'White' #'Blue'
	Clear-Host
}
else
{
	$host.ui.RawUI.BackGroundColor = 'DarkMagenta'
	Clear-Host
}
$VMaj = $PSVersionTable.PSVersion.Major
$VMin = $PSVersionTable.PSVersion.Minor
Write-Host ' '	
Write-Host "                 Bonjour $UserType sur PowerShell V $VMaj.$VMin            " -foregroundcolor red -backgroundcolor white
Write-Host ' '
Write-Host ' '
$User = $(($CurrentUser.Name).split('\')[1])
Parler("Bonjour $UserType . Je suis contente de te revoir.")
#...
# Modification de la couleur du prompt en jaune, remplacement
# du prompt par PS > et affichage du chemin courant dans la barre
# de titre de la fênetre de la console
function prompt
{
	$heure = get-date -format T
	Write-Host ('PS ' + $heure +' >') -nonewline -fore yellow
	$host.ui.RawUI.Set_windowtitle("$(get-location) ($UserType) : $User")
	return ' '
}
cd C:\
#...
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
