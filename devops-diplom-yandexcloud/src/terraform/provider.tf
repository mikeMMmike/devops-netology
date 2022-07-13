terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }



  # YC Bucket
  # Needs!!!
  # Чтобы не светить ключи, необходимо экспортировать переменные перед инициализацией терраформ:
  # export AWS_ACCESS_KEY_ID=YC_access_key
  # export AWS_SECRET_ACCESS_KEY=YC_secret_key

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-diplom-devops"
    region     = "ru-central1"
    key        = "stage/terraform-stage.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  /*  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
      bucket     = "netology-diplom-devops"
      region     = "ru-central1-a"
      key        = "stage/terraform-stage.tfstate"
      access_key = "YCA"
      secret_key = "YCM"

      skip_region_validation      = true
      skip_credentials_validation = true
  }*/

}
  # Provider
  provider "yandex" {
    token     = "${var.yandex_token}"
    cloud_id  = "${var.yandex_cloud_id}"
    folder_id = "${var.yandex_folder_id}"
    zone      = "${var.yandex_region_id}"
  }



