# SBOM del código fuente (CycloneDX y SPDX).
# syft escribe los archivos con "-o formato=archivo": redirigir con ">" en Windows
# PowerShell 5.1 los guardaría en UTF-16 y otras herramientas no podrían leerlos.
. "$PSScriptRoot\comun.ps1"
New-Reports

Invoke-Paso "SBOM del código" {
    syft dir:. --source-name lab246 --source-version 1.0.0 `
        --exclude './reports/**' --exclude './.git/**' `
        -o cyclonedx-json=reports/sbom-codigo.cdx.json `
        -o spdx-json=reports/sbom-codigo.spdx.json
}
