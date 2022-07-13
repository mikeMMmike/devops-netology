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
  vpc_subnets = {
    stage = [
      {
        zone           = "ru-central1-a"
        v4_cidr_blocks = ["10.128.0.0/24"]
      }
    ]
    /*stage = [
      {
        "v4_cidr_blocks": [
          "10.128.0.0/24"
        ],
        "zone": var.yandex_region_id
      }
    ]*/
    prod = [
      {
        zone           = "ru-central1-a"
        v4_cidr_blocks = ["10.128.0.0/24"]
      },
      {
        zone           = "ru-central1-b"
        v4_cidr_blocks = ["10.129.0.0/24"]
      }
      /*
      #В лекциях советовали вовсе не использовать эту зону, т.к. с ней часто возникают проблемы. по слухам, в YC того же мнения.
      {
        zone           = "ru-central1-c"
        v4_cidr_blocks = ["10.130.0.0/24"]
      }*/
    ]
  }
}