resource "yandex_vpc_network" "yc_network" {

  #1 из попыток автоматизировать присвоениe имен. но вообще - это ерунда, т.к. берется значение yc_instance_count. т.е. если это 2 - то,если 3 - то 3.
  # и никак не меняется. если сетей несколько, добавляется [номер с 0]
  name = "vpc-network-${local.yc_instance_count[terraform.workspace]}"

  #Это не работает, так как "The "count" object can only be used in "module", "resource", and "data" blocks, and only when the "count" argument is set"
  /*name = "vpc-network-${count.index[terraform.workspace]}"*/
}

resource "yandex_vpc_subnet" "yc_subnet" {
  /*абсолютно не понимаю значение этого блока из документации Яндекс. Блок адаптировал под применение воркспейс.
  count          = "${local.yc_instance_count[terraform.workspace] > length(var.yandex_region_id)}"
  Решил удалить вот это вот  > length(var.yandex_region_id)}. вроде, получилось.
  */
/*  т.к. не вышло использовать yandex_vpc_subnet.yc_subnet[count.index] в yc instance in NODE01, пришлось отказаться от использования параметра count
count          = local.yc_instance_count[terraform.workspace]*/
  name           = "yc_subnet"
  zone           = local.vpc_subnets_zone[terraform.workspace]
  /*
  Vyacheslav Sukharev, [16.07.2022 22:37]
[В ответ на Синица Михаил]
local.vpc_subnets[terraform.workspace].zone и v4_cidr_blocks соответственно. А network_id так вообще определять нельзя, его надо брать из созданного выше обьекта
  network_id     = "${local.vpc_subnets[terraform.workspace]}"*/
  network_id     = yandex_vpc_network.yc_network.id
  v4_cidr_blocks = local.vpc_subnets_v4-cidr[terraform.workspace]
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
