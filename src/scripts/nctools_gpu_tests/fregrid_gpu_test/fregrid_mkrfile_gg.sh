# Call fregrid to make the remap file that maps from
# one GEC mosaic of input size (the first arg) to a second GEC mosaic
# of given size (the second arg).

source  ./fregrid_gpu_test_util.sh
SGS=$1
TGS=$2

echo "source/input mosaic size:" $SGS
echo "target/output mosaic size:" $TGS

MS=$(get_gec_mosaic_name $SGS)
MT=$(get_gec_mosaic_name $SGS)

RFN="remap_C"$SGS"_C"$TGS".nc"

echo "remap file name:" $RFN

source fregrid_mkrfile.sh $MS $MT $RFN


