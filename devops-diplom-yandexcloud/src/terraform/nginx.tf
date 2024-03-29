resource "yandex_compute_instance" "nginx" {
  name = "web"
  hostname = "mycompanyname.ru"
  platform_id = local.yc_instance_type_map[terraform.workspace]
  zone = local.vpc_zone[terraform.workspace]
    resources {
    core_fraction = 20
    cores  = 2
    memory = 2

      }
  scheduling_policy {
    preemptible = true
}

  boot_disk {
    initialize_params {
      image_id = "fd8f1tik9a7ap9ik2dg1" //Ubunutu2004
      size = local.yc_disk_size[terraform.workspace]
    }

  }

  network_interface {
    subnet_id = yandex_vpc_subnet.yc_subnet.id
    nat       = true
    nat_ip_address = "62.84.118.229"
    ip_address = "192.168.1.12"
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yc_diplom.pub")}"
  }
}
