# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. 
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомиться с обоими облаками, потому что они отличаются. 


## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

## Решение
1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).

- Ознакомились

2. Обратите внимание на период бесплатного использования после регистрации аккаунта.

- Обратили

3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
```bash
 23:29:00 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
23:24:21 j0 mike@mike-VirtualBox:~
$ yc init
Welcome! This command will take you through the configuration process.
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb in order to obtain OAuth token.

Please enter OAuth token: A
You have one cloud available: 'c' (id = 1). It is going to be used by default.
Please choose folder to use:
 [1] default (id = 1)
 [2] netology (id = 2)
 [3] Create a new folder
Please enter your numeric choice: 2
Your current folder has been set to 'n' (id = 2).
Do you want to configure a default Compute zone? [Y/n] y
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-c
 [4] Don't set default zone
Please enter your numeric choice: 2
Your profile default Compute zone has been set to 'ru-central1-b'.
```

4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, чтобы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

```bash
23:25:57 j0 mike@mike-VirtualBox:~
$ yc iam create-token
MY_Token
23:26:14 j0 mike@mike-VirtualBox:~
$ export YC_TOKEN=MY_Token
```


## Задача 2. Создание yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
5. В файле `main.tf` создайте ресурс [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Если вы выполнили первый пункт, то добейтесь того, чтобы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
2. Ссылку на репозиторий с исходной конфигурацией терраформа.  
 
## Решение

В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
```bash
01:05:11 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ yc compute image list --folder-id standard-images | grep "ubuntu-2004-lts "
| fd81hgrcv6lsnkremf32 | ubuntu-20-04-lts-v20210908                                     | ubuntu-2004-lts                                 | f2e4vkdnbdu1d3abiuto           | READY  |
| fd82re2tpfl4chaupeuf | ubuntu-20-04-lts-v20220502                                     | ubuntu-2004-lts                                 | f2eljveqcurh622633be           | READY  |
| fd83klic6c8gfgi40urb | ubuntu-2004-lts-1623345129                                     | ubuntu-2004-lts                                 | f2efrqfcllr7ns1o7b1t           | READY  |

01:00:04 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ nano main.tf
```
Создали файл [main.tf](./src/terraform/main.tf)
Проверяем кофигурацию терраформ:
```bash
01:45:19 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ terraform validate
╷
│ Error: Missing required provider
│ 
│ This configuration requires provider registry.terraform.io/hashicorp/yandex, but that provider isn't available. You may be able to install it automatically by running:
│   terraform init

01:47:39 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/yandex...
╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider hashicorp/yandex: provider registry.terraform.io/hashicorp/yandex was not found in any of the search
│ locations
│ 
│   - provider mirror at https://terraform-mirror.yandexcloud.net/
```
Ошибку исправили добавлением [конфигурационного файла](./src/terraform/provider.tf), описывающего провайдер ya.cloud:

```bash
01:51:48 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.75.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
01:56:56 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ touch versions.tf
02:00:43 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ terraform validate
Success! The configuration is valid.
```
Для подстановки переменных в [](./src/terraform/provider.tf) в виде ${var.yandex_cloud_id} можно использовать файл [variables.tf](./src/terraform/variables.tf). но в рамках задачи мы создадим системные переменные и будем использовать их в дальнейшем:  
Экспортируем переменные yandex_folder_id и yandex_cloud_id:
```bash
02:12:56 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ export yandex_cloud_id={my_cloud_id}
02:15:02 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ export yandex_folder_id={my_yandex_folder_id}
```
Запускаем terraform plan: 
```bash
02:16:42 j0 mike@mike-VirtualBox:~/devops/07-terraform-02-syntax
$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1 will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa *****
            EOT
        }
      + name                      = "terraform1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81hgrcv6lsnkremf32"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_vm_1 = (known after apply)
  + internal_ip_address_vm_1 = (known after apply)
```

Команда `terraform init` выполнилась без ошибок.

При помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami? Ответ: при помощи packer.





`Задачу с AWS не выполнял. Само задание вынес в комментарии ниже. посмотреть можно в RAW или в редакторе`

[comment]: <> (## Задача 1 &#40;вариант с AWS&#41;. Регистрация в aws и знакомство с основами &#40;необязательно, но крайне желательно&#41;.)

[comment]: <> (Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов. )

[comment]: <> (AWS предоставляет достаточно много бесплатных ресурсов в первый год после регистрации, подробно описано [здесь]&#40;https://aws.amazon.com/free/&#41;.)

[comment]: <> (1. Создайте аккаут aws.)

[comment]: <> (2. Установите aws-cli https://aws.amazon.com/cli/.)

[comment]: <> (3. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.)

[comment]: <> (4. Создайте IAM политику для терраформа c правами)

[comment]: <> (    * AmazonEC2FullAccess)

[comment]: <> (    * AmazonS3FullAccess)

[comment]: <> (    * AmazonDynamoDBFullAccess)

[comment]: <> (    * AmazonRDSFullAccess)

[comment]: <> (    * CloudWatchFullAccess)

[comment]: <> (    * IAMFullAccess)

[comment]: <> (5. Добавьте переменные окружения )

[comment]: <> (    ```)

[comment]: <> (    export AWS_ACCESS_KEY_ID=&#40;your access key id&#41;)

[comment]: <> (    export AWS_SECRET_ACCESS_KEY=&#40;your secret access key&#41;)

[comment]: <> (    ```)

[comment]: <> (6. Создайте, остановите и удалите ec2 инстанс &#40;любой с пометкой `free tier`&#41; через веб интерфейс. )

[comment]: <> (В виде результата задания приложите вывод команды `aws configure list`.)

[comment]: <> (## Задача 2. Создание aws ec2 через терраформ. )

[comment]: <> (1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.)

[comment]: <> (2. Зарегистрируйте провайдер для [aws]&#40;https://registry.terraform.io/providers/hashicorp/aws/latest/docs&#41;. В файл `main.tf` добавьте)

[comment]: <> (   блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион )

[comment]: <> (   внутри блока `provider`.   )

[comment]: <> (3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали)

[comment]: <> (их в виде переменных окружения. )

[comment]: <> (4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  )

[comment]: <> (5. В файле `main.tf` создайте рессурс )

[comment]: <> (   1. либо [ec2 instance]&#40;https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance&#41;.)

[comment]: <> (   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке )

[comment]: <> (   `Example Usage`, но желательно, указать большее количество параметров.)

[comment]: <> (6. Также в случае использования aws:)

[comment]: <> (   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.)

[comment]: <> (   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: )

[comment]: <> (       * AWS account ID,)

[comment]: <> (       * AWS user ID,)

[comment]: <> (       * AWS регион, который используется в данный момент, )

[comment]: <> (       * Приватный IP ec2 инстансы,)

[comment]: <> (       * Идентификатор подсети в которой создан инстанс.  )

[comment]: <> (7. Если вы выполнили первый пункт, то добейтесь того, чтобы команда `terraform plan` выполнялась без ошибок. )


[comment]: <> (В качестве результата задания предоставьте:)

[comment]: <> (1. Ответ на вопрос: при помощи какого инструмента &#40;из разобранных на прошлом занятии&#41; можно создать свой образ ami?)

[comment]: <> (2. Ссылку на репозиторий с исходной конфигурацией терраформа.)

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---