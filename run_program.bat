@echo off

REM Navighează în folderul Resources\Spectre
cd "Resources\Spectre" || exit /b

REM Iterează prin toate fișierele .amplitude1 și .amplitude2 din folderul curent
for %%f in (*.amplitude1 *.amplitude2) do (
    echo.
    echo --------------------------------------------------------------------------------
    echo.
    
    echo Procesând fișierul: %%f

    REM Navighează înapoi în folderul Resources
    cd .. || exit /b

    REM Citește parametrii din fișierul de input
    setlocal enabledelayedexpansion
    set "line="
    for /f "usebackq tokens=2-8" %%A in ("InputFile.txt") do (
        set "param2=%%A"
        set "param3=%%B"
        set "param4=%%C"
        set "param5=%%D"
        set "param6=%%E"
        set "param7=%%F"
        set "param8=%%G"
    )

    REM Verifică dacă s-au citit corect parametrii
    if "!param2!"=="" (
        echo Eroare: Nu s-au putut citi toți parametrii din fișierul de input.
        endlocal
        goto :continue
    )
    if "!param3!"=="" (
        echo Eroare: Nu s-au putut citi toți parametrii din fișierul de input.
        endlocal
        goto :continue
    )
    if "!param4!"=="" (
        echo Eroare: Nu s-au putut citi toți parametrii din fișierul de input.
        endlocal
        goto :continue
    )
    if "!param5!"=="" (
        echo Eroare: Nu s-au putut citi toți parametrii din fișierul de input.
        endlocal
        goto :continue
    )
    if "!param6!"=="" (
        echo Eroare: Nu s-au putut citi toți parametrii din fișierul de input.
        endlocal
        goto :continue
    )
    if "!param7!"=="" (
        echo Eroare: Nu s-au putut citi toți parametrii din fișierul de input.
        endlocal
        goto :continue
    )
    if "!param8!"=="" (
        echo Eroare: Nu s-au putut citi toți parametrii din fișierul de input.
        endlocal
        goto :continue
    )

    REM Navighează înapoi în folderul principal
    cd .. || exit /b

    REM Rulează programul pentru fișierul curent cu parametrii corespunzători
    Integrator.exe "Resources\Spectre\%%f" "!param2!" "!param3!" "!param4!" "!param5!" "!param6!" "!param7!" "!param8!"

    :continue
    endlocal

    REM Navighează în folderul Resources\Spectre
    cd "Resources\Spectre" || exit /b
)

echo Toate fișierele au fost procesate.
pause
