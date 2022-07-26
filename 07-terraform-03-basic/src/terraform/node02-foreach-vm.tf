resource "yandex_compute_instance" "server02" {
  name = ""
  platform_id = local.yc_instance_type_map[terraform.workspace]
  for_each = local.id
  zone = local.vpc_zone[terraform.workspace]
  hostname = ""

  resources {
    cores  = local.yc_cores[terraform.workspace]
    memory = local.yc_mem[terraform.workspace]
      }
  boot_disk {
    initialize_params {
      image_id = "fd8f1tik9a7ap9ik2dg1" //ubuntu 2004
      size = local.yc_disk_size[terraform.workspace]
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.yc_subnet.id
    nat       = false
    ip_address = ""
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
