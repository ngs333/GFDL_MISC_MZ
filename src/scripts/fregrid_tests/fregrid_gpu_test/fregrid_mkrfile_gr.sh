# Call  fregrid_mkrfile.sh to make the remap file that maps from
# one GEC mosaic of input size (the first arg) to a regualr lat-lon grid
# with nlat (the second arg) and nlon (3rd arg) sizes.

source  ./fregrid_gpu_test_util.sh

SGS=$1
NLAT=$2
NLON=$3
TGS=$2"x"$3

echo "source/input mosaic size:" $SGS
echo "target/output mosaic size:" $TGS

MS=$(get_gec_mosaic_name $SGS)
MT=$(get_rll_mosaic_name $NLAT $NLON)

RFN="remap_C"$SGS"_R"$TGS".nc"

echo "remap file name:" $RFN

source fregrid_mkrfile.sh $MS $MT $RFN


