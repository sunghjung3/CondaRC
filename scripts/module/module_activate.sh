#!/bin/bash

# save current set of loaded modules
#echo $(ml list | grep -v "Currently Loaded Modules" | awk 'NR > 1 { for(i=2; i<=NF; i++) print $i }' | grep -v ')$') > \
#    $CONDA_PREFIX/etc/conda/initial_module_state.txt

line_counter=0
skipped_lines=''
while read line; do
    if [ "${line:0:1}" = "#" ]; then
        continue
    fi
    line_counter=$((line_counter+1))
    passed=0
    action=$(echo $line | cut -d' ' -f1)
    module1=$(echo $line | cut -d' ' -f2)
    module2=$(echo $line | cut -d' ' -f3)  # only for swap
    if [ $action != 'swap' ] && [ -n module2 ]; then
        echo "Warning: 2 modules provided for 'ml $action $module1 $module2'"
    fi
    if [ $action = 'unload' ] || [ $action = 'swap' ]; then
        if (( $(ml list | grep $module1 | wc -l) )); then
            passed=1
        else
            echo "Warning: attempted to unload module '$module1' but not currently loaded"
            echo "Skipping 'ml $action $module1 $module2'..."
            skipped_lines+=" $line_counter"
        fi
    else  # load or something else
        passed=1
    fi
    if (( $passed )); then
        ml $action $module1 $module2
    fi
done < "$CONDA_PREFIX/etc/conda/modules.txt"

export CONDA_ENV_ML_SKIPPED=$skipped_lines
