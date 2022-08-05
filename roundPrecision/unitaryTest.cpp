//============================================================================
// Name        : executeCommandInTerminal.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
using namespace std;

int main() {
	cout << "!!!Hello World!!!" << endl; // prints !!!Hello World!!!
	system("pwd");
	system("pdal translate ~/Documents/boxesDatabaseSample/corrida6/\"Depth Long Throw\"/132697189182154571.ply frame552.ply --writers.ply.dims=\"X=float32,Y=float32,Z=float32\" ");
	system("ls");
	return 0;
}

/*expected output_iterator
!!!Hello World!!!
/home/gacamacho/eclipse-workspace/myThirdProject/executeCommandInTerminal
Debug  frame552.ply  src
*/