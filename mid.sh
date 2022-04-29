#!/bin/bash

# file path: esp/socs/xilinx-vcu128-xcvu37p/

read -p "GUI? (y/n): " gui
read -p "Remove? (y/n): " yn
if [ "${yn}" == "y" ]; then
    rm -rf socgen/ modelsim/
	make grlib-xconfig
    make lenet_rtl-hls
    make esp-xconfig
    make lenet_rtl-baremetal
    export TEST_PROGRAM=./soft-build/ariane/baremetal/lenet_rtl.exe
    if [ "${gui}" == "y" ]; then
        make sim-gui
    else
        make sim
    fi
else
    read -p "Update hardware? (y/n): " yn
    if [ "${yn}" == "y" ]; then
        make lenet_rtl-hls
    fi

    read -p "Update software? (y/n): " yn
    if [ "${yn}" == "y" ]; then
        make lenet_rtl-baremetal
    fi

    if [ "${gui}" == "y" ]; then
        make sim-gui
    else
        make sim
    fi
fi



