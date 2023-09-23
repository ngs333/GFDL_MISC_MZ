# Call fregrid to make the remap file that maps from
# one GEC mosaic of input size (the first arg) to a second GEC mosaic
# of given size (the second arg).

source  ../TestCommon/fregrid_gpu_test_util.sh

SGS=$1
TGS=$2

MS=$(get_gec_mosaic_name $SGS)
MT=$(get_gec_mosaic_name $TGS)

RFN="remap_C"$SGS"_C"$TGS".nc"

echo "source/input mosaic size:" $SGS
echo "target/output mosaic size:" $TGS
echo "remap file name:" $RFN

../TestCommon/fregrid_mkrfile.sh $MS $MT $RFN 1


