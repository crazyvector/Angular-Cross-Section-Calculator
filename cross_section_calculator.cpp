#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>
#include <sstream>

using namespace std;


int main(int argc, char* argv[]) {

    if (argc != 10) {
        //cerr << "To recompile the file : g++ cross_section_calculator.cpp -o cross_section_calculator" << endl;
        //cerr << "Usage for cross section calculator: .\\Program photo_peak area, sample area, integrator, density, efficiency, dead time, outputfile, run, detector << endl;
        
        cerr << "Eroare: Nu s-au găsit parametrii"<< endl;

        return 1;
    }

    //the format of the file is
    //photo_peak area, sample area, integrator, density, efficiency, dead time
    double c1 = 1/(4*3.14);                         //1/4*pi
    double c2 = 1.66053 * pow(10,-27)*pow(10,6);    //a.m.u(mg) - atomic mass (1u)
    double A = stod(argv[1]);                     //photo_peak area
    double A_sample = stod(argv[2]);              //sample area
    double N = (stod(argv[3])/1.602) * pow(10,9); //proton number - integrator
    double ro = 0.98*0.512*stod(argv[4]);         //density
    double niu = stod(argv[5]);                   //efficiency
    double dead_time = stod(argv[6]);             //dead time
    
    //calculate cross section
    // cross_section = (1/4*pi) * ((photo_peak_area*amu*sample_area)/(proton_number*density*efficiency)) / 10^-24 * dead_time
    double cross_section = c1 * ((A*c2*A_sample)/(N*ro*niu)) / pow(10,-24);
    cout << "cross section is: " << cross_section << endl;
    cross_section = cross_section * dead_time;
    cout << "cross section is (with dead time correction): " << cross_section << endl;

    string Run = argv[8];
    string Detector = argv[9];

    //write in file
    string outputFileName = argv[7];
    ofstream OutputFile;
    OutputFile.open("Resources/"+outputFileName+".txt", ios_base::app);
    
    if (OutputFile.is_open()) {
        OutputFile << Run << " " << Detector << " " << cross_section << endl;
        OutputFile.close();
    } else {
        cerr << "Unable to open file for writing!" << endl;
    }

    return 0;
}
