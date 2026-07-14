@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR%.."
set "BACKUP_ROOT=%ROOT_DIR%\backups"
set "CONFIG_FILE=%SCRIPT_DIR%backup-config.local.bat"
set "START_SECONDS="
set "END_SECONDS="
set "DURATION_SECONDS="

echo.
echo === Restauracion PostgreSQL/Supabase - Web Pena Campanar ===
echo.
echo ADVERTENCIA: este proceso aplica schema.sql y data.sql sobre la base de datos configurada.
echo No se ejecuta automaticamente: exige seleccion de copia y confirmacion escrita.
echo.

where psql >nul 2>nul
if errorlevel 1 (
  echo ERROR: psql no esta instalado o no esta en el PATH.
  echo Instala PostgreSQL para Windows y marca la opcion de incluir las herramientas de linea de comandos.
  echo Despues abre una nueva terminal y prueba: psql --version
  exit /b 1
)

if not exist "%CONFIG_FILE%" (
  echo ERROR: falta la configuracion local.
  echo Copia tools\backup-config.example.bat como tools\backup-config.local.bat
  echo y pega la cadena de conexion PostgreSQL del proyecto destino.
  exit /b 1
)

call "%CONFIG_FILE%"
if errorlevel 1 (
  echo ERROR: no se pudo cargar tools\backup-config.local.bat
  exit /b 1
)

if not defined DATABASE_URL (
  echo ERROR: DATABASE_URL no esta definida en tools\backup-config.local.bat
  exit /b 1
)

set "PGSSLMODE=require"

for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "$u=$env:DATABASE_URL; try { $uri=[uri]$u; if ($uri.UserInfo) { $u=$u.Replace($uri.UserInfo + '@', '***@') }; $u } catch { 'DATABASE_URL configurada en tools\backup-config.local.bat' }"`) do set "SAFE_DATABASE_URL=%%I"

if not exist "%BACKUP_ROOT%" (
  echo ERROR: No existe la carpeta backups.
  exit /b 1
)

echo Destino configurado:
echo %SAFE_DATABASE_URL%
echo.
echo Copias disponibles:
echo.

set "COUNT=0"
for /d %%D in ("%BACKUP_ROOT%\*") do (
  if exist "%%D\schema.sql" if exist "%%D\data.sql" (
    set /a COUNT+=1
    set "BACKUP_!COUNT!=%%D"
    echo !COUNT!^) %%~nxD
  )
)

if "%COUNT%"=="0" (
  echo No hay copias validas con schema.sql y data.sql.
  exit /b 1
)

echo.
set /p "CHOICE=Selecciona el numero de copia a restaurar: "
echo(!CHOICE!| findstr /r "^[1-9][0-9]*$" >nul 2>nul
if errorlevel 1 (
  echo ERROR: seleccion no valida. Escribe solo el numero de la copia.
  exit /b 1
)
if !CHOICE! GTR !COUNT! (
  echo ERROR: seleccion no valida. No existe una copia con ese numero.
  exit /b 1
)
set "SELECTED=!BACKUP_%CHOICE%!"
if not defined SELECTED (
  echo ERROR: Seleccion no valida.
  exit /b 1
)
set "SCHEMA_FILE=!SELECTED!\schema.sql"
set "DATA_FILE=!SELECTED!\data.sql"
set "SCHEMA_ERROR=%TEMP%\kampanar_restore_schema_%RANDOM%.log"
set "DATA_ERROR=%TEMP%\kampanar_restore_data_%RANDOM%.log"

call :validate_file "!SCHEMA_FILE!" "schema.sql"
if errorlevel 1 exit /b 1
call :validate_file "!DATA_FILE!" "data.sql"
if errorlevel 1 exit /b 1

echo.
echo Copia seleccionada:
echo !SELECTED!
echo.
echo Destino:
echo %SAFE_DATABASE_URL%
echo.
echo Para confirmar la restauracion escribe RESTAURAR
set /p "CONFIRM=Confirmacion: "
if /i not "%CONFIRM%"=="RESTAURAR" (
  echo Restauracion cancelada.
  exit /b 0
)

call :capture_seconds START_SECONDS

echo.
echo Restaurando archivo:
echo !SCHEMA_FILE!
psql "%DATABASE_URL%" -v ON_ERROR_STOP=1 -f "!SCHEMA_FILE!" 2>"!SCHEMA_ERROR!"
if errorlevel 1 (
  call :show_psql_error "!SCHEMA_ERROR!" "restaurar schema.sql"
  exit /b 1
)
del "!SCHEMA_ERROR!" >nul 2>nul

echo.
echo Restaurando archivo:
echo !DATA_FILE!
psql "%DATABASE_URL%" -v ON_ERROR_STOP=1 -f "!DATA_FILE!" 2>"!DATA_ERROR!"
if errorlevel 1 (
  call :show_psql_error "!DATA_ERROR!" "restaurar data.sql"
  exit /b 1
)
del "!DATA_ERROR!" >nul 2>nul

call :capture_seconds END_SECONDS
set /a DURATION_SECONDS=END_SECONDS-START_SECONDS
if !DURATION_SECONDS! LSS 0 set /a DURATION_SECONDS+=86400

echo.
echo === Restauracion completada ===
echo Copia restaurada: !SELECTED!
echo Duracion aproximada: !DURATION_SECONDS! segundos
echo Restauracion finalizada correctamente.

endlocal
exit /b 0

:capture_seconds
set "NOW_TIME=%TIME: =0%"
set /a "%~1=(1%NOW_TIME:~0,2%-100)*3600+(1%NOW_TIME:~3,2%-100)*60+(1%NOW_TIME:~6,2%-100)"
set "NOW_TIME="
exit /b 0

:validate_file
if not exist "%~1" (
  echo ERROR: no existe %~2 en la copia seleccionada.
  exit /b 1
)
for %%A in ("%~1") do if %%~zA LEQ 0 (
  echo ERROR: %~2 no es valido porque tiene 0 bytes.
  exit /b 1
)
exit /b 0

:show_psql_error
echo ERROR: fallo psql al %~2. Se detiene el proceso.
if not exist "%~1" (
  echo No se ha podido leer el detalle del error.
  exit /b 0
)
findstr /i /c:"could not translate host name" /c:"Name or service not known" /c:"Temporary failure in name resolution" "%~1" >nul 2>nul
if not errorlevel 1 (
  echo Motivo probable: fallo de resolucion DNS.
  echo Revisa el host de DATABASE_URL y tu conexion de red.
  exit /b 0
)
findstr /i /c:"password authentication failed" /c:"authentication failed" "%~1" >nul 2>nul
if not errorlevel 1 (
  echo Motivo probable: contrasena incorrecta o usuario no valido.
  echo Revisa DATABASE_URL en tools\backup-config.local.bat.
  exit /b 0
)
findstr /i /c:"Connection refused" /c:"No connection could be made" "%~1" >nul 2>nul
if not errorlevel 1 (
  echo Motivo probable: conexion rechazada por el servidor o puerto incorrecto.
  echo Revisa host, puerto y tipo de pooler configurado.
  exit /b 0
)
findstr /i /c:"timeout expired" /c:"Connection timed out" /c:"timed out" "%~1" >nul 2>nul
if not errorlevel 1 (
  echo Motivo probable: timeout de conexion.
  echo Revisa la red, firewall, VPN o usa el Session Pooler de Supabase si tu red es IPv4.
  exit /b 0
)
echo Detalle devuelto por psql:
type "%~1"
exit /b 0
