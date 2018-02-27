/*
 *  splitData.cpp
 *
 *  Created by Aline Marins Paes on August 2006.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <cstdlib>
#include <iostream>

//#include "ISO646.h"
#include "Instances.h"

using namespace std;

int main (int argc, const char * argv[]){

	if(argc < 3){
         printf("\nUsage: splitData fileName numFolds\n");
		 return 0;
	}

    const char* fileName = argv[argc-2];
	int numFolds = atoi(argv[argc-1]);

	//process positive examples
	Instances posInstances;
	posInstances.SplitAndWrite(fileName, numFolds, ".f");

	//process negative examples
	Instances negInstances;
	negInstances.SplitAndWrite(fileName, numFolds, ".n");

}

