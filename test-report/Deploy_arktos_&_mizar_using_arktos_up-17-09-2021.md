# Test report for deploying Arktos cluster with Mizar CNI on AWS

This document captures the steps to deploy an Arktos cluster lab with mizar cni. The machines in this lab used are AWS EC2 t2.2xlarge (8 CPUs, 32GB mem), Ubuntu 18.04 LTS.

**Date**: 17.09.2021
### Create an instance on AWS
Created instance on AWS

![](images/img_9.png)


### Step-1: Update kernel version

* Check kernel version:

```bash
uname -a
```
##### Output

````bigquery
Linux ip-172-31-17-44 5.4.0-1045-aws #47~18.04.1-Ubuntu SMP Tue Apr 13 15:58:14 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
````

Here kernel version was `5.4.0-1045-aws` hence, to update kernel version to `5.6.0-rc2`, we used following steps :

```bash
wget https://raw.githubusercontent.com/CentaurusInfra/mizar/dev-next/kernelupdate.sh
sudo bash kernelupdate.sh
```
##### Output

```bigquery
ubuntu@ip-172-31-17-44:~$ sudo bash kernelupdate.sh
--2021-09-17 13:10:14--  https://mizar.s3.amazonaws.com/linux-5.6-rc2/linux-headers-5.6.0-rc2_5.6.0-rc2-1_amd64.deb
Resolving mizar.s3.amazonaws.com (mizar.s3.amazonaws.com)... 52.217.136.65
Connecting to mizar.s3.amazonaws.com (mizar.s3.amazonaws.com)|52.217.136.65|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7621020 (7.3M) []
Saving to: ‘../linux-5.6-rc2/linux-headers-5.6.0-rc2_5.6.0-rc2-1_amd64.deb’

linux-headers-5.6.0-rc2_5.6.0-rc2-1_amd64.deb       100%[=================================================================================================================>]   7.27M  6.26MB/s    in 1.2s

2021-09-17 13:10:15 (6.26 MB/s) - ‘../linux-5.6-rc2/linux-headers-5.6.0-rc2_5.6.0-rc2-1_amd64.deb’ saved [7621020/7621020]

--2021-09-17 13:10:15--  https://mizar.s3.amazonaws.com/linux-5.6-rc2/linux-image-5.6.0-rc2-dbg_5.6.0-rc2-1_amd64.deb
Resolving mizar.s3.amazonaws.com (mizar.s3.amazonaws.com)... 52.217.136.65
Connecting to mizar.s3.amazonaws.com (mizar.s3.amazonaws.com)|52.217.136.65|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 857827912 (818M) [application/x-www-form-urlencoded]
Saving to: ‘../linux-5.6-rc2/linux-image-5.6.0-rc2-dbg_5.6.0-rc2-1_amd64.deb’

linux-image-5.6.0-rc2-dbg_5.6.0-rc2-1_amd64.deb     100%[=================================================================================================================>] 818.09M  11.2MB/s    in 53s

2021-09-17 13:11:09 (15.4 MB/s) - ‘../linux-5.6-rc2/linux-image-5.6.0-rc2-dbg_5.6.0-rc2-1_amd64.deb’ saved [857827912/857827912]

--2021-09-17 13:11:09--  https://mizar.s3.amazonaws.com/linux-5.6-rc2/linux-image-5.6.0-rc2_5.6.0-rc2-1_amd64.deb
Resolving mizar.s3.amazonaws.com (mizar.s3.amazonaws.com)... 52.216.164.227
Connecting to mizar.s3.amazonaws.com (mizar.s3.amazonaws.com)|52.216.164.227|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 56427036 (54M) [application/x-www-form-urlencoded]
Saving to: ‘../linux-5.6-rc2/linux-image-5.6.0-rc2_5.6.0-rc2-1_amd64.deb’

linux-image-5.6.0-rc2_5.6.0-rc2-1_amd64.deb         100%[=================================================================================================================>]  53.81M  9.67MB/s    in 6.1s

2021-09-17 13:11:15 (8.86 MB/s) - ‘../linux-5.6-rc2/linux-image-5.6.0-rc2_5.6.0-rc2-1_amd64.deb’ saved [56427036/56427036]

--2021-09-17 13:11:15--  https://mizar.s3.amazonaws.com/linux-5.6-rc2/linux-libc-dev_5.6.0-rc2-1_amd64.deb
Resolving mizar.s3.amazonaws.com (mizar.s3.amazonaws.com)... 52.216.77.188
Connecting to mizar.s3.amazonaws.com (mizar.s3.amazonaws.com)|52.216.77.188|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1082248 (1.0M) []
Saving to: ‘../linux-5.6-rc2/linux-libc-dev_5.6.0-rc2-1_amd64.deb’

linux-libc-dev_5.6.0-rc2-1_amd64.deb                100%[=================================================================================================================>]   1.03M  2.45MB/s    in 0.4s

2021-09-17 13:11:16 (2.45 MB/s) - ‘../linux-5.6-rc2/linux-libc-dev_5.6.0-rc2-1_amd64.deb’ saved [1082248/1082248]

Continue kernel update (y/n)?y
Updating kernel
Selecting previously unselected package linux-headers-5.6.0-rc2.
(Reading database ... 57240 files and directories currently installed.)
Preparing to unpack .../linux-headers-5.6.0-rc2_5.6.0-rc2-1_amd64.deb ...
Unpacking linux-headers-5.6.0-rc2 (5.6.0-rc2-1) ...
Selecting previously unselected package linux-image-5.6.0-rc2-dbg.
Preparing to unpack .../linux-image-5.6.0-rc2-dbg_5.6.0-rc2-1_amd64.deb ...
Unpacking linux-image-5.6.0-rc2-dbg (5.6.0-rc2-1) ...
Selecting previously unselected package linux-image-5.6.0-rc2.
Preparing to unpack .../linux-image-5.6.0-rc2_5.6.0-rc2-1_amd64.deb ...
Unpacking linux-image-5.6.0-rc2 (5.6.0-rc2-1) ...
Selecting previously unselected package linux-libc-dev:amd64.
Preparing to unpack .../linux-libc-dev_5.6.0-rc2-1_amd64.deb ...
Unpacking linux-libc-dev:amd64 (5.6.0-rc2-1) ...
Setting up linux-headers-5.6.0-rc2 (5.6.0-rc2-1) ...
Setting up linux-image-5.6.0-rc2-dbg (5.6.0-rc2-1) ...
Setting up linux-image-5.6.0-rc2 (5.6.0-rc2-1) ...
update-initramfs: Generating /boot/initrd.img-5.6.0-rc2
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/50-cloudimg-settings.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.6.0-rc2
Found initrd image: /boot/initrd.img-5.6.0-rc2
Found linux image: /boot/vmlinuz-5.4.0-1045-aws
Found initrd image: /boot/initrd.img-5.4.0-1045-aws
done
Setting up linux-libc-dev:amd64 (5.6.0-rc2-1) ...
Reboot host (y/n)?y
Rebooting
```

### Step-2:Install dependencies
Login to created instance and run following steps to install dependencies required for arktos deployment:

* Clone the Arktos repository
```bash
git clone https://github.com/CentaurusInfra/arktos.git ~/go/src/k8s.io/arktos 
```
##### Output
```bigquery
ubuntu@ip-172-31-17-44:~$ git clone https://github.com/CentaurusInfra/arktos.git ~/go/src/k8s.io/arktos
Cloning into '/home/ubuntu/go/src/k8s.io/arktos'...
remote: Enumerating objects: 104938, done.
remote: Counting objects: 100% (447/447), done.
remote: Compressing objects: 100% (258/258), done.
remote: Total 104938 (delta 209), reused 341 (delta 173), pack-reused 104491
Receiving objects: 100% (104938/104938), 227.98 MiB | 25.72 MiB/s, done.
Resolving deltas: 100% (63446/63446), done.
Checking out files: 100% (20757/20757), done.
```

Then installed prerequisites required for Arktos cluster suing following command
```
sudo bash $HOME/go/src/k8s.io/arktos/hack/setup-dev-node.sh
```
##### Output
```bigquery
ubuntu@ip-172-31-17-44:~$ sudo bash $HOME/go/src/k8s.io/arktos/hack/setup-dev-node.sh
The script is to help install prerequisites of Arktos development environment
on a fresh Linux installation.
It's been tested on Ubuntu 16.04 LTS and 18.04 LTS.
Update apt.
Hit:1 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic InRelease
Get:2 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:3 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Get:4 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/universe amd64 Packages [8570 kB]
Get:5 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Get:6 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/universe Translation-en [4941 kB]
Get:7 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/multiverse amd64 Packages [151 kB]
Get:8 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/multiverse Translation-en [108 kB]
Get:9 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 Packages [2217 kB]
Get:10 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main Translation-en [433 kB]
Get:11 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/restricted amd64 Packages [462 kB]
Get:12 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/restricted Translation-en [62.5 kB]
Get:13 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/universe amd64 Packages [1749 kB]
Get:14 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/universe Translation-en [375 kB]
Get:15 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/multiverse amd64 Packages [27.3 kB]
Get:16 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/multiverse Translation-en [6808 B]
Get:17 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-backports/main amd64 Packages [10.0 kB]
Get:18 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-backports/main Translation-en [4764 B]
Get:19 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages [10.3 kB]
Get:20 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-backports/universe Translation-en [4588 B]
Get:21 http://security.ubuntu.com/ubuntu bionic-security/main amd64 Packages [1871 kB]
Get:22 http://security.ubuntu.com/ubuntu bionic-security/main Translation-en [341 kB]
Get:23 http://security.ubuntu.com/ubuntu bionic-security/restricted amd64 Packages [438 kB]
Get:24 http://security.ubuntu.com/ubuntu bionic-security/restricted Translation-en [58.8 kB]
Get:25 http://security.ubuntu.com/ubuntu bionic-security/universe amd64 Packages [1138 kB]
Get:26 http://security.ubuntu.com/ubuntu bionic-security/universe Translation-en [259 kB]
Get:27 http://security.ubuntu.com/ubuntu bionic-security/multiverse amd64 Packages [20.9 kB]
Get:28 http://security.ubuntu.com/ubuntu bionic-security/multiverse Translation-en [4732 B]
Fetched 23.5 MB in 4s (5622 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
79 packages can be upgraded. Run 'apt list --upgradable' to see them.
Install docker.
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  bridge-utils containerd pigz runc ubuntu-fan
Suggested packages:
  ifupdown aufs-tools cgroupfs-mount | cgroup-lite debootstrap docker-doc rinse zfs-fuse | zfsutils
The following NEW packages will be installed:
  bridge-utils containerd docker.io pigz runc ubuntu-fan
0 upgraded, 6 newly installed, 0 to remove and 79 not upgraded.
Need to get 74.0 MB of archives.
After this operation, 359 MB of additional disk space will be used.
Get:1 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/universe amd64 pigz amd64 2.4-1 [57.4 kB]
Get:2 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 bridge-utils amd64 1.5-15ubuntu1 [30.1 kB]
Get:3 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/universe amd64 runc amd64 1.0.0~rc95-0ubuntu1~18.04.2 [4087 kB]
Get:4 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/universe amd64 containerd amd64 1.5.2-0ubuntu1~18.04.2 [32.9 MB]
Get:5 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/universe amd64 docker.io amd64 20.10.7-0ubuntu1~18.04.1 [36.9 MB]
Get:6 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 ubuntu-fan all 0.12.10 [34.7 kB]
Fetched 74.0 MB in 2s (49.2 MB/s)
Preconfiguring packages ...
Selecting previously unselected package pigz.
(Reading database ... 88826 files and directories currently installed.)
Preparing to unpack .../0-pigz_2.4-1_amd64.deb ...
Unpacking pigz (2.4-1) ...
Selecting previously unselected package bridge-utils.
Preparing to unpack .../1-bridge-utils_1.5-15ubuntu1_amd64.deb ...
Unpacking bridge-utils (1.5-15ubuntu1) ...
Selecting previously unselected package runc.
Preparing to unpack .../2-runc_1.0.0~rc95-0ubuntu1~18.04.2_amd64.deb ...
Unpacking runc (1.0.0~rc95-0ubuntu1~18.04.2) ...
Selecting previously unselected package containerd.
Preparing to unpack .../3-containerd_1.5.2-0ubuntu1~18.04.2_amd64.deb ...
Unpacking containerd (1.5.2-0ubuntu1~18.04.2) ...
Selecting previously unselected package docker.io.
Preparing to unpack .../4-docker.io_20.10.7-0ubuntu1~18.04.1_amd64.deb ...
Unpacking docker.io (20.10.7-0ubuntu1~18.04.1) ...
Selecting previously unselected package ubuntu-fan.
Preparing to unpack .../5-ubuntu-fan_0.12.10_all.deb ...
Unpacking ubuntu-fan (0.12.10) ...
Setting up runc (1.0.0~rc95-0ubuntu1~18.04.2) ...
Setting up containerd (1.5.2-0ubuntu1~18.04.2) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Setting up bridge-utils (1.5-15ubuntu1) ...
Setting up ubuntu-fan (0.12.10) ...
Created symlink /etc/systemd/system/multi-user.target.wants/ubuntu-fan.service → /lib/systemd/system/ubuntu-fan.service.
Setting up pigz (2.4-1) ...
Setting up docker.io (20.10.7-0ubuntu1~18.04.1) ...
Adding group `docker' (GID 115) ...
Done.
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /lib/systemd/system/docker.socket.
Processing triggers for systemd (237-3ubuntu10.46) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Processing triggers for ureadahead (0.100.0-21) ...
Install make & gcc.
Reading package lists... Done
Building dependency tree
Reading state information... Done
Suggested packages:
  make-doc
The following NEW packages will be installed:
  make
0 upgraded, 1 newly installed, 0 to remove and 79 not upgraded.
Need to get 154 kB of archives.
After this operation, 381 kB of additional disk space will be used.
Get:1 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 make amd64 4.1-9.1ubuntu1 [154 kB]
Fetched 154 kB in 0s (13.8 MB/s)
Selecting previously unselected package make.
(Reading database ... 89149 files and directories currently installed.)
Preparing to unpack .../make_4.1-9.1ubuntu1_amd64.deb ...
Unpacking make (4.1-9.1ubuntu1) ...
Setting up make (4.1-9.1ubuntu1) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu cpp cpp-7 gcc-7 gcc-7-base libasan4 libatomic1 libbinutils libc-dev-bin libc6-dev libcc1-0 libcilkrts5 libgcc-7-dev libgomp1 libisl19 libitm1 liblsan0
  libmpc3 libmpx2 libquadmath0 libtsan0 libubsan0 manpages-dev
Suggested packages:
  binutils-doc cpp-doc gcc-7-locales gcc-multilib autoconf automake libtool flex bison gdb gcc-doc gcc-7-multilib gcc-7-doc libgcc1-dbg libgomp1-dbg libitm1-dbg libatomic1-dbg libasan4-dbg liblsan0-dbg
  libtsan0-dbg libubsan0-dbg libcilkrts5-dbg libmpx2-dbg libquadmath0-dbg glibc-doc
The following NEW packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu cpp cpp-7 gcc gcc-7 gcc-7-base libasan4 libatomic1 libbinutils libc-dev-bin libc6-dev libcc1-0 libcilkrts5 libgcc-7-dev libgomp1 libisl19 libitm1
  liblsan0 libmpc3 libmpx2 libquadmath0 libtsan0 libubsan0 manpages-dev
0 upgraded, 26 newly installed, 0 to remove and 79 not upgraded.
Need to get 29.6 MB of archives.
After this operation, 112 MB of additional disk space will be used.
Get:1 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 binutils-common amd64 2.30-21ubuntu1~18.04.5 [197 kB]
Get:2 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libbinutils amd64 2.30-21ubuntu1~18.04.5 [489 kB]
Get:3 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 binutils-x86-64-linux-gnu amd64 2.30-21ubuntu1~18.04.5 [1839 kB]
Get:4 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 binutils amd64 2.30-21ubuntu1~18.04.5 [3388 B]
Get:5 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 gcc-7-base amd64 7.5.0-3ubuntu1~18.04 [18.3 kB]
Get:6 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 libisl19 amd64 0.19-1 [551 kB]
Get:7 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 libmpc3 amd64 1.1.0-1 [40.8 kB]
Get:8 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 cpp-7 amd64 7.5.0-3ubuntu1~18.04 [8591 kB]
Get:9 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 cpp amd64 4:7.4.0-1ubuntu2.3 [27.7 kB]
Get:10 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libcc1-0 amd64 8.4.0-1ubuntu1~18.04 [39.4 kB]
Get:11 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libgomp1 amd64 8.4.0-1ubuntu1~18.04 [76.5 kB]
Get:12 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libitm1 amd64 8.4.0-1ubuntu1~18.04 [27.9 kB]
Get:13 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libatomic1 amd64 8.4.0-1ubuntu1~18.04 [9192 B]
Get:14 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libasan4 amd64 7.5.0-3ubuntu1~18.04 [358 kB]
Get:15 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 liblsan0 amd64 8.4.0-1ubuntu1~18.04 [133 kB]
Get:16 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libtsan0 amd64 8.4.0-1ubuntu1~18.04 [288 kB]
Get:17 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libubsan0 amd64 7.5.0-3ubuntu1~18.04 [126 kB]
Get:18 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libcilkrts5 amd64 7.5.0-3ubuntu1~18.04 [42.5 kB]
Get:19 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libmpx2 amd64 8.4.0-1ubuntu1~18.04 [11.6 kB]
Get:20 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libquadmath0 amd64 8.4.0-1ubuntu1~18.04 [134 kB]
Get:21 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libgcc-7-dev amd64 7.5.0-3ubuntu1~18.04 [2378 kB]
Get:22 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 gcc-7 amd64 7.5.0-3ubuntu1~18.04 [9381 kB]
Get:23 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 gcc amd64 4:7.4.0-1ubuntu2.3 [5184 B]
Get:24 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libc-dev-bin amd64 2.27-3ubuntu1.4 [71.8 kB]
Get:25 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libc6-dev amd64 2.27-3ubuntu1.4 [2585 kB]
Get:26 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 manpages-dev all 4.15-1 [2217 kB]
Fetched 29.6 MB in 1s (55.8 MB/s)
Selecting previously unselected package binutils-common:amd64.
(Reading database ... 89165 files and directories currently installed.)
Preparing to unpack .../00-binutils-common_2.30-21ubuntu1~18.04.5_amd64.deb ...
Unpacking binutils-common:amd64 (2.30-21ubuntu1~18.04.5) ...
Selecting previously unselected package libbinutils:amd64.
Preparing to unpack .../01-libbinutils_2.30-21ubuntu1~18.04.5_amd64.deb ...
Unpacking libbinutils:amd64 (2.30-21ubuntu1~18.04.5) ...
Selecting previously unselected package binutils-x86-64-linux-gnu.
Preparing to unpack .../02-binutils-x86-64-linux-gnu_2.30-21ubuntu1~18.04.5_amd64.deb ...
Unpacking binutils-x86-64-linux-gnu (2.30-21ubuntu1~18.04.5) ...
Selecting previously unselected package binutils.
Preparing to unpack .../03-binutils_2.30-21ubuntu1~18.04.5_amd64.deb ...
Unpacking binutils (2.30-21ubuntu1~18.04.5) ...
Selecting previously unselected package gcc-7-base:amd64.
Preparing to unpack .../04-gcc-7-base_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking gcc-7-base:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package libisl19:amd64.
Preparing to unpack .../05-libisl19_0.19-1_amd64.deb ...
Unpacking libisl19:amd64 (0.19-1) ...
Selecting previously unselected package libmpc3:amd64.
Preparing to unpack .../06-libmpc3_1.1.0-1_amd64.deb ...
Unpacking libmpc3:amd64 (1.1.0-1) ...
Selecting previously unselected package cpp-7.
Preparing to unpack .../07-cpp-7_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking cpp-7 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package cpp.
Preparing to unpack .../08-cpp_4%3a7.4.0-1ubuntu2.3_amd64.deb ...
Unpacking cpp (4:7.4.0-1ubuntu2.3) ...
Selecting previously unselected package libcc1-0:amd64.
Preparing to unpack .../09-libcc1-0_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libcc1-0:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libgomp1:amd64.
Preparing to unpack .../10-libgomp1_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libgomp1:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libitm1:amd64.
Preparing to unpack .../11-libitm1_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libitm1:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libatomic1:amd64.
Preparing to unpack .../12-libatomic1_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libatomic1:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libasan4:amd64.
Preparing to unpack .../13-libasan4_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libasan4:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package liblsan0:amd64.
Preparing to unpack .../14-liblsan0_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking liblsan0:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libtsan0:amd64.
Preparing to unpack .../15-libtsan0_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libtsan0:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libubsan0:amd64.
Preparing to unpack .../16-libubsan0_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libubsan0:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package libcilkrts5:amd64.
Preparing to unpack .../17-libcilkrts5_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libcilkrts5:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package libmpx2:amd64.
Preparing to unpack .../18-libmpx2_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libmpx2:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libquadmath0:amd64.
Preparing to unpack .../19-libquadmath0_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libquadmath0:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libgcc-7-dev:amd64.
Preparing to unpack .../20-libgcc-7-dev_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libgcc-7-dev:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package gcc-7.
Preparing to unpack .../21-gcc-7_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking gcc-7 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package gcc.
Preparing to unpack .../22-gcc_4%3a7.4.0-1ubuntu2.3_amd64.deb ...
Unpacking gcc (4:7.4.0-1ubuntu2.3) ...
Selecting previously unselected package libc-dev-bin.
Preparing to unpack .../23-libc-dev-bin_2.27-3ubuntu1.4_amd64.deb ...
Unpacking libc-dev-bin (2.27-3ubuntu1.4) ...
Selecting previously unselected package libc6-dev:amd64.
Preparing to unpack .../24-libc6-dev_2.27-3ubuntu1.4_amd64.deb ...
Unpacking libc6-dev:amd64 (2.27-3ubuntu1.4) ...
Selecting previously unselected package manpages-dev.
Preparing to unpack .../25-manpages-dev_4.15-1_all.deb ...
Unpacking manpages-dev (4.15-1) ...
Setting up libquadmath0:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libgomp1:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libatomic1:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libcc1-0:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libtsan0:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up liblsan0:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up gcc-7-base:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up binutils-common:amd64 (2.30-21ubuntu1~18.04.5) ...
Setting up libmpx2:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libmpc3:amd64 (1.1.0-1) ...
Setting up libc-dev-bin (2.27-3ubuntu1.4) ...
Setting up manpages-dev (4.15-1) ...
Setting up libc6-dev:amd64 (2.27-3ubuntu1.4) ...
Setting up libitm1:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libisl19:amd64 (0.19-1) ...
Setting up libasan4:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up libbinutils:amd64 (2.30-21ubuntu1~18.04.5) ...
Setting up libcilkrts5:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up libubsan0:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up libgcc-7-dev:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up cpp-7 (7.5.0-3ubuntu1~18.04) ...
Setting up binutils-x86-64-linux-gnu (2.30-21ubuntu1~18.04.5) ...
Setting up cpp (4:7.4.0-1ubuntu2.3) ...
Setting up binutils (2.30-21ubuntu1~18.04.5) ...
Setting up gcc-7 (7.5.0-3ubuntu1~18.04) ...
Setting up gcc (4:7.4.0-1ubuntu2.3) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Processing triggers for libc-bin (2.27-3ubuntu1.4) ...
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  libjq1 libonig4
The following NEW packages will be installed:
  jq libjq1 libonig4
0 upgraded, 3 newly installed, 0 to remove and 79 not upgraded.
Need to get 276 kB of archives.
After this operation, 930 kB of additional disk space will be used.
Get:1 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/universe amd64 libonig4 amd64 6.7.0-1 [119 kB]
Get:2 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/universe amd64 libjq1 amd64 1.5+dfsg-2 [111 kB]
Get:3 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/universe amd64 jq amd64 1.5+dfsg-2 [45.6 kB]
Fetched 276 kB in 0s (15.6 MB/s)
Selecting previously unselected package libonig4:amd64.
(Reading database ... 92426 files and directories currently installed.)
Preparing to unpack .../libonig4_6.7.0-1_amd64.deb ...
Unpacking libonig4:amd64 (6.7.0-1) ...
Selecting previously unselected package libjq1:amd64.
Preparing to unpack .../libjq1_1.5+dfsg-2_amd64.deb ...
Unpacking libjq1:amd64 (1.5+dfsg-2) ...
Selecting previously unselected package jq.
Preparing to unpack .../jq_1.5+dfsg-2_amd64.deb ...
Unpacking jq (1.5+dfsg-2) ...
Setting up libonig4:amd64 (6.7.0-1) ...
Setting up libjq1:amd64 (1.5+dfsg-2) ...
Setting up jq (1.5+dfsg-2) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Processing triggers for libc-bin (2.27-3ubuntu1.4) ...
Install golang.
--2021-09-17 13:16:49--  https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz
Resolving dl.google.com (dl.google.com)... 142.250.217.110, 2607:f8b0:400a:80b::200e
Connecting to dl.google.com (dl.google.com)|142.250.217.110|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 120139686 (115M) [application/octet-stream]
Saving to: ‘/tmp/go1.13.9.linux-amd64.tar.gz’

go1.13.9.linux-amd64.tar.gz                         100%[=================================================================================================================>] 114.57M  53.5MB/s    in 2.1s

2021-09-17 13:16:52 (53.5 MB/s) - ‘/tmp/go1.13.9.linux-amd64.tar.gz’ saved [120139686/120139686]

Done.
Please run and add 'export PATH=$PATH:/usr/local/go/bin' into your shell profile.
You can proceed to run arktos-up.sh if you want to launch a single-node cluster.
```

and then run the following commands:
```
echo export PATH=$PATH:/usr/local/go/bin\ >> ~/.profile
echo cd \$HOME/go/src/k8s.io/arktos >> ~/.profile
source ~/.profile
```
![](images/img_10.png)


#### Additional steps to configure branch `default-cni-mizar`

```bigquery
git remote add -f c2c https://github.com/Click2Cloud-Centaurus/arktos.git
git checkout default-cni-mizar
```

### Step-4: Start Arktos cluster
*Login to instance  and run following steps to deploy arktos cluster with Mizar as CNI*
```bash
cd $HOME/go/src/k8s.io/arktos
CNIPLUGIN=mizar ./hack/arktos-up.sh
```
**Finally we got  following output, which indicates that arktos cluster created successfully with Mizar as CNI**

```bigquery
ubuntu@ip-172-31-17-44:~/go/src/k8s.io/arktos$ CNIPLUGIN=mizar ./hack/arktos-up.sh
WARNING : The kubelet is configured to not fail even if swap is enabled; production deployments should disable swap.
WARNING : This script MAY be run as root for docker socket / iptables functionality; if failures occur, retry as root.
cni plugin is mizar; arktos will use mizar to provision pod network
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  build-essential dh-python dpkg-dev fakeroot g++ g++-7 libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libdpkg-perl libexpat1-dev libfakeroot libfile-fcntllock-perl
  libpython3-dev libpython3.6-dev libstdc++-7-dev python-pip-whl python3-crypto python3-dev python3-distutils python3-keyring python3-keyrings.alt python3-lib2to3 python3-secretstorage python3-setuptools
  python3-wheel python3-xdg python3.6-dev
Suggested packages:
  debian-keyring g++-multilib g++-7-multilib gcc-7-doc libstdc++6-7-dbg bzr libstdc++-7-doc python-crypto-doc gnome-keyring libkf5wallet-bin gir1.2-gnomekeyring-1.0 python-secretstorage-doc
  python-setuptools-doc
The following NEW packages will be installed:
  build-essential dh-python dpkg-dev fakeroot g++ g++-7 libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libdpkg-perl libexpat1-dev libfakeroot libfile-fcntllock-perl
  libpython3-dev libpython3.6-dev libstdc++-7-dev python-pip-whl python3-crypto python3-dev python3-distutils python3-keyring python3-keyrings.alt python3-lib2to3 python3-pip python3-secretstorage
  python3-setuptools python3-wheel python3-xdg python3.6-dev
0 upgraded, 29 newly installed, 0 to remove and 79 not upgraded.
Need to get 60.4 MB of archives.
After this operation, 134 MB of additional disk space will be used.
Get:1 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libstdc++-7-dev amd64 7.5.0-3ubuntu1~18.04 [1471 kB]
Get:2 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 g++-7 amd64 7.5.0-3ubuntu1~18.04 [9697 kB]
Get:3 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 g++ amd64 4:7.4.0-1ubuntu2.3 [1568 B]
Get:4 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libdpkg-perl all 1.19.0.5ubuntu2.3 [211 kB]
Get:5 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 dpkg-dev all 1.19.0.5ubuntu2.3 [607 kB]
Get:6 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 build-essential amd64 12.4ubuntu1 [4758 B]
Get:7 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 python3-lib2to3 all 3.6.9-1~18.04 [77.4 kB]
Get:8 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 python3-distutils all 3.6.9-1~18.04 [144 kB]
Get:9 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 dh-python all 3.20180325ubuntu2 [89.2 kB]
Get:10 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 libfakeroot amd64 1.22-2ubuntu1 [25.9 kB]
Get:11 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 fakeroot amd64 1.22-2ubuntu1 [62.3 kB]
Get:12 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 libalgorithm-diff-perl all 1.19.03-1 [47.6 kB]
Get:13 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 libalgorithm-diff-xs-perl amd64 0.04-5 [11.1 kB]
Get:14 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 libalgorithm-merge-perl all 0.08-3 [12.0 kB]
Get:15 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libexpat1-dev amd64 2.2.5-3ubuntu0.2 [122 kB]
Get:16 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 libfile-fcntllock-perl amd64 0.22-3build2 [33.2 kB]
Get:17 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libpython3.6-dev amd64 3.6.9-1~18.04ubuntu1.4 [44.9 MB]
Get:18 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 libpython3-dev amd64 3.6.7-1~18.04 [7328 B]
Get:19 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/universe amd64 python-pip-whl all 9.0.1-2.3~ubuntu1.18.04.5 [1653 kB]
Get:20 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 python3-crypto amd64 2.6.1-8ubuntu2 [244 kB]
Get:21 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 python3.6-dev amd64 3.6.9-1~18.04ubuntu1.4 [508 kB]
Get:22 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 python3-dev amd64 3.6.7-1~18.04 [1288 B]
Get:23 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 python3-secretstorage all 2.3.1-2 [12.1 kB]
Get:24 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 python3-keyring all 10.6.0-1 [26.7 kB]
Get:25 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 python3-keyrings.alt all 3.0-1 [16.6 kB]
Get:26 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/universe amd64 python3-pip all 9.0.1-2.3~ubuntu1.18.04.5 [114 kB]
Get:27 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/main amd64 python3-setuptools all 39.0.1-2 [248 kB]
Get:28 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic/universe amd64 python3-wheel all 0.30.0-0.2 [36.5 kB]
Get:29 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates/main amd64 python3-xdg all 0.25-4ubuntu1.1 [31.3 kB]
Fetched 60.4 MB in 1s (53.7 MB/s)
Selecting previously unselected package libstdc++-7-dev:amd64.
(Reading database ... 92443 files and directories currently installed.)
Preparing to unpack .../00-libstdc++-7-dev_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libstdc++-7-dev:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package g++-7.
Preparing to unpack .../01-g++-7_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking g++-7 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package g++.
Preparing to unpack .../02-g++_4%3a7.4.0-1ubuntu2.3_amd64.deb ...
Unpacking g++ (4:7.4.0-1ubuntu2.3) ...
Selecting previously unselected package libdpkg-perl.
Preparing to unpack .../03-libdpkg-perl_1.19.0.5ubuntu2.3_all.deb ...
Unpacking libdpkg-perl (1.19.0.5ubuntu2.3) ...
Selecting previously unselected package dpkg-dev.
Preparing to unpack .../04-dpkg-dev_1.19.0.5ubuntu2.3_all.deb ...
Unpacking dpkg-dev (1.19.0.5ubuntu2.3) ...
Selecting previously unselected package build-essential.
Preparing to unpack .../05-build-essential_12.4ubuntu1_amd64.deb ...
Unpacking build-essential (12.4ubuntu1) ...
Selecting previously unselected package python3-lib2to3.
Preparing to unpack .../06-python3-lib2to3_3.6.9-1~18.04_all.deb ...
Unpacking python3-lib2to3 (3.6.9-1~18.04) ...
Selecting previously unselected package python3-distutils.
Preparing to unpack .../07-python3-distutils_3.6.9-1~18.04_all.deb ...
Unpacking python3-distutils (3.6.9-1~18.04) ...
Selecting previously unselected package dh-python.
Preparing to unpack .../08-dh-python_3.20180325ubuntu2_all.deb ...
Unpacking dh-python (3.20180325ubuntu2) ...
Selecting previously unselected package libfakeroot:amd64.
Preparing to unpack .../09-libfakeroot_1.22-2ubuntu1_amd64.deb ...
Unpacking libfakeroot:amd64 (1.22-2ubuntu1) ...
Selecting previously unselected package fakeroot.
Preparing to unpack .../10-fakeroot_1.22-2ubuntu1_amd64.deb ...
Unpacking fakeroot (1.22-2ubuntu1) ...
Selecting previously unselected package libalgorithm-diff-perl.
Preparing to unpack .../11-libalgorithm-diff-perl_1.19.03-1_all.deb ...
Unpacking libalgorithm-diff-perl (1.19.03-1) ...
Selecting previously unselected package libalgorithm-diff-xs-perl.
Preparing to unpack .../12-libalgorithm-diff-xs-perl_0.04-5_amd64.deb ...
Unpacking libalgorithm-diff-xs-perl (0.04-5) ...
Selecting previously unselected package libalgorithm-merge-perl.
Preparing to unpack .../13-libalgorithm-merge-perl_0.08-3_all.deb ...
Unpacking libalgorithm-merge-perl (0.08-3) ...
Selecting previously unselected package libexpat1-dev:amd64.
Preparing to unpack .../14-libexpat1-dev_2.2.5-3ubuntu0.2_amd64.deb ...
Unpacking libexpat1-dev:amd64 (2.2.5-3ubuntu0.2) ...
Selecting previously unselected package libfile-fcntllock-perl.
Preparing to unpack .../15-libfile-fcntllock-perl_0.22-3build2_amd64.deb ...
Unpacking libfile-fcntllock-perl (0.22-3build2) ...
Selecting previously unselected package libpython3.6-dev:amd64.
Preparing to unpack .../16-libpython3.6-dev_3.6.9-1~18.04ubuntu1.4_amd64.deb ...
Unpacking libpython3.6-dev:amd64 (3.6.9-1~18.04ubuntu1.4) ...
Selecting previously unselected package libpython3-dev:amd64.
Preparing to unpack .../17-libpython3-dev_3.6.7-1~18.04_amd64.deb ...
Unpacking libpython3-dev:amd64 (3.6.7-1~18.04) ...
Selecting previously unselected package python-pip-whl.
Preparing to unpack .../18-python-pip-whl_9.0.1-2.3~ubuntu1.18.04.5_all.deb ...
Unpacking python-pip-whl (9.0.1-2.3~ubuntu1.18.04.5) ...
Selecting previously unselected package python3-crypto.
Preparing to unpack .../19-python3-crypto_2.6.1-8ubuntu2_amd64.deb ...
Unpacking python3-crypto (2.6.1-8ubuntu2) ...
Selecting previously unselected package python3.6-dev.
Preparing to unpack .../20-python3.6-dev_3.6.9-1~18.04ubuntu1.4_amd64.deb ...
Unpacking python3.6-dev (3.6.9-1~18.04ubuntu1.4) ...
Selecting previously unselected package python3-dev.
Preparing to unpack .../21-python3-dev_3.6.7-1~18.04_amd64.deb ...
Unpacking python3-dev (3.6.7-1~18.04) ...
Selecting previously unselected package python3-secretstorage.
Preparing to unpack .../22-python3-secretstorage_2.3.1-2_all.deb ...
Unpacking python3-secretstorage (2.3.1-2) ...
Selecting previously unselected package python3-keyring.
Preparing to unpack .../23-python3-keyring_10.6.0-1_all.deb ...
Unpacking python3-keyring (10.6.0-1) ...
Selecting previously unselected package python3-keyrings.alt.
Preparing to unpack .../24-python3-keyrings.alt_3.0-1_all.deb ...
Unpacking python3-keyrings.alt (3.0-1) ...
Selecting previously unselected package python3-pip.
Preparing to unpack .../25-python3-pip_9.0.1-2.3~ubuntu1.18.04.5_all.deb ...
Unpacking python3-pip (9.0.1-2.3~ubuntu1.18.04.5) ...
Selecting previously unselected package python3-setuptools.
Preparing to unpack .../26-python3-setuptools_39.0.1-2_all.deb ...
Unpacking python3-setuptools (39.0.1-2) ...
Selecting previously unselected package python3-wheel.
Preparing to unpack .../27-python3-wheel_0.30.0-0.2_all.deb ...
Unpacking python3-wheel (0.30.0-0.2) ...
Selecting previously unselected package python3-xdg.
Preparing to unpack .../28-python3-xdg_0.25-4ubuntu1.1_all.deb ...
Unpacking python3-xdg (0.25-4ubuntu1.1) ...
Setting up python-pip-whl (9.0.1-2.3~ubuntu1.18.04.5) ...
Setting up python3-crypto (2.6.1-8ubuntu2) ...
Setting up python3-xdg (0.25-4ubuntu1.1) ...
Setting up python3-keyrings.alt (3.0-1) ...
Setting up libdpkg-perl (1.19.0.5ubuntu2.3) ...
Setting up python3-wheel (0.30.0-0.2) ...
Setting up libstdc++-7-dev:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up libfile-fcntllock-perl (0.22-3build2) ...
Setting up dpkg-dev (1.19.0.5ubuntu2.3) ...
Setting up libfakeroot:amd64 (1.22-2ubuntu1) ...
Setting up libalgorithm-diff-perl (1.19.03-1) ...
Setting up libexpat1-dev:amd64 (2.2.5-3ubuntu0.2) ...
Setting up python3-lib2to3 (3.6.9-1~18.04) ...
Setting up python3-secretstorage (2.3.1-2) ...
Setting up python3-distutils (3.6.9-1~18.04) ...
Setting up python3-keyring (10.6.0-1) ...
Setting up g++-7 (7.5.0-3ubuntu1~18.04) ...
Setting up fakeroot (1.22-2ubuntu1) ...
update-alternatives: using /usr/bin/fakeroot-sysv to provide /usr/bin/fakeroot (fakeroot) in auto mode
Setting up libpython3.6-dev:amd64 (3.6.9-1~18.04ubuntu1.4) ...
Setting up libalgorithm-merge-perl (0.08-3) ...
Setting up libalgorithm-diff-xs-perl (0.04-5) ...
Setting up python3-pip (9.0.1-2.3~ubuntu1.18.04.5) ...
Setting up g++ (4:7.4.0-1ubuntu2.3) ...
update-alternatives: using /usr/bin/g++ to provide /usr/bin/c++ (c++) in auto mode
Setting up python3-setuptools (39.0.1-2) ...
Setting up python3.6-dev (3.6.9-1~18.04ubuntu1.4) ...
Setting up dh-python (3.20180325ubuntu2) ...
Setting up libpython3-dev:amd64 (3.6.7-1~18.04) ...
Setting up build-essential (12.4ubuntu1) ...
Setting up python3-dev (3.6.7-1~18.04) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Processing triggers for libc-bin (2.27-3ubuntu1.4) ...
installing mizar python dependencies
The directory '/home/ubuntu/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/home/ubuntu/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Requirement already satisfied: setuptools in /usr/lib/python3/dist-packages
Collecting netaddr
  Downloading https://files.pythonhosted.org/packages/ff/cd/9cdfea8fc45c56680b798db6a55fa60a22e2d3d3ccf54fc729d083b50ce4/netaddr-0.8.0-py2.py3-none-any.whl (1.9MB)
    100% |████████████████████████████████| 1.9MB 662kB/s
Collecting docker
  Downloading https://files.pythonhosted.org/packages/59/86/b2430d652d082a2132bbd6023b3f298d0582977c27f125c7e3875c65e178/docker-5.0.2-py2.py3-none-any.whl (145kB)
    100% |████████████████████████████████| 153kB 5.0MB/s
Collecting grpcio
  Downloading https://files.pythonhosted.org/packages/37/56/700ff83b59eb69a7ddd62840666699173923020cfdf33a2860b9eba5667a/grpcio-1.40.0.tar.gz (21.3MB)
    100% |████████████████████████████████| 21.3MB 61kB/s
Collecting grpcio-tools
  Downloading https://files.pythonhosted.org/packages/7f/67/04da9b7b4d99756ba89b0046e2447bee7740b116ef8a281a4cc655426151/grpcio-tools-1.40.0.tar.gz (2.1MB)
    100% |████████████████████████████████| 2.1MB 660kB/s
Collecting scapy
  Downloading https://files.pythonhosted.org/packages/85/47/c919432ca258f354bb2c1e645623f891603f185bfc7563d4a21f6432e7ed/scapy-2.4.5.tar.gz (1.1MB)
    100% |████████████████████████████████| 1.1MB 1.3MB/s
Collecting kubernetes
  Downloading https://files.pythonhosted.org/packages/19/4a/39b09950b35a36fe1af54bb85413c2976b62a5c29e7254c8c3573f86c028/kubernetes-18.20.0-py2.py3-none-any.whl (1.6MB)
    100% |████████████████████████████████| 1.6MB 823kB/s
Collecting importlib-resources; python_version < "3.7" (from netaddr)
  Downloading https://files.pythonhosted.org/packages/f2/6c/2f3b930513bb971172ffceb63cf4e910944e57451724e69b1dec97cfefa6/importlib_resources-5.2.2-py3-none-any.whl
Collecting websocket-client>=0.32.0 (from docker)
  Downloading https://files.pythonhosted.org/packages/55/44/030ea47390896c8d6dc9995c8e9a4c5df3a161cd45416d88119036c73eda/websocket_client-1.2.1-py2.py3-none-any.whl (52kB)
    100% |████████████████████████████████| 61kB 14.1MB/s
Requirement already satisfied: requests!=2.18.0,>=2.14.2 in /usr/lib/python3/dist-packages (from docker)
Requirement already satisfied: six>=1.5.2 in /usr/lib/python3/dist-packages (from grpcio)
Collecting protobuf<4.0dev,>=3.5.0.post1 (from grpcio-tools)
  Downloading https://files.pythonhosted.org/packages/74/4e/9f3cb458266ef5cdeaa1e72a90b9eda100e3d1803cbd7ec02f0846da83c3/protobuf-3.18.0-py2.py3-none-any.whl (174kB)
    100% |████████████████████████████████| 184kB 7.6MB/s
Collecting pyyaml>=5.4.1 (from kubernetes)
  Downloading https://files.pythonhosted.org/packages/7a/5b/bc0b5ab38247bba158504a410112b6c03f153c652734ece1849749e5f518/PyYAML-5.4.1-cp36-cp36m-manylinux1_x86_64.whl (640kB)
    100% |████████████████████████████████| 645kB 2.2MB/s
Collecting python-dateutil>=2.5.3 (from kubernetes)
  Downloading https://files.pythonhosted.org/packages/36/7a/87837f39d0296e723bb9b62bbb257d0355c7f6128853c78955f57342a56d/python_dateutil-2.8.2-py2.py3-none-any.whl (247kB)
    100% |████████████████████████████████| 256kB 5.6MB/s
Collecting google-auth>=1.0.1 (from kubernetes)
  Downloading https://files.pythonhosted.org/packages/b5/64/f65e9e568dbb3f76093225d1bf1caf20c1ac53d959558fb47c0d3e4706a0/google_auth-2.1.0-py2.py3-none-any.whl (153kB)
    100% |████████████████████████████████| 153kB 8.2MB/s
Collecting urllib3>=1.24.2 (from kubernetes)
  Downloading https://files.pythonhosted.org/packages/5f/64/43575537846896abac0b15c3e5ac678d787a4021e906703f1766bfb8ea11/urllib3-1.26.6-py2.py3-none-any.whl (138kB)
    100% |████████████████████████████████| 143kB 9.4MB/s
Collecting requests-oauthlib (from kubernetes)
  Downloading https://files.pythonhosted.org/packages/a3/12/b92740d845ab62ea4edf04d2f4164d82532b5a0b03836d4d4e71c6f3d379/requests_oauthlib-1.3.0-py2.py3-none-any.whl
Requirement already satisfied: certifi>=14.05.14 in /usr/lib/python3/dist-packages (from kubernetes)
Collecting zipp>=3.1.0; python_version < "3.10" (from importlib-resources; python_version < "3.7"->netaddr)
  Downloading https://files.pythonhosted.org/packages/92/d9/89f433969fb8dc5b9cbdd4b4deb587720ec1aeb59a020cf15002b9593eef/zipp-3.5.0-py3-none-any.whl
Collecting rsa<5,>=3.1.4 (from google-auth>=1.0.1->kubernetes)
  Downloading https://files.pythonhosted.org/packages/e9/93/0c0f002031f18b53af7a6166103c02b9c0667be528944137cc954ec921b3/rsa-4.7.2-py3-none-any.whl
Requirement already satisfied: pyasn1-modules>=0.2.1 in /usr/lib/python3/dist-packages (from google-auth>=1.0.1->kubernetes)
Collecting cachetools<5.0,>=2.0.0 (from google-auth>=1.0.1->kubernetes)
  Downloading https://files.pythonhosted.org/packages/bf/28/c4f5796c67ad06bb91d98d543a5e01805c1ff065e08871f78e52d2a331ad/cachetools-4.2.2-py3-none-any.whl
Collecting oauthlib>=3.0.0 (from requests-oauthlib->kubernetes)
  Downloading https://files.pythonhosted.org/packages/e8/5d/9dd1c29e5a786525f6342f6c1d812ed2e37edc653ad297048c1668988053/oauthlib-3.1.1-py2.py3-none-any.whl (146kB)
    100% |████████████████████████████████| 153kB 8.4MB/s
Requirement already satisfied: pyasn1>=0.1.3 in /usr/lib/python3/dist-packages (from rsa<5,>=3.1.4->google-auth>=1.0.1->kubernetes)
Installing collected packages: zipp, importlib-resources, netaddr, websocket-client, docker, grpcio, protobuf, grpcio-tools, scapy, pyyaml, python-dateutil, rsa, cachetools, google-auth, urllib3, oauthlib, requests-oauthlib, kubernetes
  Running setup.py install for grpcio ... done
  Running setup.py install for grpcio-tools ... done
  Running setup.py install for scapy ... done
  Found existing installation: PyYAML 3.12
    Not uninstalling pyyaml at /usr/lib/python3/dist-packages, outside environment /usr
  Found existing installation: urllib3 1.22
    Not uninstalling urllib3 at /usr/lib/python3/dist-packages, outside environment /usr
  Found existing installation: oauthlib 2.0.6
    Not uninstalling oauthlib at /usr/lib/python3/dist-packages, outside environment /usr
Successfully installed cachetools-4.2.2 docker-5.0.2 google-auth-2.1.0 grpcio-1.40.0 grpcio-tools-1.40.0 importlib-resources-5.2.2 kubernetes-18.20.0 netaddr-0.8.0 oauthlib-3.1.1 protobuf-3.18.0 python-dateutil-2.8.2 pyyaml-5.4.1 requests-oauthlib-1.3.0 rsa-4.7.2 scapy-2.4.5 urllib3-1.26.6 websocket-client-1.2.1 zipp-3.5.0
done with mizar python dependencies installation
Checking arktos containerd...
arktos containerd not found...
--2021-09-17 13:21:57--  https://github.com/containerd/containerd/releases/download/v1.4.2/containerd-1.4.2-linux-amd64.tar.gz
Resolving github.com (github.com)... 192.30.255.112
Connecting to github.com (github.com)|192.30.255.112|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-releases.githubusercontent.com/46089560/5cad0000-2fc0-11eb-8e3a-ed435a7b945c?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210917%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210917T132157Z&X-Amz-Expires=300&X-Amz-Signature=fb64da99acdb00456b64b86b767ad8007d6b1cc86f6b9e805d88355d64ad3daa&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=46089560&response-content-disposition=attachment%3B%20filename%3Dcontainerd-1.4.2-linux-amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
--2021-09-17 13:21:57--  https://github-releases.githubusercontent.com/46089560/5cad0000-2fc0-11eb-8e3a-ed435a7b945c?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210917%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210917T132157Z&X-Amz-Expires=300&X-Amz-Signature=fb64da99acdb00456b64b86b767ad8007d6b1cc86f6b9e805d88355d64ad3daa&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=46089560&response-content-disposition=attachment%3B%20filename%3Dcontainerd-1.4.2-linux-amd64.tar.gz&response-content-type=application%2Foctet-stream
Resolving github-releases.githubusercontent.com (github-releases.githubusercontent.com)... 185.199.111.154, 185.199.110.154, 185.199.109.154, ...
Connecting to github-releases.githubusercontent.com (github-releases.githubusercontent.com)|185.199.111.154|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 31160021 (30M) [application/octet-stream]
Saving to: ‘/home/ubuntu/arktos-containerd/containerd-1.4.2-linux-amd64.tar.gz’

containerd-1.4.2-linux-amd64.tar.gz                 100%[=================================================================================================================>]  29.72M  38.2MB/s    in 0.8s

2021-09-17 13:21:59 (38.2 MB/s) - ‘/home/ubuntu/arktos-containerd/containerd-1.4.2-linux-amd64.tar.gz’ saved [31160021/31160021]

installing arktos containerd...
WARNING : The kubelet is configured to not fail even if swap is enabled; production deployments should disable swap.
WARNING : This script MAY be run as root for docker socket / iptables functionality; if failures occur, retry as root.
Getting runtime deployment file  libvirt-qemu
--2021-09-17 13:22:14--  https://raw.githubusercontent.com/futurewei-cloud/arktos-vm-runtime/release-0.6/deploy/apparmor/libvirt-qemu
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.111.133, 185.199.108.133, 185.199.109.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 6578 (6.4K) [text/plain]
Saving to: ‘/tmp/libvirt-qemu’

/tmp/libvirt-qemu                                   100%[=================================================================================================================>]   6.42K  --.-KB/s    in 0s

2021-09-17 13:22:14 (70.6 MB/s) - ‘/tmp/libvirt-qemu’ saved [6578/6578]

Getting runtime deployment file  libvirtd
--2021-09-17 13:22:14--  https://raw.githubusercontent.com/futurewei-cloud/arktos-vm-runtime/release-0.6/deploy/apparmor/libvirtd
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.110.133, 185.199.109.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1617 (1.6K) [text/plain]
Saving to: ‘/tmp/libvirtd’

/tmp/libvirtd                                       100%[=================================================================================================================>]   1.58K  --.-KB/s    in 0s

2021-09-17 13:22:15 (29.9 MB/s) - ‘/tmp/libvirtd’ saved [1617/1617]

Getting runtime deployment file  virtlet
--2021-09-17 13:22:15--  https://raw.githubusercontent.com/futurewei-cloud/arktos-vm-runtime/release-0.6/deploy/apparmor/virtlet
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.110.133, 185.199.109.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2582 (2.5K) [text/plain]
Saving to: ‘/tmp/virtlet’

/tmp/virtlet                                        100%[=================================================================================================================>]   2.52K  --.-KB/s    in 0s

2021-09-17 13:22:15 (56.6 MB/s) - ‘/tmp/virtlet’ saved [2582/2582]

Getting runtime deployment file  vms
--2021-09-17 13:22:15--  https://raw.githubusercontent.com/futurewei-cloud/arktos-vm-runtime/release-0.6/deploy/apparmor/vms
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.110.133, 185.199.109.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 485 [text/plain]
Saving to: ‘/tmp/vms’

/tmp/vms                                            100%[=================================================================================================================>]     485  --.-KB/s    in 0s

2021-09-17 13:22:15 (28.6 MB/s) - ‘/tmp/vms’ saved [485/485]

Getting runtime deployment file  vmruntime.yaml
--2021-09-17 13:22:15--  https://raw.githubusercontent.com/futurewei-cloud/arktos-vm-runtime/release-0.6/deploy/data/virtlet-ds.yaml
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.110.133, 185.199.109.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 11643 (11K) [text/plain]
Saving to: ‘/tmp/vmruntime.yaml’

/tmp/vmruntime.yaml                                 100%[=================================================================================================================>]  11.37K  --.-KB/s    in 0s

2021-09-17 13:22:15 (76.5 MB/s) - ‘/tmp/vmruntime.yaml’ saved [11643/11643]

Getting runtime deployment file  images.yaml
--2021-09-17 13:22:15--  https://raw.githubusercontent.com/futurewei-cloud/arktos-vm-runtime/release-0.6/deploy/images.yaml
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.110.133, 185.199.109.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 254 [text/plain]
Saving to: ‘/tmp/images.yaml’

/tmp/images.yaml                                    100%[=================================================================================================================>]     254  --.-KB/s    in 0s

2021-09-17 13:22:15 (14.8 MB/s) - ‘/tmp/images.yaml’ saved [254/254]

Stopping Apparmor service
make: Entering directory '/home/ubuntu/go/src/k8s.io/arktos'
make[1]: Entering directory '/home/ubuntu/go/src/k8s.io/arktos'
+++ [0917 13:22:22] Building go targets for linux/amd64:
    ./vendor/k8s.io/code-generator/cmd/deepcopy-gen
+++ [0917 13:22:22] Building go targets for linux/amd64:
    ./vendor/k8s.io/code-generator/cmd/defaulter-gen
+++ [0917 13:22:22] Building go targets for linux/amd64:
    ./vendor/k8s.io/code-generator/cmd/conversion-gen
+++ [0917 13:22:22] Building go targets for linux/amd64:
    ./vendor/k8s.io/kube-openapi/cmd/openapi-gen
+++ [0917 13:22:25] Building go targets for linux/amd64:
    ./vendor/github.com/go-bindata/go-bindata/go-bindata
make[1]: Leaving directory '/home/ubuntu/go/src/k8s.io/arktos'
Running copyright check for repo: /home/ubuntu/go/src/k8s.io/arktos, logging to _output/ArktosCopyrightTool.log
~/go/src/k8s.io/arktos ~/go/src/k8s.io/arktos
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your diff.renameLimit variable to at least 3060 and retry the command.
~/go/src/k8s.io/arktos
~/go/src/k8s.io/arktos ~/go/src/k8s.io/arktos
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your diff.renameLimit variable to at least 3060 and retry the command.
~/go/src/k8s.io/arktos
Inspecting copyright files, writing logs to _output/ArktosCopyrightTool.log
Done.
+++ [0917 13:22:46] Building go targets for linux/amd64:
    cmd/kubectl
    cmd/hyperkube
    cmd/kube-apiserver
    cmd/kube-controller-manager
    cmd/workload-controller-manager
    cmd/cloud-controller-manager
    cmd/kubelet
    cmd/kube-proxy
    cmd/kube-scheduler
Running copyright check for repo: /home/ubuntu/go/src/k8s.io/arktos, logging to _output/ArktosCopyrightTool.log
~/go/src/k8s.io/arktos ~/go/src/k8s.io/arktos
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your diff.renameLimit variable to at least 3060 and retry the command.
~/go/src/k8s.io/arktos
~/go/src/k8s.io/arktos ~/go/src/k8s.io/arktos
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your diff.renameLimit variable to at least 3060 and retry the command.
~/go/src/k8s.io/arktos
Inspecting copyright files, writing logs to _output/ArktosCopyrightTool.log
Done.
make: Leaving directory '/home/ubuntu/go/src/k8s.io/arktos'
make: Entering directory '/home/ubuntu/go/src/k8s.io/arktos'
make[1]: Entering directory '/home/ubuntu/go/src/k8s.io/arktos'
make[1]: Leaving directory '/home/ubuntu/go/src/k8s.io/arktos'
Running copyright check for repo: /home/ubuntu/go/src/k8s.io/arktos, logging to _output/ArktosCopyrightTool.log
~/go/src/k8s.io/arktos ~/go/src/k8s.io/arktos
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your diff.renameLimit variable to at least 3060 and retry the command.
~/go/src/k8s.io/arktos
~/go/src/k8s.io/arktos ~/go/src/k8s.io/arktos
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your diff.renameLimit variable to at least 3060 and retry the command.
~/go/src/k8s.io/arktos
Inspecting copyright files, writing logs to _output/ArktosCopyrightTool.log
Done.
+++ [0917 13:25:29] Building go targets for linux/amd64:
    cmd/arktos-network-controller
Running copyright check for repo: /home/ubuntu/go/src/k8s.io/arktos, logging to _output/ArktosCopyrightTool.log
~/go/src/k8s.io/arktos ~/go/src/k8s.io/arktos
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your diff.renameLimit variable to at least 3060 and retry the command.
~/go/src/k8s.io/arktos
~/go/src/k8s.io/arktos ~/go/src/k8s.io/arktos
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your diff.renameLimit variable to at least 3060 and retry the command.
~/go/src/k8s.io/arktos
Inspecting copyright files, writing logs to _output/ArktosCopyrightTool.log
Done.
make: Leaving directory '/home/ubuntu/go/src/k8s.io/arktos'
cannot find etcd locally. will install one.
Downloading https://github.com/centaurus-cloud/etcd/releases/download/v3.4.4-arktos.1/etcd-v3.4.4-arktos.1-linux-amd64.tar.gz succeed
etcd v3.4.4-arktos.1 installed. To use:
export PATH="/home/ubuntu/go/src/k8s.io/arktos/third_party/etcd:${PATH}"

The current version is 3.4.4-arktos.1

API SERVER insecure port is free, proceeding...
API SERVER secure port is free, proceeding...
Unable to successfully run 'cfssl' from /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/home/ubuntu/go/src/k8s.io/arktos/third_party/etcd; downloading instead...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   623  100   623    0     0   1769      0 --:--:-- --:--:-- --:--:--  1769
100  9.8M  100  9.8M    0     0  13.5M      0 --:--:-- --:--:-- --:--:-- 13.5M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   627  100   627    0     0   2668      0 --:--:-- --:--:-- --:--:--  2668
100 2224k  100 2224k    0     0  4302k      0 --:--:-- --:--:-- --:--:-- 8208k
Detected host and ready to start services.  Doing some housekeeping first...
Using GO_OUT /home/ubuntu/go/src/k8s.io/arktos/_output/local/bin/linux/amd64
Starting services now!
Starting etcd

The current version is 3.4.4-arktos.1

etcd --name ip-172-31-17-44 --cluster-id 0 --listen-peer-urls http://172.31.17.44:2380   --advertise-client-urls http://172.31.17.44:2379 --data-dir /tmp/tmp.ifSC8GWzdh --listen-client-urls http://172.31.17.44:2379,http://127.0.0.1:2379 --listen-peer-urls http://172.31.17.44:2380 --debug > "/tmp/etcd.log" 2>/dev/null
Waiting for etcd to come up.
+++ [0917 13:25:48] On try 2, etcd: : {"health":"true"}
{"header":{"cluster_id":"14788394046821881976","member_id":"17721740914898044746","revision":"2","raft_term":"2"}}Starting 1 kube-apiserver instances. If you want to make changes to the kube-apiserver nubmer, please run export APISERVER_SERVER=n(n=1,2,...).
Copied the apiserver partition config file  /var/run/kubernetes/apiserver.config...
Can't load /home/ubuntu/.rnd into RNG
140558520029632:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88:Filename=/home/ubuntu/.rnd
Generating a RSA private key
...............................................................+++++
................................................................................+++++
writing new private key to '/var/run/kubernetes/server-ca.key'
-----
Can't load /home/ubuntu/.rnd into RNG
140000366154176:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88:Filename=/home/ubuntu/.rnd
Generating a RSA private key
......................................................................................+++++
....................................................................+++++
writing new private key to '/var/run/kubernetes/client-ca.key'
-----
Can't load /home/ubuntu/.rnd into RNG
139899406754240:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88:Filename=/home/ubuntu/.rnd
Generating a RSA private key
........................................+++++
...........+++++
writing new private key to '/var/run/kubernetes/request-header-ca.key'
-----
2021/09/17 13:25:48 [INFO] generate received request
2021/09/17 13:25:48 [INFO] received CSR
2021/09/17 13:25:48 [INFO] generating key: rsa-2048
2021/09/17 13:25:49 [INFO] encoded CSR
2021/09/17 13:25:49 [INFO] signed certificate with serial number 292862150336938479337717043815810055909780736576
2021/09/17 13:25:49 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2021/09/17 13:25:49 [INFO] generate received request
2021/09/17 13:25:49 [INFO] received CSR
2021/09/17 13:25:49 [INFO] generating key: rsa-2048
2021/09/17 13:25:49 [INFO] encoded CSR
2021/09/17 13:25:49 [INFO] signed certificate with serial number 331997646978082041329726903667786882530016246759
2021/09/17 13:25:49 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2021/09/17 13:25:49 [INFO] generate received request
2021/09/17 13:25:49 [INFO] received CSR
2021/09/17 13:25:49 [INFO] generating key: rsa-2048
2021/09/17 13:25:49 [INFO] encoded CSR
2021/09/17 13:25:49 [INFO] signed certificate with serial number 444122131382130356997822928943085885660339455366
2021/09/17 13:25:49 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2021/09/17 13:25:49 [INFO] generate received request
2021/09/17 13:25:49 [INFO] received CSR
2021/09/17 13:25:49 [INFO] generating key: rsa-2048
2021/09/17 13:25:49 [INFO] encoded CSR
2021/09/17 13:25:49 [INFO] signed certificate with serial number 711467342329364339813346570727984921503108241754
2021/09/17 13:25:49 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2021/09/17 13:25:49 [INFO] generate received request
2021/09/17 13:25:49 [INFO] received CSR
2021/09/17 13:25:49 [INFO] generating key: rsa-2048
2021/09/17 13:25:50 [INFO] encoded CSR
2021/09/17 13:25:50 [INFO] signed certificate with serial number 231321183563065975022854338628912581410132413702
2021/09/17 13:25:50 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2021/09/17 13:25:50 [INFO] generate received request
2021/09/17 13:25:50 [INFO] received CSR
2021/09/17 13:25:50 [INFO] generating key: rsa-2048
2021/09/17 13:25:50 [INFO] encoded CSR
2021/09/17 13:25:50 [INFO] signed certificate with serial number 329639384503644617184280505183077765158282270797
2021/09/17 13:25:50 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2021/09/17 13:25:50 [INFO] generate received request
2021/09/17 13:25:50 [INFO] received CSR
2021/09/17 13:25:50 [INFO] generating key: rsa-2048
2021/09/17 13:25:50 [INFO] encoded CSR
2021/09/17 13:25:50 [INFO] signed certificate with serial number 209562643804550726242772088380594825818488984611
2021/09/17 13:25:50 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2021/09/17 13:25:50 [INFO] generate received request
2021/09/17 13:25:50 [INFO] received CSR
2021/09/17 13:25:50 [INFO] generating key: rsa-2048
2021/09/17 13:25:51 [INFO] encoded CSR
2021/09/17 13:25:51 [INFO] signed certificate with serial number 503311058188830539824683707020353325099483792244
2021/09/17 13:25:51 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2021/09/17 13:25:51 [INFO] generate received request
2021/09/17 13:25:51 [INFO] received CSR
2021/09/17 13:25:51 [INFO] generating key: rsa-2048
2021/09/17 13:25:51 [INFO] encoded CSR
2021/09/17 13:25:51 [INFO] signed certificate with serial number 639933542801365104667454658658915682432889017538
2021/09/17 13:25:51 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
Waiting for apiserver to come up
+++ [0917 13:26:01] On try 8, apiserver: : ok
clusterrolebinding.rbac.authorization.k8s.io/kube-apiserver-kubelet-admin created
Cluster "local-up-cluster" set.
use 'kubectl --kubeconfig=/var/run/kubernetes/admin-kube-aggregator0.kubeconfig' to use the aggregated API server
2021/09/17 13:26:01 [INFO] generate received request
2021/09/17 13:26:01 [INFO] received CSR
2021/09/17 13:26:01 [INFO] generating key: rsa-2048
2021/09/17 13:26:01 [INFO] encoded CSR
2021/09/17 13:26:01 [INFO] signed certificate with serial number 291100398256491907908337769946939037316535228307
2021/09/17 13:26:01 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
service/kube-dns created
serviceaccount/kube-dns created
configmap/kube-dns created
deployment.apps/kube-dns created
Kube-dns addon successfully deployed.
2021/09/17 13:26:02 [INFO] generate received request
2021/09/17 13:26:02 [INFO] received CSR
2021/09/17 13:26:02 [INFO] generating key: rsa-2048
2021/09/17 13:26:02 [INFO] encoded CSR
2021/09/17 13:26:02 [INFO] signed certificate with serial number 230528363478478537036500246564767804171230240710
2021/09/17 13:26:02 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
kubelet ( 5181 ) is running.
customresourcedefinition.apiextensions.k8s.io/bouncers.mizar.com created
customresourcedefinition.apiextensions.k8s.io/dividers.mizar.com created
customresourcedefinition.apiextensions.k8s.io/droplets.mizar.com created
customresourcedefinition.apiextensions.k8s.io/endpoints.mizar.com created
customresourcedefinition.apiextensions.k8s.io/subnets.mizar.com created
customresourcedefinition.apiextensions.k8s.io/vpcs.mizar.com created
serviceaccount/mizar-operator created
clusterrolebinding.rbac.authorization.k8s.io/mizar-operator created
daemonset.apps/mizar-daemon created
deployment.apps/mizar-operator created
Create default storage class for
storageclass.storage.k8s.io/standard created
customresourcedefinition.apiextensions.k8s.io/networks.arktos.futurewei.com created
*******************************************
Setup Arktos components ...

Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
Waiting for node ready at api server
ip-172-31-17-44   Ready   <none>   5m24s   v0.7.0
node/ip-172-31-17-44 labeled
configmap/virtlet-image-translations created
daemonset.apps/virtlet created
configmap/virtlet-config created
clusterrolebinding.rbac.authorization.k8s.io/virtlet created
clusterrole.rbac.authorization.k8s.io/virtlet created
clusterrole.rbac.authorization.k8s.io/configmap-reader created
clusterrole.rbac.authorization.k8s.io/virtlet-userdata-reader created
clusterrolebinding.rbac.authorization.k8s.io/kubelet-node-binding created
clusterrolebinding.rbac.authorization.k8s.io/vm-userdata-binding created
clusterrole.rbac.authorization.k8s.io/virtlet-crd created
clusterrolebinding.rbac.authorization.k8s.io/virtlet-crd created
serviceaccount/virtlet created
NAME      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
virtlet   0         0         0       0            0           <none>          0s
clusterrole.rbac.authorization.k8s.io/system:arktos-network-reader created
clusterrolebinding.rbac.authorization.k8s.io/system:kubelet-network-reader created

Arktos Setup done.
*******************************************
Setup Kata Containers components ...
* Install Kata components
kata-containers 2.2.0-1 from Kata Containers (katacontainers✓) installed
* Checking Kata compatibility
No newer release available time="2021-09-17T13:31:42Z" level=error msg="CPU property not found" arch=amd64 description="Virtualization support" name=vmx pid=27593 source=runtime type=flag time="2021-09-17T13:31:42Z" level=error msg="Module is not loaded and it can not be inserted. Please consider running with sudo or as root" arch=amd64 module=kvm_intel name=kata-runtime pid=27593 source=runtime time="2021-09-17T13:31:42Z" level=error msg="kernel property not found" arch=amd64 description="Intel KVM" name=kvm_intel pid=27593 source=runtime type=module time="2021-09-17T13:31:42Z" level=error msg="Module is not loaded and it can not be inserted. Please consider running with sudo or as root" arch=amd64 module=kvm name=kata-runtime pid=27593 source=runtime time="2021-09-17T13:31:42Z" level=error msg="kernel property not found" arch=amd64 description="Kernel-based Virtual Machine" name=kvm pid=27593 source=runtime type=module time="2021-09-17T13:31:42Z" level=error msg="Module is not loaded and it can not be inserted. Please consider running with sudo or as root" arch=amd64 module=vhost name=kata-runtime pid=27593 source=runtime time="2021-09-17T13:31:42Z" level=error msg="kernel property not found" arch=amd64 description="Host kernel accelerator for virtio" name=vhost pid=27593 source=runtime type=module time="2021-09-17T13:31:42Z" level=error msg="Module is not loaded and it can not be inserted. Please consider running with sudo or as root" arch=amd64 module=vhost_net name=kata-runtime pid=27593 source=runtime time="2021-09-17T13:31:42Z" level=error msg="kernel property not found" arch=amd64 description="Host kernel accelerator for virtio network" name=vhost_net pid=27593 source=runtime type=module time="2021-09-17T13:31:42Z" level=error msg="Module is not loaded and it can not be inserted. Please consider running with sudo or as root" arch=amd64 module=vhost_vsock name=kata-runtime pid=27593 source=runtime time="2021-09-17T13:31:42Z" level=error msg="kernel property not found" arch=amd64 description="Host Support for Linux VM Sockets" name=vhost_vsock pid=27593 source=runtime type=module time="2021-09-17T13:31:42Z" level=error msg="ERROR: System is not capable of running Kata Containers" arch=amd64 name=kata-runtime pid=27593 source=runtime ERROR: System is not capable of running Kata Containers
Aborted. Current system does not support Kata Containers.
Kata Setup done.
*******************************************
Local Kubernetes cluster is running. Press Ctrl-C to shut it down.

Logs:
  /tmp/kube-apiserver0.log
  /tmp/kube-controller-manager.log


  /tmp/kube-proxy.log
  /tmp/kube-scheduler.log
  /tmp/kubelet.log

To start using your cluster, you can open up another terminal/tab and run:

  export KUBECONFIG=/var/run/kubernetes/admin.kubeconfig
Or
  export KUBECONFIG=/var/run/kubernetes/adminN(N=0,1,...).kubeconfig

  cluster/kubectl.sh

Alternatively, you can write to the default kubeconfig:

  export KUBERNETES_PROVIDER=local

  cluster/kubectl.sh config set-cluster local --server=https://ip-172-31-17-44:6443 --certificate-authority=/var/run/kubernetes/server-ca.crt
  cluster/kubectl.sh config set-credentials myself --client-key=/var/run/kubernetes/client-admin.key --client-certificate=/var/run/kubernetes/client-admin.crt
  cluster/kubectl.sh config set-context local --cluster=local --user=myself
  cluster/kubectl.sh config use-context local
  cluster/kubectl.sh
```

##### *Leave this terminal here as it is (do not close the terminal) and open new terminal of same instance*

### Step-5 Check Cluster health
Open new terminal for same instance and run following commands:

##### Check node status
```bigquery
./cluster/kubectl.sh  get node
```
***Output***
![](images/img_11.png)

##### Check pods status
```bigquery
./cluster/kubectl.sh get pods -Ao wide
```
***Output***
![](images/img_12.png)


##### Check vpcs
```bigquery
./cluster/kubectl.sh get vpc -Ao wide
```
***Output***
![](images/img_13.png)


##### Check subnets
```bigquery
./cluster/kubectl.sh get subnet -Ao wide
```
***Output***
![](images/img_14.png)


##### Check dividers
```bigquery
./cluster/kubectl.sh get dividers -Ao wide
```
***Output***
![](images/img_15.png)


##### Check bouncers
```bigquery
./cluster/kubectl.sh get bouncers -Ao wide
```
***Output***
![](images/img_16.png)


##### Check networks
```bigquery
./cluster/kubectl.sh get net
```
***Output***
![](images/img_17.png)


##### Pod deployment
*Pods are getting stuck in ContainerCreating state, found issue of `loopback` binary for which team is going to generate another PR.*
![](images/img_18.png)
