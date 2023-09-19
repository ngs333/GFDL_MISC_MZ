# the first arg is the input mosaicl the second arg
# is the output
SI=$1
SO=$2
CI="C"$SI
CO="C"$SO

# To decimate or promote a cube to cube (grids must be integer multiples):
start=`date +%s`
make_remap_file.x --input_mosaic $CI"_mosaic.nc" --output_mosaic $CO"_mosaic.nc" \
 --remap_file "remap_"$SI"-"$SO".nc" --interp_method conserve_order2
end=`date +%s`
runtime=$((end-start))
echo "make_remap_file "$SI"-"$SO"time:" $runtime
