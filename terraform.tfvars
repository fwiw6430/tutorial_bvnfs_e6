#compartment_ocid             = "xxxx"
#ad                           = "xxxx"
#ssh_key                      = "xxxx"
#exist_vcn                    = true
#vcn_ocid                     = "xxxx"
#storage_ocid                 = "xxxx"
#nfs_ocid                     = "xxxx"

user_name                     = "opc"

inst_params_nfs               = {
  display_name                = "nfs-srv"
  shape                       = "BM.Optimized3.36"
  image_name                  = "Oracle-Linux-9.5-2025.04.16-0"
  boot_vol_size               = 50
  cloud_config                = "cloud-init_nfs.cfg"
  secondary_vnis_display_name = "nfs-srv2"
}

bv_params                     = {
  vol_count                   = 15
  vpus_per_gb                 = 10
}

rm_pend_display_name          = "rmpe_nfs"
