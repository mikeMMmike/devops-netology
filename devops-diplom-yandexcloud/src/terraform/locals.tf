locals {
  yc_instance_type_map = {
    stage = "standard-v1"
    prod  = "standard-v2"
  }
  yc_cores = {
    stage = 2
    prod  = 4
  }
  yc_disk_size = {
    stage = 10
    prod  = 20
  }
  yc_instance_count = {
    stage = 1
    prod  = 1
  }
  yc_mem = {
    stage = 4
    prod  = 8
  }
  vpc_zone = {
    stage = "ru-central1-a"
    prod  = "ru-central1-b"
  }
  vpc_subnets_v4-cidr = {
    stage = ["10.128.0.0/24"]
    prod  = ["10.128.0.0/24", "10.129.0.0/24"]
  }
}
    /* копия предыдущего конфига
    vpc_subnets = {
    stage = [
      {
        zone           = "ru-central1-a"
        v4_cidr_blocks = ["10.128.0.0/24"]
      }
    ]
    prod = [
      {
        zone           = "ru-central1-a"
        v4_cidr_blocks = ["10.128.1.0/24"]
      },
      {
        zone           = "ru-central1-b"
        v4_cidr_blocks = ["10.129.0.0/24"]
      }*/
      /*
      #В лекциях советовали вовсе не использовать эту зону, т.к. с ней часто возникают проблемы. по слухам, в YC того же мнения.
      {
        zone           = "ru-central1-c"
        v4_cidr_blocks = ["10.130.0.0/24"]
      }*/