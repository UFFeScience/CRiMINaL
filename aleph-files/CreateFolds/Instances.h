//
// Created by Aline Marins Paes on August 2006
//

#include <string>
#include <vector>
//#include "ISO646.h"
using namespace std;

class Instances
{
    public:
        // Construtor
        Instances(void);

        //IO manipulation
        void ReadData(const char* fileName);
		    void WriteData(const char* fileName);

        //Split Data
        Instances GetTrainSet(int numFolds, int numFold);
		    Instances GetTestSet(int numFolds, int numFold);
		    void SplitAndWrite(const char* fileName, int numFolds, const char* target);
	 	    void SetFolds(const char* fileName, int numFolds, const char* target);

		    //add instance
		    void Add(string instance);

		    //shuffle instances
		    void Shuffle(void);

        //destructor
	      virtual ~Instances();

    protected:
        vector<string> data;
        int numInstances;

};
