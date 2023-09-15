src=$1
dst=$2
dir=$(pwd)
cd $dir/$dst
for f in $dir/$src/*.ncl
do
    filename=$(basename $f .ncl)
    ncgen -o $filename.nc $f
done

