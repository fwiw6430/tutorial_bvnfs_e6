#!/bin/bash
declare -a ar_bv_dev_name=("/dev/sdb" "/dev/sdc" "/dev/sdd" "/dev/sde" "/dev/sdf" "/dev/sdg" "/dev/sdh" "/dev/sdi" "/dev/sdj" "/dev/sdk" "/dev/sdl" "/dev/sdm" "/dev/sdn" "/dev/sdo" "/dev/sdp")
bv_dev_list=""
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

echo $bv_dev_list
#echo "Start creating volume group"
#sudo vgcreate bv $bv_dev_list
#echo "Start creating logical volume"
#sudo lvcreate -y -l 100%FREE --stripes 15 --stripesize "64K" -n bv bv
#echo "Start formatting XFS file system"
#sudo mkfs.xfs -L blockvolume /dev/bv/bv
echo "LABEL=blockvolume /mnt/bv/ xfs defaults,_netdev,noatime 0 0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo mkdir -p /mnt/bv
#echo "Start mounting file system"
#sudo mount /mnt/bv
echo "/mnt/bv (rw,sync,no_root_squash)" | sudo tee -a /etc/exports
sudo sed -i 's/# threads=8/threads=256/g' /etc/nfs.conf
echo "Start NFS server"
sudo systemctl enable --now nfs-server rpcbind
echo "Start changing kernel to RHCK"
vmlinuz=`sudo grubby --info=ALL | grep ^kernel= | grep -v -e uek -e rescue | awk -F\" '{print $2}'`
sudo grubby --set-default $vmlinuz
sudo sed -i 's/kernel-uek/kernel/g' /etc/sysconfig/kernel
