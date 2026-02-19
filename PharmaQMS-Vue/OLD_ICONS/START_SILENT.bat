@echo off
setlocal
cd /d "%~dp0app"

:: Just start the server. Vite --open will trigger the browser.
:: Using 'call' to ensure npm completes correctly.
call npm run dev

:: No pause here so the hidden process can exit cleanly when the server stops.
