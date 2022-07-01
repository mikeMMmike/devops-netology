resource "yandex_compute_instance_group" "group1" {
  name                = "test-ig"
  folder_id           = ""
  service_account_id  = ""
  deletion_protection = true
  instance_template {
    platform_id = local.yc_instance_type_map[terraform.workspace]
    resources {
      memory = 2
      cores  = local.yc_cores[terraform.workspace]
      instance_count = local.yc_instance_count[terraform.workspace]
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8f1tik9a7ap9ik2dg1"
        size     = local.yc_disk_size[terraform.workspace]
      }
    }
    network_interface {
      network_id = "yandex_vpc_network.network-1.id"
      subnet_ids = ["yandex_vpc_subnet.subnet-1.id"]
    }
    labels = {
      label1 = "label1-value"
      label2 = "label2-value"
    }
    metadata = {
      foo      = "bar"
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
    network_settings {
      type = "STANDARD"
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
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}