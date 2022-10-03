#For a C48, first create the six tiles of the cube sphere:
S0=$1
CA="C"$S0
SA=$(expr $S0 + $S0)

echo "Calling make_hgrid for "$CA"_grid"
start=`date +%s`
make_hgrid.x --grid_type gnomonic_ed --nlon $SA --grid_name $CA"_grid"
end=`date +%s`
runtime=$((end-start))
echo "make_hgrid "$CA" time:" $runtime

#Now stitch them together into a solo model mosaic:
start=`date +%s`
make_solo_mosaic.x --num_tiles 6 --dir ./ --mosaic $CA"_mosaic" \
 --tile_file $CA"_grid.tile1.nc",$CA"_grid.tile2.nc",$CA"_grid.tile3.nc",$CA"_grid.tile4.nc",$CA"_grid.tile5.nc",$CA"_grid.tile6.nc"
end=`date +%s`
runtime=$((end-start))
echo "make_solo_mosaic "$CA"_ time:" $runtime
