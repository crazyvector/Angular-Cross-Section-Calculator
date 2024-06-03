#!/bin/bash

# Navighează în folderul Resources/Spectre
cd "Resources/Spectre" || exit

# Iterează prin toate fișierele .amplitude1 și .amplitude2 din folderul curent
for f in *.amplitude1 *.amplitude2; do

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo ""
    
    echo "Procesând fișierul: $f"

    # Navighează înapoi în folderul Resources
    cd ../ || exit

    # Citeste parametrii din fișierul de input
    read -r param2 param3 param4 param5 param6 param7 param8 < InputFile.txt

    # Verifică dacă s-au citit corect parametrii
    if [ -z "$param2" ] || [ -z "$param3" ] || [ -z "$param4" ] || [ -z "$param5" ] || [ -z "$param6" ] || [ -z "$param7" ] || [ -z "$param8" ]; then
        echo "Eroare: Nu s-au putut citi toți parametrii din fișierul de input."
        continue
    fi

    # Navighează înapoi în folderul principal
    cd ../ || exit

    # Rulează programul pentru fișierul curent cu parametrii corespunzători
    ./Integrator "$f" "$param2" "$param3" "$param4" "$param5" "$param6" "$param7" "$param8"

    # Navighează în folderul Resources/Spectre
    cd "Resources/Spectre" || exit
done

echo "Toate fișierele au fost procesate."
