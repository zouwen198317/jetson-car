#!/bin/bash

# Install Realense Library on NVIDA Jetson TX2

# Prerequisites:
#   1. Finished installed Custom Kernel Modules
#   2. /usr/srsc/kernel/kernel-4.4 is availalbe

INSTALL_DIR=$PWD
sudo apt-get install libusb-1.0-0-dev pkg-config -y
sudo apt-get install libglfw3-dev -y
sudo apt-get install qtcreator -y
sudo apt-get install cmake -y
# Install librealsense into home directory
cd $HOME
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
# Checkout version 1.11.0 of librealsense, last tested version
git checkout v1.12.1
# Install Qt libraries
sudo scripts/install_qt.sh
# Copy over the udev rules so that camera can be run from user space
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
# Make and Install
mkdir build
cd build
cmake .. -DBUILD_EXAMPLES:BOOL=true
make -j4
sudo make install

# Disable USB autosuspend
sudo sed -i '$s/$/ usbcore.autosuspend=-1/'  /boot/extlinux/extlinux.conf
# /bin/ required for echo to work correctly in /bin/sh file
/bin/echo -e "\e[1;32mPlease reboot for changes to take effect.\e[0m"

