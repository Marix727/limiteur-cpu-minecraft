# =====================================================================
#  toggle-xray.ps1
#  Active ou desactive le pack de ressources XRay sans passer par les menus.
#
#  Usage :
#    .\toggle-xray.ps1 -On
#    .\toggle-xray.ps1 -Off
#
#  Le script :
#    1. copie XRay.zip dans  %APPDATA%\.minecraft\resourcepacks\
#    2. ajoute (On) ou retire (Off) "file/XRay.zip" dans options.txt
#
#  IMPORTANT : fermez Minecraft avant de lancer ce script, sinon le jeu
#  ecrasera options.txt en quittant.
# =====================================================================
[CmdletBinding()]
param(
    [switch]$On,
    [switch]$Off
)

$ErrorActionPreference = 'Stop'

if (-not $On -and -not $Off) {
    Write-Host "Precisez -On ou -Off." -ForegroundColor Yellow
    exit 1
}

$mcDir  = Join-Path $env:APPDATA '.minecraft'
$rpDir  = Join-Path $mcDir 'resourcepacks'
$optFile = Join-Path $mcDir 'options.txt'
$srcZip = Join-Path $PSScriptRoot 'XRay.zip'
$entry  = 'file/XRay.zip'

if (-not (Test-Path $mcDir)) {
    Write-Host "Dossier Minecraft introuvable : $mcDir" -ForegroundColor Red
    exit 1
}

# --- avertissement si le jeu tourne ----------------------------------------
$running = @(Get-Process -Name java, javaw -ErrorAction SilentlyContinue |
             Where-Object { $_.Path -and $_.Path -match '(?i)tlauncher|minecraft|jre' })
if ($running.Count -gt 0) {
    Write-Host "ATTENTION : Minecraft / Java semble tourner (PID $($running.Id -join ', '))." -ForegroundColor Yellow
    Write-Host "Fermez le jeu avant de continuer, sinon options.txt sera ecrase." -ForegroundColor Yellow
}

# --- 1. deploiement du pack ------------------------------------------------
if (-not (Test-Path $rpDir)) { New-Item -ItemType Directory -Path $rpDir -Force | Out-Null }
if (-not (Test-Path $srcZip)) {
    Write-Host "XRay.zip introuvable a cote du script." -ForegroundColor Red
    exit 1
}
Copy-Item -Path $srcZip -Destination (Join-Path $rpDir 'XRay.zip') -Force
Write-Host "Pack deploye : $(Join-Path $rpDir 'XRay.zip')" -ForegroundColor Green

# --- 2. edition de options.txt ---------------------------------------------
if (-not (Test-Path $optFile)) {
    if ($On) {
        Set-Content -Path $optFile -Value ('resourcePacks:["vanilla","' + $entry + '"]') -Encoding ASCII
        Write-Host "options.txt cree et pack active." -ForegroundColor Green
    } else {
        Write-Host "options.txt absent : rien a desactiver." -ForegroundColor Yellow
    }
    exit 0
}

$lines = Get-Content -Path $optFile
$out = New-Object System.Collections.Generic.List[string]
$found = $false

foreach ($line in $lines) {
    if ($line -match '^resourcePacks:') {
        $found = $true
        $inner = $line.Substring($line.IndexOf('[') + 1)
        $inner = $inner.Substring(0, $inner.LastIndexOf(']'))
        $entries = @()
        foreach ($m in [regex]::Matches($inner, '"([^"]*)"')) { $entries += $m.Groups[1].Value }

        if ($On) {
            if ($entries -notcontains $entry) { $entries += $entry }
        } else {
            $entries = @($entries | Where-Object { $_ -ne $entry })
        }
        if ($entries.Count -eq 0) { $entries = @('vanilla') }

        $rebuilt = 'resourcePacks:[' + (($entries | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']'
        $out.Add($rebuilt)
    }
    elseif ($line -match '^incompatibleResourcePacks:') {
        # on retire XRay de la liste des packs incompatibles pour eviter l'alerte
        $inner = $line.Substring($line.IndexOf('[') + 1)
        $inner = $inner.Substring(0, $inner.LastIndexOf(']'))
        $entries = @()
        foreach ($m in [regex]::Matches($inner, '"([^"]*)"')) { $entries += $m.Groups[1].Value }
        $entries = @($entries | Where-Object { $_ -ne $entry })
        $out.Add('incompatibleResourcePacks:[' + (($entries | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']')
    }
    else {
        $out.Add($line)
    }
}

if (-not $found -and $On) {
    $out.Add('resourcePacks:["vanilla","' + $entry + '"]')
}

Copy-Item -Path $optFile -Destination ($optFile + '.xray.bak') -Force
Set-Content -Path $optFile -Value $out -Encoding ASCII

if ($On) { Write-Host "XRay ACTIVE. Lancez Minecraft." -ForegroundColor Green }
else     { Write-Host "XRay DESACTIVE. Relancez Minecraft." -ForegroundColor Green }
Write-Host "Sauvegarde de l'ancien options.txt : $optFile.xray.bak" -ForegroundColor DarkGray
