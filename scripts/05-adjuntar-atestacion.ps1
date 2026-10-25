# Adjunta el SBOM CycloneDX a la imagen publicada como atestación firmada (keyless).
param([Parameter(Mandatory = $true)][string]$ImageDigest)
. "$PSScriptRoot\comun.ps1"
if ($ImageDigest -notmatch '@sha256:[0-9a-f]{64}$') { throw "Usa la imagen por digest: repo@sha256:..." }

Invoke-Paso "cosign attest (CycloneDX)" {
    cosign attest --yes `
        --predicate reports/sbom-imagen.cdx.json `
        --type cyclonedx `
        $ImageDigest
}
