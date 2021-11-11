$version = "0.0.0.0"
$fileName = $Env:FILENAME
$buildNumber = [int]$Env:BUILDNUMBER
$directory = $Env:DIRECTORY
$recursive = [System.Convert]::ToBoolean($Env:RECURSIVE)

function SetVersion($file)
{
	$content = [System.IO.File]::ReadAllText($file)
	$content = [Regex]::Replace($content, "(\d+)\.(\d+)\.(\d+)[\.(\d+)]*", '$1.$2.$3.' + $buildNumber);
	$match = [Regex]::Match($content, "(\d+)\.(\d+)\.(\d+)." + $buildNumber)
	if ($match.success)
	{
		$version = $match.Value
		"::set-output name=version::$version"
		Write-Host "$file is set to version $version"
	}
	else
	{
		Write-Host "Failed to set version on $file"
	}

	$streamWriter = New-Object System.IO.StreamWriter($file, $false, [System.Text.Encoding]::GetEncoding("utf-8"))
	$streamWriter.Write($content)
	$streamWriter.Close()
}

if ($recursive)
{
	$assemblyInfoFiles = Get-ChildItem $directory -Recurse -Include $fileName
	foreach($file in $assemblyInfoFiles)
	{	
		SetVersion($file)
	}
}
else
{
	$file = Get-ChildItem $directory -Filter $fileName | Select-Object -First 1
	SetVersion($file)
}


