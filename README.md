\"Create a Partition in Linux\"

Step1 - view all the partitions currently on your system, we use the
following command \$ sudo fdisk -l

step2 - a) choose one disk from this list to partition \[disk path\] \$
sudo fdisk \[disk path\]

b) Using the command mode  - choose prompt \'n\'  - choose promot \'p\'
 - partition number choose default prompt \'1\'  - first sector or
specify the size for your partition
c) Setting the partition type  -
change the ID for our partition, we will use the command 't'.  - HEX
code 8e is the partition ID for the 'Linux LVM' partition type, choose
\'8e\'
 d) see the detailed list of partitions choose \'p\' e) save
changes , choose \'w\'

step3 - Formatting a partition \$ sudo mkfs.ext4 \[partition path\]

step4 - Create a folder on root \$ sudo mkdir \[folder name\] step5 -
Mount the folder on crated partition \$ sudo mount -t auto \[partition
path\] \[Folder name\]
