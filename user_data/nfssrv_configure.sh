#!/bin/bash
declare -a ar_bv_dev_name=("/dev/sdaa" "/dev/sdab" "/dev/sdac" "/dev/sdad" "/dev/sdae" "/dev/sdaf" "/dev/sdag" "/dev/sdb" "/dev/sdc" "/dev/sdd" "/dev/sde" "/dev/sdf" "/dev/sdg" "/dev/sdh" "/dev/sdi" "/dev/sdj" "/dev/sdk" "/dev/sdl" "/dev/sdm" "/dev/sdn" "/dev/sdo" "/dev/sdp" "/dev/sdq" "/dev/sdr" "/dev/sds" "/dev/sdt" "/dev/sdu" "/dev/sdv" "/dev/sdw" "/dev/sdx" "/dev/sdy" "/dev/sdz")
bv_dev_list=""

# Check all block volumes are attached
for ((i = 0; i < ${#ar_bv_dev_name[@]}; i++))
{
  while :
  do
    lsblk ${ar_bv_dev_name[i]} > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
      echo "Device ${ar_bv_dev_name[i]} is attached."
      bv_dev_list=${bv_dev_list}" "${ar_bv_dev_name[i]}
      break
    fi
    echo "Device ${ar_bv_dev_name[i]} is not attached yet. Sleep 5 seconds"
    sleep 5
  done
}

# Create file system on block volume
echo "Start creating volume group"
sudo vgcreate bv $bv_dev_list
echo "Start creating logical volume"
sudo lvcreate -y -l 100%FREE --stripes 32 --stripesize "64K" -n bv bv
echo "Start formatting XFS file system"
sudo mkfs.xfs -L blockvolume /dev/bv/bv
echo "Start mounting file system"
echo "LABEL=blockvolume /mnt/bv/ xfs defaults,_netdev,noatime 0 0" | sudo tee -a /etc/fstab
sudo mkdir -p /mnt/bv
sudo systemctl daemon-reload

# Configure NFS server
echo "Start NFS server"
echo "/mnt/bv *(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
sudo sed -i 's/# threads=8/threads=256/g' /etc/nfs.conf
sudo systemctl enable --now nfs-server rpcbind

# Change Linux kernel from UEK to RHCK
echo "Start changing kernel to RHCK"
vmlinuz=`sudo grubby --info=ALL | grep ^kernel= | grep -v -e uek -e rescue | awk -F\" '{print $2}'`
sudo grubby --set-default $vmlinuz
sudo sed -i 's/kernel-uek/kernel/g' /etc/sysconfig/kernel
