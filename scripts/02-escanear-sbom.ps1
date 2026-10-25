# Consume el SBOM de la imagen con Grype. Falla si hay vulnerabilidades de la
# severidad indicada o superior (gate).
param([string]$FallarEn = "high")
. "$PSScriptRoot\comun.ps1"
New-Reports

Invoke-Paso "Grype: reporte JSON" {
    grype sbom:reports/sbom-imagen.cdx.json -o json --file reports/grype-resultados.json
}
Invoke-Paso "Grype: gate (falla con $FallarEn o superior)" {
    grype sbom:reports/sbom-imagen.cdx.json -o table --fail-on $FallarEn
}
