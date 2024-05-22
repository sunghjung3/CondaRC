#!/bin/bash

line_counter=0
while read line; do
    if [ "${line:0:1}" = "#" ]; then
        continue
    fi
    line_counter+=$((line_counter+1))
    if [[ " $CONDA_ENV_ML_SKIPPED " =~ "$line_counter" ]]; then
        continue
    fi
    passed=0
    action=$(echo $line | cut -d' ' -f1)
    module1=$(echo $line | cut -d' ' -f2)
    module2=$(echo $line | cut -d' ' -f3)  # only for swap

    # reverse for deactivation
    if [ $action = 'load' ]; then
        action=unload
    elif [ $action = 'unload' ]; then
        action=load
    elif [ $action = 'swap' ]; then
        tmp=$module1
        module1=$module2
        module2=$tmp
    fi

    if [ $action != 'swap' ] && [ -n module2 ]; then
        echo "Warning: 2 modules provided for 'ml $action $module1 $module2'"
    fi
    if [ $action = 'unload' ] || [ $action = 'swap' ]; then
        if (( $(ml list | grep $module1 | wc -l) )); then
            passed=1
        else
            echo "Warning: attempted to unload module '$module' but not currently loaded"
            echo "Skipping 'ml $action $module1 $module2'..."
        fi
    else  # load or something else
        passed=1
    fi
    if (( $passed )); then
        ml $action $module1 $module2
    fi
done < "$CONDA_PREFIX/etc/conda/modules.txt"

unset CONDA_ENV_ML_SKIPPED
