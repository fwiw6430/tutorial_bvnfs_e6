variable "user_name" { 
  description          = "User name to be used to access instances via SSH"
  type                 = string
} 
variable "inst_params_nfs" {
  description          = "Instance parameters for bastion"
  type                 = map(string)
}
variable "bv_params" {
  description          = "Block volume parameters"
  type                 = map(string)
}
variable "rm_pend_display_name" {
  description          = "Resource manager private endpoint display name"
  type                 = string
}

# Variables under are defined in schema.html
variable "compartment_ocid" {
  description          = "Compartment OCID where resources reside"
  type                 = string
}
variable "ad" {
  description          = "Availability Domain where OCI resources reside"
  type                 = string
}
variable "ssh_key" {
  description          = "SSH public key to login bastion"
  type                 = string
}
variable "exist_vcn" {
  description          = "Deploy HPC/GPU cluster on existing VCN"
  type                 = bool
}
variable "vcn_ocid" { 
  description          = "Pre-exsisting VCN OCID" 
  type                 = string
  default              = ""
}
#variable "storage_ocid" { 
#  description          = "Pre-exsisting block volume subnet OCID" 
#  type                 = string
#  default              = ""
#}
variable "nfs_ocid" { 
  description          = "Pre-exsisting NFS subnet OCID" 
  type                 = string
  default              = ""
}
variable "bv_total_size" { 
  description          = "Block volume total size in GB"
  type                 = number
}
