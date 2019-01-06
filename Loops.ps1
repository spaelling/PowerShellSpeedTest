. "$PSScriptRoot\TestFunctions.ps1"

$Start = 1000
$Increment = 5000
$Max = 100000
$Iterations = 3
$DataSet0 = New-Object 'System.Collections.Generic.List[System.Object]'
for ($i = $Start; $i -lt $Max; $i += $Increment) {
    $MyList = 1..$i

    $ListIntegersForeachObject = Test-ListIntegersForeachObject -List $MyList -Iterations $Iterations
    $ListIntegersForeach = Test-ListIntegersForeach -List $MyList -Iterations $Iterations
    $ListIntegersFor = Test-ListIntegersFor -List $MyList -Iterations $Iterations

    $DataSet0.Add(
        [PSCustomObject]@{
            x = $i
            ForeachObject = $ListIntegersForeachObject
            Foreach = $ListIntegersForeach
            For = $ListIntegersFor
        }
    )    
}

# TODO: test add value to array

Remove-Module -Name ReportHTML -ErrorAction SilentlyContinue
# Cloned from https://github.com/spaelling/ReportHTML
Import-Module 'C:\git\ReportHTML\ReportHTML\ReportHTML.psm1'

$tabarray = @('Loops')

$LineObject0 = Get-HTMLLineChartObject -ColorScheme Random -DataSetNames 'ForeachObject', 'Foreach', 'For'
$LineObject0.Title = "Indexing"

$LineObject1 = Get-HTMLLineChartObject -ColorScheme Random -DataSetName 'ForeachObject'
$LineObject1.Title = "Foreach-Object"

$LineObject2 = Get-HTMLLineChartObject -ColorScheme Random -DataSetName 'Foreach'
$LineObject2.Title = "Foreach"

$LineObject3 = Get-HTMLLineChartObject -ColorScheme Random -DataSetName 'For'
$LineObject3.Title = "For-loop"

$rpt = New-Object 'System.Collections.Generic.List[System.Object]'
#region generate html
$rpt += Get-HTMLOpenPage -TitleText 'TitleText'

$rpt += Get-HTMLTabHeader -TabNames $tabarray    
    $rpt += Get-HTMLTabContentOpen -TabName $tabarray[0] -TabHeading ("Report: " + (Get-Date -Format MM-dd-yyyy))  
        $rpt += Get-HtmlContentOpen -HeaderText "Results"
            $rpt += Get-HtmlContenttext -Heading "Test" -Detail "Indexing array and assigning value to `$null"
            $rpt += Get-HtmlContenttext -Heading "Iterations" -Detail $Iterations
            $rpt += Get-HtmlContenttext -Heading "Increment" -Detail $Increment        
            $rpt += Get-HTMLLineChart -ChartObject $LineObject0 -DataSet $DataSet0
            #$rpt += Get-HTMLLineChart -ChartObject $LineObject1 -DataSet $DataSet0
            #$rpt += Get-HTMLLineChart -ChartObject $LineObject2 -DataSet $DataSet0
            #$rpt += Get-HTMLLineChart -ChartObject $LineObject3 -DataSet $DataSet0
        $rpt += Get-HTMLContentClose
    $rpt += Get-HTMLTabContentClose

$rpt += Get-HTMLClosePage

#endregion

Write-Output "Saving report..."
$ReportName = 'psspeedtestreport' # below will append .html
$ReportSavePath = $env:TEMP
Save-HTMLReport -ReportContent $rpt -ReportName $ReportName -ReportPath $ReportSavePath

# https://www.chartjs.org/docs/latest/charts/line.html

<# using different implementations of arrays
$Base = 1..25000
$Iterations = 100
# 279ms
Test-ListIntegersForeachObject -List $Base -Iterations $Iterations
[int[]]$myArray = $Base
# 288ms
Test-ListIntegersForeachObject -List $myArray -Iterations $Iterations
$MyArrayList = New-Object System.Collections.ArrayList; $MyArrayList.AddRange($Base)
# 271 ms
Test-ListIntegersForeachObject -List $MyArrayList -Iterations $Iterations
#>