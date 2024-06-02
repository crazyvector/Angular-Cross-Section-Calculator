@echo off

REM Specifică calea către directoarele care trebuie golite
set "folder1=Images"
set "folder2=Resources\Data"
set "folder3=Scripts"

REM Verifică dacă directorul există și șterge toate fișierele și subfolderele
if exist "%folder1%" (
    del /q "%folder1%\*"
    for /d %%p in ("%folder1%\*") do rmdir /s /q "%%p"
    echo Toate fișierele și subfolderele din %folder1% au fost șterse.
) else (
    echo Directorul %folder1% nu există.
)

REM Verifică dacă directorul există și șterge toate fișierele și subfolderele
if exist "%folder2%" (
    del /q "%folder2%\*"
    for /d %%p in ("%folder2%\*") do rmdir /s /q "%%p"
    echo Toate fișierele și subfolderele din %folder2% au fost șterse.
) else (
    echo Directorul %folder2% nu există.
)

REM Verifică dacă directorul există și șterge toate fișierele și subfolderele
if exist "%folder3%" (
    del /q "%folder3%\*"
    for /d %%p in ("%folder3%\*") do rmdir /s /q "%%p"
    echo Toate fișierele și subfolderele din %folder3% au fost șterse.
) else (
    echo Directorul %folder3% nu există.
)
