#!/bin/bash

echo Setup: Enable persistent interface naming

sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /etc/default/grub
sudo update-grub
sudo sed -i 's/en.*[0-9]:$/eth0:/g' $(sudo find /etc/netplan/ -maxdepth 1 -type f -name '*.yaml'||'*.yml' -print0)
sudo sed -i 's/en.*[0-9]$/eth0/g' $(sudo find /etc/netplan/ -maxdepth 1 -type f -name '*.yaml'||'*.yml' -print0)
sudo netplan apply
sudo reboot