#For a C48, first create the six tiles of the cube sphere:
start=`date +%s`
make_hgrid.x --grid_type gnomonic_ed --nlon 96 --grid_name C48_grid
end=`date +%s`
runtime=$((end-start))
echo 'make_hgrid C48 time:' $runtime

#Now stitch them together into a solo model mosaic:
start=`date +%s`
make_solo_mosaic.x --num_tiles 6 --dir ./ --mosaic C48_mosaic \
 --tile_file C48_grid.tile1.nc,C48_grid.tile2.nc,C48_grid.tile3.nc,C48_grid.tile4.nc,C48_grid.tile5.nc,C48_grid.tile6.nc
end=`date +%s`
echo 'make_solo_mosaic C48 time:' $runtime

start=`date +%s`
make_hgrid.x --grid_type gnomonic_ed --nlon 512 --grid_name C256_grid
end=`date +%s`
echo 'make_hgrid C256 time:' $runtime

#Now stitch them together into a solo model mosaic:
start=`date +%s`
make_solo_mosaic.x --num_tiles 6 --dir ./ --mosaic C256_mosaic \
 --tile_file C256_grid.tile1.nc,C256_grid.tile2.nc,C256_grid.tile3.nc,C256_grid.tile4.nc,C256_grid.tile5.nc,C256_grid.tile6.nc
end=`date +%s`
echo 'make_hgrid C256 time:' $runtime

# To decimate or promote a cube to cube (grids must be integer multiples):
start=`date +%s`
make_remap_file.x --input_mosaic C256_mosaic.nc --output_mosaic C48_mosaic.nc \
 --remap_file remap_256-48.nc --interp_method conserve_order2
end=`date +%s`
echo 'make_remap_file C256-48 time:' $runtime

#To generate a weight file from cube to cube:
start=`date +%s`
fregrid.x --input_mosaic C256_mosaic.nc --output_mosaic C48_mosaic.nc \
 --remap_file remap_c256-c48.nc --interp_method conserve_order2
end=`date +%s`
echo 'fregrid C256-48 time:' $runtime

#To generate a weight file from cube to lat-lon:
start=`date +%s`
fregrid.x --input_mosaic C256_mosaic.nc --nlon 144 --nlat 90 \
 --remap_file remap_c256-144x90.nc --interp_method conserve_order2
end=`date +%s`
echo 'fregrid C256-144x90 time:' $runtime
#

