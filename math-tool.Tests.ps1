BeforeAll {
    $script:MathToolPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    . $script:MathToolPath
}

Describe 'Get-Fibonacci' {
    It 'returns <Expected> for N=<N>' -ForEach @(
        @{ N = 0; Expected = 0 }
        @{ N = 1; Expected = 1 }
        @{ N = 2; Expected = 1 }
        @{ N = 10; Expected = 55 }
    ) {
        Get-Fibonacci -N $N | Should -Be $Expected
    }

    It 'returns a single numeric value with no incidental output' {
        $output = @(Get-Fibonacci -N 10 *>&1)

        $output.Count | Should -Be 1
        $output[0] | Should -BeOfType [System.Numerics.BigInteger]
        $output[0] | Should -Be 55
    }

    It 'rejects negative input' {
        { Get-Fibonacci -N -1 } | Should -Throw
    }
}

Describe 'math-tool.ps1 direct execution' {
    BeforeAll {
        $script:PwshPath = (Get-Process -Id $PID).Path
    }

    It 'prints exactly "<Expected>" for N=<N>' -ForEach @(
        @{ N = 0; Expected = 'Fibonacci(0) = 0' }
        @{ N = 1; Expected = 'Fibonacci(1) = 1' }
        @{ N = 10; Expected = 'Fibonacci(10) = 55' }
    ) {
        $output = @(& $script:PwshPath -NoLogo -NoProfile -NonInteractive -File $script:MathToolPath -N $N 2>&1)
        $exitCode = $LASTEXITCODE

        $exitCode | Should -Be 0
        $output.Count | Should -Be 1
        $output[0] | Should -BeOfType [string]
        $output[0] | Should -BeExactly $Expected
    }
}
