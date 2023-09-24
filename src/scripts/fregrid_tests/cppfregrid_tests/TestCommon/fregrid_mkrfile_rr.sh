# Call  fregrid_mkrfile.sh to make the remap file that maps from
# one RLL (regular lat-lon) mosaic to another RLL mosaic.

source  ../TestCommon/fregrid_gpu_test_util.sh

NLAT1=$1
NLON1=$2
NLAT2=$3
NLON2=$4


MS1=$(get_rll_mosaic_name $NLAT1 $NLON1) 
MT2=$(get_rll_mosaic_name $NLAT2 $NLON2)

RFN="remap_R"$NLAT1"x"$NLON1"_x_R"$NLAT2"x"$NLON2".nc"

echo "remap file name:" $RFN
echo "source mosaic: " $MS1
echo "target mosaic: " $MT2
../TestCommon/fregrid_mkrfile.sh $MS1 $MT2 $RFN 1


