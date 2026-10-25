. "$PSScriptRoot\comun.ps1"
Invoke-Paso "Build de $IMAGEN" { docker build -t $IMAGEN . }
