nccmp -df --variable=tile1,tile1_cell,tile2_cell remap_R90x180_x_R180x360.nc baseline/remap_R90x180_x_R180x360.nc

nccmp -df remap_R90x180_x_R180x360.nc baseline/remap_R90x180_x_R180x360.nc --Tolerance=1.0e-14 --variable=xgrid_area
