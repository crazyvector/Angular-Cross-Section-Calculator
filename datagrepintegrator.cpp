#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>

int main(int argc, char* argv[]) {

    //cerr << "To recompile the file : g++ datagrepintegrator.cpp -o datagrepintegrator" << endl;

    std::string inputFile = argv[1];
    std::string outputFile = argv[2];

    std::ifstream input("Resources/SetupFiles/" + inputFile); // Input file name
    std::ofstream output("Resources/SetupFiles/" + outputFile ); // Output file name

    if (!input.is_open() || !output.is_open()) {
        std::cerr << "Could not open the file!" << std::endl;
        return 1;
    }

    std::string line;
    int line_count = 0;
    while (std::getline(input, line)) {
        line_count++;
        size_t pos;
        std::string searchStr;

        // Find filename
        searchStr = "File name:";
        pos = line.find(searchStr);

        if (pos != std::string::npos) {
            // We go to the end of the found sequence
            pos += searchStr.length();
            
            // Skip the remaining spaces (if any)
            while (pos < line.length() && line[pos] == ' ') {
                ++pos;
            }

            // Extract the following word
            std::string filename;
            while (pos < line.length() && line[pos] != ' ') {
                filename += line[pos];
                ++pos;
            }
            
            output << filename << " ";
        }

        // Find the number of counts
        searchStr = "Beam integrator (D3):";
        pos = line.find(searchStr);

        if (pos != std::string::npos) {
            // We go to the end of the found sequence
            pos += searchStr.length();
            
            // Skip the remaining spaces (if any)
            while (pos < line.length() && line[pos] == ' ') {
                ++pos;
            }

            // Extract the following word
            std::string counts;
            while (pos < line.length() && line[pos] != ' ') {
                counts += line[pos];
                ++pos;
            }
            
            output << counts << std::endl;
        }

    }

    // Close files
    input.close();
    output.close();

    std::cout << "Operation successfully completed!" << std::endl;

    return 0;
}
