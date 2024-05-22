# CondaRC


## Motivation

We often work on several different projects on the same server/account.
Each project often have different sets of dependencies, like compilers and Python packages, which may conflict with one another.
Conda helps with this by isolating different project environments and their dependencies from other projects,
and it does so in a convenient way using a single command `conda [de]activate`.
This load and unloads different packages and tools that were installed using Conda for a specific environment.

However, Conda does not control external dependencies, like loading a specific set of modules or prepending a path to the environmental variable `PATH`.
For instance, you may always want the `intel` compiler module loaded with Conda environment `A` but `gcc` loaded with environment `B`.
Or, you may have a cloned Git repo that you want to include in your `PYTHONPATH` environmental variable only when working with 1 project but not others.

This repo contains files and scripts that automates this process by incorporating into `conda [de]activate`.
It's like `.bashrc` (or `.bash_profile`) but for Conda, hence the name "CondaRC".

## Description

The `scripts` directory has subdirectories for each feature:

  * `envvar`: setting/unsetting environmental variables
  * `module`: loading/unloading lmod modules (common in HPC)

Each subdirectory contains 3 files:

  * `<feature>s.txt`: where the customization is defined (user should modify)
      * e.g. what modules to load, what values to append to which environmental variable
  * `<feature>_activate.sh`: script that is called by `conda activate <env>` (do not modify)
  * `<feature>_deactivate.sh`: script that is called by `conda deactivate` (do not modify)
      * Un-does the activation script

The user needs to customize only the `.txt` file. The shell scripts are automatically called when the conda
environment is activate/deactivated like normal.

## Setup

*Repeat these steps for all Conda environments where you want this capability.*

The Conda environment's root directory is `$CONDA_PREFIX` (typically `$HOME/mini[conda3/forge3]/envs/[env_name]`).

Go to `$CONDA_PREFIX/etc/conda` (can be manually created if it does not exist already).
Place the `.txt` file here.

Go to `$CONDA_PREFIX/etc/conda/activate.d` (can be manually created if it does not exist already).
Place the `_activate.sh` script here, and add the executable permission for the user:

    chmod u+x _activate.sh

Go to `$CONDA_PREFIX/etc/conda/deactivate.d` (can be manually created if it does not exist already).
Place the `_deactivate.sh` script here, and add the executable permission for the user:

    chmod u+x _deactivate.sh

Finally, log out and back in to start using CondaRC!

## Notes

* The use of environmental variables **within** the `.txt` files (like `$HOME`) may not be supported yet.
