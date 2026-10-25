# Lab 246: supply chain security con SBOM y SLSA

Grupo: Juan José Gutiérrez Lasso, María Paula Andrade, Víctor Daniel Fernández, José Fernández y Alejandra Guzmán.

Aplicación Go mínima empaquetada en una imagen distroless `nonroot`. El pipeline genera su SBOM (CycloneDX y SPDX) con Syft, lo consume con Grype, lo adjunta a la imagen como atestación firmada con cosign y emite procedencia SLSA con el generador oficial `slsa-github-generator`.

## Estructura

| Ruta | Contenido |
|---|---|
| `app/main.go`, `go.mod` | Servicio HTTP de ejemplo (puerto 8080) |
| `Dockerfile` | Multi-stage `golang:1.27` → `distroless/static-debian12:nonroot` |
| `scripts/01-generar-sbom.ps1` | SBOM del código (CycloneDX y SPDX) |
| `scripts/02-escanear-sbom.ps1` | Grype sobre el SBOM de la imagen, con gate `--fail-on high` |
| `scripts/03-construir-imagen.ps1` | Build de `lab246:1.0.0` |
| `scripts/04-sbom-imagen.ps1` | SBOM de la imagen (CycloneDX y SPDX) |
| `scripts/05-adjuntar-atestacion.ps1` | `cosign attest --type cyclonedx` sobre el digest |
| `scripts/06-verificar-atestacion.ps1` | `cosign verify-attestation` con identidad exacta |
| `scripts/pipeline-local.ps1` | 01 → 03 → 04 → 02 |
| `.github/workflows/sbom-slsa.yml` | Build, publicación, SBOM, Grype, atestación y procedencia SLSA |
| `reports/` | SBOM, resultados de Grype y evidencias |

## Uso

```powershell
pwsh -File ./scripts/pipeline-local.ps1
pwsh -File ./scripts/06-verificar-atestacion.ps1 -ImageDigest "ghcr.io/juanjosegl/lab246@sha256:<digest>"
slsa-verifier verify-image "ghcr.io/juanjosegl/lab246@sha256:<digest>" --source-uri github.com/juanjosegl/lab246 --source-branch main
```
