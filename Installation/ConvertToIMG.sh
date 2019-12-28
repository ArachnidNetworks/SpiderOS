#!/bin/bash

# SpiderOS: Tool to convert generated filesystem into .img format
#
# This script is for taking a new mkroot+busybox and custom kernel image and
# porting it all into a custom .img file for certain platforms, such as the
# Raspberry PI or the BeagleBone.
#
# IMPORTANT NOTE: This program DOES NOT install a bootloader!!! We expect users
# of SpiderOS to prepare one themselves as a part of building their own custom
# tailored Linux image.

printf "SpiderOS: Convert current filesystem to .img file\n";
printf "RUN THIS SCRIPT ON THE HOST SYSTEM AS ROOT (NOT IN CHROOT)!!!\n\n";

# Get size of image
printf "What image size would you like (In Kilobytes): ";
read -r IMAGESIZE;

while true
do
	if [ "$IMAGESIZE" == "" ]
	then
		printf "Enter the image size in Kb: ";
		read -r IMAGESIZE;
	else
		break;
	fi
done

# Get path to save image file
printf "What is the absolute folder path you would like to save the file to: ";
read -r SAVEPATH

while true
do
	if [ "$SAVEPATH" == "" ]
	then
		printf "Enter the absolute folder path: ";
		read -r SAVEPATH;
	else
		dd if=/dev/zero of="$SAVEPATH"/SpiderOS.img bs=1M count="$IMAGESIZE";
		mkfs.ext4 "$SAVEPATH"/SpiderOS.img;
		printf "\n\n";
		break;
	fi
done

# Get path to stage 3
printf "What is the path to the root folder of the system stage 3 you wish to copy: ";
read -r SYSPATH;

# Check path and begin copying files from stage 3 path to mounted image.
while true
do
	if [ "$SYSPATH" == "" ]
	then
		printf "Enter the path to the root of the stage 3: ";
		read -r SYSPATH;
	else
		mkdir "$SAVEPATH"/tmp;
		mount "$SAVEPATH"/SpiderOS.img "$SAVEPATH"/tmp;
		cp -r "$SYSPATH"/* "$SAVEPATH"/tmp;
		umount "$SAVEPATH"/tmp;
		rm -rf "$SAVEPATH"/tmp;
		printf "\n\nSystem image created! ";
		printf "Flash this to your DevBoard like the Pi to use this.\n";
		break;
	fi
done

