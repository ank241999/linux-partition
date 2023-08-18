\"Create a Partition in Linux\"

Step1 -  <br />
view all the partitions currently on your system, we use the
following command \  <br />
$ sudo fdisk -l

step2 -  <br />
a) choose one disk from this list to partition \[disk path\] $
sudo fdisk \[disk path\]  <br />

b) Using the command mode  - choose prompt \'n\'  <br />
 - choose promot \'p\'
 - partition number choose default prompt \'1\'  <br />
 - first sector or specify the size for your partition <br />
c) Setting the partition type  -
change the ID for our partition, we will use the command 't'.  <br />
- HEX code 8e is the partition ID for the 'Linux LVM' partition type, choose
\'8e\'  <br />
 d) see the detailed list of partitions choose \'p\'  <br />
 e) save changes , choose \'w\'

step3 - <br />
Formatting a partition \$ sudo mkfs.ext4 \[partition path\]

step4 - <br />
Create a folder on root \$ sudo mkdir \[folder name\]  <br />
step5 -  <br />
Mount the folder on crated partition  <br />
$ sudo mount -t auto \[partition
path\] \[Folder name\]
