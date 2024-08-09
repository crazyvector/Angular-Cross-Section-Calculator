#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>
#include <sstream>

using namespace std;


int main(int argc, char* argv[]) {

    if (argc != 10) {
        //cerr << "To recompile the file : g++ cross_section_calculator.cpp -o cross_section_calculator" << endl;
        //cerr << "Usage for cross section calculator: .\\Program photo_peak area, sample area, integrator, density, efficiency, dead time, outputfile, run, energy << endl;
        
        cerr << "Error: Parameters not found!"<< endl;

        return 1;
    }

    //the format of the file is
    //photo_peak area, sample area, integrator, density, efficiency, dead time
    double pi = 3.141592653589793;
    double c1 = 1/(4*pi);                           //1/4*pi
    double c2 = 1.66053 * pow(10,-21);              //a.m.u(mg) - atomic mass (1u)
    double A = stod(argv[1]);                       //photo_peak area
    double A_sample = stod(argv[2]);                //sample area
    double N = (stod(argv[3])/1.602) * pow(10,9);   //proton number - integrator
    double ro = stod(argv[4]);                      //areal density
    double niu = stod(argv[5]);                     //efficiency
    double dead_time = stod(argv[6]);               //dead time
    
    //calculate cross section
    // cross_section = (1/4*pi) * ((photo_peak_area*amu*sample_area)/(proton_number*density*efficiency)) / 10^-24 * dead_time
    double cross_section = c1 * ((A*c2*A_sample)/(N*ro*niu)) / pow(10,-24);
    cout << "cross section is: " << cross_section << endl;
    cross_section = cross_section * dead_time;
    cout << "cross section is (with dead time correction): " << cross_section << endl;

    string Run = argv[8];                           //run name
    double energy = stod(argv[9]);                  //energy

    //write in file
    string outputFileName = argv[7];
    ofstream OutputFile;
    OutputFile.open("Resources/"+outputFileName+".txt", ios_base::app);
    
    if (OutputFile.is_open()) {
        OutputFile << Run << " " << energy << " " << cross_section << " " << cross_section/20 << endl;
        OutputFile.close();
    } else {
        cerr << "Unable to open file for writing!" << endl;
    }

    return 0;
}
