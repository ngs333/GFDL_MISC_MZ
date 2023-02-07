# Call  fregrid_mkrfile.sh to make the remap file that maps from
# one tripolar mosaic to a regualr lat-lon grid
# with nlat (the second arg) and nlon (3rd arg) sizes.

source  ./fregrid_gpu_test_util.sh

#TPN is the name prefix for the tripolar grid, eg "ocean" of tp_ocean_grid.nc
TPN=$1
NLAT=$2
NLON=$3
TGS=$2"x"$3

echo "source/input tripolar grid name prefix :" $TPN
echo "target/output mosaic size:" $TGS

MS=$(get_tripolar_mosaic_name $TPN)
MT=$(get_rll_mosaic_name $NLAT $NLON)

RFN="remap_TP"$TPN"_R"$TGS".nc"

echo "remap file name:" $RFN

source fregrid_mkrfile.sh $MS $MT $RFN


