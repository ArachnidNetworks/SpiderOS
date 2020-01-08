#!/bin/bash

#This program takes a .tar.bz2 file of the current SpiderOS kernel and swaps
#the kernel files in the /boot directory with the new ones. This allows for
#on-the-fly kernel upgrades and compilation using external tools.

printf "This script needs to be run as root!!!\n";
printf "Kernel Installation Tool\n";
printf "This program allows the swapping of SpiderOS kernels via a simple script.\n\n";

#Get path to file
printf "Enter the FULL path to the kernel.tar.bz2 you are trying to swap: "
read -r PTH;

#check user input
while true
do
	if [ "$PTH" == "" ]
	then
		printf "You need to enter the full path: ";
		read -r PTH;
	else
		break;
	fi
done

#Get path to mounted install image
printf "CreateLiteStage3.sh mounted an image in a directory called INSTALL. where\n";
printf "is it's absolute path: ";

read -r INSTALLPATH

#check user input
while true
do
	if [ "$INSTALLPATH" == "" ]
	then
		printf "You need to enter the path to the mounted install image: ";
		read -r INSTALLPATH;
	else
		break;
	fi
done

printf "Are you sure you want to swap the kernel? [Y/n]: ";
read -r USER_IN;

while true
do
	if [ "$USER_IN" == "Y" ]
	then
		rm "$INSTALLPATH"/boot/*;
		tar -xvpf "$PTH" -C "$INSTALLPATH"/boot;
		printf "New Kernel Successfully Installed!\n";
		printf "Remember to update your bootloader.\n";
		break;
	elif [ "$USER_IN" == "n" ]
	then
		printf "Exiting upon user request...\n\n";
		exit 0;
	else
		printf "I/O error. Exiting...\n\n";
		exit 1;
	fi
done
