@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR%.."
set "BACKUP_ROOT=%ROOT_DIR%\backups"
set "CONFIG_FILE=%SCRIPT_DIR%backup-config.local.bat"
set "START_SECONDS="
set "END_SECONDS="
set "DURATION_SECONDS="
set "SCHEMA_SIZE="
set "DATA_SIZE="

echo.
echo === Backup PostgreSQL/Supabase - Web Pena Campanar ===
echo.

where pg_dump >nul 2>nul
if errorlevel 1 (
  echo ERROR: pg_dump no esta instalado o no esta en el PATH.
  echo Instala PostgreSQL para Windows y marca la opcion de incluir las herramientas de linea de comandos.
  echo Despues abre una nueva terminal y prueba: pg_dump --version
  exit /b 1
)

if not exist "%CONFIG_FILE%" (
  echo ERROR: falta la configuracion local.
  echo Copia tools\backup-config.example.bat como tools\backup-config.local.bat
  echo y pega tu cadena de conexion PostgreSQL de Supabase.
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

call :capture_seconds START_SECONDS
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "BACKUP_DATE=%%I"
set "BACKUP_DIR=%BACKUP_ROOT%\%BACKUP_DATE%"
set "SCHEMA_FILE=%BACKUP_DIR%\schema.sql"
set "DATA_FILE=%BACKUP_DIR%\data.sql"
set "SCHEMA_ERROR=%BACKUP_DIR%\schema.error.log"
set "DATA_ERROR=%BACKUP_DIR%\data.error.log"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
if errorlevel 1 (
  echo ERROR: carpeta de destino no accesible.
  echo No se ha podido crear:
  echo %BACKUP_DIR%
  exit /b 1
)

> "%BACKUP_DIR%\.write-test" echo test
if errorlevel 1 (
  echo ERROR: carpeta de destino no accesible.
  echo No se puede escribir en:
  echo %BACKUP_DIR%
  exit /b 1
)
del "%BACKUP_DIR%\.write-test" >nul 2>nul

echo Copia destino:
echo %BACKUP_DIR%
echo.
echo Exportando esquema public...
pg_dump "%DATABASE_URL%" --schema=public --schema-only --no-owner --no-privileges --file="%SCHEMA_FILE%" 2>"%SCHEMA_ERROR%"
if errorlevel 1 (
  call :show_pg_error "%SCHEMA_ERROR%" "pg_dump" "exportar el esquema"
  exit /b 1
)
del "%SCHEMA_ERROR%" >nul 2>nul

echo.
echo Exportando datos public...
pg_dump "%DATABASE_URL%" --schema=public --data-only --column-inserts --no-owner --no-privileges --file="%DATA_FILE%" 2>"%DATA_ERROR%"
if errorlevel 1 (
  call :show_pg_error "%DATA_ERROR%" "pg_dump" "exportar los datos"
  exit /b 1
)
del "%DATA_ERROR%" >nul 2>nul

call :validate_backup_file "%SCHEMA_FILE%" "schema.sql" SCHEMA_SIZE
if errorlevel 1 exit /b 1
call :validate_backup_file "%DATA_FILE%" "data.sql" DATA_SIZE
if errorlevel 1 exit /b 1

call :capture_seconds END_SECONDS
set /a DURATION_SECONDS=END_SECONDS-START_SECONDS
if %DURATION_SECONDS% LSS 0 set /a DURATION_SECONDS+=86400

echo.
echo ========================================
echo Backup completado correctamente
echo.
echo Carpeta:
echo %BACKUP_DIR%
echo.
echo Archivos generados:
echo   schema.sql   %SCHEMA_SIZE%
echo   data.sql     %DATA_SIZE%
echo.
echo Duracion aproximada: %DURATION_SECONDS% segundos
echo ========================================
echo.
echo Guarda tambien una copia fuera de este equipo si necesitas proteccion adicional.

endlocal
exit /b 0

:capture_seconds
set "NOW_TIME=%TIME: =0%"
set /a "%~1=(1%NOW_TIME:~0,2%-100)*3600+(1%NOW_TIME:~3,2%-100)*60+(1%NOW_TIME:~6,2%-100)"
set "NOW_TIME="
exit /b 0

:validate_backup_file
if not exist "%~1" (
  echo ERROR: no se ha generado %~2.
  exit /b 1
)
for %%A in ("%~1") do if %%~zA LEQ 0 (
  echo ERROR: %~2 no es valido porque tiene 0 bytes.
  exit /b 1
)
for %%A in ("%~1") do call :format_size %%~zA %~3
exit /b 0

:format_size
set "SIZE_BYTES=%~1"
if %SIZE_BYTES% LSS 1024 (
  set "%~2=%SIZE_BYTES% bytes"
  exit /b 0
)
set /a SIZE_KB=(SIZE_BYTES+1023)/1024
if %SIZE_KB% LSS 1024 (
  set "%~2=%SIZE_KB% KB"
  exit /b 0
)
set /a SIZE_MB=(SIZE_KB+1023)/1024
set "%~2=%SIZE_MB% MB"
exit /b 0

:show_pg_error
echo ERROR: fallo %~2 al %~3.
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
echo Detalle devuelto por %~2:
type "%~1"
exit /b 0
