@echo off
for %%f in (*.swift) do (
    echo %%f
    echo F|xcopy /s /F header.conf "%TEMP%\%%f"
    more +7 "%%f" >> "%TEMP%\%%f"
    move /y "%TEMP%\%%f" "%%f" > nul
)
echo Done.
PAUSE