#Копия 1 из вариантов конфигурации. Не стоит рассматривать это.




/*
resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"
  platform_id = local.yc_instance_type_map[terraform.workspace]
  instance_count = local.yc_instance_count[terraform.workspace]
  resources {
    cores  = local.yc_cores[terraform.workspace]
    memory = 2
    disk_size = local.yc_disk_size[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = "fd8f1tik9a7ap9ik2dg1"
    }
  }

  network_interface {
    */
/*subnet_id = yandex_vpc_subnet.subnet-1.id*//*

    subnet_id = local.vpc_subnets[terraform.workspace]
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}


*/
/*resource "yandex_compute_instance" "vm-2" {
  name = "terraform2"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8f1tik9a7ap9ik2dg1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}*//*



resource "yandex_vpc_network" "network-1" {
  */
/*name = "vpc-network-${local.yc_instance_count[terraform.workspace]}"*//*

  name = "vpc-network-${count.index}"
}

resource "yandex_vpc_subnet" "subnet-1" {
  count          = "${local.yc_instance_count[terraform.workspace] > length(var.yc_region)}"
  */
/*name           = "yc-auto-subnet-${local.yc_instance_count[terraform.workspace]}"*//*

  name           = "yc-auto-subnet-${count.index}"
  */
/*name           = "subnet1"*//*

  zone           = "ru-central1-a"
  network_id     = local.vpc_subnets[terraform.workspace]
  */
/*network_id     = yandex_vpc_network.network-1.id*//*

  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
output "subnet-1" {
  value = yandex_vpc_subnet.subnet-1.id
}

*/
/*
output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}
*//*

#*/
/*
#output "external_ip_address_vm_2" {
#  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
#}
#*//*

#
*/



/*
#Оригинальный конфиг ВМ из документации яндекса.  В доке рассматривается поднятие 2 ВМ, описанных вручную отдельно. Ниже конфигурация второй машины
resource "yandex_compute_instance" "vm-2" {
  name = "terraform2"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8f1tik9a7ap9ik2dg1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}*/





#КОнфа взята из репозитория преподавателя, который вел лекцию по теме. адрес: https://gitlab.com/k11s-os/infrastructure-as-code/-/tree/main/terraform


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
