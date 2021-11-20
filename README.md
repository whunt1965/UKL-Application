# UKL-Build
This repository contains a simple shell script (build.sh) which automates the process of cloning and building the UKL with a given application. The script then boots the UKL in QEMU.

## Instructions for Use
To use this script, run the following command:
```
./build.sh <application_directory_name>
```

As an example:
```
./build.sh lebench
```

## Script Details
The script begins by installing required packages necessary for building the UKL and running it in QEMU (by default the script uses apt-get, but for non-Debian systems, lines 7-8 can be updated to the appropriate package manager and package names). 

Then, if the ukl directory does not exist, the script clones the unikernelLinux/ukl repository (which contains the UKL Makefile). The script subsequently checks for each dependency repository required for the UKL (linux, gcc, glibc, etc.) and clones/compiles each of those repositories (if they do not yet exist in the file system). These checks are implemented so that new applications can be run without requiring a user to have to re-clone and compile all dependency repos.

After building all dependencies, the script copies over the files necessary for creating a UKL.a object (ukl/undefined_sys_hack.o, ukl/gcc-build, ukl/glibc-build, ukl/redef_sym_names) into the target application's folder.

The script then runs "make" on the application's Makefile to produce the UKL.a object and copies it into the /ukl directory. 

Finally, the script runs "make linux-build" to build the UKL and then runs "sudo make run" to boot this application in QEMU.


## Set-Up and Required Configurations
* UKL Repository:
  - To clone a specific branch of the ukl repository, update line 14 of *build.sh*. By default, this script will clone the *ubuntu* branch of the ukl repository (which has ubuntu-specific flags/configurations in the Makefile & source code files as well as clones an ubuntu-specific branch of min-initrd).
  - Applications which require specific command-line/networking/etc. options for running in QEMU will require the user to either directly edit the Makefile cloned into ukl/min-initrd or will require a specific pair of ukl and min-initrd branches tailored for the application.

* Adding new Applications
  - New Applications may be added by including a new directory with both the application source code and an application specific Makefile that produces a UKL.a object.
  - Notably, the name of this new directory must be the same as the name of the Makefile target (which produces the UKL.a file). If the name of the Make target *must* differ from the directory name, line 60 (make "$application") of *build.sh* should be updated.
