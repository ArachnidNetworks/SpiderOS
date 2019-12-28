#!/bin/bash

# THIS SCRIPT NEEDS TO BE RUN ON THE HOST MACHINE!!!
#
# SpiderOS Custom Linux Kernel Generation tool
# Dependencies: GNU Make, GCC, BASH, wget, git, ncurses, any POSIX compliant OS
#
# This tool automatically downloads the latest type of Linux kernel and if the
# user specifies, it will download a cross-compiler to build the linux kernel
# for other architectures. The user will be presented with the familiar ncurses
# menu for configuring custom Linux kernels and still has to go through the
# process of compilation. This tool simply makes cross-compiling and configuring
# much easier to do.

# Linux Tarball URL's
# UPDATE AS NEW LINUX RELEASES COME OUT!!!!!
LINUX_STABLE="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.6.tar.xz"
LINUX_MAINLINE="https://git.kernel.org/torvalds/t/linux-5.5-rc3.tar.gz"

# Save Current Working Directory
CWD=$(pwd);

printf "Custom Linux Kernel Compilation Tool\n";
printf "To use this tool you must have GNU Make, tar, wget and GCC installed.\n";

# Get user input for the download path for the linux kernel image
printf "What is the full path of where you want the kernel downloaded to: ";
read -r DOWNLOAD_PATH;

# User input checking
while true
do
	if [ "$DOWNLOAD_PATH" == "" ]
	then
		printf "Enter the full download path: ";
		read -r DOWNLOAD_PATH;
	else
		break;
	fi
done

# Offer the user options to install different linux kernels
# TODO: Add linux-grsec support and different linux kernel options to this menu
printf "\n\nCURRENT LINUX KERNEL OPTIONS:\n";
printf "1) Current Linux Stable Kernel\n2) Current Linux Mainline Kernel\n\n";
printf "Enter the number to the left of the kernel you want to install: ";
read -r KERNELTYPE;
DOWNLOADSUCCESS=0;

# User input checking
while true
do
	if [ "$KERNELTYPE" == "1" ]
	then
		wget "$LINUX_STABLE" -O "$DOWNLOAD_PATH"/linux.tar.gz;
		DOWNLOADSUCCESS=1;
		break;
	elif [ "$KERNELTYPE" == "2" ]
	then
		wget "$LINUX_MAINLINE" -O "$DOWNLOAD_PATH"/linux.tar.gz;
		DOWNLOADSUCCESS=1;
		break;
	else
		printf "Enter the number next to the type of kernel you want: ";
		read -r KERNELTYPE;
	fi
done

# If DOWNLOADSUCCESS equals 1 (download successfully happened), attempt to
# extract the linux kernel tarball and compile the kernel.
if [ "$DOWNLOADSUCCESS" == "0" ]
then
	printf "Download error! Try checking the download URLs in this script ";
	printf "and running this script again.\n";
	exit 1;
elif [ "$DOWNLOADSUCCESS" == "1" ]
then
	printf "Extracting files...\n\n";
	
	cd "$DOWNLOAD_PATH" || exit 1;
	mkdir LINUX;
	mkdir KERNEL;
	tar -xvpf linux.tar.gz -C LINUX --strip-components=1;

	printf "Extraction complete!\nInvoking Menu Configuration\n";
	printf "The following process will invoke a menu for you to select ";
	printf "drivers and kernel support for you choose to add in. BE CAREFUL!\n";
	read -n 1 -s -r -p "Press any key to continue"

	cd "$DOWNLOAD_PATH"/LINUX || exit 1;
	make -j "$(nproc)" menuconfig;
	make -j "$(nproc)" O="$DOWNLOAD_PATH"/KERNEL;
	make -j "$(nproc)" O="$DOWNLOAD_PATH"/KERNEL modules_install;
	make -j "$(nproc)" O="$DOWNLOAD_PATH"/KERNEL install;

	cd "$CWD" || exit 1;

	printf "\n\nKernel Compilation Complete and stored at the download path ";
	printf "specified inside the newly created directory KERNEL.\n";
else
	printf "Error checking to see if download was successful. Try running ";
	printf "this script again to see if the problem persists.\n";
	exit 1;
fi

