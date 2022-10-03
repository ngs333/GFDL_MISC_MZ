# the first arg is the input mosaicl the second arg
# is the output
SG=$1
SO=$2
SA=$3
CG="C"$SG"_mosaic.nc"
CGps="c"$SG
RN="remap_"$CGps"-"$SO"x"$SA".nc"

echo "input mosaic name:" $CG
echo "remap file name:" $RN
#To generate a weight file from cube to cube:
start=`date +%s`
fregrid.x --input_mosaic $CG --nlon $SO --nlat $SA \
 --remap_file $RN --interp_method conserve_order2
end=`date +%s`
runtime=$((end-start))
echo "fregrid "$RN" time: " $runtime

