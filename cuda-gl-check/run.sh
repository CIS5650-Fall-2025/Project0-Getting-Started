#!/usr/bin/env bash

while true; do
    read -p "Do you want to proceed? (y/n): " yn
    case $yn in
        [Yy]* ) 
        trash build;
        mkdir build && cd build;
        cmake ..;
        make -j$(nproc --all);
        cd ..;
        break;;
        [Nn]* ) 
        break;;
        * ) echo "Invalid input. Please answer 'y' or 'n'.";;
    esac
done

__NV_PRIME_RENDER_OFFLAND=1 __GLX_VENDOR_LIBRARY_NAME=nvidia ./build/bin/cuda-gl-check


