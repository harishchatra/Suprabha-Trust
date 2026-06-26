$content = Get-Content src\pages\knowledge.html -Raw

$replacements = @{
    "openKB('vedic')" = "window.location.href='knowledge/vedic-sciences.html'"
    "openKB('humanistic')" = "window.location.href='knowledge/life-sciences.html'"
    "openKB('meta')" = "window.location.href='knowledge/meta-physics.html'"
    "openKB('ils')" = "window.location.href='knowledge/vedic-blueprint.html'"
    "openKB('ils2')" = "window.location.href='knowledge/ils-meta-physics.html'"
    "openKB('humanistic2')" = "window.location.href='knowledge/humanistic-energy.html'"
    "openKB('lifescience')" = "window.location.href='knowledge/life-sciences-documentary.html'"
    "openKB('biofield')" = "window.location.href='knowledge/biofield-sciences.html'"
    "openKB('sanatana')" = "window.location.href='knowledge/sanatana-dharma.html'"
}

foreach ($key in $replacements.Keys) {
    $content = $content.Replace($key, $replacements[$key])
}

Set-Content -Path src\pages\knowledge.html -Value $content
Write-Host "knowledge.html updated."
