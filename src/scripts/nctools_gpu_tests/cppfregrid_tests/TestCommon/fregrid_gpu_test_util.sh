#List of utilitties; mostly to make files with names following a
#certain convention used in some tests.

get_gec_grid_name(){
    size=$1
    result="C"$1"_grid"
    echo $result
}
get_gec_mosaic_name(){
    size=$1
    result="C"$1"_mosaic"
    echo $result
}
get_rll_grid_name(){
    slat=$1
    slon=$2
    result="R"$slat"x"$slon"_grid"
    echo $result
}
get_rll_mosaic_name(){
    slat=$1
    slon=$2
    result="R"$slat"x"$slon"_mosaic"
    echo $result
}
get_tripolar_grid_name(){
    result="TP_"$1"_grid"
    echo $result
}
get_tripolar_mosaic_name(){
    result="TP_"$1"_mosaic"
    echo $result
}


#make similar functions for tridiagonals
