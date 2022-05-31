#!/bin/bash


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

    # USEFUL message
    echo "!! *** THIS FILE WAS AUTO-GENERATED FROM FILE: ***" >> $target
    echo "!! *** $source ." >> $target

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
#copy the template to this dir
f_in='../fortran_execs/templates/send_data_r.F90'
cp $f_in './input_file.F90'

f_in='input_file.F90'

#1.0 Generate send_data_i_mod.F90 (the one with integer
# types for the arrays) from the template
#usually, we want to replae the module name, the function
#name and a type. In this particular example, both
# the function name and the module name begin the same way,
# so only two patterns will be neeed:
f_out='send_data_i_mod.F90'
in_text=("send_data_r_mod" "send_data_r" "_REAL_")
out_text=("send_data_i_mod" "send_data_i" "INTEGER")

replace_text_list $f_in $f_out in_text out_text
f_in='../fortran_execs/templates/send_data_r.F90'
f_out='send_data_r.F90'

#2.0 Generate send_data_r_mod.F90  (the one with REAL
# types for the arrays) from the template.
#In this case we really only need one pattern changed
#(i.e. _REAL_ => INTEGER), but we will do as
# prior exampe anyway:
f_out='send_data_r_mod.F90'
in_text=("send_data_r_mod" "send_data_r" "_REAL_")
out_text=("send_data_r_mod" "send_data_r" "REAL")

echo "in_tetx  is ${in_text[@]}"
echo "out_textis ${out_text[@]}"

replace_text_list $f_in $f_out in_text out_text
echo "bye from gen_from_generic"
