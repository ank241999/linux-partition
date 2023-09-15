#!/bin/bash
folder_name="db"

# Get a list of disk paths (excluding system disk)
#disk_paths=($(lsblk -rno NAME,TYPE | awk '$2=="disk" && ($1=="nvme0n1" || $1=="nvme1n1") {print "/dev/"$1}'))
disk_paths=($(lsblk -rno NAME,TYPE | awk '$2=="disk" && ($1=="sda" || $1=="sdb") {print "/dev/"$1}'))
if [ ${#disk_paths[@]} -lt 2 ]; then
    echo "Need at least two disks for this operation."
    exit 1
fi

for disk_path in "${disk_paths[@]}"; do
    partition_path=""

    # Create partition
    fdisk_output=$(echo -e "n\np\n1\n\n\nt\n8e\np\nw" | sudo fdisk "$disk_path")
    partition_path=$(echo "$fdisk_output" | grep -oP '^/dev/\S+\s+\d+' | awk '{print $1}')

    # Format the partition
    echo "y" | sudo mkfs.ext4 "$partition_path"

    # Create a folder
    sudo mkdir -p "/$folder_name"

    # Mount the partition
    mount_point="/$folder_name"
    sudo mkdir -p "$mount_point"
    sudo mount "$partition_path" "$mount_point"

    # Get the UUID of the partition
    partition_uuid=$(sudo blkid -o value -s UUID "$partition_path")

    # Add entry to /etc/fstab for permanent mounting only if UUID is not empty
    if [ -n "$partition_uuid" ]; then
        echo "UUID=$partition_uuid   $mount_point   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    fi

    echo "Partitioning and mounting completed for $disk_path!"
done