# Pipeline local: SBOM del código, build, SBOM de la imagen y escaneo con gate.
. "$PSScriptRoot\comun.ps1"

& "$PSScriptRoot\01-generar-sbom.ps1"
& "$PSScriptRoot\03-construir-imagen.ps1"
& "$PSScriptRoot\04-sbom-imagen.ps1"
& "$PSScriptRoot\02-escanear-sbom.ps1"
Write-Host "=== Pipeline local completado: reportes en reports/ ==="
