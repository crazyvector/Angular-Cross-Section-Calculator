#!/bin/bash

# Check if the number of arguments is different from 2
if [ "$#" -ne 2 ]; then
    echo "Error: You must provide exactly 2 arguments."
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

# Definition of variables
zile=365
t=1141
sigma_t=1
T=$(echo "13.522 * $zile * 86400" | bc)
sigma_T=$(echo "0.016 * $zile * 86400" | bc)
activity_0=389300
sigma_activity_0=7800
time_dif=475200000
ln2=0.6931471805599453

activity=$(echo "$activity_0 * $(echo "e(-($ln2 * $time_dif)/$T)" | bc -l)" | bc -l)
sigma_activity=$(echo "$activity * sqrt((($ln2 / $T)^2 * $sigma_t^2) + (($ln2 * $t / $T^2)^2 * $sigma_T^2) + ((1 / $activity_0^2) * $sigma_activity_0^2))" | bc -l)

# Display result
echo "Activity: $activity +/- $sigma_activity"

# Input file
input_file=$1
# Output file
output_file=$2

# Cleaning the input file
> $output_file

echo "RUN                                       E               A               Error               I           Error               Efficiency                  Error" >> $output_file

# Read the corresponding parameters from the input file and calculate the efficiency
while IFS= read -r line; do
    read -r RUN E A Const sigma_A I  Const sigma_I<<< "$line"
    
    # Efficiency calculation
    efficiency=$(echo "scale=10; $A / ($activity * $I * $t)" | bc -l)
    sigma_efficiency=$(echo "$efficiency * sqrt(($sigma_A/$A)^2 + ($sigma_I/$I)^2 + ($sigma_t/$t)^2 + ($sigma_activity/$activity)^2)" | bc -l)
    
    # Writing the result to the output file
    echo "$RUN          $E          $A          $sigma_A            $I          $sigma_I            0$efficiency            0$sigma_efficiency" >> $output_file
done < $input_file

#rm "$input_file"