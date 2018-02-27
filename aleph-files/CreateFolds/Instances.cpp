// Created by Aline Marins Paes on August 2006
// Methods to split data in folds to training and testing are based on weka.core.Instances.java
//

#include <fstream>
#include <iostream>
#include <iomanip>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <string.h>
#include <vector>
//#include "ISO646.h"

#include "Instances.h"
using namespace std;

// Constructor
//
Instances::Instances(void){
    numInstances = 0;
}

//
//-------------------------------------------------------------------------------------
// Destructor
//
Instances::~Instances(void){
}

//
//-------------------------------------------------------------------------------------
//read data from a file
//
void
Instances::ReadData(const char* fileName){

	string instance;

	data.clear();
	numInstances = 0;
	ifstream inFile(fileName);    // Create an input file stream
	if (! inFile) {
		cerr << "Error: Can't open the input file\n";
		exit(1);
	}

	//read data
	while (getline(inFile, instance, '\n')){
        	data.push_back(instance);
		numInstances++;
	}
	inFile.close();


}

//
//-------------------------------------------------------------------------------------
//write data to a file
//
void
Instances::WriteData(const char* fileName){

	ofstream outFile;
	outFile.open(fileName, ofstream::out | ofstream::trunc);
    //outFile.open(fileName, ofstream::out | ofstream::trunc); //create an output file stream
    if (! outFile) {
		cerr << "Error: Can't open the input file\n";
		exit(1);
	}

    //write data
	for(int i = 0; i < numInstances; i++){
		outFile << data[i];
		outFile << '\n';
    }

	outFile.close();
}

//
//-------------------------------------------------------------------------------------
// Return kth training fold for k-fold cross validation training
//
Instances
Instances::GetTrainSet(int numFolds, int numFold){

	Instances kthFoldTrain;

	int numInstforFold = numInstances / numFolds;
	int offset = 0;

	if (numFold < (numInstances % numFolds)) {
		numInstforFold++;
		offset = numFold;
	}
	else
		offset = numInstances % numFolds;

	int first = numFold * (numInstances / numFolds) + offset;

	for (int i = 0; i < first; i++)
		kthFoldTrain.Add(data[i]);

	for (int i = first+numInstforFold; i < numInstances; i++)
		kthFoldTrain.Add(data[i]);

	return kthFoldTrain;
}

//
//-------------------------------------------------------------------------------------
// Return kth test fold for k-fold cross validation training
//
Instances
Instances::GetTestSet(int numFolds, int numFold){

	Instances kthFoldTest;

	int numInstforFold = numInstances / numFolds;
	int offset = 0;

	if (numFold < (numInstances % numFolds)) {
		numInstforFold++;
		offset = numFold;
	}
	else
		offset = numInstances % numFolds;

	int first = numFold * (numInstances / numFolds) + offset;

	for (int i = first; i < first+numInstforFold; i++)
		kthFoldTest.Add(data[i]);

	return kthFoldTest;
}

//
//-------------------------------------------------------------------------------------
// Add one instance to a set
void
Instances::Add(string instance){
    data.push_back(instance);
    numInstances++;
}

//
//-----------------------------------------------------------------------------------
//
void
Instances::SplitAndWrite(const char* inFileName, int numFolds, const char* target){

	char buffer[3];

	//process positive examples
    	int sizeNameFile = strlen(inFileName);
    	char fileName[sizeNameFile+2];
    	::strcpy(fileName, inFileName);
      ::strcat(fileName, ".");
    	::strcat(fileName, target);
    	ReadData(fileName);
	Shuffle();

	for (int k = 1; k < numFolds+1; k++){
		//get kth training fold set
		Instances trgset = GetTrainSet(numFolds, k);

		//write to a file kth training fold set
		char kthTrainFileName[50];
		::strcpy(kthTrainFileName, inFileName);
		::strcat(kthTrainFileName, "-train");
		sprintf(buffer, "%d", k);
		::strcat(kthTrainFileName, buffer);
    ::strcat(kthTrainFileName, ".");
		::strcat(kthTrainFileName, target);
		trgset.WriteData(kthTrainFileName);

		//do the same for test set
		//get kth test fold set
		Instances tstset = GetTestSet(numFolds, k);

		//write to a file kth test fold set
		char kthTestFileName[50];
		::strcpy(kthTestFileName, inFileName);
		::strcat(kthTestFileName, "-test");
		sprintf(buffer, "%d", k);
		::strcat(kthTestFileName, buffer);
    ::strcat(kthTestFileName, ".");
		::strcat(kthTestFileName, target);
		tstset.WriteData(kthTestFileName);
	}
}

//
//-----------------------------------------------------------------------------------
//
void
Instances::SetFolds(const char* inFileName, int numFolds, const char* target){

	char buffer[2];

	//process examples
    	int sizeNameFile = strlen(inFileName);
    	char fileName[sizeNameFile+2];
    	::strcpy(fileName, inFileName);
      ::strcat(fileName, ".");
    	::strcat(fileName, target);
      //printf("%s\n", fileName);
    	ReadData(fileName);
	Shuffle();

	for (int k = 1; k < numFolds+1; k++){
		//get kth test fold set
		Instances tstset = GetTestSet(numFolds, k);

		//write to a file kth test fold set
		char kthTestFileName[50];
		::strcpy(kthTestFileName, inFileName);
		::strcat(kthTestFileName, "-test");
		sprintf(buffer, "%d", k+1);
		::strcat(kthTestFileName, buffer);
    ::strcat(kthTestFileName, ".");
		::strcat(kthTestFileName, target);
		tstset.WriteData(kthTestFileName);
	}
}


//
//-------------------------------------------------------------------------------------------
//
// Shuffle the instances in the dataset.
//
void
Instances::Shuffle(void){
    for(int from = 0; from < numInstances; from++){
        int to = rand() % numInstances;

        data[to].swap(data[from]);
    }

}

//
