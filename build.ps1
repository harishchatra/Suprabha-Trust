$ErrorActionPreference = "Stop"

$srcPagesDir = "src\pages"
$srcCompDir = "src\components"
$outDir = "."

# Ensure output directory exists (root)
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

# Read components
$header = Get-Content -Path "$srcCompDir\header.html" -Raw -Encoding UTF8
$footer = Get-Content -Path "$srcCompDir\footer.html" -Raw -Encoding UTF8
$sidebar = Get-Content -Path "$srcCompDir\sidebar.html" -Raw -Encoding UTF8

# Get all HTML files in pages directory
$pages = Get-ChildItem -Path $srcPagesDir -Filter "*.html" -Recurse

foreach ($page in $pages) {
    $content = Get-Content -Path $page.FullName -Raw -Encoding UTF8
    
    # Extract Title and Description from page if present
    $title = "Suprabha Trust - Mystic Sciences of Ancient India"
    $desc = "Preserving and promoting India's mystic sciences, ancient wisdom, Vedic traditions, and cultural heritage."
    
    if ($content -match "<!-- SET_TITLE:\s*(.+?)\s*-->") {
        # Format the title nicely
        $rawTitle = $matches[1]
        $rawTitle = (Get-Culture).TextInfo.ToTitleCase($rawTitle.ToLower())
        $title = "$rawTitle | Suprabha Trust"
    }
    if ($content -match "<!-- SET_DESC:\s*(.+?)\s*-->") {
        $desc = $matches[1]
    }
    
    # Process Header variables
    # If the page is in a subdirectory, the header links need to be relative to root
    # Wait, the header links are absolute (using /) or relative?
    # Our header.html probably uses just "about.html", which works if all files are at root.
    # But if a file is in knowledge/, "about.html" will be broken. It needs to be "../about.html".
    # Since this is a simple static site, it's better to just write everything to the root, but rename files?
    # No, the user explicitly asked for `knowledge/vedic-sciences.html`.
    # Let's handle path traversal for header/footer assets.
    $relativePath = Resolve-Path -Relative $page.FullName -ErrorAction SilentlyContinue
    if (-not $relativePath) {
        $relativePath = $page.FullName.Substring((Get-Location).Path.Length + 1)
    }
    # Remove the src\pages\ prefix
    $relativeToPages = $relativePath -replace "^.*?[\\/]src[\\/]pages[\\/]", ""
    
    $outPath = Join-Path -Path $outDir -ChildPath $relativeToPages
    $outDirPath = Split-Path -Path $outPath -Parent
    
    if (-not (Test-Path $outDirPath)) {
        New-Item -ItemType Directory -Path $outDirPath -Force | Out-Null
    }
    
    $depth = ($relativeToPages.Split("\/").Count) - 1
    $prefix = ""
    if ($depth -gt 0) {
        for ($i=0; $i -lt $depth; $i++) { $prefix += "../" }
    }
    
    # Process Header variables
    $processedHeader = $header.Replace("<!-- VAR_TITLE -->", $title)
    $processedHeader = $processedHeader.Replace("<!-- VAR_DESC -->", $desc)
    
    # Replace includes
    $content = $content.Replace("<!-- INCLUDE header -->", $processedHeader)
    $content = $content.Replace("<!-- INCLUDE footer -->", $footer)
    $content = $content.Replace("<!-- INCLUDE sidebar -->", $sidebar)
    
    # Fix paths in included components if we are in a subdirectory
    if ($depth -gt 0) {
        $content = $content -replace 'href="(?!(http|#|mailto:|tel:|/))([^"]+)"', "href=`"$prefix`$2`""
        $content = $content -replace 'src="(?!(http|data:|/))([^"]+)"', "src=`"$prefix`$2`""
    }
    
    # Active class logic: replace the class string for the current page
    $pageName = $page.BaseName
    $content = $content.Replace("data-pid=""$pageName"" class=""mpt-tab""", "data-pid=""$pageName"" class=""mpt-tab active""")
    $content = $content.Replace("data-pid=""$pageName"" class=""mpt-sb-link""", "data-pid=""$pageName"" class=""mpt-sb-link active""")
    
    # Lazy loading optimization
    $content = $content -replace '(<img(?!.*?loading="lazy").*?>)', '$1' -replace '<img ', '<img loading="lazy" '
    
    # Clean up SET commands
    $content = $content -replace "(?s)<!-- SET_TITLE:.*?-->", ""
    $content = $content -replace "(?s)<!-- SET_DESC:.*?-->", ""
    
    # Write output
    [IO.File]::WriteAllText($outPath, $content, [System.Text.Encoding]::UTF8)
    Write-Host "Built $relativeToPages"
}

Write-Host "Build complete!"
