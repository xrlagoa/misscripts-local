# ==============================================================================
# ARTEFACTO: Lanzador de Entorno de Trabajo
# OBJETIVO: Abrir todas las herramientas necesarias en un solo llamado.
# ==============================================================================

Write-Host "--- Iniciando Secuencia de Apertura ---" -ForegroundColor Cyan

# 1. NAVEGADOR (Monitor Central - Pestañas de IA)
$URLS_IA = "https://m365.cloud.microsoft/chat/?auth=2 https://www.google.com/search?q=&num=10&sca_esv=4105d4398ced2790&hl=es&sxsrf=ANbL-n6byO_1KPgzIcYkEVeas3Ej_UoP6w%3A1776866127830&source=hp&ei=T9Poaa2PMN6sruEP7p3g0A8&iflsig=AFdpzrgAAAAAaejhX1QWUodBzb81M3Wlym5bWxfgSs9W&aep=22&udm=50&ved=0ahUKEwjt8vCSzoGUAxVelisGHe4OGPoQteYPCBM&oq=&gs_lp=Egdnd3Mtd2l6IgBIAFAAWABwAHgAkAEAmAEAoAEAqgEAuAEByAEAmAIAoAIAmAMAkgcAoAcAsgcAuAcAwgcAyAcAgAgB&sclient=gws-wiz https://claude.ai"
Start-Process "chrome.exe" $URLS_IA

# 2. NAVEGADOR (Monitor Izquierdo - Microsoft Loop en ventana nueva)
Start-Process "chrome.exe" "--new-window https://loop.cloud.microsoft/p/eyJ3Ijp7InUiOiJodHRwczovL2hvdGVsZXN0dXJpc3RpY29zdW5pZG9zLnNoYXJlcG9pbnQuY29tLz9uYXY9Y3owbE1rWW1aRDFpSVZsTk5uWm9RMmRzU210WGExbFZPVGs1YW1WcVVqWnlXbTlxWVd4Mk0xWkVhemhXUWxsUWVFVkljWFJ3Y0d0VFR5MUtjbFpTTkV0UVRYTkpjV3BNVGtnbVpqMHdNVk5YUVZaTE1rbEhORlZCUVVaRlYxZGFTa2hLVWtZM1VVNUNOa1pDUjFZM0ptTTlKbVpzZFdsa1BURSUzRCIsInIiOmZhbHNlfSwicCI6eyJ1IjoiaHR0cHM6Ly9ob3RlbGVzdHVyaXN0aWNvc3VuaWRvcy5zaGFyZXBvaW50LmNvbS86Zmw6L3IvY29udGVudHN0b3JhZ2UveDhGTk8teHRza3VDUlgyX2ZNVEhMZkMzT1h2bm9naEd0Z0VZNkdIbFdMYy9Eb2N1bWVudCUyMExpYnJhcnkvQ29waWxvdC9TaW4lMjB0JUMzJUFEdHVsby5sb29wP2Q9d2I0NWMxMmMzNjk4ZjQ0YWJiYTgxODUzM2Q5NTlkYzdmJmNzZj0xJndlYj0xJm5hdj1jejBsTWtaamIyNTBaVzUwYzNSdmNtRm5aU1V5Um5nNFJrNVBMWGgwYzJ0MVExSllNbDltVFZSSVRHWkRNMDlZZG01dloyaEhkR2RGV1RaSFNHeFhUR01tWkQxaUlWbE5OblpvUTJkc1NtdFhhMWxWT1RrNWFtVnFValp5V205cVlXeDJNMVpFYXpoV1FsbFFlRVZJY1hSd2NHdFRUeTFLY2xaU05FdFFUWE5KY1dwTVRrZ21aajB3TVZOWFFWWkxNazlFUTBwUFRFcEVNMHBXVGtOTVZrRk5Sa2RRVFZaVVdFUTNKbU05SlRKR0ptWnNkV2xrUFRFbVlUMU1iMjl3UVhCd0puQTlKVFF3Wm14MWFXUjRKVEpHYkc5dmNDMXdZV2RsTFdOdmJuUmhhVzVsY2clM0QlM0QiLCJyIjpmYWxzZX0sImkiOnsiaSI6IjJlMDNhY2U1LTg1NDgtNDdiMS04ZTFkLWExMGNkMWZmZDk1MSJ9fQ%3D%3D https://planner.cloud.microsoft/webui/plan/bUTBpbrULEWmHQ1zwCdRPpgACiEZ/view/board?tid=8b359526-17c7-4604-89f2-c85804d6a88f"

# 3. DESARROLLO Y DATOS
Start-Process "C:\Users\joseramon.lopez\AppData\Local\Programs\Microsoft VS Code\Code.exe"                                          # VS Code

if (Test-Path "C:\Program Files\DBeaver\dbeaver.exe") {
    Start-Process "C:\Program Files\DBeaver\dbeaver.exe"      # DBeaver
}

# 4. UTILIDADES Y SISTEMA
Start-Process "explorer.exe" "shell:MyComputerFolder"            # Mi PC
Start-Process "notepad.exe"                                      # Bloc de notas
Start-Process "powershell.exe"                                   # Terminal

# Lanzar Outlook (Versión de escritorio)
Start-Process "C:\Program Files\Google\Chrome\Application\chrome_proxy.exe" -ArgumentList $outlookArgs

# Lanzar Microsoft Teams (Versión corporativa)
# El comando 'msteams' es el estándar para el "New Teams" de Windows 11
Start-Process "msteams:"

Write-Host "--- Entorno cargado. Posicionamiento manual habilitado. ---" -ForegroundColor Green

# El comando 'Exit' asegura que el proceso del script muera tras lanzar todo
# exit