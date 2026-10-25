# SBOM de la imagen final: incluye el sistema base y el binario construido.
param([string]$Imagen = "lab246:1.0.0")
. "$PSScriptRoot\comun.ps1"
New-Reports

Invoke-Paso "SBOM de la imagen $Imagen" {
    syft $Imagen `
        -o cyclonedx-json=reports/sbom-imagen.cdx.json `
        -o spdx-json=reports/sbom-imagen.spdx.json
}
