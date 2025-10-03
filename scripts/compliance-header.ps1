# ============================================================
#  Soke Compliance Header Inserter
#  Author: Ishura
#  Description: Adds copyright headers to all project files
# ============================================================

$root = Get-Location

$commentStyles = @{
    ".py"   = "#"
    ".yml"  = "#"
    ".yaml" = "#"
    ".md"   = "#"
    ".ps1"  = "<#"
}

$endCommentStyles = @{
    ".ps1"  = "#>"
}

# Function to generate header text
function Get-Header($filename, $ext) {
    $base = @()
    $comment = $commentStyles[$ext]

    if ($comment -eq "<#") {
        # PowerShell block comment
        $base += "<#"
        $base += "============================================================"
        $base += "  Project: Soke"
        $base += "  File: $filename"
        $base += "  Author: Ishura"
        $base += ""
        $base += "  This file ($filename) is part of the Soke project."
        $base += "  © 2025 Ishura. All rights reserved."
        $base += "============================================================"
        $base += "#>"
    }
    else {
        # Line comment style
        $base += "$comment ============================================================"
        $base += "$comment  Project: Soke"
        $base += "$comment  File: $filename"
        $base += "$comment  Author: Ishura"
        $base += "$comment"
        $base += "$comment  This file ($filename) is part of the Soke project."
        $base += "$comment  © 2025 Ishura. All rights reserved."
        $base += "$comment ============================================================"
    }

    return ($base -join "`n")
}

$files = Get-ChildItem -Path $root -Recurse -Include *.py, *.yml, *.yaml, *.md, *.ps1

foreach ($file in $files) {
    $ext = $file.Extension.ToLower()
    if (-not $commentStyles.ContainsKey($ext)) { continue }

    $filename = $file.Name
    $header = Get-Header $filename $ext

    $content = Get-Content $file.FullName -Raw

    if ($content -match "Project: Soke") {
        Write-Host "Skipping $filename (already has header)"
        continue
    }

    $newContent = $header + "`n`n" + $content
    Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8

    Write-Host "Added header to $filename"
}

Write-Host "Compliance check complete!"
