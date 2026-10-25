# Funciones compartidas por los scripts del laboratorio.
# $ErrorActionPreference = "Stop" no detiene el script cuando un comando externo
# (docker, syft, grype, cosign) termina con error: hay que revisar $LASTEXITCODE.

$ErrorActionPreference = "Stop"
$IMAGEN = "lab246:1.0.0"

function Invoke-Paso {
    param([string]$Nombre, [scriptblock]$Comando)
    Write-Host "=== $Nombre ==="
    & $Comando
    if ($LASTEXITCODE -ne 0) {
        throw "Falló '$Nombre' (código $LASTEXITCODE)."
    }
}

function New-Reports {
    if (!(Test-Path "reports")) { New-Item -ItemType Directory -Path "reports" | Out-Null }
}
