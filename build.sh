#! /bin/bash

#Get Application Name from Command Line Arguments
application="$1"

#Install packages for building Linux and Using QEMU
sudo apt-get -y update
sudo apt-get -y install git build-essential flex bison supermin libelf-dev libssl-dev texinfo libgmp3-dev libmpc-dev libmpfr-dev qemu-kvm

#Clone UKL repo
if [ ! -d ./ukl ]; then
    git clone --branch ubuntu git@github.com:unikernelLinux/ukl.git
fi

#Build Linux and Dependencies
cd ukl/

#Clone and build Linux (if not already cloned)
if [ ! -d "./linux" ]; then
    make linux-dir
fi

#Clone and build GCC (if not already cloned)
if [ ! -d "./gcc" ]; then
    make gcc-dir
fi

#Clone and build glibc (if not already cloned)
if [ ! -d "./glibc" ]; then
    make glibc-dir
fi

#Clone and build min-initrd (if not already cloned)
if [ ! -d "./min-initrd" ]; then
    make min-initrd-dir
fi

#Create gcc-build (if directory does not exist)
if [ ! -d "./gcc-build" ]; then
    make gcc-build
fi

#Make glibc-build
./cleanbuild.sh

#Make undefined sys hack
make undefined_sys_hack.o

#Return to parent directory and copy build files into target directory
cd ../
cp -r ukl/undefined_sys_hack.o ukl/gcc-build ukl/glibc-build ukl/redef_sym_names ./"$application"

#Build Application (produces UKL.a file)
cd "$application"
make "$application"

#Return to Parent Directory and copy UKL.a file into ukl directory
cd ../
cp  "$application"/UKL.a ./ukl

#Build UKL with application
cd ukl
make linux-build

#Run Application in QEMU 
sudo make run
