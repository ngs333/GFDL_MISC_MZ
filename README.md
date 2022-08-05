This is a miscellaneous collection of custom code related to GFDL work
by mzuniga which did not quite fit under repos NCTools, FMS, etc.

Build and install general info:
I) This version was tested with Cmake - with Ninja and the default generator.

II) External Libs required:

First edit the top level CMakeLists.txt. These need to be changes to have
the NetCDF C++ libs:

include_directories(/home/mzuniga/NetCdCPP/include)
link_directories(/home/mzuniga/NetCdCPP/lib)

Libray sources are here:
https://github.com/Unidata/netcdf-cxx4

III) Other sources
some apps (e.g. test_send_data.x) use source files that are generated
froma template. Currently program gen_from_generic.sh is run manually and
the generated files are manually copied to the proper src directory!!

IV) then you can build with 
$ cd gfdl_misc
$ mkdir build; cd build
$ cmake -G Ninja .. 
$ ninja -v

the executables are placed in directory "bin" at the same level as
the main src direcotry.

VSCode compile:
These extensions are recommended (circa 2021)
a) C/C++ for Visual Studio Code (by Microsoft)
b) C/C++ Extension Pack (Microsoft)
c) C/C++ Themes (By Microsoft)
d) Modern Fortran ( from frotran-lang)
e) Fortran IntelliSense (Chris Hansen)
f) Fortran Breakpoint Support (ekibun)
g) EditorConfig for VS Code (EditorConfig)
