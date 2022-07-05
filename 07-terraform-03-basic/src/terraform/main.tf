resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"
  platform_id = local.yc_instance_type_map[terraform.workspace]
  /*
  #нет здесь параметра instance_count
  instance_count = local.yc_instance_count[terraform.workspace]*/
  count = local.yc_instance_count[terraform.workspace]
  resources {
    cores  = local.yc_cores[terraform.workspace]
    memory = 2
 /*   disk_size = local.yc_disk_size[terraform.workspace]*/
  }

  boot_disk {
    initialize_params {
      image_id = "fd8f1tik9a7ap9ik2dg1"
    }
  }

  network_interface {
    /*subnet_id = yandex_vpc_subnet.subnet-1.id*/
    subnet_id = local.vpc_subnets[terraform.workspace]
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

