locals {
  yc_instance_type_map = {
       stage = "standard-v1"
       prod = "standard-v2"
     }
  yc_cores = {
    stage = 1
    prod = 2
  }
  yc_disk_size = {
    stage = 20
    prod = 40
  }
  yc_instance_count = {
    stage = 1
    prod = 2
  }
}