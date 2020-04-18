param($Path, $TableAddress, $ParameterCount)

$bytes = [System.IO.File]::ReadAllBytes($Path)

$baseAddress = [Convert]::ToUInt16($TableAddress, 16);

$lines = [IO.File]::ReadAllLines("C:\GitHub\12587603\Resources\pidlist.txt")

$builder = New-Object -TypeName "System.Text.StringBuilder";
$unused = $builder.AppendLine("static main() {")
$unused = $builder.AppendLine("auto nameFlags = 0;")

$pids = @{}
foreach($line in $lines)
{
	$parts = $line.Split(' ', 2);
	$name = $parts[1] -replace '[^a-zA-Z]'
	$pids.Add($parts[0], $name);		
}

foreach ($index in 0 .. $ParameterCount)
{
	$start = $baseAddress + (8 * $index);

	$parameterId = $bytes[$start] * 256
	$parameterId += $bytes[$start+1]

	$functionAddress = $bytes[$start+5] * 256 * 256
	$functionAddress += $bytes[$start+6] * 256
	$functionAddress += $bytes[$start+7]

	$parameterIdString = $parameterId.ToString("X4")
	$pidName = $pids[$parameterIdString]
	$functionName = "GetPid_" + $parameterIdString

	if (-not [string]::IsNullOrEmpty($pidName))
	{
		$functionName += "_" + $pidName
	}

	$functionAddress = "0x" + $functionAddress.ToString("X6")
#	$unused = $builder.AppendLine("MakeFunction($functionAddress);");
	$unused = $builder.AppendLine("MakeNameEx($functionAddress, `"$functionName`", nameFlags);")
}

$unused = $builder.Append("}")
Out-File -FilePath ($Path + ".pids.idc") -InputObject $builder.ToString() -Encoding ASCII