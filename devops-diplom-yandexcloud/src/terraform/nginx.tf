resource "yandex_compute_instance" "nginx" {
  name = "mycompanyname.ru"
  platform_id = local.yc_instance_type_map[terraform.workspace]
  count = local.yc_instance_count[terraform.workspace]
  zone = local.vpc_zone[terraform.workspace]
    resources {
    cores  = local.yc_cores[terraform.workspace]
    memory = local.yc_mem[terraform.workspace]
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
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
  resource "null_resource" "ansible-install" {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = format("ansible-playbook -D -i %s, -u ${var.data["account"]} ../ansible/nginx/provision.yml",
    join("\",\"", yandex_compute_instance.nginx[*].network_interface.0.nat_ip_address)
    )
  }
}