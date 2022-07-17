/* КОНФА ИЗ ДИПЛОМА. РАБОТОСПОСОБНАЯ С ОГОВОРКАМИ. ПОЛУЧИЛОСЬ ТОЛЬКО ПО 1 УЗЛУ В КАЖДОМ ВОРКСПЕЙСЕ СОБРАТЬ
resource "yandex_compute_instance" "test-server" {
  name = "testserver"
  # вот уж не знаю,почему, но при count >= 2 появляется ошибка. YC ругается на не верное имя:
#  rpc error: code = InvalidArgument desc = Request validation error: Name: invalid resource name
#поэтому все варианты, что ниже,закомменчены, имя захардкожено и count в locals равняется 1. решения на 17.07.22 не нашел
  */
/*name = "${var.name}-${format(var.count_format, var.count_offset+count.index+1)}"*//*

  */
/*name = "test-server-[${count.index+1}]"*//*

  platform_id = local.yc_instance_type_map[terraform.workspace]
  count = local.yc_instance_count[terraform.workspace]
  zone = local.vpc_zone[terraform.workspace]
  */
/*hostname = "test-server-[${count.index+1}]"*//*

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
    */
/*yandex_vpc_network.yc_network.id*//*

    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

*/


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

