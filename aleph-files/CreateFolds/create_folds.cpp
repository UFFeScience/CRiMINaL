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
         printf("\nUsage: ./cv fileNamePos fileNameNeg extPos extNeg numFolds\n");
		 return 0;
	}

  const char* fileNamePos = argv[argc-5];
	const char* fileNameNeg = argv[argc-4];
	const char* extPos = argv[argc-3];
	const char* extNeg = argv[argc-2];
	int numFolds = atoi(argv[argc-1]);

	//process positive examples
	Instances posInstances;
	//posInstances.SetFolds(fileNamePos, numFolds, extPos);
	posInstances.SplitAndWrite(fileNamePos, numFolds, extPos);

	//process negative examples
	Instances negInstances;
	//negInstances.SetFolds(fileNameNeg, numFolds, extNeg);
	negInstances.SplitAndWrite(fileNameNeg, numFolds, extNeg);

}
