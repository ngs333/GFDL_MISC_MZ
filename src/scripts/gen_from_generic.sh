#!/bin/bash

# This function "replace_text_in_section" is deprecated
function replace_text_in_section {
    source=$1
    target=$2
    etext=$3
    otext=$4
    generic_section=false

    ## The read should not trim leading whitespace,
    ##  interpret backshash seqs, or skip last line if 
    ## missing a terminating fed.
    while IFS="" read -r line || [ -n "$line" ]
    ## while read -r line
    do
        if [[ "${line}" =~ .*"!!GENERIC_START".* ]]; then
            generic_section=true
        elif [[ "${line}" =~ .*"!!GENERIC_END".* ]]; then
            generic_section=false
        fi
        
        if [[ $generic_section == true ]]; then
            if [[ "${line}" =~ .*"$etext".* ]]; then
                line=${line/"$etext"/$otext}
            fi
        fi
        echo "$line" >> $target
    done < "$source"
}

# Function replace_text_list makes a copy of the contents of
# file source, replaces all occurences of the test in ARRAY
# itext with the corresponding ones in ARRAY otext, and writes
# the result into file target.
function replace_text_list {
    source=$1
    target=$2
    #Arrays are passed in be reference. Requires bash 4.3 or later
    local -n itext=$3
    local -n otext=$4
    generic_section=false

    #remove the existing target file
    rm -f $target

    ## The read should not trim leading whitespace,
    ##  interpret backshash seqs, or skip last line if 
    ## missing a terminating fed.
    while IFS="" read -r line || [ -n "$line" ]
    do
        for i in ${!itext[@]}; do
            it=${itext[$i]}
            ot=${otext[$i]}
            if [[ "${line}" =~ .*"$it".* ]]; then
                line=${line/"$it"/"$ot"}
            fi
        done
        echo "$line" >> $target
    done < "$source"
}

#This below is just an example usage
f_in='/home/mzuniga/gfdl_misc/src/scripts/sample.in'
f_out='sample.F90'

in_text=("send_dat_r" "_REAL_")
out_text=("send_data_i" "INTEGER")

echo "in_tetx  is ${in_text[@]}"
echo "out_textis ${out_text[@]}"

replace_text_list $f_in $f_out in_text out_text
echo "bye from gen_from_generic"
