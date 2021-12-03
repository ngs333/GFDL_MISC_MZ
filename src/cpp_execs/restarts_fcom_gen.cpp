
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

/*
 This app generates files that are domain decomposed restart files for testing mppnccombine.
 The generated files are ncl text files, and they should be processed with ncgen before used as
 input to mppnccombine.
 */

// The decomposition is into NDX x NDY domains.
static const int NDX = 1;  // 4
static const int NDY = 4;  // 4
// NLAT, NLO below are per file;; i.e. total latituses are NLAT * DNY, etc
static const int NLAT = 24;  // 1350
static const int NLON = 96;  // 1800


void printVariables(ofstream& f, string& fnPre, int fileNum, int nlon, int ndx,  int nlat, int ndy, int is, int ie, int js, int je ){
  string tw = "  ";
  string fw = "    ";
  string ew = "        ";
  string fileName = fnPre + ".nc."  + std::to_string(fileNum);
  const  int nfiles = ndx * ndy;

  f << "netcdf \\" << fnPre << ".nc {" << endl;

  f << "dimensions:" << endl;
  f << fw << "grid_xt = " << nlon << " ;" << endl;
  f << fw << "grid_yt = " << nlat << " ;" << endl;
  ;
  f << fw << "time = UNLIMITED ; // (1 currently) ;" << endl;
  f << "variables:" << endl;
  f << fw << "double grid_xt(grid_xt) ;" << endl;
  f << ew << "grid_xt:long_name = \"T-cell longitude\" ;" << endl;
  f << ew << "grid_xt:units = \"degrees_E\" ;"<< endl;
  f << ew << "grid_xt:axis = \"X\" ;" << endl;
  f << ew << "grid_xt:domain_decomposition = 1, " << nlon * ndx << ", " << is << ", " << ie << " ;" << endl;
  f << fw << "double grid_yt(grid_yt) ;" << endl;
  f << ew << "grid_yt:long_name = \"T-cell latitude\" ;" << endl;
  f << ew << "grid_yt:units = \"degrees_N\" ;" << endl;
  f << ew << "grid_yt:axis = \"Y\" ;" << endl;
  f << ew << "grid_yt:domain_decomposition = 1, " << nlat * ndy  << ", " << js << ", " << je << " ;" << endl;
  f << fw << "double time(time) ;" << endl;
  f << ew << "time:long_name = \"time\" ;" << endl;
  f << ew << "time:units = \"days since 0001-01-01 00:00:00\" ;" << endl;
  f << ew << "time:axis = \"T\" ;" << endl;
  f << ew << "time:calendar_type = \"NOLEAP\" ;" << endl;
  f << ew << "time:calendar = \"noleap\" ;" << endl;
  f << fw << "float orog(grid_yt, grid_xt)  ;" << endl;
  f << ew << "orog:long_name = \"Surface Altitude\" ;" << endl;
  f << ew << "orog:units = \"m\" ;" << endl;
  f << ew << "orog:missing_value = 1.e+20f  ;" << endl;
  f << ew << "orog:_FillValue = 1.e+20f  ;" << endl;
  f << ew << "orog:cell_methods = \"time: point\" ;" << endl;
  f << ew << "orog:cell_measures = \"area: area\" ;" << endl;
  f << ew << "orog:standard_name = \"surface_altitude\" ;" << endl;
  f << ew << "orog:interp_method = \"conserve_order1\" ;" << endl;

  f << endl << "// global attributes:" << endl;
  f << ew << ":filename = \"" << fileName << "\" ;" << endl;
  f << ew << ":NumFilesInSet = " << nfiles << " ;" << endl;
  f << ew << ":title = \"ESM4_piControl_D\" ;" << endl;
  f << ew << ":associated_files = \"area: 00010101.grid_spec.nc\" ;" << endl;
  f << ew << ":grid_type = \"regular\" ;" << endl;
  f << ew << ":grid_tile = \"N/A\" ;" << endl;
}

int main(void) {
  string fnamePre = "data";
  // loops over files
  int fnum_ctr = -1;
  for (int fj = 0; fj < NDY; fj++) {
    for (int fi = 0; fi < NDX; fi++) {
      int fnum = fi * NDX + fj;

      string fnumStr = std::to_string(fnum);
      string fnamePos = "00";
      if (fnum < 10) {
        fnamePos += "0" + fnumStr;
      } else {
        fnamePos += fnumStr;
      }

      string fname = fnamePre + ".ncl." + fnamePos;
      string fnameNC = fnamePre + ".nc." + fnamePos;
      ofstream file(fname, ios::app);
      file << fixed;
      
      int is = fi * NLON + 1;
      int js = fj * NLAT + 1;
      int ie = is + NLON - 1;
      int je = js + NLAT - 1;
      printVariables(file, fnamePre, fnum , NLON , NDX,  NLAT , NDY, 
      is , ie, js, je);

      file << "data:" << endl << endl;

      file << "grid_xt =" << std::endl;
      for (size_t i = is; i <= ie; i++) {
        if (i == ie) {
          file << i << " ;" << endl << endl;
        } else {
          file << i << ", ";
          if (i % 20 == 0) file << endl;
        }
      }

      file << "grid_yt =" << std::endl;
      for (size_t j = js ; j <= je; j++) {
        if (j == je) {
          file << j << " ;" << endl << endl;
        } else {
          file << j << ", ";
          if (j % 20 == 0) file << endl;
        }
      }

      file << "time = 0 ;" << endl << endl;

      file << "orog = ";

      for (size_t j = 1; j <= NLAT; j++) {
        file << endl;
        int colCounter = 0;
        for (size_t i = 1; i <= NLON; i++) {
          auto ij = (j - 1) * NLON + i;
          auto num = fnum + 0.000001 * ij;
          if (ij == 0) {
            file << num << ", ";
            colCounter++;
          } else if (ij == NLAT * NLON) {
            file << num << " ;" << endl << endl;
          } else {
            file << num << ", ";
            colCounter++;
            if (colCounter % 10 == 0) {
              file << endl;
            }
          }
        }
      }

      file << "}" << endl;
      file.close();
    }
  }
  return 0;
}
