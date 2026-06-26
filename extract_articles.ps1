$sourceHtml = Get-Content "C:\Users\DELL\Downloads\suprabha-trust (14).html" -Raw

# We need to extract each <div class="kb-overlay" id="kb-..."> ... </div>
$regex = '(?s)<div class="kb-overlay" id="kb-(.*?)">.*?<div class="kb-modal-header">(.*?)</div>.*?<div class="kb-modal-body">(.*?)<button class="kb-close-btn".*?</div>'

$matches = [regex]::Matches($sourceHtml, $regex)

foreach ($match in $matches) {
    $id = $match.Groups[1].Value
    $headerHtml = $match.Groups[2].Value
    $bodyHtml = $match.Groups[3].Value

    # Extract title from header
    $titleRegex = '<p style="font-family: ''Cormorant Garamond''.*?>(.*?)</p>'
    $titleMatch = [regex]::Match($headerHtml, $titleRegex)
    $title = "Untitled Article"
    if ($titleMatch.Success) {
        $title = $titleMatch.Groups[1].Value
    }

    # Extract meta from header
    $metaRegex = '<p style="font-size: 1\.02rem.*?>(.*?)</p>'
    $metaMatch = [regex]::Match($headerHtml, $metaRegex)
    $meta = ""
    if ($metaMatch.Success) {
        $meta = $metaMatch.Groups[1].Value
    }
    
    # Extract badges
    $badgesRegex = '(?s)<div style="display: flex; gap: 0\.5rem.*?>.*?<span.*?>(.*?)</span>.*?</p>'
    # This is a bit hard with regex, let's just grab the whole div containing badges if possible, or just ignore badges for now and let the template handle it.
    
    # Let's map IDs to slug names
    $slugMap = @{
        "vedic" = "vedic-sciences"
        "humanistic" = "life-sciences"
        "meta" = "meta-physics"
        "ils" = "vedic-blueprint"
        "ils2" = "ils-meta-physics"
        "humanistic2" = "humanistic-energy"
        "lifescience" = "life-sciences-documentary"
        "biofield" = "biofield-sciences"
        "sanatana" = "sanatana-dharma"
    }

    $slug = $slugMap[$id]
    if (-not $slug) {
        $slug = $id
    }

    $template = @"
<!-- INCLUDE header -->
<!-- INCLUDE sidebar -->
<!-- SET_TITLE: $title | Knowledge Bank | Suprabha Trust -->
<!-- SET_DESC: Explore the Knowledge Bank article on $title -->

<main id="spt-main">
  <style>
    .kb-article { max-width: 820px; margin: 0 auto; }
    .kb-article-header { background: #2C0F0F; padding: 2.5rem 3rem; }
    .kb-article-body { background: #F5F0E8; padding: 2.5rem 3rem; }
    .kb-article-body h2 { font-family: 'Cormorant Garamond', serif; font-size: 1.6rem; color: #4A1818; margin: 2rem 0 0.75rem; font-weight: 400; }
    .kb-article-body h3 { font-family: 'Cormorant Garamond', serif; font-size: 1.4rem; color: #7A2828; margin: 1.5rem 0 0.5rem; font-weight: 400; }
    .kb-article-body p { font-size: 1.04rem; color: #2C1000; line-height: 1.85; margin-bottom: 1rem; }
    .kb-article-body ul { list-style: none; margin: 0.75rem 0 1rem; padding: 0; }
    .kb-article-body ul li { font-size: 1.02rem; color: #3A2000; line-height: 1.75; padding-left: 1.1rem; position: relative; margin-bottom: 0.3rem; }
    .kb-article-body ul li::before { content: '◆'; position: absolute; left: 0; color: #B8860B; font-size: 0.45rem; top: 0.38rem; }
    .kb-pullquote { border-left: 3px solid #B8860B; padding: 1rem 1.25rem; background: rgba(184,134,11,0.06); margin: 1.5rem 0; border-radius: 0 2px 2px 0; }
    .kb-pullquote p { font-family: 'Cormorant Garamond', serif; font-size: 1.05rem; color: #4A1818; font-style: italic; margin: 0; }
    .kb-modal-table { width: 100%; border-collapse: collapse; margin: 1rem 0 1.5rem; font-size: 0.98rem; }
    .kb-modal-table th { background: #B8860B; color: white; padding: 0.5rem 0.8rem; text-align: left; font-family: 'Jost', sans-serif; font-size: 1.05rem; letter-spacing: 0.1em; text-transform: uppercase; font-weight: 500; }
    .kb-modal-table td { padding: 0.5rem 0.8rem; border-bottom: 1px solid rgba(184,134,11,0.12); color: #2C1000; line-height: 1.6; vertical-align: top; }
    .kb-modal-table tr:nth-child(even) td { background: rgba(184,134,11,0.04); }
    .kb-cat-badge { display: inline-block; font-size: 0.98rem; font-weight: 500; letter-spacing: 0.18em; text-transform: uppercase; padding: 0.2rem 0.7rem; border-radius: 2px; font-family: 'Jost', sans-serif; margin-right: 0.4rem; }
    .kb-back-btn { display: inline-block; background: #B8860B; color: #2C0F0F; border: none; padding: 0.6rem 1.5rem; font-family: 'Jost', sans-serif; font-size: 1rem; font-weight: 500; letter-spacing: 0.12em; text-transform: uppercase; cursor: pointer; border-radius: 2px; margin-top: 2rem; text-decoration: none; }
  </style>

  <article class="kb-article">
    <div class="kb-article-header">
      <h1 style="font-family:'Cormorant Garamond',serif;font-size:2.4rem;color:#FEFCF4;font-weight:400;line-height:1.2;margin-bottom:0.5rem;">$title</h1>
      <p style="font-size:1.02rem;color:rgba(255,240,232,0.4);font-family:'Jost',sans-serif;">$meta</p>
    </div>
    <div class="kb-article-body">
$bodyHtml
      
      <a href="../knowledge.html" class="kb-back-btn">← Back to Knowledge Bank</a>
    </div>
  </article>
</main>
<!-- INCLUDE footer -->
"@

    Set-Content -Path "src\pages\knowledge\$slug.html" -Value $template
    Write-Host "Extracted: src\pages\knowledge\$slug.html"
}
