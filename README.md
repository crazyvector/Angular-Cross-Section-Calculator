# Gamma-peak-integrator & Angular Cross section Calculator & Efficiency Calculator & Raw data conversion file
Program for Integrating and Subtracting the Background of Gamma Peaks and then calculating the Angular Cross-Section.  
We included programs for efficiency calculation and a batch file for converting the raw files.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

In the input file, we provide the parameters for spectrum analysis.  
We will get one file for each detector. In each file, the spectrum name, energy, and integral after background subtraction will be displayed.  
It will be the same for cross-section calculations. One file for each detector, with the Run number and cross section.  
In the end we get a file with angular cross-section data and plot the cross-sections for 2 detectors and the angular cross-section, with error bars.  

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

We have added .sh scripts for running the program on Linux.  
The C++ programs can be compiled using g++ program_name.cpp -o program_name  

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

To run the program, change the input file and then run ./run_program.sh in the main folder.  
** To store it in a log file, run ./run_program.sh > log.txt in the main folder.**  

To convert the raw files, you need different programs that were not included in this repository. They are convert.cpp and faster2spectra.cpp.  
To run the program, run ./conversie.sh in the main folder.  

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Steps to use the program

1. Update the input file in Resources foulder
2. Update the range for areal density, sample atomic mass, efficiency for detector 1 and 2 in ./run_program.sh from the main folder
3. Provide the convert2txt_ns.txt (integrator count) and deadTime_det1_0.3.txt, deadTime_det2_0.3.txt (dead time for 2 detectors) in Resources/SetupFiles folder
   
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Program functionality in steps:

1. We remove the previous files
2. We extract dead time and number of counts from the provided setup files
3. We go through each spectrum to be analyzed and send the parameters from the input_file to the program Integrator.cpp, which returns the area of the analyzed peak with errors and write it to the file detector1.txt (respectively detector2.txt)
4. We go through all the spectra for detector 1, look for the parameters in the provided files and send them to the program cross_section_calculator.cpp which returns the cross section for detector 1 with errors and write it to the file cross_section_detector1.txt
5. Analog for second detector
6. We go through all the spectra (it doesn't matter for which detector, for simplicity we used detector 2, the run name is the same), read the sections from the previously created files cross_section_detector1.txt and cross_section_detector2.txt and calculate the angular cross-section that we write in the file angular_cross_section.txt with errors
7. We plot the sections of the 2 detectors in the file cross_section.png with error bars and the final angular cross-section in the file angular_cross_section.png with error bars
