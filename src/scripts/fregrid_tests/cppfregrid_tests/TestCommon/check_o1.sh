#The conservative interpolation method
if [ "x$1" == "xexact" ]
then
    for f in remap*nc; do
	echo "Checking xc file $f"
	nccmp -df  $f baseline/$f
    done
else
    for f in remap*nc; do
	echo "Checking file $f"
	nccmp -df --variable=tile1,tile1_cell,tile2_cell $f baseline/$f
	
	nccmp -df $f baseline/$f --Tolerance=1.0e-4 --variable=xgrid_area
    done
fi
