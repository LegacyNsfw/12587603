param($path)

$lines = [IO.File]::ReadAllLines($path)

$builder = New-Object -TypeName "System.Text.StringBuilder";

foreach($line in $lines)
{
	if (-not $line.StartsWith("; |"))
	{
		$unused = $builder.AppendLine($line)
	}
}

$name = [System.IO.Path]::GetFileNameWithoutExtension($path)
Out-File -FilePath ($name + ".sanitized.asm") -InputObject $builder.ToString() -Encoding ASCII