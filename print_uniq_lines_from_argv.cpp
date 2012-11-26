#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <vector>
#include <string>
#include <iostream>
#include <set>
#include <fstream>

using namespace std;

int getdir (string dir, vector<string> &files);

int main(int argc, char *argv[] ) {
   if(argc < 2) {
       cout << "usage: " << argv[0] << " <RR data>" << endl;
       return 1;
   }

   set<string> setStr;

   for (unsigned int i = 1; i < argc; i++) {
       ifstream file;
       file.open(argv[i]);
    
       string next;

       getline(file, next);
       while(next.compare("") != 0) {
            setStr.insert(next);
            getline(file, next);
       }
    
       file.close();
   }



   for (set<string>::const_iterator p = setStr.begin( );p != setStr.end( ); ++p)
      cout << *p << endl;
}

