#!/bin/bash

strip_last_letters() {
    local input="$1"
    local n="$2"
    echo "${input:0:-$n}"
}

calc_areal_dens() {
    local input="$1"
    number=${input:3}

    # Convert number to integer
    number=$(echo $number | bc)

    # Check what range the number is in
    if [ $number -ge 1 ] && [ $number -le 271 ]; then
        echo "0.6089"
    elif [ $number -ge 275 ] && [ $number -le 345 ]; then
        echo "3.3097"
    elif [ $number -ge 347 ] && [ $number -le 373 ]; then
        echo "1.57"
    elif [ $number -ge 374 ] && [ $number -le 385 ]; then
        echo "0"
    else
        echo "The number is not in any of the specified ranges"
    fi
}

# Constants
sample_atomic_mass=55.9349
efficiency1=0.0004474336921638
efficiency2=0.0006010000164478
pi=3.141592653589793

# Delete files we don't need
./remove_files.sh

# Extract integrator and dead time
./datagrepintegrator convert2txt_ns.txt integrator_count.txt
./datagrepdeadtime deadTime_det1_0.3.txt dead_time_det1
./datagrepdeadtime deadTime_det2_0.3.txt dead_time_det2

# Navigate to the Resources/Spectre folder
cd "Resources/Spectre" || exit

# Go through all .amplitude1 and .amplitude2 files in the current folder
for f in *.amplitude1 *.amplitude2; do

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo ""
    
    echo "Processing file: $f"

    # Initializes the control variable to check if the parameters were found
    found_params=false

    # Read the corresponding parameters from the input file
    while IFS= read -r line; do
        read -r name param2 param3 param4 param5 param6 param7 param8 param9 <<< "$line"
        if [ "$name" == "$f" ]; then
            found_params=true
            break
        fi
    done < ../InputFile.txt

    # Navigate back to the main folder
    cd ../../ || exit

    # Check if parameters have been found
    if [ "$found_params" = false ]; then
        ./Integrator $f

        # Navigate to the Resources/Spectre folder
        cd "Resources/Spectre" || exit
        continue
    fi

    # Run the program for the current file with the corresponding parameters
    # .\\Program <input_file> <Energy> <ch_left> <ch_right> <ch_left_noise> <ch_right_noise> <ch_left_noise> <ch_right_noise> <output_file>
    ./Integrator $f $param2 $param3 $param4 $param5 $param6 $param7 $param8 $param9

     # Navigate to the Resources/Spectre folder
    cd "Resources/Spectre" || exit
done

# Go through all .amplitude1 files in the current folder
for f in *.amplitude1; do

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo ""
    
    echo "Processing file: $f"

    output_file="cross_section_detector1"

    search_filename=$f
    search_filename=$(strip_last_letters "$search_filename" 11)

    input_file="../SetupFiles/integrator_count.txt"

    # Search for the line containing the searched name and extract the integrator number
    integrator_count=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    input_file="../SetupFiles/dead_time_det1"

    # Search for the line containing the searched name and extract the dead time
    dead_time_det1=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    search_filename=$(echo "$search_filename" | cut -d'_' -f1)

    input_file="../detector1.txt"

    # Search for the line containing the searched name and extract the specified word
    photo_peak_area=$(grep -E "${search_filename}" $input_file | awk '{print $3}')
    energy=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    areal_density=$(calc_areal_dens "$search_filename")

    echo "RUN Energy photo_peak area, sample area, integrator, areal_density, efficiency1, dead time, outputfile"
    echo $search_filename $energy $photo_peak_area $sample_atomic_mass $integrator_count $areal_density $efficiency1 $dead_time_det1 $output_file

    # Navigate to the Resources/Spectre folder
    cd "../../" || exit

    # .\\Program photo_peak area, sample area, integrator, areal_density, efficiency1, dead time, outputfile, run, energy
    ./cross_section_calculator $photo_peak_area $sample_atomic_mass $integrator_count $areal_density $efficiency1 $dead_time_det1 $output_file $search_filename $energy

    # Navigate to the Resources/Spectre folder
    cd "Resources/Spectre" || exit

done

# Go through all .amplitude2 files in the current folder
for f in *.amplitude2; do

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo ""
    
    echo "Processing file: $f"

    output_file="cross_section_detector2"

    search_filename=$f
    search_filename=$(strip_last_letters "$search_filename" 11)

    input_file="../SetupFiles/integrator_count.txt"

    # Search for the line containing the searched name and extract the integrator number
    integrator_count=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    input_file="../SetupFiles/dead_time_det2"

    # Search for the line containing the searched name and extract the dead time
    dead_time_det2=$(grep -E "${search_filename}" $input_file | awk '{print $2}')
    
    search_filename=$(echo "$search_filename" | cut -d'_' -f1)

    input_file="../detector2.txt"

    # Search for the line containing the searched name and extract the specified word
    photo_peak_area=$(grep -E "${search_filename}" $input_file | awk '{print $3}')
    energy=$(grep -E "${search_filename}" $input_file | awk '{print $2}')

    areal_density=$(calc_areal_dens "$search_filename")

    echo "RUN Energy photo_peak area, sample area, integrator, areal_density, efficiency1, dead time, outputfile"
    echo $search_filename $energy $photo_peak_area $sample_atomic_mass $integrator_count $areal_density $efficiency2 $dead_time_det2 $output_file

    # Navigate to the Resources/Spectre folder
    cd "../../" || exit

    # .\\Program photo_peak area, sample area, integrator, areal_density, efficiency2, dead time, outputfile, run, energy
    ./cross_section_calculator $photo_peak_area $sample_atomic_mass $integrator_count $areal_density $efficiency2 $dead_time_det2 $output_file $search_filename $energy

    # Navigate to the Resources/Spectre folder
    cd "Resources/Spectre" || exit

done


# Go through all .amplitude2 files in the current folder
for f in *.amplitude2; do

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo ""

    f=$(echo "$f" | cut -d'_' -f1)
    
    echo "Processing file: $f"

    # Initializes the control variable to check if the parameters were found
    found_params1=false
    found_params2=false

    # Read the corresponding parameters from the input (cross_section1) file
    while IFS= read -r line; do
        read -r run energy cross_section1 error1 <<< "$line"
        if [ "$run" == "$f" ]; then
            found_params1=true
            break
        fi
    done < "../cross_section_detector1.txt"

    # Read the corresponding parameters from the input (cross_section2) file
    while IFS= read -r line; do
        read -r run energy cross_section2 error2 <<< "$line"
        if [ "$run" == "$f" ]; then
            found_params2=true
            break
        fi
    done < "../cross_section_detector2.txt"

    echo "Cross section 1: $cross_section1 ; Cross section 2: $cross_section2"

    angular_cross_section=$(echo "$pi * 4 * (0.652145 * $cross_section1 + 0.347855 * $cross_section2)" | bc -l)

    echo "Angular cross section is: 0$angular_cross_section"

    angular_cross_section_err=$(echo "$angular_cross_section/20" | bc -l)
    echo "$run $energy 0$angular_cross_section 0$angular_cross_section_err" >> "../angular_cross_section.txt"

done

echo ""
echo "--------------------------------------------------------------------------------"
echo ""

# Navigate to the Resources folder
    cd "../" || exit

# Define the scripts filename for gnuplot
GNUPLOT_SCRIPT1="../Scripts/plot_cross_sections.gp"
GNUPLOT_SCRIPT2="../Scripts/plot_angular_cross_sections.gp"

# Create the gnuplot scripts
cat << EOF > $GNUPLOT_SCRIPT1
set terminal png size 800,600
set output 'cross_section.png'
set grid
set xlabel 'X'
set ylabel 'Y'
set style data points
plot 'cross_section_detector1.txt' u 2:3:4 with yerr title 'cross_section_detector1', 'cross_section_detector2.txt' u 2:3:4 with yerr title 'cross_section_detector2'
EOF
cat << EOF > $GNUPLOT_SCRIPT2
set terminal png size 800,600
set output 'angular_cross_section.png'
set grid
set xlabel 'X'
set ylabel 'Y'
set style data points
plot 'angular_cross_section.txt' u 2:3:4 with yerr title 'angular_cross_section'
EOF

# Run the gnuplot script
gnuplot $GNUPLOT_SCRIPT1
gnuplot $GNUPLOT_SCRIPT2

echo "Section graphs have been generated and saved"

echo "All files have been processed."