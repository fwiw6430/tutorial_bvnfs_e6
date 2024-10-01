#compartment_ocid   = "ocid1.compartment.oc1..aaaaaaaaunve4zxbocxmh3e75l567c5tffah3red5jfjl4whpiksqrujn33a"
#ad                 = "TGjA:AP-TOKYO-1-AD-1"
#ssh_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCf5pkef2csDdtiZPuiz9KmwxJcXvkKrkEFEQGI44phzDxjwrtXmvxBFqly8zgUdF7ECtAu+hl53DAwjJLuZd2UpWpC4H5WSD1QluDoP6DG7cPYT3aczrrldAphyiphjl7Uz26Yb16vov9ul+/zdCokWPPBd8IVeGytrRdDf///dpyXw7jTv0I9ukis5Y6MzapxHKZKj54SH/SFZp9clcG2o4xcK+FAMlboWif3zYn8fB0Ca98ObqlhLI+ME8QAKrshDUXqYyjVmARXNz7IHhiMO5sALgjpOPM8nV3byLz+pDH1Nzl2anrz1bN/Rx0w5LFk1wbRiTo1Mae1imKWlcZUay6ts686ubYDG5HupUBW/va5cmNnnSnxy+U3VXllbQj9vWDbfi2Tw17I/4HzI2qNtaDpLzpiKHxIWuWqM35GiRWmwDZwjxM0a+RUFGvvqtLiuIUGC7UGOJ2IjTV0Ao22n3alZF5E4h6sPy/9Y87pUDFoy6pcVePDevybBAnEaNU= opc@TMIYASHI-7420"
#exist_vcn          = true
#vcn_ocid           = "ocid1.vcn.oc1.ap-tokyo-1.amaaaaaassl65iqajp7dwztiouxmg65mkkl3ydudeuwfs4ekknjvy6qoosea"
#storage_ocid       = "ocid1.subnet.oc1.ap-tokyo-1.aaaaaaaamc6s7berzdpgzqbiiicpfjmbl6qkuedzvpdfbckoc2flxrcnf4aq"
#nfs_ocid           = "ocid1.subnet.oc1.ap-tokyo-1.aaaaaaaaqpyi456qlfp6uaerpjpuylw4do66iure6giyqaeutdy4wwvomz2a"

user_name            = "opc"

inst_params_nfs      = {
  display_name       = "nfs-srv"
  shape              = "BM.Optimized3.36"
  image_name         = "Oracle-Linux-9.4-2024.08.29-0"
  boot_vol_size      = 50
  cloud_config       = "cloud-init_nfs.cfg"
}

bv_params            = {
  vol_count          = 15
#  vol_size           = 1000
  vpus_per_gb        = 10
}

rm_pend_display_name = "rmpe_nfs"
