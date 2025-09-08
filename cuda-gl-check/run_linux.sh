#!/usr/bin/env bash

CURRENT_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

while true; do
    read -p "Do you want to re-build? (y/n): " yn
    case $yn in
        [Yy]* )
        cd $SCRIPT_DIR; # cd to where script is located

        trash build;
        mkdir build && cd build;
        cmake ..;
        make -j$(nproc --all);

        cd $CURRENT_DIR; # cd to stored original directory 
        break;;
        [Nn]* ) 
        break;;
        * ) echo "Invalid input. Please answer 'y' or 'n'.";;
    esac
done

XDG_SESSION_TYPE=x11 $SCRIPT_DIR/build/bin/cuda-gl-check
