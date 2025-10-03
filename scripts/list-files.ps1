param(
    [string]$Path = ".",
    [string]$GitIgnorePath = ".gitignore"
)

function Get-GitIgnorePatterns {
    param($GitIgnoreFile)
    if (Test-Path $GitIgnoreFile) {
        Get-Content $GitIgnoreFile | Where-Object { $_ -and ($_ -notmatch '^\s*#') }
    } else {
        @()
    }
}

function Test-Ignored {
    param($Item, $Patterns)

    foreach ($pattern in $Patterns) {
        # Convert .gitignore glob to regex
        $regex = $pattern `
            -replace '\.', '\.' `
            -replace '\*', '.*' `
            -replace '\?', '.'
        
        if ($Item -match $regex) {
            return $true
        }
    }
    return $false
}

function Show-Tree {
    param(
        [string]$BasePath,
        [int]$Indent = 0,
        [string[]]$IgnorePatterns
    )

    $items = Get-ChildItem -LiteralPath $BasePath | Sort-Object Name

    foreach ($item in $items) {
        $relative = $item.FullName.Substring((Resolve-Path $BasePath).Path.Length).TrimStart('\')

        if (Test-Ignored $relative $IgnorePatterns) {
            continue
        }

        $prefix = " " * ($Indent * 4)
        if ($item.PSIsContainer) {
            Write-Output "$prefix- $($item.Name) (Folder)"
            Show-Tree -BasePath $item.FullName -Indent ($Indent + 1) -IgnorePatterns $IgnorePatterns
        } else {
            Write-Output "$prefix- $($item.Name) (File)"
        }
    }
}

# Main Execution
$patterns = Get-GitIgnorePatterns -GitIgnoreFile $GitIgnorePath
Show-Tree -BasePath (Resolve-Path $Path).Path -IgnorePatterns $patterns
