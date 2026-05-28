@echo off
setlocal
cd /d "%~dp0"
set "NODE_EXE=C:\Users\familia\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe"
if exist "%NODE_EXE%" (
  start "Web Peña Campanar" cmd /k ""%NODE_EXE%" server.js"
) else (
  start "Web Peña Campanar" cmd /k "node server.js"
)
timeout /t 2 /nobreak >nul
start "" "%~dp0index.html"
