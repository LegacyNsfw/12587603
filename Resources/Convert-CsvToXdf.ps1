$inPath = "12587603.csv"
$outPath = $inPath + ".xdf"

$builder = New-Object -TypeName "System.Text.StringBuilder";

$xdfHeaderStart = @"
<XDFFORMAT version="1.60">
  <XDFHEADER>
    <flags>0x1</flags>
    <fileversion>Ver 1</fileversion>
    <deftitle>12587603 raw</deftitle>
    <description>Dumpster-dive data for the 12587603 operating system.</description>
    <author>DzidaV8</author>
    <BASEOFFSET offset="0" subtract="0" />
    <DEFAULTS datasizeinbits="16" sigdigits="1" outputtype="2" signed="0" lsbfirst="0" float="0" />
    <REGION type="0xFFFFFFFF" startaddress="0x0" size="0xFFFFF" regionflags="0x0" name="Binary File" desc="Editable range" />
"@

$unused = $builder.AppendLine($xdfHeaderStart)

$xdfHeaderEnd = "  </XDFHEADER>"

$xdfFooter = "</XDFFORMAT>"

### Create categories

# TODO: Should this start at zero?
$categoryCount = 1
$categories = @{}

$records = Import-Csv -Path $inPath
foreach ($record in $records)
{
    if ($categories.ContainsKey($record.MODULE))
    {
        continue
    }

    $categories[$record.MODULE] = $categoryCount

    # This index attribute really does need to be in hexadecimal
    $unused = $builder.AppendLine('    <CATEGORY index="' + $categoryCount.ToString("X") + '" name="' + $record.MODULE + '"/>')
    $categoryCount = $categoryCount + 1
}

$unused = $builder.AppendLine($xdfHeaderEnd)

### Create itens

$count = 0
$records = Import-Csv -Path $inPath
foreach ($record in $records)
{
    $categoryName = $record.MODULE
    $categoryId = $categories[$categoryName] + 1

    $name = $record.LABEL
    if (($name.Length -eq 0) -or -not [System.Char]::IsLetterOrDigit($name[0]))
    {
        $name = "_" + $name
    }

    $units = $record.UNITS
    $comment = $record.COMMENT + "\n" + $record.UNITS
    $address = "0x" + $record.ADDRESS
    $uniqueId = "0x" + ($name + $comment + $address).GetHashCode().ToString("X")

    if ($comment.StartsWith("$"))
    {
        $comment = ""
    }

    $comment = $comment.Replace("<", "&lt;").Replace(">", "&gt;").Replace("&", "&amp;")

    $xdfConstant = @"
  <XDFCONSTANT uniqueid="$uniqueId" flags="0xC">
    <title>$name - $units</title>
    <description>$comment</description>
    <CATEGORYMEM index="0" category="$categoryId" />
    <EMBEDDEDDATA mmedaddress="$address" mmedelementsizebits="16" mmedmajorstridebits="0" mmedminorstridebits="0" />
    <outputtype>3</outputtype>
    <decimalpl>0</decimalpl>
    <rangehigh>0</rangehigh>
    <rangelow>65536</rangelow>
    <datatype>0</datatype>
    <unittype>0</unittype>
    <DALINK index="0" />
    <MATH equation="X">
      <VAR id="X" />
    </MATH>
  </XDFCONSTANT>
"@

	$unused = $builder.AppendLine($xdfConstant)

    $count++ 
}

write-host "$count records processed"

$unused = $builder.Append($xdfFooter)

Out-File -FilePath ($outPath) -InputObject $builder.ToString() -Encoding ASCII
