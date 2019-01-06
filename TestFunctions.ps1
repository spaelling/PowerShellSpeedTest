<#
functions for testing various performance metrics
#>
function Test-ListIntegersForeachObject {
    [CmdletBinding()]
    param (
        $List,
        $Iterations = 25
    )
    Write-Verbose "Running $Iterations iterations of $($MyInvocation.InvocationName)"

    $Time = 0
    for ($i = 0; $i -lt $Iterations; $i++) {
        $Time += Measure-Command -Expression {
            $List | ForEach-Object {
                $null = $_
            }
        } | Select-Object -ExpandProperty TotalMilliseconds        
    }
    $Time / $Iterations
}
function Test-ListIntegersForeach {
    [CmdletBinding()]
    param (
        $List,
        $Iterations = 25
    )
    Write-Verbose "Running $Iterations iterations of $($MyInvocation.InvocationName)"

    $Time = 0
    for ($i = 0; $i -lt $Iterations; $i++) {
        $Time += Measure-Command -Expression {
            foreach ($item in $List) {
                $null = $item
            }
        } | Select-Object -ExpandProperty TotalMilliseconds        
    }
    $Time / $Iterations
}
function Test-ListIntegersFor {
    [CmdletBinding()]
    param (
        $List,
        $Iterations = 25
    )
    Write-Verbose "Running $Iterations iterations of $($MyInvocation.InvocationName)"

    $Time = 0
    for ($i = 0; $i -lt $Iterations; $i++) {
        $Time += Measure-Command -Expression {
            for ($i = 0; $i -lt $List.Count; $i++) {
                $null = $List[$i]
            }
        } | Select-Object -ExpandProperty TotalMilliseconds        
    }
    $Time / $Iterations
}

function Test-AddToArrayPlusEqual {
    [CmdletBinding()]
    param (
        $Count,
        $Iterations = 25
    )
    Write-Verbose "Running $Iterations iterations of $($MyInvocation.InvocationName)"

    $Time = 0
    for ($i = 0; $i -lt $Iterations; $i++) {
        $Time += Measure-Command -Expression {
            $_List = @()            
            for ($j = 0; $j -lt $Count; $j++) {
                $_List += $j
            }
        } | Select-Object -ExpandProperty TotalMilliseconds        
    }
    $Time / $Iterations
}

function Test-AddToArrayAdd {
    [CmdletBinding()]
    param (
        $Count,
        $Iterations = 25
    )
    Write-Verbose "Running $Iterations iterations of $($MyInvocation.InvocationName)"

    $Time = 0
    for ($i = 0; $i -lt $Iterations; $i++) {
        $Time += Measure-Command -Expression {
            $_List = New-Object 'System.Collections.ArrayList'
            for ($j = 0; $j -lt $Count; $j++) {
                $_List.Add($j)
            }
        } | Select-Object -ExpandProperty TotalMilliseconds        
    }
    $Time / $Iterations
}