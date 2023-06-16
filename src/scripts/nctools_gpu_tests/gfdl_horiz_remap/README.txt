contents

NOTES: a) egc below means "equidistant gnomonic cubic".
       b) The ebc name prefixes mentioned below are C48, C192, C768, C3072.
          The name prefix number is the same pattern without the "C".
       c) Regualr lat-lon grid name prefixes follow a pattern like 144x90.
          where the firs number is for the longitudes.
       c) The .sh files are copied into every test directory.

1.0 set_path.sh - source it to use the executables compiled into the
         NOAA_hack_2020/gfdl_horiz_remap directory tree.

2.0 make_geds.sh - calls make_ged_mosaic.sh to make the C48 - C3072
       egc grids and mosaics.

2.1 make_ged_mosaic.sh - Calls make_hgrid.x and make_solo_mosaic
         to make a edgcc grid and mosaics. Prints timing of called routines.

3.0 make_remap_files.sh - calls make_remap_file.sh to make some files
         for remapping among the C48,C192,C768, and C3072 egc mosaic set.
 
3.1 make_remap_file.sh - Accepts two input args ma and mb for two egc
      mosaic name prefixe numbers and calls make_remap_file.x for
      the two corresponding mosaics. Runtime is printed.

4.0 fregrid_gg_s.sh - Calls fregrid_gg.sh for various pairs of
       egc mosaics on which remapping will occur in the tests.
       
4.1 fregrid_gg.sh - Accepts two input args ma and mb of egc mosaic
       name prefix numbers, and calls fregrid to gerate the weight file for
       the pair. Runtime is printed.

5.0 fregrid_gr_s.sh - Calls fregrid_gr.sh for combinations of a
       egc mosaic with regular lat-lon grids on which remapping
       will occur in the tests.
       
5.1 fregrid_gr.sh -  Accepts three input args ma, so, and sa. ma is for
       and egc mosaic name prefix number, and so and sa
       and is the number of longs and lats regualr lat-lon grid
       of corresponig prefix name.( [NOTE: longs BEFORE lats])
       Then it calls fregrid to generate the weight file for the pair.
       Runtime is printed.


5.0 fregrid_gr_mpi_s.sh - Calls fregrid_gr_mpi.sh for combinations of a
       egc mosaic with regular lat-lon grids on which remapping
       will occur in the tests.
       
5.1 fregrid_gr_mpi.sh -  Accepts four input args ma, so, sa, and np.
       ma is for and egc mosaic name prefix number, and so and sa
       and is the number of longs and lats regualr lat-lon grid
       of corresponig prefix name.( [NOTE: longs BEFORE lats])
       np is the number of processers inpur argument to pass to
       mpirun. Then it calls fregrid with mpirun to generate the
       weight file for the pair. Runtime is printed.




