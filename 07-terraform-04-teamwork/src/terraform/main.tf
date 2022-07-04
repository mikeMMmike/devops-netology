resource "yandex_compute_instance_group" "group1" {
  name                = "test_yc_ig"
  folder_id           = "${var.yandex_folder_id}"
  service_account_id  = "${var.yandex_cloud_id}"
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd81hgrcv6lsnkremf32"
        size     = 4
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.default.id}"
      subnet_ids = ["${yandex_vpc_subnet.default.id}"]
    }
    metadata = {
      foo      = "bar"
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
}