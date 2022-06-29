

resource "yandex_compute_instance_group" "group1" {
  name                = "test-ig"
  folder_id           = "${data.yandex_resourcemanager_folder.test_folder.id}"
  service_account_id  = "${yandex_iam_service_account.test_account.id}"
  deletion_protection = true
  instance_template {
    platform_id = local.yc_instance_type_map[terraform.workspace]
    resources {
      memory = 2
      cores  = local.yc_cores[terraform.workspace]
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8f1tik9a7ap9ik2dg1"
        size     = local.yc_disk_size[terraform.workspace]
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.my-inst-group-network.id}"
      subnet_ids = ["${yandex_vpc_subnet.my-inst-group-subnet.id}"]
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
}