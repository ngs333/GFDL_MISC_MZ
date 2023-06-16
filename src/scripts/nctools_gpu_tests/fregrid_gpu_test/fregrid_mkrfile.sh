# Call fregrid to make the remap file (3rd agument) to map from
# the source mosaic (argument 1) to the target mosaic (argument 2)
MSF=$1".nc"
MTF=$2".nc"
RF=$3

echo "fregrid_mkrfile.sh"
echo "source/input mosaic name:" $MSF
echo "target/output mosaic name:" $MTF
echo "remap file name:" $RF

if [ -f "$RF" ] ; then
    echo ""
    echo "*** Deleting existing remap file named "$RF
    echo ""
    rm "$RF"
fi

start=`date +%s`

fregrid --input_mosaic $MSF --output_mosaic $MTF \
	--remap_file $RF --interp_method conserve_order2

end=`date +%s`
runtime=$((end-start))
echo "fregrid "$RF" time: " $runtime

