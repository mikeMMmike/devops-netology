#"Мудреная" конфигурация. пытаюсь адаптировать под задачу
resource "yandex_vpc_network" "network-1" {

  #1 из попыток автоматизировать присвоениe имен:
  name = "vpc-network-${local.yc_instance_count[terraform.workspace]}"

  #Это не работает, так как "The "count" object can only be used in "module", "resource", and "data" blocks, and only when the "count" argument is set"
  /*name = "vpc-network-${count.index}"*/
}

resource "yandex_vpc_subnet" "subnet-1" {
  /*абсолютно не понимаю значение этого блока из документации Яндекс. Блок адаптировал под применение воркспейс.
  count          = "${local.yc_instance_count[terraform.workspace] > length(var.yandex_region_id)}"
  Решил удалить вот это вот  > length(var.yandex_region_id)}. вроде, получилось.
  */
  count          = "${local.yc_instance_count[terraform.workspace]}"
  /*name           = "yc-auto-subnet-${local.yc_instance_count[terraform.workspace]}"*/
  name           = "yc-auto-subnet-${count.index}"
  /*
  #Оригинальный конфиг:
  name           = "subnet1"*/
  zone           = local.vpc_subnets[terraform.workspace]
  /*
  #Оригинальный конфиг:
  zone           = "ru-central1-a"*/
  network_id     = "${local.vpc_subnets[terraform.workspace]}"
  /*network_id     = yandex_vpc_network.network-1.id*/
  v4_cidr_blocks = "${local.vpc_subnets[terraform.workspace]}"
  #v4_cidr_blocks = ["192.168.10.0/24"]
}











/*
# Оригинальные параметры из документации Яндекс. Необходимо использовать лишь 1 из конфигураций
output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}
*/
#/*
#output "external_ip_address_vm_2" {
#  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
#}
#*/
#

/*
#Еще оригинальные параметры из документации Яндекс.
# Network
resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}*/
