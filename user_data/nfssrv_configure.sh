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

echo "Start creating volume group"
sudo vgcreate bv $bv_dev_list
echo "Start creating logical volume"
sudo lvcreate -y -l 100%FREE -n bv bv
echo "Start formatting XFS file system"
sudo mkfs.xfs -L blockvolume /dev/bv/bv
echo "LABEL=blockvolume /mnt/bv/ xfs defaults,noatime 0 0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo mkdir -p /mnt/bv
echo "Start mounting file system"
sudo mount /mnt/bv
echo "Start configuring secondary NIC"
sudo oci-network-config configure
echo "/mnt/bv 10.0.2.0/24(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
sudo sed -i 's/# threads=8/threads=64/g' /etc/nfs.conf
echo "Start NFS server"
sudo systemctl enable --now nfs-server rpcbind
