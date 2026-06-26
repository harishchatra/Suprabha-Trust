$ErrorActionPreference = "Stop"

$inFile = "C:\Users\DELL\Downloads\suprabha-trust (14).html"
$outDir = "src\pages"

if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

$lines = Get-Content -Path $inFile
$currentPage = $null
$content = @()

foreach ($line in $lines) {
    if ($line -match '<div class="page-window"\s+id="page-(.*?)"') {
        # If we were capturing a page, save it
        if ($currentPage) {
            # remove the last line if it's just '</div>'
            if ($content[-1] -match '^\s*</div>\s*$') {
                $content = $content[0..($content.Length - 2)]
            }
        
            $pageContent = "<!-- INCLUDE header -->`n<!-- INCLUDE sidebar -->`n<!-- SET_TITLE: $currentPage | Suprabha Trust -->`n<main id=`"spt-main`">`n" + ($content -join "`n") + "`n</main>`n<!-- INCLUDE footer -->"
            
            # If the page is "home", name it "index.html"
            $fileName = $currentPage
            if ($fileName -eq "home") { $fileName = "index" }
            
            $outPath = Join-Path -Path $outDir -ChildPath "$fileName.html"
            [IO.File]::WriteAllText($outPath, $pageContent, [System.Text.Encoding]::UTF8)
            Write-Host "Extracted $fileName.html"
        }
        
        # Start new page
        $currentPage = $matches[1]
        $content = @()
        
        # We don't include the `<div class="page-window"...` line itself, because we replace it with `<main>` wrapper
        continue
    }
    
    if ($currentPage) {
        # Stop capturing when we hit the footer
        if ($line -match '<footer') {
            # remove the last line if it's just '</div>'
            if ($content[-1] -match '^\s*</div>\s*$') {
                $content = $content[0..($content.Length - 2)]
            }
        
            $pageContent = "<!-- INCLUDE header -->`n<!-- INCLUDE sidebar -->`n<!-- SET_TITLE: $currentPage | Suprabha Trust -->`n<main id=`"spt-main`">`n" + ($content -join "`n") + "`n</main>`n<!-- INCLUDE footer -->"
            
            $fileName = $currentPage
            if ($fileName -eq "home") { $fileName = "index" }
            
            $outPath = Join-Path -Path $outDir -ChildPath "$fileName.html"
            [IO.File]::WriteAllText($outPath, $pageContent, [System.Text.Encoding]::UTF8)
            Write-Host "Extracted $fileName.html"
            
            $currentPage = $null
            $content = @()
            continue
        }
        
        $content += $line
    }
}

Write-Host "Extraction complete!"
