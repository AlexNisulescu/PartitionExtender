# Bash script for Extending space on a Linux partition
<a href="https://www.buymeacoffee.com/alexnisuleXu" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
## Table of contents
  * [Index](#index)
  * [Introduction](#introduction)
  * [Requirements](#requirements)
  * [How to use it](#how-to-use-it)
  * [Contributors](#contributors)


## Introduction

This script was created from the need to simplify the way a partition is extended on Linux.
It was coded in a way that it will do all the work in recognizing the partition type (LVM or Non-LVM) and will only ask the user for extra input if it detects that it is necessary for him to provide the LV Path.

## Requirements

The script was tested and currently works for:
 - Ubuntu 20.04
 - CentOS 7

It is possible for it to work with other distributions but you will need to make sure that you have growpart installed.

It is also very important to run this script as root since it needs permissions to play with the partitions.

## How to use it
Syntax:

    pext [-p|m|h]

The options are:

    p - provide the partition name (ex: /dev/sda1)
    m - provide the name of the mountpoint (ex: /var)
    h - prints the help menu

Some examples of running it are:

    pext -p /dev/sda1 -m /    -->   Will extend / directory on the first disk first partition
    pext -p /dev/sdb2 -m /var -->   Will extend /var directory on the second disk second partition

I recommend adding this script to /usr/local/bin/ in order to be easily accessed form anywhere. 

## Contributors
    Creator: Alexandru Nișulescu
    Contact: alex.nisulescu1998@gmail.com
    Linkedin: https://www.linkedin.com/in/alex-nisulescu-45822b178/

If you found this usefull, please consider [buying me a coffee](https://www.buymeacoffee.com/alexnisuleXu)
