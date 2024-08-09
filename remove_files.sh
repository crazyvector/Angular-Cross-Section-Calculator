#!/bin/bash

# Specifies the path to the directory to empty
folder1="Images"
folder2="Resources/Data"
folder3="Scripts"
folder4="Resources"

# Check if the directory exists
if [ -d "$folder1" ]; then
    # Delete all files and subfolders in the target directory
    rm -rf "$folder1"/*
    echo "All files and subfolders in $folder1 have been deleted."
else
    echo "The directory $folder1 does not exist."
fi

# Check if the directory exists
if [ -d "$folder2" ]; then
    # Delete all files and subfolders in the target directory
    rm -rf "$folder2"/*
    echo "All files and subfolders in $folder2 have been deleted."
else
    echo "The directory $folder2 does not exist."
fi

# Check if the directory exists
if [ -d "$folder3" ]; then
    # Delete all files and subfolders in the target directory
    rm -rf "$folder3"/*
    echo "All files and subfolders in $folder3 have been deleted."
else
    echo "The directory $folder3 does not exist."
fi

# Check if the directory exists
if [ -d "$folder4" ]; then
    # Delete all files and subfolders in the target directory
    rm -rf "$folder4"/detector1.txt
    rm -rf "$folder4"/detector2.txt
    rm -rf "$folder4"/cross_section_detector1.txt
    rm -rf "$folder4"/cross_section_detector2.txt
    rm -rf "$folder4"/angular_cross_section.txt
    rm -rf "$folder4"/angular_cross_section.png
    rm -rf "$folder4"/cross_section.png
    echo "I deleted the files detector1.txt, detector2.txt, cross_section_detector1, cross_section_detector2, angular_cross_section.txt, angular_cross_section.png, cross_section.png"
else
    echo "The directory $folder4 does not exist."
fi