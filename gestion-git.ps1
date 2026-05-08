# Desc: Gestor Pro de Repositorios para Windows (v4.9 - URL Dinamica OK)
# Autor: Adaptativo - Colaboracion con joseramon.lopez

$MI_VM = hostname

function Update-Readme-Tabla {
    $header = "# Indice Global de Scripts`n"
    $header += "Generado automaticamente desde: **$MI_VM**`n"
    $header += "| Script | Descripcion | Origen Sugerido |`n"
    $header += "| :--- | :--- | :--- |"
    $header | Out-File -FilePath README.md -Encoding utf8
    
    Get-ChildItem *.sh, *.ps1, *.py | ForEach-Object {
        $f = $_.Name
        $descLine = Get-Content $f -TotalCount 10 | Select-String "# Desc: "
        $desc = if ($descLine) { $descLine.ToString().Replace("# Desc: ", "").Trim() } else { "Sin descripcion" }
        "| $f | $desc | $MI_VM |" | Out-File -FilePath README.md -Append -Encoding utf8
    }
}

while ($true) {
    $RAMA_ACTUAL = git branch --show-current 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $RAMA_ACTUAL) { $RAMA_ACTUAL = "No Git" }
    $NOMBRE_CARPETA = (Get-Item .).Name
    
    Clear-Host
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "   SISTEMA DE GESTION WINDOWS (Host: $MI_VM)"
    Write-Host "   PROYECTO: $NOMBRE_CARPETA | RAMA: [$RAMA_ACTUAL]"
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host " 01. [NUEVO] Crear proyecto desde cero (Master + Develop)"
    Write-Host " 02. [VINCULAR SELECTIVO] Conectar Host a subcarpeta de Repo"
    Write-Host " 03. [CONVERTIR] Proyecto existente (Anadir Master/Develop)"
    Write-Host "----------------------------------------------------------"
    Write-Host " 04. SUBIR Cambios a rama actual ($RAMA_ACTUAL)"
    Write-Host " 05. BAJAR Cambios (Sync rapido desde Master)"
    Write-Host " 06. CLONAR / Traer proyecto completo de GitHub"
    Write-Host "----------------------------------------------------------"
    Write-Host " 07. Cambiar entre ramas (Master / Develop / Otros)"
    Write-Host " 08. Crear rama de EXPERIMENTO / COLABORADOR"
    Write-Host " 09. PROMOVER: Fusionar Develop -> Master (PASO A PRO)"
    Write-Host "----------------------------------------------------------"
    Write-Host " 10. Actualizar Tabla README"
    Write-Host " 11. Cambiar de Directorio (CD)"
    Write-Host " R. REPARAR Conexion GitHub | X. Salir"
    
    $opcion = Read-Host "`nSeleccione una opcion"

    switch ($opcion) {
        "01" {
            $nuevo_repo = Read-Host "Nombre del nuevo repositorio"
            $desc = Read-Host "Descripcion"
            git init
            "# $nuevo_repo" | Out-File -FilePath README.md -Encoding utf8
            git add .
            git commit -m "Initial commit [Master]"
            git branch -M master
            gh repo create "xrlagoa/$nuevo_repo" --public --description "$desc" --source=. --remote=origin --push
            git checkout -b develop
            git push -u origin develop
        }

        "02" {
            Write-Host "--- VINCULACION SELECTIVA (Sparse Checkout) ---" -ForegroundColor Yellow
            $repo_target = Read-Host "Nombre del repositorio global (ej: misscripts)"
            $sub_dir = Read-Host "Nombre de la subcarpeta (ej: local)"
            if (-not (Test-Path .git)) { git init }
            
            # --- URL DINAMICA CORREGIDA ---
            $url_full = "https://github.com/xrlagoa/$repo_target.git"
            git remote remove origin 2>$null
            git remote add origin $url_full
            
            git config core.sparseCheckout true
            $sub_dir | Out-File -FilePath .git/info/sparse-checkout -Encoding utf8
            Write-Host "Conectando a: $url_full"
            git fetch origin
            git checkout -b develop 2>$null
            git checkout develop
            git pull origin develop --allow-unrelated-histories
            Write-Host "✅ Vinculado correctamente a /$sub_dir." -ForegroundColor Green
        }

        "03" {
            if ($RAMA_ACTUAL -eq "main") { git branch -m main master }
            git checkout master; git pull origin master
            git checkout -b develop
            git push -u origin develop
        }

        "04" {
            if ($RAMA_ACTUAL -eq "master") {
                $conf = Read-Host "ATENCION: Estas en MASTER. Seguro? (s/n)"
                if ($conf -ne "s") { break }
            }
            git status -s
            $msg = Read-Host "Mensaje de commit"
            git add .
            git commit -m "[$MI_VM] $msg"
            git push origin $RAMA_ACTUAL
        }

        "05" {
            git fetch origin; git checkout master; git pull origin master; git checkout $RAMA_ACTUAL
        }

        "06" {
            $repo_clone = Read-Host "Nombre del repo en GitHub"
            $path_dest = Read-Host "Ruta local"
            if (-not (Test-Path $path_dest)) { New-Item -ItemType Directory -Path $path_dest }
            Set-Location $path_dest
            gh repo clone "xrlagoa/$repo_clone" .
            git checkout develop 2>$null
        }

        "07" {
            git branch
            $target_branch = Read-Host "Ir a rama"
            git checkout $target_branch
        }

        "08" {
            $exp_branch = Read-Host "Nombre rama experimental"
            git checkout develop; git checkout -b $exp_branch; git push -u origin $exp_branch
        }

        "09" {
            git checkout master; git pull origin master
            git merge develop
            if ($LASTEXITCODE -eq 0) {
                git push origin master
                Write-Host "✅ PRO ACTUALIZADO" -ForegroundColor Green
            } else {
                Write-Host "❌ Conflictos detectados" -ForegroundColor Red
            }
            git checkout develop
        }

        "10" { Update-Readme-Tabla; Write-Host "✅ README OK" }

        "11" { 
            $new_path = Read-Host "Ruta"
            if (Test-Path $new_path) { Set-Location $new_path } else { Write-Host "Invalida" -ForegroundColor Red }
        }

        "R" {
            $fix_repo = Read-Host "Nombre del repo"
            git remote remove origin 2>$null
            $url_fix = "https://github.com"
            git remote add origin $url_fix
            Write-Host "Conexion reparada hacia: $url_fix" -ForegroundColor Yellow
        }

        "X" { exit }
        "x" { exit }
    }
    Write-Host "`nPresione Enter para continuar..." -ForegroundColor Gray
    Read-Host
}