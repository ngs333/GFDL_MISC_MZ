#!/bin/bash

# PATH to the NCTools executable
#export PATH=/ncrc/home1/Miguel.Zuniga/fre_fv3/install/bin:$PATH
export PATH=/home/mzuniga/fre_fv3/install/bin:$PATH


# Steps to regrid data from FV3 internal grids (the source  or src grids) to one
# lat-lon grid (the destination or dst grid)

#Directory assumptions : directories fv3_igrids, fv3_sgrids, ll_grids exists under current directory.
# fv3_igrids containe the FV3 internal grids.

#myhome="/lustre/f2/dev/Miguel.Zuniga/fv3_regrid"
myhome="/home/mzuniga/fv3_regrid/ctest"


#dir of fv3 internal grids :
fv3_igrids="$myhome/fv3_igrids"
#dir to place fv3 supergrids :
fv3_sgrids="$myhome/fv3_sgrids"
# name prefix of the internal grids is to be used as the name prefix
# of the supergrids and the mosaic file:
src_grid_name="grid_spec"
src_mosaic_name=$src_grid_name"_mosaic"
src_mosaic_fname=$src_mosaic_name".nc"


dst_grid_dir="$myhome/ll_grids"
dst_grid_prefix="reg_ll_grid"
dst_grid_name=$dst_grid_prefix
dst_grid_fname=$dst_grid_name".nc"
dst_mosaic_name=$dst_grid_prefix"_mosaic"
dst_mosaic_fname=$dst_mosaic_name".nc"

## dir of data that is mapped
idat_dir="$myhome/fv3_idat"
odat_dir="$myhome/fv3_odat"
#the file to map
src_file_name="atmos_static" 
dst_fname="atmos_static_mapped"
scalar_fields="HGTsfc"  #their names are ... ?
vector_field="vf1,vf2"  #their names are ... ?
#u_field=
#v_filed=


## I)  make the src grids - the supergrids from the fv3 internal files
# Ia) put together the list of tile files
fv3_grids_tilelist=""
fv3_grids_filelist=""
for file in $fv3_igrids/*.nc; do
    bfile="$(basename "$file")"
    if [[ $bfile == $src_grid_name* ]]; ##process only if name starts wiith given name preifx
    then
       sg_file=${bfile/\.nc/}
       echo "Making supergrid file $fv3_sgrids/$sg_file"
       if [[ $fv3_grids_tilelist == "" ]]
	  then
	      fv3_grids_tilelist=$bfile
	      fv3_grids_filelist=$file
       else
	   fv3_grids_tilelist=$fv3_grids_tilelist","$bfile
	   fv3_grids_filelist=$fv3_grids_filelist","$file

       fi
       
    fi
done

# Ib)  #make the supergrid.
cd $fv3_sgrids
echo "about to call make_hgrid with file list: "
echo $fv3_grids_filelist
echo ""
make_hgrid --grid_type from_file \
	   --my_grid $fv3_grids_filelist \
	   --grid_name $src_grid_name


## II) Make the src mosaic from the supergrids
echo""
echo "make solo mossaic for fv3 grids to use name list :"
echo $fv3_grids_tilelist
echo""

make_solo_mosaic --num_tiles 6 \
		 --dir ./  \
		 --mosaic $src_mosaic_name  \
		 --tile_file $fv3_grids_tilelist
#mv "$src_mosaic_fname" "$fv3_sgrids"
cd ..


## III) make the desired dst lot-lon grid
## See unit test  t/Test06-regrid_extrap.sh
cd $dst_grid_dir
echo "making call to make_hgrid for regular lat-lon grid."

make_hgrid --grid_type regular_lonlat_grid \
	--nxbnd 2 \
	--nybnd 2 \
	--xbnd 0,360 \
	--ybnd -90,90 \
	--nlon 720 \
	--nlat 360 \
	--grid_name $dst_grid_prefix

## IV) make dst solo mosaic for dst lot-lon grid
## See unit test  t/Test06-regrid_extrap.sh

make_solo_mosaic \
	--num_tiles 1 \
	--dir ./ \
	--mosaic_name $dst_mosaic_name \
	--tile_file $dst_grid_fname \
	--periodx 360

# mv "$dst_mosaic_fname "$dst_grid_dir"
cd ..


## V) regrid the data from the input grid to the dst grid
echo ""
echo "About to call fregrid with "
echo "src_mosaic : $fv3_sgrids/$src_mosaic_fname"
echo "dst_mosaic : $dst_grid_dir/$dst_mosaic_fname"
echo ""

fregrid \
    --input_mosaic $fv3_sgrids/$src_mosaic_fname \
    --output_mosaic $dst_grid_dir/$dst_mosaic_fname \
    --input_dir $idat_dir \
    --input_file $src_file_name \
    --output_dir $odat_dir \
    --output_file out.nc \
    --scalar_field $scalar_fields \
    --interp_method conserve_order2 \
    --check_conserve
