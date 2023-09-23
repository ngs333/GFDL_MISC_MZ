#Make a regualr lat-lon grid (rll) that covers the globe; and make its mosaic.
#First arguemnt is the nummber of latittudes; second is
# the number of longitudes. The supergrid is 2X larger in each dim.

source  ../TestCommon/fregrid_gpu_test_util.sh


NLAT=$1
NLON=$2
GN=$(get_rll_grid_name $NLAT $NLON)
MN=$(get_rll_mosaic_name $NLAT $NLON)

echo "Calling make_hgrid for "$GN

start=`date +%s`

make_hgrid \
    --grid_type regular_lonlat_grid \
    --nxbnd 2 \
    --nybnd 2 \
    --xbnd 0,360 \
    --ybnd -90,90 \
    --nlon $NLON \
    --nlat $NLAT \
    --grid_name $GN

end=`date +%s`
runtime=$((end-start))
echo "make_hgrid "$GN " time:" $runtime

make_solo_mosaic --num_tiles 1 --dir . \
    --mosaic_name $MN\
    --tile_file $GN".nc" \
    --periodx 360

