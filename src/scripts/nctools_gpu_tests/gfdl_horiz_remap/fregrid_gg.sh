# the first arg is the input mosaicl the second arg
# is the output
SI=$1
SO=$2
CI="C"$SI
CO="C"$SO

echo "input mosaic:" $CI"_mosaic.nc"
#To generate a weight file from cube to cube:
start=`date +%s`
fregrid.x --input_mosaic $CI"_mosaic.nc" --output_mosaic $CO"_mosaic.nc" \
 --remap_file "remap_"$SI"-"$SO".nc" --interp_method conserve_order2
end=`date +%s`
runtime=$((end-start))
echo "fregrid "$SI"-"$SO"time: " $runtime

