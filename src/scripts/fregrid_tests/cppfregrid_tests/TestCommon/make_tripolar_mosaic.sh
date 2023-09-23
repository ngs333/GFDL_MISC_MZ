#Make a tripolar grid; currently the only argument is
# name prefix, eg. ocen in tp_ocean_grid.nc

source  ../TestCommon/fregrid_gpu_test_util.sh

NP=$1

GN=$(get_tripolar_grid_name $NP)
MN=$(get_tripolar_mosaic_name $NP)


echo "make_tripolar_mosaic.sh"
echo "tripolar grid name will be:" $GN
echo "tripolar mosaic name will be:" $MN



make_hgrid \
    --grid_type tripolar_grid \
    --nxbnd 2 \
    --nybnd 7 \
    --xbnd -280,80 \
    --ybnd -82,-30,-10,0,10,30,90 \
    --dlon 1.0,1.0 \
    --dlat 1.0,1.0,0.6666667,0.3333333,0.6666667,1.0,1.0 \
    --grid_name $GN\
    --center c_cell

make_solo_mosaic \
    --num_tiles 1 \
    --dir . \
    --mosaic_name $MN \
    --tile_file $GN".nc" \
    --periodx 360
