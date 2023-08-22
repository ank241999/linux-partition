#!/bin/bash
#this is  for valid for when no partition on disk
disk_path="/dev/sdb"
partition_path=""
folder_name="db" 
# View all partitions
sudo fdisk -l
#create partition 
fdisk_output=$(echo -e "n\np\n1\n\n\nt\n8e\np\nw" | sudo fdisk "$disk_path")
partition_path=$(echo "$fdisk_output" | grep -oP '^/dev/\S+\s+\d+' | awk '{print $1}')
# Format the partition
echo "y" | sudo mkfs.ext4 "$partition_path"
# Create a folder
sudo mkdir "/$folder_name"

# Mount the partition
sudo mkdir /db
sudo mount -t auto "$partition_path" "/$folder_name"
echo "Partitioning and mounting completed!"