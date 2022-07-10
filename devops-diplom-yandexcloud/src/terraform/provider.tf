terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  # Provider
  provider "yandex" {
    token     = "${var.yandex_token}"
    cloud_id  = "${var.yandex_cloud_id}"
    folder_id = "${var.yandex_folder_id}"
    zone      = "${var.yandex_region_id}"
  }
  # YC Bucket
  # Needs:
  # export AWS_ACCESS_KEY_ID={access_key}
  # export AWS_SECRET_ACCESS_KEY={secret_key}

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-diplom-devops"
    region     = "ru-central1"
    key        = "stage/terraform-stage.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

/*terraform {
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
    key        = ".*//****state.tfstate"
    access_key = "YCAJ******"
    secret_key = "YCM*******"

    skip_region_validation      = true
    skip_credentials_validation = true
}

}*/


