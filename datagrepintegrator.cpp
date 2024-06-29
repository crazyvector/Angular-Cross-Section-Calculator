#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>

int main(int argc, char* argv[]) {
    std::string inputFile = argv[1];
    std::string outputFile = argv[2];

    std::ifstream input("Resources/SetupFiles/" + inputFile); // Numele fisierului de intrare
    std::ofstream output("Resources/SetupFiles/" + outputFile ); // Numele fisierului de iesire

    if (!input.is_open() || !output.is_open()) {
        std::cerr << "Nu s-a putut deschide fisierul!" << std::endl;
        return 1;
    }

    std::string line;
    int line_count = 0;
    while (std::getline(input, line)) {
        line_count++;
        size_t pos;
        std::string searchStr;

        // Gasim filename
        searchStr = "File name:";
        pos = line.find(searchStr);

        if (pos != std::string::npos) {
            // Mergem la finalul secvenței găsite
            pos += searchStr.length();
            
            // Sărim peste spațiile rămase (dacă există)
            while (pos < line.length() && line[pos] == ' ') {
                ++pos;
            }

            // Extragem următorul cuvânt
            std::string filename;
            while (pos < line.length() && line[pos] != ' ') {
                filename += line[pos];
                ++pos;
            }
            
            output << filename << " ";
        }

        // Gasim numarul de count-uri
        searchStr = "Beam integrator (D3):";
        pos = line.find(searchStr);

        if (pos != std::string::npos) {
            // Mergem la finalul secvenței găsite
            pos += searchStr.length();
            
            // Sărim peste spațiile rămase (dacă există)
            while (pos < line.length() && line[pos] == ' ') {
                ++pos;
            }

            // Extragem următorul cuvânt
            std::string counts;
            while (pos < line.length() && line[pos] != ' ') {
                counts += line[pos];
                ++pos;
            }
            
            output << counts << std::endl;
        }

    }

    // Inchidem fisierele
    input.close();
    output.close();

    std::cout << "Operatiune finalizata cu succes!" << std::endl;

    return 0;
}
