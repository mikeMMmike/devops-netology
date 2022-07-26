resource "yandex_compute_instance" "nginx" {
  name = "web"
  hostname = "mycompanyname.ru"
  platform_id = local.yc_instance_type_map[terraform.workspace]
  /*count = local.yc_instance_count[terraform.workspace]*/
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
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
/*
  Вариант с запуском playbook. Позже переделал в роль. строку закомментил
  resource "null_resource" "ansible-install" {

    triggers = {
      always_run = "${timestamp()}"
    }


provisioner "local-exec" {
    command = format("sleep 40 && ssh-keyscan 62.84.118.229 >> ~/.ssh/known_hosts && ansible-playbook -D -i %s, -u ubuntu ../ansible/nginx/provision.yml",
    join("\",\"", yandex_compute_instance.nginx[*].network_interface.0.nat_ip_address)
    )
  }
 Не удалось сформировать корректный inventory файл. посему отложил это решение
    provisioner "local-exec" {
      command = format(" sleep 30 && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/nginx/provision.yml" #, join("\",\"", yandex_compute_instance.nginx[*].network_interface.0.nat_ip_address)
    )
    }
  }*/
