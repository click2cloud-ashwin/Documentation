currenttime=$(date "+%Y%m%d%H%M%S")
INSTANCENAME=temp
INSTANCENAME_FINAL=$INSTANCENAME$currenttime
export IMAGE="ubuntu-2004-focal-v20210820"
export ZONE="us-central1-a"
export INSTANCE_TYPE="c2-standard-4"
CUSTOMIMAGE=customimage-$currenttime
echo "Creating new temporary instance"
gcloud compute instances create $INSTANCENAME_FINAL \
        --zone=$ZONE \
        --image=$IMAGE \
        --image-project=ubuntu-os-cloud \
        --maintenance-policy=TERMINATE \
        --machine-type=$INSTANCE_TYPE \
	--image-project=ubuntu-os-cloud \
	--metadata=startup-script='#! /bin/bash
apt remove ifupdown
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/ens4/eth0/g' /etc/netplan/50-cloud-init.yaml
sudo netplan generate && netplan apply
echo "Temporary instance is creating"'
gcloud auth login
echo "Creating custom image"
gcloud compute images create $CUSTOMIMAGE --source-disk=$INSTANCENAME_FINAL --source-disk-zone=us-central1-a --source-disk-project=click2cloud --family=ubuntu-os-cloud --force
echo "Deleting temporary instance"
gcloud compute instances delete $INSTANCENAME_FINAL -q
