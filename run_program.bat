@echo off

REM Definim calea relativă către folder
set "relative_path=cale\relativa\catre\folder"

REM Verificăm dacă folderul există
if not exist "%relative_path%" (
    echo Folderul %relative_path% nu exista.
    exit /b 1
)

REM Stergem fisierele de care nu avem nevoie
call remove_files.bat

REM Extragem integrator-ul si timpul mort
call datagrepintegrator convert2txt_ns.txt integrator_count.txt
call datagrepdeadtime deadTime_det1_0.3.txt dead_time_det1
call datagrepdeadtime deadTime_det2_0.3.txt dead_time_det2

REM Navigăm în folderul Resources\Spectre
cd "Resources\Spectre" || exit /b 1

REM Iterăm prin toate fișierele .amplitude1 și .amplitude2 din folderul curent
for %%f in (*.amplitude1 *.amplitude2) do (
    echo.
    echo --------------------------------------------------------------------------------
    echo.
    
    echo Procesând fișierul: %%f

    set "found_params=false"
    for /F "tokens=1-9" %%a in ('type ..\InputFile.txt') do (
        if "%%a" == "%%f" (
            set "found_params=true"
            set "param2=%%b"
            set "param3=%%c"
            set "param4=%%d"
            set "param5=%%e"
            set "param6=%%f"
            set "param7=%%g"
            set "param8=%%h"
            set "param9=%%i"
            goto :found_params
        )
    )
    :found_params
    cd ..\..

    if "%found_params%" == "false" (
        call Integrator %%f
        cd "Resources\Spectre"
        goto :continue
    )

    call Integrator %%f %param2% %param3% %param4% %param5% %param6% %param7% %param8% %param9%
    cd "Resources\Spectre"
    :continue
)

REM Funcție pentru a elimina ultimele 11 caractere dintr-un string
:strip_last_11
setlocal enabledelayedexpansion
set "input=%~1"
set "stripped=!input:~0,-11!"
echo !stripped!
endlocal
exit /b

REM Iterăm prin toate fișierele .amplitude1 din folderul curent
for %%f in (*.amplitude1) do (
    echo.
    echo --------------------------------------------------------------------------------
    echo.
    
    echo Procesând fișierul: %%f

    set "output_file=cross_section_detector1"

    call :strip_last_11 %%f
    set "search_filename=%stripped%"

    set "input_file=..\SetupFiles\integrator_count.txt"
    for /F "tokens=2" %%i in ('findstr /I "%search_filename%" %input_file%') do (
        set "integrator_count=%%i"
    )

    set "input_file=..\SetupFiles\dead_time_det1"
    for /F "tokens=2" %%i in ('findstr /I "%search_filename%" %input_file%') do (
        set "dead_time_det1=%%i"
    )

    set "input_file=..\detector1.txt"
    for /F "tokens=3" %%i in ('findstr /I "%search_filename%" %input_file%') do (
        set "photo_peak_area=%%i"
    )

    set "input_file=..\SetupFiles\setup_params.txt"
    for /F "tokens=1,2,3" %%a in (%input_file%) do (
        set "sample_area=%%a"
        set "density=%%b"
        set "efficiency=%%c"
    )

    echo %search_filename% %photo_peak_area% %sample_area% %integrator_count% %density% %efficiency% %dead_time_det1% %output_file%

    cd ..\.. || exit /b 1
    call cross_section_calculator %photo_peak_area% %sample_area% %integrator_count% %density% %efficiency% %dead_time_det1% %output_file% %%f
    cd "Resources\Spectre"
)

REM Iterăm prin toate fișierele .amplitude2 din folderul curent
for %%f in (*.amplitude2) do (
    echo.
    echo --------------------------------------------------------------------------------
    echo.
    
    echo Procesând fișierul: %%f

    set "output_file=cross_section_detector2"

    call :strip_last_11 %%f
    set "search_filename=%stripped%"

    set "input_file=..\SetupFiles\integrator_count.txt"
    for /F "tokens=2" %%i in ('findstr /I "%search_filename%" %input_file%') do (
        set "integrator_count=%%i"
    )

    set "input_file=..\SetupFiles\dead_time_det2"
    for /F "tokens=2" %%i in ('findstr /I "%search_filename%" %input_file%') do (
        set "dead_time_det2=%%i"
    )

    set "input_file=..\detector2.txt"
    for /F "tokens=3" %%i in ('findstr /I "%search_filename%" %input_file%') do (
        set "photo_peak_area=%%i"
    )

    set "input_file=..\SetupFiles\setup_params.txt"
    for /F "tokens=1,2,3" %%a in (%input_file%) do (
        set "sample_area=%%a"
        set "density=%%b"
        set "efficiency=%%c"
    )

    echo %search_filename% %photo_peak_area% %sample_area% %integrator_count% %density% %efficiency% %dead_time_det2% %output_file%

    cd ..\.. || exit /b 1
    call cross_section_calculator %photo_peak_area% %sample_area% %integrator_count% %density% %efficiency% %dead_time_det2% %output_file% %%f
    cd "Resources\Spectre"
)

echo.
echo --------------------------------------------------------------------------------
echo.

echo Toate fișierele au fost procesate.
