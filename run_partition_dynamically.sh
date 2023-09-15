#!/bin/bash
folder_name="db"  # Define the folder name where the partition will be mounted

# Get a list of disk paths
disk_paths=($(lsblk -rno NAME,TYPE | awk '$2=="disk" {print "/dev/"$1}'))

# Check if there are at least two disks available
if [ ${#disk_paths[@]} -lt 2 ]; then
    echo "Need at least two disks for this operation."
    exit 1
fi

# Loop through each disk path and it will ignore already mounted disks
for disk_path in "${disk_paths[@]}"; do
    # Display information about all partitions on the disk
    sudo fdisk -l

    # Create a new partition on the disk (excluding system disk)
    # configure it as a Linux LVM (8e) partition
    fdisk_output=$(echo -e "n\np\n1\n\n\nt\n8e\np\nw" | sudo fdisk "$disk_path")       #giving prompts
    partition_path=$(echo "$fdisk_output" | grep -oP '^/dev/\S+\s+\d+' | awk '{print $1}')

    # Format the newly created partition as ext4
    echo "y" | sudo mkfs.ext4 "$partition_path"

    # Create a folder with the specified name
    sudo mkdir -p "/$folder_name"

    # Mount the formatted partition to the folder
    mount_point="/$folder_name"
    sudo mkdir -p  "$mount_point"
    sudo mount "$partition_path" "$mount_point"

    # Get the UUID of the partition
    partition_uuid=$(sudo blkid -o value -s UUID "$partition_path")

    # Add an entry to /etc/fstab for permanent mounting, only if UUID is not empty
    if [ -n "$partition_uuid" ]; then
        echo "UUID=$partition_uuid   $mount_point   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    fi

    echo "Partitioning and mounting completed for $disk_path!"
done