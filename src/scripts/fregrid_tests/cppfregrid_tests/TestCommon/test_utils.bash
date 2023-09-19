
generate_all_from_ncl(){
    src = $1
    dst = $2
    dir =$(pwd)
  cd $dir/$dst
  for f in $dir/$src/*.ncl
  do
    filename=$(basename $f .ncl)
    ncgen -o $filename.nc $f
  done
}

# run the command (the argument list; 1st in list is the command) using the bats "run command"
#  its status function, and theck the status is 0
function run_and_check()
{
    local cmd="$*" #Expands the list into a single string; spearating parms with space.
    run command $cmd
    if [ $status -ne 0 ];
    then
	    echo failed:  $cmd
	    echo $output && exit 1
    fi
}

# make a csv (comma separated value) list of
# all the file names in dir argument 1 (i.e. dir arg) that
# have the pattern of argument 2 (i.e. pattern arg)
function get_csv_filename_list()
{
    local dir=$1
    local pattern=$2
    local filelist=""
    for file in $dir"/"$pattern; do
	if [[ $filelist == "" ]]
	then
	    filelist="$file" #if this is the first file
	else
	    filelist=$filelist",""$file"
	fi
    done
    echo $filelist  #I.e. this return must be capture by a $(...)
}
