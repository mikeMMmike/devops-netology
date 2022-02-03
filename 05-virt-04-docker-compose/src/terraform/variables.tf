# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1gr73vuc1ps9acsmo1c"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1g3bh3ss0hbu8t6droq"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7-base" {
#  default = "f2eacrudv331nbat9ehb"
  default = "fd8ii3dh9ua63uvagqgv"
}
