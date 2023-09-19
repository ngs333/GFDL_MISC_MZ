contents

NOTES: a) egc below means "equidistant gnomonic cubic".
       b) The ebc name prefixes mentioned below are C48, C172, C768, C3072.
          The name prefix number is the same pattern without the "C".
       c) Regualr lat-lon grid name prefixes follow a pattern like R90x180.
          where the firs number (90) is for the number of latitude lines.
       c) The .sh files are copied into every test directory.

The workflow of these tests are designed to test the calculation and
variations of the weights by fregrid. (The effect of the gpu changing
the makingof the grids are studied in a different effort. )
To that end, one should generate the input mosaics (and their grids)
only once and reuse them as as input files to the various (gpu vs cpu,
release version vs debug, etc) versions of fregrid.
Note that fregrid as commonly used generates on the fly a lat-lon grid
as the target grid, and to circumvent that in these scripts we specify
both the source (input) and target (output) mosaics when fregrid id called.

In the list below, it is the fregrid_mkrfile_* scripts that will be
repeatedly used. These scripts will make the weight or remapping files.
The make_* files are used only once to generate the mosaics and their grids.
Also there are three sets of files, one for the
small test case (helpful in debugging); one for  mid-size cases commonly
used at the GFDL; another that uses various sizes for scaling and
complexity analysis.

For the small case, the scripts are:
fregrid_mkrfile_gg_small.sh  make_ged_small.sh
fregrid_mkrfile_gr_small.sh  make_rll_small.sh

For the common case, the scripts are:
fregrid_mkrfile_gg_common.sh  make_ged_common.sh
fregrid_mkrfile_gr_common.sh  make_rll_common.sh

And for the scaling case, the scripts are:
fregrid_mkrfile_gg_n.sh   make_geds_n.sh 
fregrid_mkrfile_gr_n.sh   make_rlls_n.sh
(WARNING: some of these will take a long time to run)

TODO:
Add scripts to map geds to tri-polars
