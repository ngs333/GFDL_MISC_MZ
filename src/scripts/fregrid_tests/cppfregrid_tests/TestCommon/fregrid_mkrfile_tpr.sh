# Call  fregrid_mkrfile.sh to make the remap file that maps from
# one tripolar mosaic to a regualr lat-lon grid
# with nlat (the second arg) and nlon (3rd arg) sizes.

source  ../TestCommon/fregrid_gpu_test_util.sh

#TPN is the name prefix for the tripolar grid, eg "ocean" of tp_ocean_grid.nc
TPN=$1
NLAT=$2
NLON=$3

MS=$(get_tripolar_mosaic_name $TPN)
MT=$(get_rll_mosaic_name $NLAT $NLON)

RFN="remap_TP_"$TPN"_x_R"$NLAT"x"$NLON".nc"

echo "source mosaic :"$MS
echo "target mosaic :"$MT
echo "remap file name:" $RFN

start=`date +%s`

#note the interpolation scheme is to be 1st order conservative.
../TestCommon/fregrid_mkrfile.sh $MS $MT $RFN 1

end=`date +%s`
runtime=$((end-start))
echo "fregrid "$RF" time: " $runtime


