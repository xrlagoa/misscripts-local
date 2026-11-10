@echo off

:: Si la variable TERM_PROGRAM es "vscode", salta al final del script
if "%TERM_PROGRAM%"=="vscode" goto :salir

title MENU DE CONEXIONES SSH
cls

:menu
cls
echo ==========================================
echo       SELECCIONA UN SERVIDOR SSH
echo ==========================================
echo.
echo 1) Servidor de PostgreSQL (LIDER) dcm01
echo 2) Servidor de PostgreSQL (REPLICA) dcm02
echo 3) Servidor de cdc dcm03
echo 4) Servidor de tools dcm04
echo 5) Servidor de ORACLE m05-legacy
echo 6) Servidor de YugabyteDB Lider dcm05
echo 7) Servidor de YugabyteDB Replica dcm06
echo 8) Servidor de crs dcm07
echo.
echo X) Salir
echo.
echo ==========================================

:: Usamos CHOICE: 1=1, 2=2, 3=3, 4=4, 5=5, 6=6, 7=7, 8=8 X=9
choice /C 12345678X /N /M "Selecciona una opcion: "
set seleccion=%errorlevel%

if %seleccion%==9 goto salir

:pregunta_ventana
echo.
:: CHOICE para S/N: S=1, N=2
choice /C SN /M "Abrir en nueva ventana?"
set nueva=%errorlevel%

:: Configuramos el lanzador segun la respuesta (1 es S)
set "lanzador="
if %nueva%==1 set "lanzador=start /I "SSH""

:: Ejecutamos segun el numero de seleccion
if %seleccion%==1 %lanzador% ssh dcm01
if %seleccion%==2 %lanzador% ssh dcm02
if %seleccion%==3 %lanzador% ssh dcm03
if %seleccion%==4 %lanzador% ssh dcm04
if %seleccion%==5 %lanzador% ssh m05-legacy
if %seleccion%==6 %lanzador% ssh dcm05
if %seleccion%==7 %lanzador% ssh dcm06
if %seleccion%==8 %lanzador% ssh dcm07

:: Si se abrio en la misma ventana (N = opcion 2), pausamos para ver errores
if %nueva%==2 pause

goto menu

:salir
exit /b
