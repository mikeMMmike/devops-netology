terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
# в данном ДЗ использовал системные переменные для работы с YC, но можно было cloud_id и folder_id
# переменные указать как ${var.yandex_cloud_id} и ${var.yandex_folder_id} из ./variables
provider "yandex" {
  token     = "$YC_TOKEN"
  cloud_id  = "$yandex_cloud_id"
  folder_id = "$yandex_folder_id"
  zone      = "ru-central1-b"
}
