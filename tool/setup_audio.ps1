# Downloads SFX (Kenney CC0) and generates voice/phonics via Windows TTS.
# Run: powershell -ExecutionPolicy Bypass -File tool/setup_audio.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

$sfxDir = "assets/audio/sfx"
$voiceDir = "assets/audio/voice"
New-Item -ItemType Directory -Force -Path $sfxDir, $voiceDir | Out-Null

$baseUrl = "https://cc0-sounds.exi.software/sounds/kenney_interfacesounds/Audio"
$sfxMap = @{
    chime        = "confirmation_001.ogg"
    click        = "click_001.ogg"
    soft_boop    = "back_001.ogg"
    celebration  = "maximize_001.ogg"
    color_fill   = "select_001.ogg"
}

Write-Host "Downloading Kenney Interface Sounds (CC0)..."
foreach ($entry in $sfxMap.GetEnumerator()) {
    $dest = Join-Path $sfxDir "$($entry.Key).ogg"
    $url = "$baseUrl/$($entry.Value)"
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest
        Write-Host "  SFX: $($entry.Key).ogg"
    } catch {
        Write-Warning "  Failed to download $($entry.Key): $_"
    }
}

Write-Host "Generating phonics and Lumi voice lines (Windows TTS)..."
Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.Rate = -1
$synth.Volume = 100

function Speak-ToFile($text, $fileName) {
    $path = Join-Path $voiceDir $fileName
    $synth.SetOutputToWaveFile($path)
    $synth.Speak($text)
    $synth.SetOutputToDefaultAudioDevice()
    Write-Host "  Voice: $fileName"
}

$phonics = @{
    letter_a = "A says ah. Ah apple."
    letter_b = "B says buh. Buh ball."
    letter_c = "C says kuh. Kuh cat."
    letter_d = "D says duh. Duh dog."
    letter_e = "E says eh. Eh egg."
    letter_f = "F says fff. Fff fish."
    letter_g = "G says guh. Guh goat."
    letter_h = "H says huh. Huh hat."
    letter_i = "I says ih. Ih igloo."
    letter_j = "J says juh. Juh jump."
    letter_k = "K says kuh. Kuh kite."
    letter_l = "L says lll. Lll lion."
    letter_m = "M says mmm. Mmm moon."
    letter_n = "N says nnn. Nnn nest."
    letter_o = "O says oh. Oh octopus."
    letter_p = "P says puh. Puh pig."
    letter_q = "Q says kwuh. Queen."
    letter_r = "R says rrr. Rrr rabbit."
    letter_s = "S says sss. Sss sun."
    letter_t = "T says tuh. Tuh tiger."
    letter_u = "U says uh. Uh umbrella."
    letter_v = "V says vvv. Vvv van."
    letter_w = "W says wuh. Wuh whale."
    letter_x = "X says ks. Box."
    letter_y = "Y says yuh. Yuh yellow."
    letter_z = "Z says zzz. Zzz zebra."
}

foreach ($entry in $phonics.GetEnumerator()) {
    Speak-ToFile $entry.Value "$($entry.Key).wav"
}

Speak-ToFile "Welcome to Kids Learn Play! Let's have fun learning!" "lumi_welcome.wav"
Speak-ToFile "Great job! You did it!" "lumi_great_job.wav"
Speak-ToFile "Amazing! Keep going!" "lumi_encourage.wav"
Speak-ToFile "Try again! You can do it!" "lumi_try_again.wav"
Speak-ToFile "Wow! That looks beautiful!" "lumi_color_praise.wav"

Write-Host "`nAudio setup complete: $sfxDir and $voiceDir"
