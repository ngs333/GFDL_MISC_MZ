# diag_manager2
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

III) then you can build with 
$ cd gfdl_misc
$ mkdir build; cd build
$ cmake -G Ninja .. 
$ ninja -v

the executables are place in directory "bin" at the same level as
the main src direcotry.

VSCode compile:
These extensions are recommended (circa 2021)
a) C/C++ for Visual Studio Code (by Microsoft)
b) C/C++ Extension Pack (Microsoft)
c) C/C++ Themes (By Microsoft)
d) Modern Fortran (Miguel Carvajal)
e) Fortran IntelliSense (Chris Hansen)
f) Fortran Breakpoint Support (ekibun)
g) EditorConfig for VS Code (EditorConfig)
