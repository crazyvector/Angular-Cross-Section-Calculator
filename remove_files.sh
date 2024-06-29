#!/bin/bash

# Specifică calea către directorul care trebuie golit
folder1="Images"
folder2="Resources/Data"
folder3="Scripts"
folder4="Resources"

# Verifică dacă directorul există
if [ -d "$folder1" ]; then
    # Șterge toate fișierele și subfolderele din directorul țintă
    rm -rf "$folder1"/*
    echo "Toate fișierele și subfolderele din $folder1 au fost șterse."
else
    echo "Directorul $folder1 nu există."
fi

# Verifică dacă directorul există
if [ -d "$folder2" ]; then
    # Șterge toate fișierele și subfolderele din directorul țintă
    rm -rf "$folder2"/*
    echo "Toate fișierele și subfolderele din $folder2 au fost șterse."
else
    echo "Directorul $folder2 nu există."
fi

# Verifică dacă directorul există
if [ -d "$folder3" ]; then
    # Șterge toate fișierele și subfolderele din directorul țintă
    rm -rf "$folder3"/*
    echo "Toate fișierele și subfolderele din $folder3 au fost șterse."
else
    echo "Directorul $folder3 nu există."
fi

# Verifică dacă directorul există
if [ -d "$folder4" ]; then
    # Șterge toate fișierele și subfolderele din directorul țintă
    rm -rf "$folder4"/detector1.txt
    rm -rf "$folder4"/detector2.txt
    rm -rf "$folder4"/cross_section_detector1.txt
    rm -rf "$folder4"/cross_section_detector2.txt
    echo "Am sters fisierele detector1.txt, detector2.txt, cross_section_detector1, cross_section_detector2"
else
    echo "Directorul $folder4 nu există."
fi