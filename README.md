# Gamma-peak-integrator & Angular Cross section Calculator & Efficiency Calculator & Raw data conversion file
This program integrates and subtracts the background of gamma peaks, followed by calculating the angular cross-section.  
Additionally, it includes tools for efficiency calculation and a batch file for converting raw files.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

In the input file, parameters for spectrum analysis are provided.  
The program generates one output file for each detector, displaying the spectrum name, energy, and integral after background subtraction.  
The same process applies to cross-section calculations, producing one file per detector with the run number and cross section.  
Finally, the program outputs a file containing angular cross-section data and plots the cross-sections for two detectors, including error bars. 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Shell scripts (.sh) are provided for running the program on Linux.  
The C++ programs can be compiled using: `g++ program_name.cpp -o program_name`  

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

To run the program, update the input file and then execute: `./run_program.sh` in the main folder.  
** To store the output in a log file, use: `./run_program.sh > log.txt`**  

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Steps to use the program

1. Update the input file in Resources foulder  
2. Modify the range for areal density, sample atomic mass, and efficiency for detectors 1 and 2 in `./run_program.sh` located in the main folder.  
3. Provide the necessary files (`convert2txt_ns.txt`, `deadTime_det1_0.3.txt`, `deadTime_det2_0.3.txt`) in the `Resources/SetupFiles` folder.  
   
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Program functionality in steps:

1. Previous files are removed.  
2. Dead time and count numbers are extracted from the provided setup files.  
3. Each spectrum to be analyzed is processed, sending parameters from the `input_file` to the `program Integrator.cpp`, which returns the analyzed peak area with errors and writes it to `detector1.txt` (or `detector2.txt`).  
4. For all spectra related to detector 1, parameters are retrieved from the provided files and sent to the program `cross_section_calculator.cpp`, which returns the cross section for detector 1 with errors, writing the results to `cross_section_detector1.txt`.  
5. The same process is repeated for the second detector.  
6. All spectra (regardless of detector) are processed using the run name (detector 2 is used for simplicity). Sections from `cross_section_detector1.txt` and `cross_section_detector2.txt` are read, and the angular cross-section is calculated and written to `angular_cross_section.txt` with errors.  
7. The program plots the sections for both detectors in `cross_section.png` with error bars, as well as the final angular cross-section in `angular_cross_section.png` with error bars.  
