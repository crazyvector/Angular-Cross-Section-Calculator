#!/bin/bash

mkdir Runs
mkdir timedif1
mkdir Timedif2
mkdir Rate1
mkdir Rate2
mkdir Amplitude1
mkdir Amplitude2

for f in Run*; do
    folder_name=$(echo "$f" | cut -d'_' -f1-3)

    if [ -d "Runs/$folder_name" ]; then
        echo "The 'Runs/$folder_name' directory already exists. I skip this action."
    else
        # Create directory if none exists
        mkdir -p "Runs/$folder_name"
        echo "I created the folder: 'Runs/$folder_name'"
        cp "$folder_name"* "Runs/$folder_name"
        echo "I copied the files to the folder: 'Runs/$folder_name'"
    fi
done

echo ""
    echo "--------------------------------------------------------------------------------"
echo ""

convert_inelastic Runs

for f in Run*; do
    folder_name=$(echo "$f" | cut -d'_' -f1-3)

    echo "Processing the file: $f"
    cd Runs/$folder_name
    faster2spectra 0 $folder_name
    #cp *"amplitude1" "../../Amplitude1"
    rm converter.txt
    cd ../../
done