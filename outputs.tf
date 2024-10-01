output "NFS_server_instances_created" {
  value            = {
    "display_name" = var.inst_params_nfs.display_name
    "private_ip  " = oci_core_instance.nfs-srv.private_ip
  }
}
