#!/bin/bash

while read line; do
    if [ "${line:0:1}" = "#" ]; then
        continue
    fi
    envvar=$(echo $line | cut -d' ' -f1)
    value=$(echo $line | cut -d' ' -f2)
    export $envvar=$(echo ${!envvar} | sed -e "s|:${value}:|:|g" -e "s|:${value}\$||g" -e "s|^${value}:||g" -e "s|^${value}\$||g")
done < "$CONDA_PREFIX/etc/conda/envvars.txt"
