$utf8NoBom = New-Object System.Text.UTF8Encoding $False

$svgOriginal = Get-Content -Raw "$PSScriptRoot\header.txt"
$svgOriginal = $svgOriginal -replace '(?s)<!-- NAV -->.*', ''

$headTemplate = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>##TITLE##</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="assets/css/theme.css">
<link rel="stylesheet" href="assets/css/layout.css">
<link rel="stylesheet" href="assets/css/components.css">
<link rel="stylesheet" href="assets/css/animations.css">
<script defer src="assets/js/main.js"></script>
<link rel="canonical" href="##CANONICAL##">
</head>
<body>
"@

$svgDefs = @"
<svg width="0" height="0" style="position:absolute">
  <defs>
    <symbol id="yantra-circle" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="45" stroke="currentcolor" stroke-width="0.5" fill="none" />
      <circle cx="50" cy="50" r="35" stroke="currentcolor" stroke-width="0.5" fill="none" />
      <circle cx="50" cy="50" r="25" stroke="currentcolor" stroke-width="0.5" fill="none" />
      <line x1="5" y1="50" x2="95" y2="50" stroke="currentcolor" stroke-width="0.5" />
      <line x1="50" y1="5" x2="50" y2="95" stroke="currentcolor" stroke-width="0.5" />
      <line x1="18.18" y1="18.18" x2="81.82" y2="81.82" stroke="currentcolor" stroke-width="0.5" />
      <line x1="18.18" y1="81.82" x2="81.82" y2="18.18" stroke="currentcolor" stroke-width="0.5" />
    </symbol>
  </defs>
</svg>
"@

function Build-Page {
    param($filename, $title, $sections)
    
    $nav = @"
<!-- NAV -->
<nav>
  <a href="index.html" class="nav-logo-wrap">
    <svg><use href="#yantra-circle"/></svg>
    <div class="nav-logo-text">
      <span class="name">Suprabha Trust</span>
      <span class="tagline">Mystic Sciences</span>
    </div>
  </a>
  <button class="nav-toggle" aria-label="Toggle Navigation" aria-expanded="false">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--color-text-on-dark)" stroke-width="2"><path d="M3 12h18M3 6h18M3 18h18"/></svg>
  </button>
  <ul class="nav-links">
    <li><a href="index.html" $(if($filename -eq 'index.html'){"class='active' aria-current='page'"})>Home</a></li>
    <li><a href="knowledge.html" $(if($filename -eq 'knowledge.html'){"class='active' aria-current='page'"})>Knowledge Bank</a></li>
    <li><a href="articles.html" $(if($filename -eq 'articles.html'){"class='active' aria-current='page'"})>Articles</a></li>
    <li><a href="videos.html" $(if($filename -eq 'videos.html'){"class='active' aria-current='page'"})>Videos</a></li>
    <li><a href="renewable.html" $(if($filename -eq 'renewable.html'){"class='active' aria-current='page'"})>Renewable</a></li>
    <li><a href="about.html" $(if($filename -eq 'about.html'){"class='active' aria-current='page'"})>About</a></li>
    <li><a href="contact.html" $(if($filename -eq 'contact.html'){"class='active' aria-current='page'"})>Contact</a></li>
    <li><a href="contact.html#donate" class="btn-donate">Donate</a></li>
  </ul>
</nav>
"@

    $canonicalUrl = if ($filename -eq "index.html") { "https://www.suprabha-trust.in/" } else { "https://www.suprabha-trust.in/$filename" }
    $pageHead = $headTemplate -replace '##TITLE##', $title
    $pageHead = $pageHead -replace '##CANONICAL##', $canonicalUrl
    
    $content = $pageHead + "`n" + $svgOriginal + "`n" + $svgDefs + "`n" + $nav + "`n<main>`n"
    
    foreach ($sec in $sections) {
        $secContent = Get-Content -Raw "$PSScriptRoot\$sec"
        
        $secContent = $secContent -replace 'class="hero-eyebrow"', 'class="eyebrow reveal"'
        $secContent = $secContent -replace 'class="section-eyebrow"', 'class="eyebrow reveal"'
        $secContent = $secContent -replace 'class="section-title"', 'class="reveal"'
        $secContent = $secContent -replace 'class="section-desc"', 'class="reveal"'
        $secContent = $secContent -replace 'class="gold-line"', 'class="divider reveal"'
        $secContent = $secContent -replace 'class="hero-divider"', 'class="hero-divider reveal"'
        $secContent = $secContent -replace 'class="hero-sub"', 'class="reveal"'
        $secContent = $secContent -replace 'class="hero-actions"', 'class="hero-actions reveal"'
        $secContent = $secContent -replace 'class="btn-outline"', 'class="btn-secondary"'
        
        $secContent = $secContent -replace 'class="aspect-card"', 'class="card reveal"'
        $secContent = $secContent -replace 'class="conn-card"', 'class="card reveal"'
        $secContent = $secContent -replace 'class="impact-card"', 'class="card reveal"'
        $secContent = $secContent -replace 'class="partner-card"', 'class="card reveal"'
        $secContent = $secContent -replace 'class="aspects-grid"', 'class="card-grid"'
        $secContent = $secContent -replace 'class="connections-grid"', 'class="card-grid"'
        $secContent = $secContent -replace 'class="impact-grid"', 'class="card-grid"'
        $secContent = $secContent -replace 'class="partner-types"', 'class="card-grid"'
        $secContent = $secContent -replace 'class="donate-cards"', 'class="card-grid"'
        $secContent = $secContent -replace 'class="donate-card"', 'class="card reveal"'
        
        $secContent = $secContent -replace '<div class="hero-bg">[\s\S]*?</div>', '<svg class="yantra-bg"><use href="#yantra-circle"/></svg>'
        
        $content += $secContent + "`n"
    }
    
    $footer = @"
</main>
<footer>
  <div class="container">
    <div class="footer-grid">
      <div>
        <svg style="width:48px;height:48px;stroke:var(--color-secondary);fill:none;margin-bottom:1rem;"><use href="#yantra-circle"/></svg>
        <p class="font-display" style="font-size:24px;color:var(--color-text-on-dark);margin-bottom:0.5rem;">Suprabha Trust</p>
        <p style="font-size:14px;color:var(--color-text-on-dark);">Dedicated to preserving and promoting India's rich traditional and cultural sciences through conservation, education, and community engagement.</p>
        <p style="font-size:12px;color:var(--color-muted);margin-top:1rem;">Established 2006 &#183; Registered 2016 &#8212; 176/IU/2016</p>
      </div>
      <div>
        <h4>About</h4>
        <ul>
          <li style="margin-bottom:0.5rem;"><a href="about.html">Our Story</a></li>
          <li style="margin-bottom:0.5rem;"><a href="index.html#aspects">Sanatana Dharma</a></li>
          <li style="margin-bottom:0.5rem;"><a href="about.html">Mission & Vision</a></li>
        </ul>
      </div>
      <div>
        <h4>Engage</h4>
        <ul>
          <li style="margin-bottom:0.5rem;"><a href="knowledge.html">Knowledge Bank</a></li>
          <li style="margin-bottom:0.5rem;"><a href="renewable.html#programs">Upcoming Programs</a></li>
          <li style="margin-bottom:0.5rem;"><a href="articles.html">Submit Article</a></li>
          <li style="margin-bottom:0.5rem;"><a href="videos.html">Submit Video</a></li>
        </ul>
      </div>
      <div>
        <h4>Support</h4>
        <ul>
          <li style="margin-bottom:0.5rem;"><a href="contact.html#donate">Donate</a></li>
          <li style="margin-bottom:0.5rem;"><a href="contact.html">Contact Us</a></li>
          <li style="margin-bottom:0.5rem;"><a href="about.html#partnership">Partner With Us</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <span>&copy; 2026 Suprabha Trust. All rights reserved.</span>
      <a href="mailto:suprabhaind@gmail.com" style="color:var(--color-secondary);">suprabhaind@gmail.com</a>
    </div>
  </div>
</footer>
</body>
</html>
"@
    
    $content += $footer
    
    $content = $content -replace 'href="#home"', 'href="index.html#home"'
    $content = $content -replace 'href="#about"', 'href="about.html#about"'
    $content = $content -replace 'href="#aspects"', 'href="index.html#aspects"'
    $content = $content -replace 'href="#knowledge"', 'href="knowledge.html#knowledge"'
    $content = $content -replace 'href="#videos"', 'href="videos.html#videos"'
    $content = $content -replace 'href="#partnership"', 'href="about.html#partnership"'
    $content = $content -replace 'href="#contact"', 'href="contact.html#contact"'
    $content = $content -replace 'href="#programs"', 'href="renewable.html#programs"'
    $content = $content -replace 'href="#donate"', 'href="contact.html#donate"'
    
    $content = $content -replace 'href="knowledge.html#knowledge"\s+class="btn-primary">Explore Knowledge Bank', 'href="knowledge.html" class="btn-primary">Explore Knowledge Bank'
    $content = $content -replace 'href="about.html#about"\s+class="btn-secondary">Our Story', 'href="about.html" class="btn-secondary">Our Story'

    $content = $content -replace '<script data-cfasync="false" src="/cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script>', ''
    $content = $content -replace '<a href="/cdn-cgi/l/email-protection"[^>]*>\[email&#160;protected\]</a>', '<a href="mailto:suprabhaind@gmail.com">suprabhaind@gmail.com</a>'
    
    # Safe Mojibake fixes
    $content = $content.Replace([string][char]0x00C2 + [string][char]0x00B7, '&#183;')
    $content = $content.Replace([string][char]0x00E2 + [string][char]0x20AC + [string][char]0x201D, '&#8212;')
    $content = $content.Replace([string][char]0x00E2 + [string][char]0x20AC + [string][char]0x201C, '&#8211;')
    $content = $content.Replace([string][char]0x00C2 + [string][char]0x00A9, '&copy;')
    
    [System.IO.File]::WriteAllText("$PSScriptRoot\..\$filename", $content, $utf8NoBom)
}

Build-Page "index.html" "Home | Suprabha Trust" @("s_hero.txt", "s_aspects.txt", "s_impact.txt")
Build-Page "knowledge.html" "Knowledge Bank | Suprabha Trust" @("s_knowledge.txt")
Build-Page "articles.html" "Articles | Suprabha Trust" @("s_articles.txt")
Build-Page "videos.html" "Videos | Suprabha Trust" @("s_videos.txt")
Build-Page "renewable.html" "Renewable Energy | Suprabha Trust" @("s_programs.txt")
Build-Page "about.html" "About Us | Suprabha Trust" @("s_about.txt", "s_mission.txt", "s_connections.txt", "s_partnership.txt", "s_impact.txt")
Build-Page "contact.html" "Contact Us | Suprabha Trust" @("s_contact.txt", "s_donate.txt")

Write-Output "Build completed successfully with UTF-8 No BOM."
