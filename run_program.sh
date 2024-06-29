#!/bin/bash

# Funcție pentru a elimina ultimele 11 caractere dintr-un string
strip_last_11() {
    local input="$1"
    echo "${input:0:-11}"
}

# Sterge fisierele de care nu avem nevoie
./remove_files.sh

# Extragem integrator-ul si timpul mort
./datagrepintegrator convert2txt_ns.txt integrator_count.txt
./datagrepdeadtime deadTime_det1_0.3.txt dead_time_det1
./datagrepdeadtime deadTime_det2_0.3.txt dead_time_det2

# Navighează în folderul Resources/Spectre
cd "Resources/Spectre" || exit

# Iterează prin toate fișierele .amplitude1 și .amplitude2 din folderul curent
for f in *.amplitude1 *.amplitude2; do

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo ""
    
    echo "Procesând fișierul: $f"

    # Initializează variabila de control pentru a verifica dacă s-au găsit parametrii
    found_params=false

    # Citeste parametrii corespunzători din fișierul de input
    while IFS= read -r line; do
        read -r name param2 param3 param4 param5 param6 param7 param8 param9 <<< "$line"
        if [ "$name" == "$f" ]; then
            found_params=true
            break
        fi
    done < ../InputFile.txt

    # Navighează înapoi în folderul principal
    cd ../../ || exit

    # Verifică dacă s-au găsit parametrii
    if [ "$found_params" = false ]; then
        ./Integrator $f

        # Navighează în folderul Resources/Spectre
        cd "Resources/Spectre" || exit
        continue
    fi

    # Rulează programul pentru fișierul curent cu parametrii corespunzători
    # .\\Program <input_file> <Energy> <ch_left> <ch_right> <ch_left_noise> <ch_right_noise> <ch_left_noise> <ch_right_noise> <output_file>
    ./Integrator $f $param2 $param3 $param4 $param5 $param6 $param7 $param8 $param9

     # Navighează în folderul Resources/Spectre
    cd "Resources/Spectre" || exit
done

# Iterează prin toate fișierele .amplitude1 din folderul curent
for f in *.amplitude1; do

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo ""
    
    echo "Procesând fișierul: $f"

    output_file="cross_section_detector1"

    search_filename=$f
    search_filename=$(strip_last_11 "$search_filename")

    input_file="../SetupFiles/integrator_count.txt"

    # Căutăm linia care conține numele căutat și extragem nr integrator
    integrator_count=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    input_file="../SetupFiles/dead_time_det1"

    # Căutăm linia care conține numele căutat și extragem timpul mort
    dead_time_det1=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    input_file="../detector1.txt"

    # Căutăm linia care conține numele căutat și extragem cuvântul specificat
    photo_peak_area=$(grep -E "${search_filename}" $input_file | awk '{print $3}')

    input_file="../SetupFiles/setup_params.txt"

    sample_area=$(awk '{print $1}' $input_file)
    density=$(awk '{print $2}' $input_file)
    efficiency=$(awk '{print $3}' $input_file)

    echo $search_filename $photo_peak_area $sample_area $integrator_count $density $efficiency $dead_time_det1 $output_file

    # Navighează în folderul Resources/Spectre
    cd "../../" || exit

    # .\\Program photo_peak area, sample area, integrator, density, efficiency, dead time, outputfile, run, detector
    ./cross_section_calculator $photo_peak_area $sample_area $integrator_count $density $efficiency $dead_time_det1 $output_file $f detector1

    # Navighează în folderul Resources/Spectre
    cd "Resources/Spectre" || exit

done

# Iterează prin toate fișierele .amplitude2 din folderul curent
for f in *.amplitude2; do

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo ""
    
    echo "Procesând fișierul: $f"

    output_file="cross_section_detector2"

    search_filename=$f
    search_filename=$(strip_last_11 "$search_filename")

    input_file="../SetupFiles/integrator_count.txt"

    # Căutăm linia care conține numele căutat și extragem nr integrator
    integrator_count=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    input_file="../SetupFiles/dead_time_det2"

    # Căutăm linia care conține numele căutat și extragem timpul mort
    dead_time_det2=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    input_file="../detector2.txt"

    # Căutăm linia care conține numele căutat și extragem cuvântul specificat
    photo_peak_area=$(grep -E "${search_filename}" $input_file | awk '{print $3}')

    input_file="../SetupFiles/setup_params.txt"

    sample_area=$(awk '{print $1}' $input_file)
    density=$(awk '{print $2}' $input_file)
    efficiency=$(awk '{print $3}' $input_file)

    echo $search_filename $photo_peak_area $sample_area $integrator_count $density $efficiency $dead_time_det2 $output_file

    # Navighează în folderul Resources/Spectre
    cd "../../" || exit

    # .\\Program photo_peak area, sample area, integrator, density, efficiency, dead time, outputfile, run, detector
    ./cross_section_calculator $photo_peak_area $sample_area $integrator_count $density $efficiency $dead_time_det2 $output_file $f detector2

    # Navighează în folderul Resources/Spectre
    cd "Resources/Spectre" || exit

done

echo ""
echo "--------------------------------------------------------------------------------"
echo ""

echo "Toate fișierele au fost procesate."