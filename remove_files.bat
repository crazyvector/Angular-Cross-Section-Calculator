@echo off

REM Specifică calea către directoarele care trebuie golite
set "folder1=Images"
set "folder2=Resources\Data"
set "folder3=Scripts"
set "folder4=Resources"

REM Verifică dacă directorul există și șterge toate fișierele și subfolderele
if exist "%folder1%" (
    rd /s /q "%folder1%"
    mkdir "%folder1%"
    echo Toate fișierele și subfolderele din %folder1% au fost șterse.
) else (
    echo Directorul %folder1% nu există.
)

REM Verifică dacă directorul există și șterge toate fișierele și subfolderele
if exist "%folder2%" (
    rd /s /q "%folder2%"
    mkdir "%folder2%"
    echo Toate fișierele și subfolderele din %folder2% au fost șterse.
) else (
    echo Directorul %folder2% nu există.
)

REM Verifică dacă directorul există și șterge toate fișierele și subfolderele
if exist "%folder3%" (
    rd /s /q "%folder3%"
    mkdir "%folder3%"
    echo Toate fișierele și subfolderele din %folder3% au fost șterse.
) else (
    echo Directorul %folder3% nu există.
)

REM Verifică dacă directorul există și șterge fișierele specifice
if exist "%folder4%" (
    if exist "%folder4%\detector1.txt" del /q "%folder4%\detector1.txt"
    if exist "%folder4%\detector2.txt" del /q "%folder4%\detector2.txt"
    if exist "%folder4%\cross_section_detector1.txt" del /q "%folder4%\cross_section_detector1.txt"
    if exist "%folder4%\cross_section_detector2.txt" del /q "%folder4%\cross_section_detector2.txt"
    echo Am sters fisierele detector1.txt, detector2.txt, cross_section_detector1.txt, cross_section_detector2.txt
) else (
    echo Directorul %folder4% nu există.
)
