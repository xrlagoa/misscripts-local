$MI_VM = hostname
# Desc: Gestor Pro de Repositorios para Windows (PowerShell)
# Cambios: Refresco dinamico de ruta y deteccion de Git mejorada.
# Guardar como: gestion.ps1

# --- FUNCION: Generar tabla en README ---
function Actualizar-Readme-Tabla {
    $header = "# Indice Global de Scripts`n"
    $header += "Generado automaticamente desde: **$MI_VM**`n"
    $header += "| Script | Descripcion | Origen Sugerido |`n"
    $header += "| :--- | :--- | :--- |"
    
    # Guardamos con codificacion UTF8 para evitar problemas de acentos
    $header | Out-File -FilePath README.md -Encoding utf8
    
    Get-ChildItem *.sh, *.ps1, *.py | ForEach-Object {
        $f = $_.Name
        # Leemos las primeras lineas buscando la descripcion
        $descLine = Get-Content $f -TotalCount 10 | Select-String "# Desc: "
        $desc = if ($descLine) { $descLine.ToString().Replace("# Desc: ", "").Trim() } else { "Sin descripcion" }
        "| $f | $desc | $MI_VM |" | Out-File -FilePath README.md -Append -Encoding utf8
    }
}

# --- BUCLE PRINCIPAL ---
while ($true) {
    # RECALCULO DINAMICO: Se ejecuta en cada vuelta del bucle
    # Esto asegura que si haces CD (Opcion 10), la cabecera se actualice
    $RAMA_ACTUAL = git branch --show-current 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $RAMA_ACTUAL) { $RAMA_ACTUAL = "No Git" }
    $NOMBRE_CARPETA = (Get-Item .).Name
    
    Clear-Host
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "   SISTEMA DE GESTION WINDOWS (Host: $MI_VM)"
    Write-Host "   PROYECTO: $NOMBRE_CARPETA | RAMA: [$RAMA_ACTUAL]"
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host " 1. [NUEVO] Crear proyecto desde cero (Master + Develop)"
    Write-Host " 2. [ACTUALIZAR] Convertir proyecto (Anadir Develop)"
    Write-Host "----------------------------------------------------------"
    Write-Host " 3. SUBIR Cambios a rama actual ($RAMA_ACTUAL)"
    Write-Host " 4. BAJAR Cambios (Sync rapido desde Master)"
    Write-Host " 5. TRAER / Clonar proyecto de GitHub"
    Write-Host "----------------------------------------------------------"
    Write-Host " 6. Cambiar entre ramas (Master / Develop / Feature)"
    Write-Host " 7. Crear rama de EXPERIMENTO / COLABORADOR"
    Write-Host " 8. PROMOVER: Fusionar Develop -> Master (PASO A PRO)"
    Write-Host "----------------------------------------------------------"
    Write-Host " 9. Actualizar Tabla README"
    Write-Host " 10. Cambiar de Directorio (CD)"
    Write-Host " R. REPARAR Conexion GitHub | X. Salir"
    
    $opcion = Read-Host "`nSeleccione una opcion"

    switch ($opcion) {
        "1" {
            $nombre = Read-Host "Nombre del nuevo repositorio"
            $desc = Read-Host "Descripcion corta"
            git init
            "# $nombre" | Out-File -FilePath README.md
            git add .
            git commit -m "Carga inicial [$MI_VM]"
            git branch -M master
            gh repo create "xrlagoa/$nombre" --public --description "$desc" --source=. --remote=origin --push
            git checkout -b develop
            git push -u origin develop
        }
        "2" {
            # Convierte main a master si es necesario y crea develop
            if ($RAMA_ACTUAL -eq "main") { git branch -m main master }
            git checkout master; git pull origin master
            git checkout -b develop
            git push -u origin develop
            Write-Host "✅ Rama develop creada y vinculada." -ForegroundColor Green
        }
        "3" {
            if ($RAMA_ACTUAL -eq "master") {
                $conf = Read-Host "ATENCION: Estas en MASTER. ¿Seguro que quieres subir directo? (s/n)"
                if ($conf -ne "s") { break }
            }
            git status -s
            $msg = Read-Host "Mensaje de commit"
            git add .
            git commit -m "[$MI_VM] $msg"
            git push origin $RAMA_ACTUAL
        }
        "4" {
            Write-Host "Sincronizando base de codigo desde Master..."
            git fetch origin; git checkout master; git pull origin master; git checkout $RAMA_ACTUAL
        }
        "5" {
            $repo = Read-Host "Nombre del repo en GitHub"
            $dest = Read-Host "Ruta destino en tu PC"
            if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest }
            Set-Location $dest
            gh repo clone "xrlagoa/$repo" .
            git checkout develop
        }
        "6" {
            git branch
            $dest = Read-Host "Escribe el nombre de la rama a la que quieres ir"
            git checkout $dest
        }
        "7" {
            $nueva = Read-Host "Nombre de la rama experimental"
            git checkout develop; git checkout -b $nueva; git push -u origin $nueva
        }
        "8" {
            Write-Host "Fusionando Develop en Master para Produccion..."
            git checkout master; git pull origin master
            git merge develop
            if ($LASTEXITCODE -eq 0) {
                git push origin master
                Write-Host "✅ PASO A PRO EXITOSO" -ForegroundColor Green
            } else {
                Write-Host "❌ Conflictos detectados. Resuelve manualmente." -ForegroundColor Red
            }
            git checkout develop
        }
        "9" { Actualizar-Readme-Tabla; Write-Host "✅ README actualizado." -ForegroundColor Green }
        "10" { 
            $nr = Read-Host "Pega la ruta de la carpeta"
            if (Test-Path $nr) {
                Set-Location $nr
            } else {
                Write-Host "La ruta no es valida." -ForegroundColor Red
            }
        }
        "R" {
            $repo = Read-Host "Nombre del repo (xrlagoa/nombre)"
            git remote remove origin 2>$null
            git remote add origin "git@github.com:xrlagoa/$repo.git"
            Write-Host "Remoto corregido." -ForegroundColor Yellow
        }
        "X" { exit }
        "x" { exit }
        Default { Write-Host "Opcion no reconocida." }
    }
    Write-Host "`nPresione Enter para continuar..." -ForegroundColor Gray
    Read-Host
}