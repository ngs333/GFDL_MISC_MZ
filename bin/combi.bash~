#!/usr/bin/bash


for f in ./*.ncl.*
do
    echo $f
    filename=$(echo "$f" | sed -e 's/\.ncl./.nc./')
    ncgen -o $filename $f
done
