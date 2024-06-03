@echo off

REM Navighează în folderul Resources/Spectre
cd "Resources\Spectre" || exit /b

REM Iterează prin toate fișierele .amplitude1 și .amplitude2 din folderul curent
for %%f in (*.amplitude1 *.amplitude2) do (
    echo.
    echo --------------------------------------------------------------------------------
    echo.
    echo Procesând fișierul: %%f

    REM Navighează înapoi în folderul Resources
    cd .. || exit /b

    REM Initializează variabila de control pentru a verifica dacă s-au găsit parametrii
    set found_params=false

    REM Citeste parametrii corespunzători din fișierul de input
    for /F "tokens=1-8" %%a in (InputFile.txt) do (
        if "%%a"=="%%~nf" (
            set found_params=true
            set param2=%%b
            set param3=%%c
            set param4=%%d
            set param5=%%e
            set param6=%%f
            set param7=%%g
            set param8=%%h
            goto :found
        )
    )

    :notfound
    REM Verifică dacă s-au găsit parametrii
    if "%found_params%"=="false" (
        echo Eroare: Nu s-au găsit parametrii pentru spectrul %%~nf.
        Integrator.exe "%%f"

        REM Navighează în folderul Resources/Spectre
        cd "Resources\Spectre" || exit /b
        goto :continue
    )

    :found
    REM Rulează programul pentru fișierul curent cu parametrii corespunzători
    Integrator.exe "%%f" "%param2%" "%param3%" "%param4%" "%param5%" "%param6%" "%param7%" "%param8%"

    REM Navighează în folderul Resources/Spectre
    cd "Resources\Spectre" || exit /b

    :continue
)

echo Toate fișierele au fost procesate.
