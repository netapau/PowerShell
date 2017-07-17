<#

.SYNOPSIS
Cherche si une application est déjà installée dans le path et a quel endroit elle se trouve.

.DESCRIPTION
Cherche si une application est déjà installée dans le path. 
Passez le nom dans le paramettre -appname exemple: .\Get-AppInPath -appname 'python' 
Retourne si l'application est presente et a quel endroit.

.EXAMPLE
Get-AppInPath -appname 'python'

.NOTES
Name: Get-AppInPath | Author : Tony Simoes | DateCreated: 09/07/2017  
Thank's Marco Di Feo write-chost function author.
 
.LINK
(Tony Simoes) https://netapau.github.io/net/

#>


# Thank's Marco Di Feo write-chost function author.
# > http://marco-difeo.de/2012/06/19/powershell-colorize-string-output-with-colorvariables-in-the-output-string/
function write-chost($message = ""){
    [string]$pipedMessage = @($Input)
    if (!$message)
    {  
        if ( $pipedMessage ) {
            $message = $pipedMessage
        }
    }
	if ( $message ){
		# predefined Color Array
		$colors = @("black","blue","cyan","darkblue","darkcyan","darkgray","darkgreen","darkmagenta","darkred","darkyellow","gray","green","magenta","red","white","yellow");

		# Get the default Foreground Color
		$defaultFGColor = $host.UI.RawUI.ForegroundColor

		# Set CurrentColor to default Foreground Color
		$CurrentColor = $defaultFGColor

		# Split Messages
		$message = $message.split("#")

		# Iterate through splitted array
		foreach( $string in $message ){
			# If a string between #-Tags is equal to any predefined color, and is equal to the defaultcolor: set current color
			if ( $colors -contains $string.tolower() -and $CurrentColor -eq $defaultFGColor ){
				$CurrentColor = $string          
			}else{
				# If string is a output message, than write string with current color (with no line break)
				write-host -nonewline -f $CurrentColor $string
				# Reset current color
				$CurrentColor = $defaultFGColor
			}
			# Write Empty String at the End
		}
		# Single write-host for the final line break
		write-host
	}
}

$appname = $args[1]
$AlertPause

function Pause ($Message=" >>> Key to exit...")
 {
	$culture = Get-Culture | Select-Object Name
	if($culture -Match "fr-FR")
	{
		$Message=" >>> Appuyez sur une touche pour quitter...`n [R] pour refaire"
	}
	Write-Host -NoNewLine $Message
	Write-Host ""

	if ([System.Console]::ReadKey($true).Key -eq [System.ConsoleKey]::R) {
		write-chost " #yellow#Bien compris ! , re-execution de l'application...# "
		$appname = " "
		Get-AppInPath
	}	
	else
	{
		exit
	}
 } 


Function Get-AppInPath 
{		
		$Title    = " ------- SEARCH APPLICATION IN SYSTEM PATH  ------- "
		$Alert 	  = " >>>       [ Please enter name App ! ] [q to exit]:"
		$Process  = " >>> SEARCHING : "
		$Result   = " FIND HERE : "
		$NoResult = " NOT FIND "
		
		$culture = Get-Culture | Select-Object Name
		if($culture -Match "fr-FR"){
			$Title    = " ------- CHERCHE UNE APPLICATION DANS LE PATH SYSTEME -------"
			$Alert    = " >>> [ Entrez le nom de l'application ! ] [ q pour quitter ]:"
			$Process  = " >>> RECHERCHE : "
			$Result   = " SE TROUVE ICI : "
			$NoResult = " PAS PRESENT DANS LE PATH "
		}
		
		# TITLE CMDLET
		Write-Host ""
		write-chost "#yellow#$Title#"
		
		#Test param	
		$boucle = "True"		
		while($boucle -eq "True")
		{
			if($appname -Match "q")
			{
				Write-Host ""
				Exit
			}
			if($appname -eq $null -or $appname -eq [String]::Empty -or $appname -Match "^\s*$")
			{
				[System.Console]::Beep(659, 125);
				Write-Host ""
				$appname = Read-Host "$Alert"
			}	
			else
			{
				break	#$boucle = "False"
			}
		}
		
		Write-Host ""
		write-chost "#green#$Process $appname #"
		Write-Host ""

		$ArregloPath = $Env:Path.Split(';')

		$MatchPath = ""

		foreach($element in $ArregloPath){
			Start-Sleep -m 100
			Write-Host " $element"
			if( $element -Match $appname){
				$MatchPath = $element + "`n " + $MatchPath
			}
		}
		
		Write-Host ""
		if($MatchPath){
			#Write-Host " >>> $appname $Result $MatchPath "
			write-chost "#green# >>> $appname $Result `n $MatchPath #"
			[System.Console]::Beep(659, 125);
		}else{
			#Write-Host " >>> $appname $NoResult "
			write-chost "#magenta# >>> $appname $NoResult #"
			[System.Console]::Beep(784, 125);
		}
		Write-Host " "
		Pause
}
Get-AppInPath

