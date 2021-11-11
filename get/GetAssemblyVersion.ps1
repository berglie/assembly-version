$filename = $Env:FILENAME
$directory = $Env:DIRECTORY
$version = ""

function GetVersion ($file)
{
 	$content = [System.IO.File]::ReadAllText($file)
	$pattern = "(\d+)\.(\d+)\.(\d+)[\.(\d+)]*"
	$version = [System.Text.RegularExpressions.Regex]::Match($content, $pattern).Groups[0].Value
	return $version
}

Write-Host "Looking for file '$filename' inside directory $directory"
$versionInfo = Get-ChildItem $directory -Recurse -Include $filename -Force -File | Select-Object -First 1 Name,@{n='FileVersion';e={$_.VersionInfo.FileVersion}},@{n='AssemblyVersion';e={[Reflection.AssemblyName]::GetAssemblyName($_.FullName).Version}}
if ($versionInfo -ne $null) 
{
	Write-Host "Found file $versionInfo"
	$version = $versionInfo.AssemblyVersion	
	if ([string]::IsNullOrEmpty($version))
	{
		$file = Get-ChildItem $directory -Recurse -Include $filename -Force -File | Select-Object -First 1 
		$version = GetVersion($file)
		
	}	
	
	if ([string]::IsNullOrEmpty($version))
	{
		Write-Host Failed to get version
	}
	else
	{
		Write-Host Found version: $version
		"::set-output name=version::$version"
	}	
}
else
{
	Write-Host Failed to get version
}
