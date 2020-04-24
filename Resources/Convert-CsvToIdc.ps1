$inPath = "12587603.csv"
$outPath = $inPath + ".idc"

$builder = New-Object -TypeName "System.Text.StringBuilder";

$unused = $builder.AppendLine("static main() {")
$unused = $builder.AppendLine("auto nameFlags = 0;")

$records = Import-Csv -Path $inPath

foreach ($record in $records)
{
    $name = $record.MODULE + "_" + $record.LABEL
    $comment = $record.COMMENT + "\n" + $record.UNITS
    $address = "0x" + $record.ADDRESS

	$unused = $builder.AppendLine("MakeNameEx($address, `"$name`", nameFlags);")

    if (-not $comment.StartsWith("$"))
    {
        $unused = $builder.AppendLine("MakeRptCmt($address, `"$comment`");")
    }
}

$unused = $builder.Append("}")

Out-File -FilePath ($outPath) -InputObject $builder.ToString() -Encoding ASCII