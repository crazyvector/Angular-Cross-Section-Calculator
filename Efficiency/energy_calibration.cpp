#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>

using namespace std;

void createScripts(const string& inputFile, const string& plotFile) {
    // Script for the first window (initial)
    ofstream scriptFile1("../../Scripts/initial_plot.gp");
    scriptFile1 << "set termoption noenhanced\n";
    scriptFile1 << "set terminal qt size 800,600\n";
    scriptFile1 << "set mouse\n";
    scriptFile1 << "set grid\n";
    scriptFile1 << "set style data his\n";
    scriptFile1 << "set title 'Initial Plot'\n";
    scriptFile1 << "plot '" << inputFile << "' title '"<< inputFile.substr(11, inputFile.length()) <<"'\n";
    scriptFile1 << "pause -1 'Press Enter to close this window...'\n";
    scriptFile1.close();

    // Script for the second window (calibrated)
    ofstream scriptFile2("../../Scripts/calibrated_run.gp");
    scriptFile2 << "set termoption noenhanced\n";
    scriptFile2 << "set terminal qt size 800,600\n";
    scriptFile2 << "set mouse\n";
    scriptFile2 << "set grid\n";
    scriptFile2 << "set style data his\n";
    scriptFile2 << "f(x)=a*x+b\n";
    scriptFile2 << "fit f(x) '" << plotFile <<"' via a,b\n";
    scriptFile2 << "set title 'Calibrated Run'\n";
    scriptFile2 << "plot '" << inputFile << "' using (f($0)):1 title '"<< inputFile.substr(11, inputFile.length()) <<"'\n";
    scriptFile2 << "pause -1 'Press Enter to close this window...'\n";
    scriptFile2.close();
}

void runScripts() {
    // Run both scripts simultaneously
    system("xterm -e gnuplot ../../Scripts/initial_plot.gp &");
    system("xterm -e gnuplot ../../Scripts/calibrated_run.gp &");
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        //cerr << "To recompile the file : g++ energy_calibration.cpp -o energy_calibration" << endl;
        cerr << "Error: You must provide exactly 2 arguments." << endl;
        cerr << "Use: ./energy_calibration <spectrum> <calibration_file>" << endl;
        return 1;
    }

    createScripts(argv[1], argv[2]);
    runScripts();

    return 0;
}
