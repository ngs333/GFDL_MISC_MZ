for f in remap*nc; do
    echo "Checking file $f"
    nccmp -df --variable=tile1,tile1_cell,tile2_cell $f baseline/$f
    
    nccmp -df $f baseline/$f -Tolerance=1.0e-14 --variable=xgrid_area
done

