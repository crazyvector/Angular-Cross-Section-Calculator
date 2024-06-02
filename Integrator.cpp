#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cmath>
#include <cstring>

using namespace std;

class myClass {

public:
    //functions used
    void getData();         // get input data in a vector
    void Integrate();       // integrate between [chl, chR]
    void calculateBackground(int chL1, int chR1, int chL2, int chR2);    //with quadratic function and substract background

    // functions to set private variables
    void setInputFile(string value) { inputFileName = value; }
    void setOutputFile(string value) { outputFileName = value; }
    void setEnergy(int value) { Energy = value; }
    void setChL(int value) { chL = value; }
    void setChR(int value) { chR = value; }

    // functions to access private variables
    int getChL() { return chL; }
    int getChR() { return chR; }
    int getIntegrala() { Integrate(); return integrala; }
    vector<int> Data() { return data; }

private:
    string inputFileName;       // input file
    string outputFileName;      // output file
    int chL = 0;                // left channel
    int chR = 0;                // right channel
    vector<int> data;           // input file data stored in a vector
    int nrLines = 0;            // number of lines input file
    int integrala = 0;          // integral between chL and chR
    int Energy = 0;             // Energy from user input

    //functions used for data processing and plot
    void generateDataFile(const vector<int>& yValues, const string& filename, int CHL1, int CHR1, int CHL2, int CHR2);
    void plotDataAndFitQuadratic(const vector<double>& coeffs, int CHL);
    void plotData(const string& dataFilename, int CHL);

    // Function to fit a parabola
    void fitParabola();
};

void myClass::getData() {
    //read from file
    ifstream inputFile("Resources/Spectre/"+inputFileName);

    if (!inputFile) {
        cerr << "Could not open the input file!" << endl;
        return;
    }

    string line;

    //go every line and store the data in a vector<int> data
    while (getline(inputFile, line)) {
        data.push_back(stoi(line));
        //increment every line and store the last line
        nrLines++;
    }

    //check if the limits of the interval are correct
    if(chL != 0 && chR != 0)
    {
        int copy;

        if (chL > chR) {
            copy = chL;
            chL = chR;
            chR = copy;
        }

        if (chL < 0 || chR > nrLines) {
            cerr << "Error! Limits are not valid!! " << endl;
            return;
        }
    }
    
    //generate the input file and plot it
    string dataFilename = "output_" + inputFileName;
    //vector data, filename, start&end pos, 2 intervals
    generateDataFile(data, dataFilename, 0, nrLines, 0, 0);
    //filename and start pos
    plotData(dataFilename, 0);

    inputFile.close();
}

void myClass::Integrate() {
    integrala = 0;

    // go every channel and add the value to 'integrala'
    for (int i = chL; i <= chR; i++) {
        integrala += data[i];
    }

    cout << "Integral between the limits " << chL << " and " << chR << " : " << integrala << endl;
}

void myClass::generateDataFile(const vector<int>& yValues, const string& filename, int CHL1, int CHR1, int CHL2, int CHR2) {
    string fullFilename = "Resources/Data/" + filename + ".txt";

    //write in file
    ofstream dataFile(fullFilename);
    //write every y value coresponding to each channel
    for (int i = 0; i <= CHR1-CHL1; ++i) {
        dataFile << i+CHL1+1 << " " << yValues[i] << endl;
    }
    //case if we have a second interval
    if(CHR2 != 0 && CHL2 != 0)
        for (int i = 0; i <= CHR2-CHL2; ++i) {
            dataFile << i+CHL2 << " " << yValues[i+CHR1-CHL1+2] << endl;
        }
    dataFile.close();
}

void myClass::plotDataAndFitQuadratic(const vector<double>& coeffs, int CHL) {
    ofstream scriptFile("Scripts/plot_script_quadratic.gp");
    scriptFile << "set terminal png size 800,600\n";
    scriptFile << "set output 'Images/fit_"<< inputFileName << ".png'\n";
    scriptFile << "set grid\n";
    scriptFile << "set xlabel 'X'\n";
    scriptFile << "set ylabel 'Y'\n";
    scriptFile << "set style data histeps\n";
    scriptFile << "f(x) = " << coeffs[0] << "*(x-" << CHL << ")**2 + " << coeffs[1] << "*(x-" << CHL << ") + " << coeffs[2] << "\n";
    scriptFile << "plot["<< chL << ":" << chR <<"] 'Resources/Data/coordinates_"+ inputFileName +".txt' with points title 'Fond', '" << "Resources/Spectre/"+inputFileName <<"' title 'Data', f(x) with lines title 'Quadratic'\n";
    scriptFile.close();

    system("gnuplot Scripts/plot_script_quadratic.gp");
}

void myClass::plotData(const string& dataFilename, int CHL) {
    ofstream scriptFile("Scripts/plot_script_data.gp");
    scriptFile << "set terminal png size 800,600\n";
    scriptFile << "set output 'Images/" << dataFilename << ".png'\n";
    scriptFile << "set grid\n";
    scriptFile << "set xlabel 'X'\n";
    scriptFile << "set ylabel 'Y'\n";
    scriptFile << "set style data histeps\n";
    scriptFile << "plot 'Resources/Data/" << dataFilename << ".txt' using ($1+" << CHL << "):2 title 'Data'\n";
    scriptFile.close();

    system("gnuplot Scripts/plot_script_data.gp");
}

void myClass::fitParabola() {
    ofstream scriptFile("Scripts/plot_script_fitParabola.gp");
    scriptFile << "f(x) = a*x**2 + b*x + c\n";
    scriptFile << "a = 1\n";
    scriptFile << "b = 1\n";
    scriptFile << "c = 1\n";
    scriptFile << "fit f(x) 'Resources/Data/coordinates_"+ inputFileName +".txt' via a, b, c\n";
    scriptFile << "set print 'Resources/Data/coefficients_"+ inputFileName +".txt'\n";
    scriptFile << "print a, b, c\n";
    scriptFile.close();

    system("gnuplot Scripts/plot_script_fitParabola.gp");

}

void myClass::calculateBackground(int chL1, int chR1, int chL2, int chR2) {
    //write in file
    ofstream CoordinatesFile;
    CoordinatesFile.open("Resources/Data/coordinates_" + inputFileName+ ".txt");
    
    if (CoordinatesFile.is_open()) {
        //in order to calculate the background corectly, i start the coordinates from 0 on x axis
        //therefore i substract the first channel

        //put the coordinates from the first background interval in a file
        for (int i = 0; i <= chR1-chL1; i++) {
        CoordinatesFile << i << " " << data[i] << endl;
        }
        //put the coordinates from the second background interval in a file
        for (int i = chL2-chL1; i <= chR2-chL1; i++) {
            CoordinatesFile << i << " " << data[i] << endl;
        }
        CoordinatesFile.close();
    } else {
        cerr << "Unable to open file for writing!" << endl;
    }

    //fit quadratic using gnuplot
    fitParabola();

    //store coefficients a, b, c in a vector
    vector<double> coeffs;

    //read from file
    ifstream CoefficientsFile("Resources/Data/coefficients_" + inputFileName + ".txt");

    if (!CoefficientsFile) {
        cerr << "Could not open the input file!" << endl;
        return;
    }

    string word1, word2, word3;

    //get the coefficients from file and put them in coeffs vector
    CoefficientsFile >> word1 >> word2 >> word3;
    coeffs.push_back(stod(word1));
    coeffs.push_back(stod(word2));
    coeffs.push_back(stod(word3));
    CoefficientsFile.close();

    cout << "The integral is: " << integrala << endl;
    plotDataAndFitQuadratic(coeffs, chL1);

    float y = 0;
    float error_sigma = integrala;

    for(int i = 0; i <= chR-chL; i++)
    {
        // f(x)=ax^2 + bx + c
        y = coeffs[0]*(i*i) + coeffs[1]*i + coeffs[2];
        //cout<<y<<endl;
        if(y>0)
        {
            integrala -= y;
            error_sigma += y;
        }
            
    }
    cout << "The integral with background substracted is: " << integrala << " +/- " << sqrt(error_sigma) << endl;

    //write in file
    ofstream OutputFile;
    OutputFile.open("Resources/OutputFile.txt", ios_base::app);
    
    if (OutputFile.is_open()) {
        OutputFile << inputFileName << " " << Energy << " " << integrala << endl;
        OutputFile.close();
    } else {
        cerr << "Unable to open file for writing!" << endl;
    }
}

int main(int argc, char* argv[]) {
    myClass myObject;

    // Program usage
    if (argc != 9) {
        cerr << "To recompile the file : g++ Integrator.cpp -o Integrator" << endl;
        cerr << "Usage for Background-Noise removal: .\\Program <input_file> <Energy> <ch_left> <ch_right> <ch_left_noise> <ch_right_noise> <ch_left_noise> <ch_right_noise>" << endl;
        return 1;
    }

    myObject.setInputFile(argv[1]);
    myObject.setChL(stoi(argv[3]));
    myObject.setChR(stoi(argv[4]));
    myObject.setEnergy(stoi(argv[2]));
    myObject.getData();
    myObject.getIntegrala();
    myObject.calculateBackground(stoi(argv[5]), stoi(argv[6]), stoi(argv[7]), stoi(argv[8]));

    return 0;
}
