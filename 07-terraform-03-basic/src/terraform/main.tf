/*
module "vpc" {
  source  = "hamnsk/vpc/yandex"
  version = "0.5.0"
  description = "managed by terraform"
  create_folder = length(var.yc_folder_id) > 0 ? false : true
  name = terraform.workspace
  subnets = local.vpc_subnets[terraform.workspace]
}
*/


/*module "news" {
  source = "./modules/instance"
  instance_count = local.news_instance_count[terraform.workspace]

  subnet_id     = module.vpc.subnet_ids[0]
  zone = var.yc_region
  folder_id = module.vpc.folder_id
  image         = "centos-7"
  platform_id   = "standard-v2"
  name          = "news"
  description   = "News App Demo"
  instance_role = "news,balancer"
  users         = "centos"
  cores         = local.news_cores[terraform.workspace]
  boot_disk     = "network-ssd"
  disk_size     = local.news_disk_size[terraform.workspace]
  nat           = "true"
  memory        = "2"
  core_fraction = "100"
  depends_on = [
    module.vpc
  ]
}*/


#locals {
#/*  news_cores = {
#    stage = 2
#    prod = 2
#  }
#  news_disk_size = {
#    stage = 20
#    prod = 40
#  }
#  news_instance_count = {
#    stage = 1
#    prod = 2
#  }*/
#
#}
