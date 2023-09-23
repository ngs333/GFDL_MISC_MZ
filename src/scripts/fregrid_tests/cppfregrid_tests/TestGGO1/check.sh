#!/bin/bash

#cat /dev/null > ../log

fnpre=remap_C768_C192.tile
for i in {1..6}
do
    fname=$fnpre$i".nc"
    echo "checking $fname with nccmp"
    nccmp -df --variable=tile1,tile1_cell,tile2_cell $fname baseline/$fname

    nccmp -df $fname baseline/$fname --Tolerance=1.0e-5 --variable=xgrid_area

done

