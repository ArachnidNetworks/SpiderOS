# SpiderOS
A super-light OS designed for speed on modern hardware.
<br/><br/>
**What is this?**<br/>
Our codebase needs to run fast, especially since it's all virtual. Due to this, <br/>
we need to optimize our code and our system. Due to the nature of this beast, <br/>
a miniature Linux distro is needed. We have created build tools to spin custom <br/>
images, borrowing from the Slitaz iso image, to construct a super small system <br/>
that is capable of outperforming any available linux distro on modern hardware. <br/>
<br/>
<br/>
**How do the build tools work?** <br/>
CreateLiteStage3.sh is a tool that auto-magically downloads a copy of slitaz-rolling<br/>
and generates a .img file formatted as ext4 and then mounts and copies the files over.<br/>
This generates a functional filesystem, minus the configuration. If you so choose, one<br/>
can compress these files and install this system just like the Gentoo Linux installation.<br/>

We are currently creating a new image with a newer linux kernel and will be baking in a <br/>
few more tools into the stock installation, with the intent to get rid of the desktop <br/>
and provide a modern multi-user experience in as small of a package as possible. <br/>
<br/>
<br/>
**What are the potential use cases for this?**<br/>
Since the system is built to be EXTREMELY small, it can work really well in containers.<br/>
Along with this, if someone wishes to squeeze all the performance out of their desktop,<br/>
an OS such as this will help them perform this task. To add to this list, this distro <br/>
has it's own open source build tools, making embedded Linux an option for SpiderOS. <br/>
<br/>
<br/>
<br/>
## Creating A Base System

**Getting Started** <br/>
To prepare for the SpiderOS build, you will need the following:<br/>
- A linux system with ncurses, tar, BASH, and networking capabilities. <br/>
  (Recommended CPU/RAM: 64 bit quad-core CPU at > 2.8 GHz, 16 gb RAM)
- If compiling for another device, find and install a cross-compiler for it's CPU. <br/>
- Storage space to manipulate the newly built OS image and generate new images.<br/>
- This repository downloaded via zip or git clone.



**Generating the base system files** <br/>
Once you have ensured you have met the base requirements for creating a SpiderOS <br/>
image, run the following: <br/>
```Bash
cd /path/to/SpiderOS
sudo ./SystemBuild/mkroot.sh
```
<br/>
This will generate a stage 3 system with BusyBox in the SystemBuild folder, <br/>
though it does create a few extra directories that you don't need :). To remedy <br/>
this, look for the directory "root" in /CWD/output/host where CWD is the <br/>
current working directory in which the script was executed. <br/>



**Cross-Compiling** <br/>
Additional information can be found in the ABOUTMKROOT file in the SystemBuild <br/>
directory. Consult this for documentation on how to use mkroot to cross-compile <br/>
your base system's binaries. <br/>
*NOTE: The cross-compiling process can also be done to build a custom kernel,* <br/>
*though the scripts to build a kernel need to be updated to allow this use case.* <br/>



## Installing Software to the System

**SpiderOS Ports** <br/>
SpiderOS doesn't use a package manager, but instead provides a BSD-like ports <br/>
system to assist in installing software. SpiderOS ports are different in the <br/>
fact that a SH script is provided to assist in the installation of these apps. <br/>
It also provides the developer leeway to allow or disallow the ability to use <br/>
dependency resolution as SpiderOS provides power to the developer. <br/>

To Install the SpiderOS Ports system, copy the folder into your installation's <br/>
stage 3 build before converting it into an image. The recommended path for BSD <br/>
users is to store it in the /usr directory. <br/>


**GCC and GNU Make** <br/>
The SpiderOS contain build scripts to install GCC and GNU make into your stage3 <br/>
system directory. These scripts are located inside the SystemBuild directory. <br/>
They are named InstallGCC.sh and InstallMake.sh and install the respective <br/>
software.<br/>


**Custom Linux Kernels** <br/>
The way to guarantee high performance and functionality on SpiderOS is to build <br/>
your own custom kernel. We provide a build script to allow you to do this on <br/>
native hardware. However, you may need to manually build your own kernel to <br/>
allow for Cross-Compiling on different hardware. Without a cross-compiler, the <br/>
process involves the following: <br/>

1) Browse to kernel.org and download the kernel version you wish to use.
2) Extract the source code using tar and use cd to navigate to the directory in <br/>
   your terminal.
3) Execute the command `make menuconfig` to be greeted by an ncurses menu to <br/>
   configure your Kernel.
4) Execute the command `make O=/path/to/output` where the output directory is <br/>
   the /boot directory in your Stage3 system build.
5) Execute the command `make O=/path/to/output modules_install` where the <br/>
   output directory is also the /boot directory in your Stage3.
6) Execute the command `make O=/path/to/output install` where the output <br/>
   is (again) the /boot directory in your Stage3. <br/>

Your Kernel image files should now be built in /boot in your new system files. <br/>
*NOTE: This kernel compilation process is similar when using a cross-compiler.* <br/>


After this, use chroot to enter your new system and install new applications <br/>
and software for you to use. Once you are ready, proceed to the next phase. <br/>



## Installation

**Generating an Install Image** <br/>
SpiderOS provides 3 facilities to assist in installation, located in the aptly <br/>
named Installation directory. One script will allow you to generate a .img file <br/>
which can be used to flash devices such as the Raspberry Pi. To use this, run <br/>
ConvertToIMG.sh in the Installation directory. To create a tarball for UMSDOS <br/>
style installation (like Gentoo Linux or SourceMage Linux), Execute the file <br/>
CreateStage3Tar.sh in the Installation directory. Additional bootstrapping <br/>
tools are incoming. <br/>


**Installing** <br/>
This part is outside of the scope of SpiderOS. However, it is recommended to <br/>
consult the Gentoo Handbook for UMSDOS-style installation, and also recommended <br/>
to read the linux manual pages dd as it is useful for flashing .img files to <br/>
disks. <br/>
