@echo off

:: Si la variable TERM_PROGRAM es "vscode", salta al final del script
if "%TERM_PROGRAM%"=="vscode" exit /b

:inicio
cls
echo ==========================================
echo           MENU DE SELECCION
echo ==========================================
echo 1. Ir a Menu SSH
echo 2. Salir al Prompt (Quedar en la consola)
echo 3. Gestion Git
echo X. Cerrar ventana por completo
echo ==========================================
set /p opcion="Seleccione una opcion: "

if %opcion%==1 goto tareaA
if %opcion%==2 goto prompt
if %opcion%==3 goto git_menu
if %opcion%==X exit

:: Si llega aquí, es porque no escribió ni 1, ni 2, ni X
echo.
echo [!] Opcion invalida: "%opcion%". Intente de nuevo.
pause
goto inicio


:tareaA
echo Has elegido Menu SSH
pause
goto ssh_menu

:tareaB
echo Has elegido la Tarea B
pause
goto inicio

:ssh_menu
call ssh_menu.bat
goto inicio

:git_menu
call gestion_git.ps1
goto inicio

:prompt
cls
echo Ahora estas en el prompt normal. Escribe 'goto inicio' para volver al menu.
:: Simplemente terminamos el script. CMD se quedará abierto en esta línea.
exit /b
