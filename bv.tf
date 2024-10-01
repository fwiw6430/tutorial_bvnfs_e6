resource "oci_core_volume" "bv" {
  count                             = var.bv_params.vol_count
  availability_domain               = var.ad
  compartment_id                    = var.compartment_ocid
  display_name                      = "bv${count.index}"
  size_in_gbs                       = var.bv_total_size / var.bv_params.vol_count
  vpus_per_gb                       = var.bv_params.vpus_per_gb
}

resource "oci_core_volume_attachment" "bv_attach" {
  count                             = var.bv_params.vol_count
  attachment_type                   = "iscsi"
  instance_id                       = element(oci_core_instance.nfs-srv.*.id, count.index)
  volume_id                         = element(oci_core_volume.bv.*.id, count.index)
  is_agent_auto_iscsi_login_enabled = true
}
