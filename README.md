# SpiderOS
A super-light OS (built off a Slitaz linux stage 3) designed for speed on modern hardware.
</br></br>
**What is this?**</br>
Our codebase needs to run fast, especially since it's all virtual. Due to this, </br>
we need to optimize our code and our system. Due to the nature of this beast, </br>
a miniature Linux distro is needed. We have created build tools to spin custom </br>
images, borrowing from the Slitaz iso image, to construct a super small system </br>
that is capable of outperforming any available linux distro on modern hardware. </br>
</br>
</br>
**How do the build tools work?**
CreateLiteStage3.sh is a tool that auto-magically downloads a copy of slitaz-rolling</br>
and generates a .img file formatted as ext4 and then mounts and copies the files over.</br>
This generates a functional filesystem, minus the configuration. If you so choose, one</br>
can compress these files and install this system just like the Gentoo Linux installation.</br>

We are currently creating a new image with a newer linux kernel and will be baking in a </br>
few more tools into the stock installation, with the intent to get rid of the desktop </br>
and provide a modern multi-user experience in as small of a package as possible. </br>
</br>
</br>
**What are the potential use cases for this?**</br>
Since the system is built to be EXTREMELY small, it can work really well in containers.</br>
Along with this, if someone wishes to squeeze all the performance out of their desktop,</br>
an OS such as this will help them perform this task. To add to this list, this distro </br>
has it's own open source build tools, making embedded Linux an option for SpiderOS. </br>
</br>
</br>


