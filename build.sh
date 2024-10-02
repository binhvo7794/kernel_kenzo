#!/bin/bash

# Custom build script for Optimus Kernel

# Constants
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
cyan='\033[0;36m'
yellow='\033[0;33m'
blue='\033[0;34m'
default='\033[0m'

# Define variables
KERNEL_DIR=$PWD
Anykernel_DIR=$KERNEL_DIR/AnyKernel3/
DATE=$(date +"%d%m%Y")
TIME=$(date +"-%H.%M.%S")
KERNEL_NAME="Optimus-Kernel"
DEVICE="-kenzo-"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE"

BUILD_START=$(date +"%s")
sudo apt update -y && sudo apt install -y cpio flex bc bison gcc-aarch64* clang make cmake
git clone --depth=1 https://github.com/xiangfeidexiaohuo/GCC-4.9 tc
# Export few variables
export KBUILD_BUILD_USER="kenichi"
export KBUILD_BUILD_HOST="git"
export CROSS_COMPILE=aarch64-linux-android-
export ARCH="arm64"
export USE_CCACHE=1
export PATH=$PATH:$(pwd)/tc/bin

echo -e "$green***********************************************"
echo  "           Compiling Optimus Kernel                    "
echo -e "***********************************************"

# Finally build it
make kenzo_defconfig
make -j$(nproc --all)

echo -e "$yellow***********************************************"
echo  "                 Zipping up                    "
echo -e "***********************************************"

# Create the flashable zip
cp arch/arm64/boot/Image.gz-dtb $Anykernel_DIR
cd $Anykernel_DIR
zip -r9 $FINAL_ZIP.zip * -x .git README.md *placeholder
curl bashupload.com -T $FINAL_ZIP.zip

echo -e "$cyan***********************************************"
echo  "            Cleaning up the mess created               "
echo -e "***********************************************$default"

# Build complete
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$green Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$default"
