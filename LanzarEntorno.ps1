# ==============================================================================
# ARTEFACTO: Lanzador de Entorno de Trabajo (Versión Final Corregida)
# ==============================================================================

Write-Host "--- Iniciando Secuencia de Apertura ---" -ForegroundColor Cyan

# --- 1. COMUNICACIÓN (Outlook y Teams) ---
Write-Host "> Abriendo Outlook y Teams..."
# Definimos los argumentos exactos de tu acceso directo
$outlookArgs = "--profile-directory=Default --app-id=faolnafnngnfdaknnbpnkhgohbobgegn"
Start-Process "C:\Program Files\Google\Chrome\Application\chrome_proxy.exe" -ArgumentList $outlookArgs
Start-Process "msteams:" -ErrorAction SilentlyContinue

# --- 2. NAVEGACIÓN E IA ---
Write-Host "> Abriendo Chrome (IA y Loop/Planner)..."
# Monitor Central
$URLS_IA = "https://m365.cloud.microsoft/chat/?auth=2 https://www.google.com https://claude.ai"
Start-Process "chrome.exe" $URLS_IA

# Monitor Izquierdo (Loop y Planner en ventana nueva)
$URLS_IZQ = "https://loop.cloud.microsoft/ https://planner.cloud.microsoft/"
Start-Process "chrome.exe" "--new-window $URLS_IZQ"

# --- 3. DESARROLLO Y DATOS ---
Write-Host "> Abriendo VS Code y DBeaver..."
# Usamos la ruta directa que proporcionaste para VS Code
$vscodePath = "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code\Code.exe"
Start-Process $vscodePath -ErrorAction SilentlyContinue

if (Test-Path "C:\Program Files\DBeaver\dbeaver.exe") {
    Start-Process "C:\Program Files\DBeaver\dbeaver.exe"
}

# --- 4. UTILIDADES Y SISTEMA ---
Write-Host "> Abriendo Explorador, Notepad y Terminal..."
Start-Process "explorer.exe" "shell:MyComputerFolder"
Start-Process "notepad.exe"
# Lanzamos PowerShell con -NoProfile para que NO se quede atrapado en tu menú de inicio
Start-Process "powershell.exe" 

Write-Host "`n--- Entorno cargado. Posicionamiento manual habilitado. ---" -ForegroundColor Green

# Finalizamos el script lanzador para que la ventana inicial se cierre
exit

# Este trozo de código permite asegurar si la page esta abierta o no
# antes de abrirla
#
#if (Get-Process "chrome" -ErrorAction SilentlyContinue) {
#    # Si ya está abierto, solo lo enfocamos (requiere librerías extras, 
#    # pero lo más simple es dejar que el navegador gestione las pestañas duplicadas)
#    Start-Process "chrome.exe" -ArgumentList "https://copilot.microsoft.com/"
#} else {
#    Start-Process "chrome.exe" -ArgumentList "https://copilot.microsoft.com/", "https://claude.ai"
#}