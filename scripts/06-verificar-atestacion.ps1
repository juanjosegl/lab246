# Verifica la atestación CycloneDX. Por defecto exige la identidad exacta del workflow
# que la firmó; la guía usa '.*', que aceptaría cualquier identidad.
param(
    [Parameter(Mandatory = $true)][string]$ImageDigest,
    [string]$Identidad = "https://github.com/juanjosegl/lab246/.github/workflows/sbom-slsa.yml@refs/heads/main",
    [string]$Emisor = "https://token.actions.githubusercontent.com"
)
. "$PSScriptRoot\comun.ps1"
New-Reports

$salida = "reports/atestacion-verificada.json"
Invoke-Paso "cosign verify-attestation (CycloneDX)" {
    cosign verify-attestation --type cyclonedx `
        --certificate-identity $Identidad `
        --certificate-oidc-issuer $Emisor `
        $ImageDigest | Out-File -FilePath $salida -Encoding ascii
}

# El payload es una declaración in-toto en base64; su predicado es el SBOM.
$sobre = Get-Content $salida -TotalCount 1 | ConvertFrom-Json
$declaracion = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($sobre.payload)) | ConvertFrom-Json
Write-Host "predicateType : $($declaracion.predicateType)"
Write-Host "sujeto        : $($declaracion.subject[0].name)@sha256:$($declaracion.subject[0].digest.sha256)"
Write-Host "SBOM adjunto  : $($declaracion.predicate.bomFormat) $($declaracion.predicate.specVersion), $(@($declaracion.predicate.components).Count) componentes"
