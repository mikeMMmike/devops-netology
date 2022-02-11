Задача 1
=====
Дайте письменые ответы на следующие вопросы:

* В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
* Какой алгоритм выбора лидера используется в Docker Swarm кластере?
* Что такое Overlay Network?

Ответ
-----
В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
* Репликация - по несколько задач(микросервисов) на каждой ноде кластера
* В режиме глобального сервиса - 1 нода используется для 1 микросервиса.

Какой алгоритм выбора лидера используется в Docker Swarm кластере?
В Docker Swarm кластере используется алгоритм выбора лидера Raft. Он имеет ряд приемуществ:
* разделение крупных задач до мелких
* явно выделенный лидер. т.е. лидер в текущий момент времени может быть только один
* протоколы работы не содержат пропусков, т.е. записи добавляются строго последовательно
* изменение размера кластера без перезапуска

Что такое Overlay Network?
* Overlay Network - это подсеть использующаяся микросервисами в Docker Swarm кластере. Предпочтение необходимо отдавать в данном случае расположению нод в 1 подсети для ускорения выбора управляющей ноды в случае перевыбора.



Задача 2
=====
Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

docker node ls

Ответ.
-----



Листинг действий.
Создаем сеть и подсеть:
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/packer$ yc vpc network create --name net --labels my-label=netology --description "yc-network-docker-swarm"
id: enp5m1n85cjg37fqp7je
folder_id: b1g3bh3ss0hbu8t6droq
created_at: "2022-02-10T22:36:54Z"
name: net
description: yc-network-docker-swarm
labels:
  my-label: netology

mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/packer$ yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "docker-swarm-subnet"
id: e9bvbihenbdj0frsef9h
folder_id: b1g3bh3ss0hbu8t6droq
created_at: "2022-02-10T22:45:24Z"
name: my-subnet-a
description: docker-swarm-subnet
network_id: enp5m1n85cjg37fqp7je
zone_id: ru-central1-a
v4_cidr_blocks:
- 10.1.2.0/24
```

Проверим корректность packer-файла и запустим создание образа:
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/packer$ packer validate ./centos-7-base.json 
The configuration is valid.
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/packer$ packer build centos-7-base.json 
yandex: output will be in this color.

==> yandex: Creating temporary RSA SSH key for instance...
==> yandex: Using as source image: fd8gdnd09d0iqdu7ll2a (name: "centos-7-v20220207", family: "centos-7")

......................
//////////////////////
сокращение stdout-многабукаф
//////////////////////
......................

Build 'yandex' finished after 3 minutes 24 seconds.

==> Wait completed after 3 minutes 24 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: centos-7-base (id: fd85r4ppkktfdr7i9ma5) with family name centos
```
Образ готов. Удалим подсеть и сеть, использованные для сборки:
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/terraform$ yc vpc subnet delete e9bvbihenbdj0frsef9h
done (5s)
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/terraform$ yc vpc network delete enp5m1n85cjg37fqp7je
```

Создаем кластер вм. 
Проведем инициализацию terraform:
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/terraform$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/null...
- Finding latest version of hashicorp/local...
- Finding latest version of yandex-cloud/yandex...
- Installing hashicorp/local v2.1.0...
- Installed hashicorp/local v2.1.0 (signed by HashiCorp)
- Installing yandex-cloud/yandex v0.71.0...
- Installed yandex-cloud/yandex v0.71.0 (self-signed, key ID E40F590B50BB8E40)
- Installing hashicorp/null v3.1.0...
- Installed hashicorp/null v3.1.0 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```
Сгенерируем ключ для сервисной учетки в директории netology Я.облака:

```bash
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/terraform$ yc iam key create --folder-name netology --service-account-name netology-bot --output key.json
id: ajeq3p75a1tp6libq5eq
service_account_id: ajegbpaaepj7qhru4hun
created_at: "2022-02-10T23:11:45.696242332Z"
key_algorithm: RSA_2048
```

Запустим проверку конфиг-файла terraform и terraform plan:
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/terraform$ terraform validate
Success! The configuration is valid.

mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/terraform$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.inventory will be created
  + resource "local_file" "inventory" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "../ansible/inventory"
      + id                   = (known after apply)
    }

  # null_resource.cluster will be created
  + resource "null_resource" "cluster" {
      + id = (known after apply)
    }

  # null_resource.monitoring will be created
  + resource "null_resource" "monitoring" {
      + id = (known after apply)
    }

  # null_resource.sync will be created
  + resource "null_resource" "sync" {
      + id = (known after apply)
    }

  # null_resource.wait will be created
  + resource "null_resource" "wait" {
      + id = (known after apply)
    }

......................
//////////////////////
сокращение stdout-многабукаф
//////////////////////
......................

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 13 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_node01 = (known after apply)
  + external_ip_address_node02 = (known after apply)
  + external_ip_address_node03 = (known after apply)
  + external_ip_address_node04 = (known after apply)
  + external_ip_address_node05 = (known after apply)
  + external_ip_address_node06 = (known after apply)
  + internal_ip_address_node01 = "192.168.101.11"
  + internal_ip_address_node02 = "192.168.101.12"
  + internal_ip_address_node03 = "192.168.101.13"
  + internal_ip_address_node04 = "192.168.101.14"
  + internal_ip_address_node05 = "192.168.101.15"
  + internal_ip_address_node06 = "192.168.101.16"

```
Запустим создние ВМ при помощи terraform:
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/terraform$ terraform apply -auto-approve

......................
//////////////////////
сокращение stdout-многабукаф
//////////////////////
......................

Outputs:

external_ip_address_node01 = "62.84.117.113"
external_ip_address_node02 = "62.84.127.60"
external_ip_address_node03 = "51.250.8.221"
external_ip_address_node04 = "62.84.115.243"
external_ip_address_node05 = "51.250.15.164"
external_ip_address_node06 = "62.84.126.21"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"

```

Подключимся к лидеру кластера и проверим список запущенных нод и менеджер-статус
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/05-virt-05-docker-swarm/src/terraform$ ssh centos@62.84.117.113
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
a78b2w81u2rkaxvytqan7vrg3 *   node01.netology.yc   Ready     Active         Leader           20.10.12
yr9vwx20ufyc99aqvbwbrq7mo     node02.netology.yc   Ready     Active         Reachable        20.10.12
5r9glkkrmvgky75ta1bf5xh3r     node03.netology.yc   Ready     Active         Reachable        20.10.12
xxiusvtiz1enwqcnuyu4womps     node04.netology.yc   Ready     Active                          20.10.12
s66st5g3h1afmp75c71onru2i     node05.netology.yc   Ready     Active                          20.10.12
rc31achpczbsuukvzgd6o8ym2     node06.netology.yc   Ready     Active                          20.10.12
```
[Скриншот с ответом](https://github.com/mikeMMmike/devops-netology/tree/main/05-virt-05-docker-swarm/src/screenshots/05-05-2_node_list.png)


Задача 3
=====
Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

docker service ls

Ответ
-----

Подключимся к лидеру кластера и проверим список запущенных микросервисов:
```bash
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
rq4xiw5consa   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
jz11d1ys4yof   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
p7nq5cx5o98u   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
cpwbdsk74da0   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
keskvd2dimo2   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
bf1uf6g9swwv   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
pptsr4jq939v   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
l1i3ydfwi78q   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0       
```
[Скриншот с ответом](https://github.com/mikeMMmike/devops-netology/tree/main/05-virt-05-docker-swarm/src/screenshots/05-05-3_service_list.png)