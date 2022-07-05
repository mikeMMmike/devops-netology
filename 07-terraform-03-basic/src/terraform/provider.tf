terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
  # Backend settings
backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-bkt"
    region     = "ru-central1-a"
    key        = "./state.tfstate"
    access_key = "YCAJE1iVY7uFFmlmV6pYvSnmM"
    secret_key = "YCMGusqDVuEiHlJE5ow5bmu-dq-qyD36eHX46M5s"

    skip_region_validation      = true
    skip_credentials_validation = true
}

}

# Provider
provider "yandex" {
  token     = "${var.yandex_tocken}"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone      = "ru-central1-a"
}
