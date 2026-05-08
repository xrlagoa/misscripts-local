# ==============================================================================
# SCRIPT: AutoEscritorio_Final.ps1
# COORDENADAS: Replicadas fielmente de la captura de diagnóstico
# ==============================================================================

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  using System.Text;
  using System.Collections.Generic;

  public class WindowManager {
    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
    [DllImport("user32.dll")]
    public static extern bool EnumDesktopWindows(IntPtr hDesktop, EnumDelegate lpEnumCallbackFunction, IntPtr lParam);
    public delegate bool EnumDelegate(IntPtr hWnd, IntPtr lParam);

    public static IntPtr[] GetWindowsByTitle(string titlePart) {
        List<IntPtr> handles = new List<IntPtr>();
        EnumDesktopWindows(IntPtr.Zero, (hWnd, lParam) => {
            StringBuilder sb = new StringBuilder(256);
            GetWindowText(hWnd, sb, sb.Capacity);
            string title = sb.ToString();
            if (!string.IsNullOrEmpty(title) && title.IndexOf(titlePart, StringComparison.OrdinalIgnoreCase) >= 0) {
                handles.Add(hWnd);
            }
            return true;
        }, IntPtr.Zero);
        return handles.ToArray();
    }
  }
"@

function Sync-WorkSpace {
    Write-Host "`n--- Fase 1: Lanzamiento Completo ---" -ForegroundColor Cyan
    
    # Monitor Central
    Start-Process "chrome.exe" "https://cloud.microsoft https://google.com https://claude.ai"
    
    # Monitor Izquierdo
    Start-Process "code" 
    Start-Process "chrome.exe" "--new-window https://cloud.microsoft"
    Start-Process "explorer.exe" "shell:MyComputerFolder" 
    Start-Process "notepad.exe"
    
    # Monitor Derecho
    Start-Process "powershell.exe"
    if (Test-Path "C:\Program Files\DBeaver\dbeaver.exe") { Start-Process "C:\Program Files\DBeaver\dbeaver.exe" }

    Write-Host "Esperando 15s para que todas las ventanas carguen títulos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 15

    Write-Host "--- Fase 2: Posicionamiento Quirúrgico ---" -ForegroundColor Cyan

    # MONITOR IZQUIERDO (Ubicaciones según captura)
    [WindowManager]::GetWindowsByTitle("Visual Studio Code") | ForEach-Object { [WindowManager]::MoveWindow($_, -1271, -1350, 1200, 1290, $true) }
    [WindowManager]::GetWindowsByTitle("Loop")               | ForEach-Object { [WindowManager]::MoveWindow($_, -1271, -1350, 1200, 1290, $true) }
    [WindowManager]::GetWindowsByTitle("Este equipo")        | ForEach-Object { [WindowManager]::MoveWindow($_, -80, -1350, 1210, 654, $true) }
    [WindowManager]::GetWindowsByTitle("Bloc de notas")      | ForEach-Object { [WindowManager]::MoveWindow($_, -77, -705, 1213, 651, $true) }

    # MONITOR CENTRAL
    [WindowManager]::GetWindowsByTitle("Claude")            | ForEach-Object { [WindowManager]::MoveWindow($_, -9, -9, 1938, 1150, $true) }

    # MONITOR DERECHO (Ubicaciones según captura)
    [WindowManager]::GetWindowsByTitle("Windows PowerShell") | ForEach-Object { [WindowManager]::MoveWindow($_, -1120, -1360, 1210, 1299, $true) }
    [WindowManager]::GetWindowsByTitle("DBeaver")            | ForEach-Object { [WindowManager]::MoveWindow($_, -2320, -1360, 1210, 1299, $true) }

    Write-Host "`n¡Ambiente restaurado con éxito!" -ForegroundColor Green
}

Sync-WorkSpace
