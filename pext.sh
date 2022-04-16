#!/bin/bash

#The function that prints the help
Help()
{
	echo "The script is used to extend the space on a host. It will work in any scenario even if the host has LVM or not."
	echo
	echo "SYNTAX: pext [-p|m|h]"
	echo
	echo "OPTIONS:"
	echo "p		The name of the partition you want to extend"
	echo "m		The mount point you wish to extend"
	echo "h		Prints this menu"
	echo
	echo "USAGE:"
	echo "pext -p /dev/sda1 -m /    -->   Will extend / directory on the first disk first partition"
	echo "pext -p /dev/sdb2 -m /var -->   Will extend /var directory on the second disk second partition"
	echo	
}

#The function used to extend Non LVM partitions
NonLVM()
{
        partitions=$(lsblk -l | grep $part2 | awk '{print $1}')
        bool=0
        for i in $partitions
                do
                        if [[ $i > $part3 ]]
                        then
                                bool=1
                        fi
                done
        if [[ $bool -eq 0 ]]
        then
                growpart $growpart
                if [[ $fsystype = 'xfs' ]]
                then
                        xfs_growfs $fsys
			df -Th
                else
                        resize2fs $fsys
                        df -Th
                fi
        elif [[ $bool -eq 1 ]]
        then
                df -Th
                echo "The Partition can't be resized since there is another newer partition"
        fi
}

#The function used to extend LVM partitions
LVM()
{
        lvdisplay
        echo -n "LV Path: (ex:/dev/centos/root) "
        read LVPath
        topleveltype=$(lsblk | grep -B 1 -w / | awk '{print $6}' | head -n 1)
        if [[ $topleveltype = 'part' ]]
        then
                growpart $growpart
        fi
        pvresize $part
        lvextend -l +100%FREE $LVPath
        if [[ $fsystype = 'xfs' ]]
        then
                xfs_growfs $fsys
	        df -Th
        else
                resize2fs $fsys
                df -Th
	fi
}

while getopts "h:p:m:" option; do
        case $option in
                h) # Displays Help
			Help
                   	exit;;
		p) # Partition
			part=$OPTARG;;
		m) # MountPoint
			MountPoint=$OPTARG;;
               \?) # Invalid Option
                        echo "Invalid Option"
                        Help
                        exit;;
        esac
done

growpart="${part:0:8} ${part:9}${part:8}"
part2=$(echo $part | cut -c6-8) 
part3=$(echo $part | cut -c6-9)
fsystype=$(df --output=fstype $MountPoint | tail -1)
fsys=$(df --output=source $MountPoint | tail -1)
part_type=$(lsblk | grep -w "$MountPoint" | awk '{print $6}')
if [[ $part_type = '0' ]]
then
        part_type=$(lsblk | grep -w "$MountPoint" | awk '{print $7}')
fi
os=$(hostnamectl | grep "Operating System" | awk '{print $3}')
if [[ os = 'CentOS' ]]
then
        yum install cloud-utils-growpart -y
elif [[ os = 'Ubuntu' ]]
then
        apt-get install cloud-guest-utils -y
fi
echo 1 > /sys/block/"$part2"/device/rescan
if [[ $part_type = 'lvm' ]]
then
	LVM
elif [[ $part_type = 'part' ]]
then
	NonLVM
fi
