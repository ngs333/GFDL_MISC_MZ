This is a miscellaneous collection of custom code related to GFDL work
by mzuniga which did not quite fit under repos NCTools, FMS, etc.

Build and install general info:
I) This version was tested with Cmake 

II) External Libs required:

First edit the top level CMakeLists.txt. These need to be changes to have
the NetCDF C++ libs:

include_directories(/home/mzuniga/NetCdCPP/include)
link_directories(/home/mzuniga/NetCdCPP/lib)

Libray sources are here:
https://github.com/Unidata/netcdf-cxx4

III) Other sources
Some apps (e.g. test_send_data.x) use source files that are generated
from  template. Currently program gen_from_generic.sh is run manually and
the generated files are manually copied to the proper src directory!!

IV) Compiling
Besides the step above for file generation. Set the FC and CC env varialbles. E.g.
in bash with the Intel toolchain:

export FC=mpiifort
export CC=mpiicc

or similarly for GCC:

export FC=mpifort
export CC=mpicc

you can then build with 
$ cd gfdl_misc/src
$ mkdir build; cd build
$ cmake -G Ninja .. 
$ ninja -v

or, for example, using the default generator with verbose compilation in debug mode:

$ cd gfdl_misc/src
$ mkdir build; cd build
$ cmake .. -DCMAKE_BUILD_TYPE=Debug
$ cmake --build . -v


Note the executables are placed in directory "bin" at the same level as
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
