#!/bin/bash

while read line; do
    if [ "${line:0:1}" = "#" ]; then
        continue
    fi
    envvar=$(echo $line | cut -d' ' -f1)
    value=$(echo $line | cut -d' ' -f2)
    option=$(echo $line | cut -d' ' -f3)
    if [ -z ${!envvar} ]; then  # not existing before
        export $envvar=$value
    else  # existing before
        if [ -z $option ] || [ $option = 'p' ]; then  # prepend to envvar
            export $envvar=$value:${!envvar}
        elif  [ $option = 'a']; then  # append to envvar
            export $envvar=:${!envvar}:$value
        else
            echo "Invalid option '$option' for '$envvar $value'!"
        fi

    fi
done < "$CONDA_PREFIX/etc/conda/envvars.txt"
