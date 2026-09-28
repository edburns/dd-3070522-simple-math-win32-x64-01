[CmdletBinding()]
param(
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N = 0
)

Set-StrictMode -Version Latest

function Get-Fibonacci {
    [CmdletBinding()]
    [OutputType([System.Numerics.BigInteger])]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    [System.Numerics.BigInteger]$previous = 0
    [System.Numerics.BigInteger]$current = 1
    for ($i = 0; $i -lt $N; $i++) {
        $next = $previous + $current
        $previous = $current
        $current = $next
    }
    return $previous
}

if ($MyInvocation.InvocationName -ne '.') {
    $ErrorActionPreference = 'Stop'
    $value = Get-Fibonacci -N $N
    Write-Output "Fibonacci($N) = $value"
}
