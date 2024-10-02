resource "tls_private_key" "ssh" {
  algorithm                 = "RSA"
  rsa_bits                  = "4096"
}

data "oci_core_images" "nfs-srv" {
  compartment_id            = var.compartment_ocid
  shape                     = var.inst_params_nfs.shape
  sort_by                   = "TIMECREATED"
  sort_order                = "DESC"
  filter {
    name                    = "display_name"
    values                  = [var.inst_params_nfs.image_name]
    regex                   = false
  }
}

resource "oci_core_instance" "nfs-srv" {
  compartment_id            = var.compartment_ocid
  display_name              = var.inst_params_nfs.display_name
  availability_domain       = var.ad
  shape                     = var.inst_params_nfs.shape
  create_vnic_details {
    subnet_id               = var.exist_vcn ? var.storage_ocid : oci_core_subnet.storage[0].id
    assign_public_ip        = false
  }
  source_details {
    source_id               = data.oci_core_images.nfs-srv.images[0].id
    source_type             = "image"
    boot_volume_size_in_gbs = var.inst_params_nfs.boot_vol_size
  }
  metadata                  = {
    ssh_authorized_keys     = "${var.ssh_key}\n${tls_private_key.ssh.public_key_openssh}"
    user_data               = "${base64encode(file("./user_data/cloud-init_nfs.cfg"))}"
  }
  preserve_boot_volume      = false
  agent_config {
    plugins_config {
      desired_state         = "ENABLED"
      name                  = "Block Volume Management"
    }
  }   
}

resource "oci_core_vnic_attachment" "nfs-srv" {
  count                     = 1
  create_vnic_details {
    subnet_id               = var.exist_vcn ? var.nfs_ocid : oci_core_subnet.nfs[0].id
    assign_public_ip        = "false"
    display_name            = var.inst_params_nfs.secondary_vnis_display_name
    hostname_label          = var.inst_params_nfs.display_name
  }
  instance_id               = element(oci_core_instance.nfs-srv.*.id, count.index)
  nic_index                 = 1
}

resource "null_resource" "nfs-srv" {
  depends_on                = [oci_core_instance.nfs-srv]
  provisioner "file" {
    source                  = "./user_data/nfssrv_configure.sh"
    destination             = "/home/${var.user_name}/nfssrv_configure.sh"
    connection {
      host                  = data.oci_resourcemanager_private_endpoint_reachable_ip.rmpe_nfs_ip[0].ip_address
      type                  = "ssh"
      user                  = var.user_name
      private_key           = tls_private_key.ssh.private_key_pem
    }   
  }
  provisioner "remote-exec" {
    inline                  = [
      "chmod 755 /home/${var.user_name}/nfssrv_configure.sh",
      "/home/${var.user_name}/nfssrv_configure.sh",
    ]   
    connection {
      host                  = data.oci_resourcemanager_private_endpoint_reachable_ip.rmpe_nfs_ip[0].ip_address
      type                  = "ssh"
      user                  = var.user_name
      private_key           = tls_private_key.ssh.private_key_pem
    }   
  }
}

resource "oci_resourcemanager_private_endpoint" "rms_private_endpoint" {
  count                     = 1
  compartment_id            = var.compartment_ocid
  display_name              = var.rm_pend_display_name
  vcn_id                    = var.exist_vcn ? var.vcn_ocid : oci_core_virtual_network.vcn[0].id
  subnet_id                 = var.exist_vcn ? var.storage_ocid : oci_core_subnet.storage[0].id
}

data "oci_resourcemanager_private_endpoint_reachable_ip" "rmpe_nfs_ip" {
    count                   = 1
    private_endpoint_id     = oci_resourcemanager_private_endpoint.rms_private_endpoint[0].id
    private_ip              = tostring(oci_core_instance.nfs-srv.private_ip)
}
