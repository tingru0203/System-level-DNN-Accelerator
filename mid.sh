#!/bin/bash

# file path: esp/socs/xilinx-vcu128-xcvu37p/

read -p "Remove? (y/n): " rmv
read -p "Update hardware? (y/n): " hw
read -p "Update software? (y/n): " sw
read -p "GUI? (y/n): " gui

if [ "${rmv}" == "y" ]; then
    rm -rf modelsim/
fi

if [ "${hw}" == "y" ]; then
    make lenet_rtl-hls
fi

if [ "${sw}" == "y" ]; then
    make lenet_rtl-baremetal
fi

export TEST_PROGRAM=./soft-build/ariane/baremetal/lenet_rtl.exe   
    
if [ "${gui}" == "y" ]; then
    make sim-gui
else
    make sim
fi
