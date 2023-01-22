# The first argument is the common name size of the grid e.g. 48 for a C48
source  ./fregrid_gpu_test_util.sh

S0=$1
SA=$(expr $S0 + $S0)
GN=$(get_gec_grid_name $S0)
MN=$(get_gec_mosaic_name $S0)

echo "Calling make_hgrid for "$GN
start=`date +%s`
make_hgrid --grid_type gnomonic_ed --nlon $SA --grid_name $GN
end=`date +%s`
runtime=$((end-start))
echo "make_hgrid "$GN" time:" $runtime

#Now stitch them together into a solo model mosaic:
start=`date +%s`
make_solo_mosaic --num_tiles 6 --dir ./ --mosaic $MN \
 --tile_file $GN".tile1.nc",$GN".tile2.nc",$GN".tile3.nc",$GN".tile4.nc",$GN".tile5.nc",$GN".tile6.nc"
end=`date +%s`
runtime=$((end-start))
echo "make_solo_mosaic "$MN" time:" $runtime
