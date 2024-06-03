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

    # Initializează variabila de control pentru a verifica dacă s-au găsit parametrii
    found_params=false

    # Citeste parametrii corespunzători din fișierul de input
    while IFS= read -r line; do
        read -r name param2 param3 param4 param5 param6 param7 param8 <<< "$line"
        if [ "$name" == "$f" ]; then
            found_params=true
            break
        fi
    done < InputFile.txt

    # Navighează înapoi în folderul principal
    cd ../ || exit

    # Verifică dacă s-au găsit parametrii
    if [ "$found_params" = false ]; then
        echo "Eroare: Nu s-au găsit parametrii pentru spectrul $spectrum_name."
        ./Integrator "$f"

        # Navighează în folderul Resources/Spectre
        cd "Resources/Spectre" || exit
        continue
    fi

    # Rulează programul pentru fișierul curent cu parametrii corespunzători
    ./Integrator "$f" "$param2" "$param3" "$param4" "$param5" "$param6" "$param7" "$param8"

    # Navighează în folderul Resources/Spectre
    cd "Resources/Spectre" || exit
done

echo "Toate fișierele au fost procesate."
