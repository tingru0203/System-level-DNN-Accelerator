#!/bin/bash

# file path: esp/socs/xilinx-vcu128-xcvu37p/

read -p "Remove? (y/n): " yn
if [ "${yn}" == "y" ]; then
    rm -rf socgen/ modelsim/
	make grlib-xconfig
    make lenet_rtl-hls
    make esp-xconfig
    make lenet_rtl-baremetal
    export TEST_PROGRAM=./soft-build/ariane/baremetal/lenet_rtl.exe
    make sim-gui
else
    read -p "Update hardware? (y/n): " yn
    if [ "${yn}" == "y" ]; then
        make lenet_rtl-hls
    fi

    read -p "Update software? (y/n): " yn
    if [ "${yn}" == "y" ]; then
        make lenet_rtl-baremetal
    fi
    make sim-gui
fi



