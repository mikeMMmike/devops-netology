resource "yandex_compute_instance" "nginx" {
  /*name = "mycompanyname.ru"*/
  name = "web-server"
  hostname = "mycompanyname.ru"
  platform_id = local.yc_instance_type_map[terraform.workspace]
  count = local.yc_instance_count[terraform.workspace]
  zone = local.vpc_zone[terraform.workspace]
    resources {
    cores  = 2
    memory = 2
      }
  boot_disk {
    initialize_params {
      image_id = "fd8f1tik9a7ap9ik2dg1"
      size = local.yc_disk_size[terraform.workspace]
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.yc_subnet.id
    nat       = true
    nat_ip_address = "62.84.118.229"
    ip_address = "192.168.1.2"
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
  resource "null_resource" "ansible-install" {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = format("ansible-playbook -D -i %s, -u ubuntu ../ansible/nginx/provision.yml",
    join("\",\"", yandex_compute_instance.nginx[*].network_interface.0.nat_ip_address)
    )
  }
  }