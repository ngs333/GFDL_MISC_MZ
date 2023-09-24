# Call fregrid to make the remap file (3rd agument) to map from
# the source mosaic (argument 1) to the target mosaic (argument 2)
MSF=$1".nc"
MTF=$2".nc"
RF=$3

if [[ $# -ne 4 ]]; then
    echo "Illegal number of parameters" >&2
    exit 2
fi

#The conservative interpolation method
if [ "x$4" == "x2" ]
then
    CIM="conserve_order2"
elif [ "x$4" == "x1" ]
then
    CIM="conserve_order1"
else
    echo "interpolation order (4th argument) must be 1 or 2"
    exit 2
fi


echo "fregrid_mkrfile.sh"
echo "source/input mosaic name:" $MSF
echo "target/output mosaic name:" $MTF
echo "the conservative interpolation method:" $CIM
echo "remap file name:" $RF

if [ -f "$RF" ] ; then
    echo ""
    echo "*** Deleting existing remap file named "$RF
    echo ""
    rm "$RF"
fi

start=`date +%s%N | cut -b1-13`

fregrid.x --input_mosaic $MSF --output_mosaic $MTF \
	--remap_file $RF --interp_method $CIM

end=`date +%s%N | cut -b1-13`
dtime=$((end-start))
runtime=$(bc <<< "scale=2; $dtime / 1000")
echo "fregrid "$RF" time: " $runtime

