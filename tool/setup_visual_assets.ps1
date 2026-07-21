# Downloads game PNGs (Twemoji CC BY 4.0) + Lottie animations.
# Run: powershell -ExecutionPolicy Bypass -File tool/setup_visual_assets.ps1

$ErrorActionPreference = "Continue"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

$imgRoot = "assets/images/game"
$lottieDir = "assets/lottie"
New-Item -ItemType Directory -Force -Path $imgRoot, $lottieDir | Out-Null
@("animals","dinosaurs","space","sports","tools","colors","numbers","letters") | ForEach-Object {
    New-Item -ItemType Directory -Force -Path "$imgRoot/$_" | Out-Null
}

$twemoji = "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72"

function Get-Twemoji($code, $dest) {
    try {
        Invoke-WebRequest -Uri "$twemoji/$code.png" -OutFile $dest
        Write-Host "  OK $dest"
    } catch { Write-Warning "  Skip $dest" }
}

Write-Host "Downloading Twemoji animal PNGs (CC BY 4.0)..."
$animals = @{
    "lion"="1f981"; "elephant"="1f418"; "giraffe"="1f992"; "monkey"="1f435"
    "cow"="1f404"; "sheep"="1f411"; "pig"="1f437"; "chicken"="1f414"
    "horse"="1f434"; "duck"="1f986"; "frog"="1f438"; "bear"="1f43b"
    "penguin"="1f427"; "shark"="1f988"; "butterfly"="1f98b"
}
foreach ($a in $animals.GetEnumerator()) {
    Get-Twemoji $a.Value "$imgRoot/animals/$($a.Key).png"
}

Write-Host "Downloading dino & space PNGs..."
$dinos = @{ "trex"="1f996"; "triceratops"="1f995"; "stego"="1f996"; "brachio"="1f995"; "veloci"="1f996"; "ptero"="1f985"; "ankylo"="1f996"; "spino"="1f996" }
foreach ($d in $dinos.GetEnumerator()) {
    Get-Twemoji $d.Value "$imgRoot/dinosaurs/$($d.Key).png"
}
$space = @{ "sun"="2600"; "moon"="1f319"; "earth"="1f30d"; "mars"="1f534"; "rocket"="1f680"; "saturn"="1fa90"; "star"="2b50"; "comet"="2604" }
foreach ($s in $space.GetEnumerator()) {
    Get-Twemoji $s.Value "$imgRoot/space/$($s.Key).png"
}
$sports = @{ "football"="26bd"; "basketball"="1f3c0"; "tennis"="1f3be"; "swimming"="1f3ca"; "cricket"="1f3cf"; "golf"="26f3"; "skiing"="26f7" }
foreach ($sp in $sports.GetEnumerator()) {
    Get-Twemoji $sp.Value "$imgRoot/sports/$($sp.Key).png"
}
$tools = @{ "hammer"="1f528"; "wrench"="1f527"; "screwdriver"="1fa9b"; "saw"="1fa9a"; "drill"="1fa99"; "pliers"="1fa9b" }
foreach ($t in $tools.GetEnumerator()) {
    Get-Twemoji $t.Value "$imgRoot/tools/$($t.Key).png"
}
$colors = @{ "red"="1f534"; "blue"="1f535"; "green"="1f7e2"; "yellow"="1f7e1"; "orange"="1f7e0"; "purple"="1f7e3"; "pink"="1f49c"; "black"="26ab"; "white"="26aa" }
foreach ($c in $colors.GetEnumerator()) {
    Get-Twemoji $c.Value "$imgRoot/colors/$($c.Key).png"
}

Write-Host "Generating colorful letter & number tiles..."
$letters = "abcdefghijklmnopqrstuvwxyz".ToCharArray()
foreach ($ch in $letters) {
    $letter = $ch.ToString().ToUpper()
    $colors = @("FF6B6B","4ECDC4","FFE66D","6C63FF","FF9F43","A29BFE")
    $bg = $colors[([int][char]$letter) % $colors.Length]
    $api = "https://ui-avatars.com/api/?name=$letter&background=$bg&color=fff&size=128&font-size=0.5&bold=true&format=png"
    try { Invoke-WebRequest -Uri $api -OutFile "$imgRoot/letters/letter_$letter.png" } catch {}
}
for ($n = 1; $n -le 20; $n++) {
    $colors = @("FF6B6B","4ECDC4","6C63FF","FF9F43","A29BFE","00B894")
    $bg = $colors[($n - 1) % $colors.Length]
    $api = "https://ui-avatars.com/api/?name=$n&background=$bg&color=fff&size=128&font-size=0.45&bold=true&format=png"
    try { Invoke-WebRequest -Uri $api -OutFile "$imgRoot/numbers/num_$n.png" } catch {}
}

Write-Host "Downloading Lottie animations..."
$lotties = @{
    "celebration.json" = "https://assets10.lottiefiles.com/packages/lf20_touohxv0.json"
    "confetti.json"    = "https://assets1.lottiefiles.com/packages/lf20_u4yrau.json"
    "star_burst.json"  = "https://assets3.lottiefiles.com/packages/lf20_jbrw3hcz.json"
}
foreach ($entry in $lotties.GetEnumerator()) {
    try {
        Invoke-WebRequest -Uri $entry.Value -OutFile "$lottieDir/$($entry.Key)"
        Write-Host "  Lottie: $($entry.Key)"
    } catch { Write-Warning "  Lottie $($entry.Key) failed" }
}
if (-not (Test-Path "$lottieDir/lumi_happy.json")) {
    Copy-Item "$lottieDir/star_burst.json" "$lottieDir/lumi_happy.json" -ErrorAction SilentlyContinue
}

Write-Host "`nVisual assets setup complete."
