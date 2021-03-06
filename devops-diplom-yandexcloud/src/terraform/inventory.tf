resource "local_file" "inventory" {
  content = <<-DOC
    # Ansible inventory containing variable values from Terraform.
    # Generated by Terraform.

[nginx]
mycompanyname.ru
[mysql]
db01.mycompanyname.ru mysql_server_id=1 mysql_replication_role=master
db02.mycompanyname.ru mysql_server_id=2 mysql_replication_role=slave
[wordpress]
app.mycompanyname.ru
[monitoring]
monitoring.mycompanyname.ru
[gitlab]
gitlab.mycompanyname.ru
[runner]
runner.mycompanyname.ru

[nodes:children]
    mysql
[nodes:vars]
ansible_ssh_common_args= "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -J ubuntu@mycompanyname.ru"



    DOC
  filename = "../ansible/inventory"

/*  depends_on = [yandex_compute_instance.nginx]*/

/*[
    yandex_compute_instance.node02,
    yandex_compute_instance.node03,
    yandex_compute_instance.node04,
    yandex_compute_instance.node05,
    yandex_compute_instance.node06
    ]
*/
  #[all:vars]
#ansible_ssh_common_args= "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -J ubuntu@mycompanyname.ru"
}