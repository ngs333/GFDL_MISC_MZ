/*
  This app makes a regular lat-lon grid (llg) in an FV3 internal model format.
*/

#include <iostream>
#include <netcdf>
using namespace std;
using namespace netCDF;
using namespace netCDF::exceptions;

//  grid_x  grid_y  grid_xt  grid_yt 
// grid_lon  grid_lat  grid_lont  grid_latt

// This is the name of the data file we will create. 
#define FILE_NAME "rll.nc"

// We are writing 2D data, a 6 x 12 lat-lon grid. We will need two
// netCDF dimensions.
static const int NDIMS = 2;
static const int NLATT = 10;
static const int NLONT = 30;
static const int NLAT = NLATT + 1;
static const int NLON = NLONT + 1;


// Names of things. 
string  grid_lon_name = "grid_lon";
string grid_lat_name = "grid_lat";
string  grid_lont_name = "grid_lont";
string grid_latt_name = "grid_latt";
string  UNITS = "units";
string  DEGREES_EAST = "degrees_E";
string  DEGREES_NORTH = "degrees_N";
string LAT_NAME = "grid_y";
string LON_NAME ="grid_x";
string LATT_NAME = "grid_yt";
string LONT_NAME ="grid_xt";


#define START_LAT       50
#define START_LON       0
#define START_LATT      50.5
#define START_LONT      0.5

// Return this to OS if there is a failure.
#define NC_ERR 2

int main(void)
{
  //  grid_lon, grid_lat, grid_lont, grid_latt. They hold actual latitudes 
  //  and longitudes of grid cell center and grid cell vertex
  float grid_lont[NLATT][NLONT];
  float grid_latt[NLATT][NLONT];
  int grid_yt[NLATT];
  int grid_xt[NLONT];
  float grid_lon[NLAT][NLON];
  float grid_lat[NLAT][NLON];
  int grid_y[NLAT];
  int grid_x[NLON];

  // In addition to the latitude and longitude dimensions
  for (int j = 0; j < NLAT; j++){ 
    grid_y[j] = j+1;
  }

  for (int i = 0; i < NLON; i++){
     grid_x[i] = i+1;
  }

  for (int j = 0; j < NLATT; j++){ 
    grid_yt[j] = j+1;
  }

  for (int i = 0; i < NLONT; i++){
     grid_xt[i] = i+1;
  }

  // Create some pretend data. If this wasn't an example program, we
  // would have some real data to write, for example, model
  // output.
  for (int lat = 0; lat < NLAT; lat++) {
    for (int lon = 0; lon < NLON; lon++) {
      grid_lon[lat][lon] = START_LON + 1.0 * lon;
      grid_lat[lat][lon] = START_LAT + 1.0 * lat;
    }
  }
  for (int lat = 0; lat < NLATT; lat++) {
    for (int lon = 0; lon < NLONT; lon++) {
      grid_lont[lat][lon] = START_LONT + 1.0 * lon;
      grid_latt[lat][lon] = START_LATT + 1.0 * lat;
    }
  }

  try {
    // Create the file. 
    NcFile sfc(FILE_NAME, NcFile::replace);

    // Define the dimensions. NetCDF will hand back an ncDim object for
    // each.
    NcDim lonDim = sfc.addDim(LON_NAME, NLON);
    NcDim latDim = sfc.addDim(LAT_NAME, NLAT);

    NcDim lontDim = sfc.addDim(LONT_NAME, NLONT);
    NcDim lattDim = sfc.addDim(LATT_NAME, NLATT);


    // Define coordinate index netCDF variables. 
    //An pointer to a NcVar object is returned for
    // each.
    NcVar lonVar = sfc.addVar(LON_NAME, ncInt, lonDim);
    NcVar latVar = sfc.addVar(LAT_NAME, ncInt, latDim);  // creates variable

    NcVar lontVar = sfc.addVar(LONT_NAME, ncInt, lontDim); 
    NcVar lattVar = sfc.addVar(LATT_NAME, ncInt, lattDim);  // creates variable

    // Write the coordinate index variable data. 
    lonVar.putVar(grid_x);
    latVar.putVar(grid_y);

    lontVar.putVar(grid_xt);
    lattVar.putVar(grid_yt);

    // Define units attributes for coordinate vars. This attaches a
    // text attribute to each of the coordinate variables, containing
    // the units. Note that we are not writing a trailing NULL, just
    // "units", because the reading program may be fortran which does
    // not use null-terminated strings. In general it is up to the
    // reading C program to ensure that it puts null-terminators on
    // strings where necessary.
    lonVar.putAtt(UNITS, DEGREES_EAST);
    latVar.putAtt(UNITS, DEGREES_NORTH);

    lontVar.putAtt(UNITS, DEGREES_EAST);
    lattVar.putAtt(UNITS, DEGREES_NORTH);

    // Define the netCDF data variables.
    vector<NcDim> dims;
    dims.push_back(lonDim);
    dims.push_back(latDim);
    NcVar glonVar  = sfc.addVar(grid_lon_name, ncFloat, dims);
    NcVar glatVar  = sfc.addVar(grid_lat_name, ncFloat, dims);

    vector<NcDim> dimst;
    dimst.push_back(lontDim);
    dimst.push_back(lattDim);
    NcVar glontVar  = sfc.addVar(grid_lont_name, ncFloat, dimst);
    NcVar glattVar  = sfc.addVar(grid_latt_name, ncFloat, dimst);

    // Define units attributes for vars.
    glonVar.putAtt(UNITS, DEGREES_EAST);
    glatVar.putAtt(UNITS, DEGREES_NORTH);

    glontVar.putAtt(UNITS, DEGREES_EAST);
    glattVar.putAtt(UNITS, DEGREES_NORTH);

    glonVar.putVar(grid_lon);
    glatVar.putVar(grid_lat);

    glontVar.putVar(grid_lont);
    glattVar.putVar(grid_latt);

    // The file is automatically closed by the destructor. This frees
    // up any internal netCDF resources associated with the file, and
    // flushes any buffers.

    return 0;
  } catch (NcException& e) {
    e.what();
    return NC_ERR;
  }
}
