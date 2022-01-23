**1. Создайте виртуальную машину Linux.**


Ответ.
Конфигурация vagrant-файла. ОС - Ubuntu 20.04, настроен проброс портов для SSH и HTTPS:
``` 
Vagrant.configure("2") do |config|
 	config.vm.box = "bento/ubuntu-20.04"
	config.vm.network "forwarded_port", guest: 443, host: 443
	config.vm.network "forwarded_port", guest: 22, host: 22
 end
```

**2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.**

Ответ.

В Ubuntu 20.04 UFW уже инсталлирован, но отключен по умолчанию:

```bash
vagrant@vagrant:~$ sudo su
root@vagrant:/home/vagrant# ufw status
Status: inactive
root@vagrant:/home/vagrant# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? n
Aborted
```
Чтобы после включения фаервола не произошло отключение SSH сессии, решил сначала разрешить SSH-траффик:
```bash
root@vagrant:/home/vagrant# ufw allow 22
Rules updated
Rules updated (v6)
```
Теперь включаем UFW, разрешаем 443 порт и локальный траффик:
```bash
root@vagrant:/home/vagrant# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
root@vagrant:/home/vagrant# ufw allow 443
Rule added
Rule added (v6)
root@vagrant:/home/vagrant# ufw allow proto tcp from 127.0.0.1 to 127.0.0.1
Rule added
root@vagrant:/home/vagrant# ufw allow proto udp from 127.0.0.1 to 127.0.0.1
Rule added
```

**3. Установите hashicorp vault [инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)**

Ответ.

Добавим репозиторий и установим Vault:
```bash
root@vagrant:/home/vagrant# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
root@vagrant:/home/vagrant# apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Get:1 https://apt.releases.hashicorp.com focal InRelease [9,495 B]
Hit:2 http://archive.ubuntu.com/ubuntu focal InRelease
Get:3 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:4 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:5 https://apt.releases.hashicorp.com focal/main amd64 Packages [41.2 kB]
Get:6 http://archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:7 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1,469 kB]
Get:8 http://security.ubuntu.com/ubuntu focal-security/main i386 Packages [355 kB]
Get:9 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [1,130 kB]
Get:10 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [204 kB]
Get:11 http://archive.ubuntu.com/ubuntu focal-updates/main i386 Packages [585 kB]
Get:12 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [636 kB]
Get:13 http://archive.ubuntu.com/ubuntu focal-updates/main Translation-en [291 kB]
Get:14 http://security.ubuntu.com/ubuntu focal-security/restricted i386 Packages [20.5 kB]
Get:15 http://archive.ubuntu.com/ubuntu focal-updates/restricted i386 Packages [21.8 kB]
Get:16 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [694 kB]
Get:17 http://security.ubuntu.com/ubuntu focal-security/restricted Translation-en [90.7 kB]
Get:18 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [675 kB]
Get:19 http://archive.ubuntu.com/ubuntu focal-updates/restricted Translation-en [99.0 kB]
Get:20 http://archive.ubuntu.com/ubuntu focal-updates/universe i386 Packages [662 kB]
Get:21 http://security.ubuntu.com/ubuntu focal-security/universe i386 Packages [532 kB]
Get:22 http://security.ubuntu.com/ubuntu focal-security/universe Translation-en [114 kB]
Get:23 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [892 kB]
Get:24 http://security.ubuntu.com/ubuntu focal-security/multiverse i386 Packages [7,176 B]
Get:25 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [21.8 kB]
Get:26 http://security.ubuntu.com/ubuntu focal-security/multiverse Translation-en [4,948 B]
Get:27 http://archive.ubuntu.com/ubuntu focal-updates/universe Translation-en [195 kB]
Get:28 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [24.8 kB]
Get:29 http://archive.ubuntu.com/ubuntu focal-updates/multiverse i386 Packages [8,432 B]
Get:30 http://archive.ubuntu.com/ubuntu focal-updates/multiverse Translation-en [6,928 B]
Get:31 http://archive.ubuntu.com/ubuntu focal-backports/main amd64 Packages [42.0 kB]
Get:32 http://archive.ubuntu.com/ubuntu focal-backports/main i386 Packages [34.5 kB]
Get:33 http://archive.ubuntu.com/ubuntu focal-backports/main Translation-en [10.0 kB]
Get:34 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [19.5 kB]
Get:35 http://archive.ubuntu.com/ubuntu focal-backports/universe i386 Packages [11.1 kB]
Get:36 http://archive.ubuntu.com/ubuntu focal-backports/universe Translation-en [13.4 kB]
Fetched 9,257 kB in 9s (1,060 kB/s)
Reading package lists... Done
root@vagrant:/home/vagrant# apt-get update
Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
Hit:2 https://apt.releases.hashicorp.com focal InRelease
Hit:3 http://security.ubuntu.com/ubuntu focal-security InRelease
Hit:4 http://archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu focal-backports InRelease
Reading package lists... Done
root@vagrant:/home/vagrant# apt-get install vault
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  vault
0 upgraded, 1 newly installed, 0 to remove and 109 not upgraded.
Need to get 69.4 MB of archives.
After this operation, 188 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com focal/main amd64 vault amd64 1.9.2 [69.4 MB]
Fetched 69.4 MB in 17s (4,134 kB/s)
Selecting previously unselected package vault.
(Reading database ... 41552 files and directories currently installed.)
Preparing to unpack .../archives/vault_1.9.2_amd64.deb ...
Unpacking vault (1.9.2) ...
Setting up vault (1.9.2) ...
Generating Vault TLS key and self-signed certificate...
Generating a RSA private key
..........................................++++
...............................................................................................................................................................................................................++++
writing new private key to 'tls.key'
-----
Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.
```
Проверим, установился ли Vault:
```bash
vagrant@vagrant:~$ vault
```
Установился успешно, т.к. мы получили вывод справки:
```bash
Usage: vault <command> [args]

Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit          Interact with audit devices
    auth           Interact with auth methods
    debug          Runs the debug command
    kv             Interact with Vault's Key-Value storage
    lease          Interact with leases
    monitor        Stream log messages from a Vault server
    namespace      Interact with namespaces
    operator       Perform operator-specific tasks
    path-help      Retrieve API help for paths
    plugin         Interact with Vault plugins and catalog
    policy         Interact with policies
    print          Prints runtime configurations
    secrets        Interact with secrets engines
    ssh            Initiate an SSH session
    token          Interact with tokens
```

**4. Создайте центр сертификации по инструкции [ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).**

Ответ.

Создадим центр сертификации. Запускаем сервер в режиме тестирования:
```bash
vagrant@vagrant:~$ vault server -dev -dev-root-token-id root
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.5
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.9.2
             Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf

==> Vault server started! Log data will stream in below:

2022-01-11T20:48:36.250Z [INFO]  proxy environment: http_proxy="\"\"" https_proxy="\"\"" no_proxy="\"\""
2022-01-11T20:48:36.250Z [WARN]  no `api_addr` value specified in config or in VAULT_API_ADDR; falling back to detection if possible, but this value should be manually set
2022-01-11T20:48:36.251Z [INFO]  core: Initializing VersionTimestamps for core
2022-01-11T20:48:36.251Z [INFO]  core: security barrier not initialized
2022-01-11T20:48:36.252Z [INFO]  core: security barrier initialized: stored=1 shares=1 threshold=1
2022-01-11T20:48:36.253Z [INFO]  core: post-unseal setup starting
2022-01-11T20:48:36.259Z [INFO]  core: loaded wrapping token key
2022-01-11T20:48:36.259Z [INFO]  core: Recorded vault version: vault version=1.9.2 upgrade time="2022-01-11 20:48:36.259136716 +0000 UTC m=+0.125953441"
2022-01-11T20:48:36.259Z [INFO]  core: successfully setup plugin catalog: plugin-directory="\"\""
2022-01-11T20:48:36.259Z [INFO]  core: no mounts; adding default mount table
2022-01-11T20:48:36.263Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2022-01-11T20:48:36.264Z [INFO]  core: successfully mounted backend: type=system path=sys/
2022-01-11T20:48:36.264Z [INFO]  core: successfully mounted backend: type=identity path=identity/
2022-01-11T20:48:36.280Z [INFO]  core: successfully enabled credential backend: type=token path=token/
2022-01-11T20:48:36.281Z [INFO]  rollback: starting rollback manager
2022-01-11T20:48:36.282Z [INFO]  core: restoring leases
2022-01-11T20:48:36.282Z [INFO]  expiration: lease restore complete
2022-01-11T20:48:36.283Z [INFO]  identity: entities restored
2022-01-11T20:48:36.283Z [INFO]  identity: groups restored
2022-01-11T20:48:36.284Z [INFO]  core: post-unseal setup complete
2022-01-11T20:48:36.285Z [INFO]  core: root token generated
2022-01-11T20:48:36.285Z [INFO]  core: pre-seal teardown starting
2022-01-11T20:48:36.285Z [INFO]  rollback: stopping rollback manager
2022-01-11T20:48:36.285Z [INFO]  core: pre-seal teardown complete
2022-01-11T20:48:36.286Z [INFO]  core.cluster-listener.tcp: starting listener: listener_address=127.0.0.1:8201
2022-01-11T20:48:36.286Z [INFO]  core.cluster-listener: serving cluster requests: cluster_listen_address=127.0.0.1:8201
2022-01-11T20:48:36.286Z [INFO]  core: post-unseal setup starting
2022-01-11T20:48:36.286Z [INFO]  core: loaded wrapping token key
2022-01-11T20:48:36.286Z [INFO]  core: successfully setup plugin catalog: plugin-directory="\"\""
2022-01-11T20:48:36.293Z [INFO]  core: successfully mounted backend: type=system path=sys/
2022-01-11T20:48:36.293Z [INFO]  core: successfully mounted backend: type=identity path=identity/
2022-01-11T20:48:36.293Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2022-01-11T20:48:36.296Z [INFO]  core: successfully enabled credential backend: type=token path=token/
2022-01-11T20:48:36.296Z [INFO]  core: restoring leases
2022-01-11T20:48:36.297Z [INFO]  rollback: starting rollback manager
2022-01-11T20:48:36.297Z [INFO]  identity: entities restored
2022-01-11T20:48:36.297Z [INFO]  identity: groups restored
2022-01-11T20:48:36.297Z [INFO]  expiration: lease restore complete
2022-01-11T20:48:36.297Z [INFO]  core: post-unseal setup complete
2022-01-11T20:48:36.298Z [INFO]  core: vault is unsealed
2022-01-11T20:48:36.302Z [INFO]  expiration: revoked lease: lease_id=auth/token/root/h9b060e132905a57a91c8db763c55270d24eaa53157c0927dd11dbb0c14f10834
2022-01-11T20:48:36.307Z [INFO]  core: successful mount: namespace="\"\"" path=secret/ type=kv
2022-01-11T20:48:36.318Z [INFO]  secrets.kv.kv_15a788a7: collecting keys to upgrade
2022-01-11T20:48:36.318Z [INFO]  secrets.kv.kv_15a788a7: done collecting keys: num_keys=1
2022-01-11T20:48:36.318Z [INFO]  secrets.kv.kv_15a788a7: upgrading keys finished
WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
and starts unsealed with a single unseal key. The root token is already
authenticated to the CLI, so you can immediately begin using Vault.

You may need to set the following environment variable:

    $ export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: blah-blah-blah
Root Token: root

Development mode should NOT be used in production installations!
```
И сворачиваем:
```bash
^Z
[1]+  Stopped                 vault server -dev -dev-root-token-id root
vagrant@vagrant:~$ bg
[1]+ vault server -dev -dev-root-token-id root &
```
Экспортируем переменные окружения Vault:
```bash
vagrant@vagrant:~$ export VAULT_ADDR=http://127.0.0.1:8200
vagrant@vagrant:~$ export VAULT_TOKEN=root
```
Включаем механизм PKI по инструкции:
```bash
vagrant@vagrant:~$ vault secrets enable pki
2022-01-11T20:49:46.033Z [INFO]  core: successful mount: namespace="\"\"" path=pki/ type=pki
Success! Enabled the pki secrets engine at: pki/
vagrant@vagrant:~$ vault secrets tune -max-lease-ttl=87600h pki
2022-01-11T20:53:27.581Z [INFO]  core: mount tuning of leases successful: path=pki/
Success! Tuned the secrets engine at: pki/
```
Создаем корневой сертификат УЦ и экспортируем открытый ключ в файл:
```bash
vagrant@vagrant:~$ vault write -field=certificate pki/root/generate/internal \
> common_name="netology.ru" \
> ttl=87600h > CA_cert.crt
```
Создаем сертификат промежуточного ЦС:
```bash
vagrant@vagrant:~$ vault secrets enable -path=pki_int pki
2022-01-11T21:02:53.369Z [INFO]  core: successful mount: namespace="\"\"" path=pki_int/ type=pki
Success! Enabled the pki secrets engine at: pki_int/
vagrant@vagrant:~$ vault secrets tune -max-lease-ttl=43800h pki_int
2022-01-11T21:03:06.764Z [INFO]  core: mount tuning of leases successful: path=pki_int/
Success! Tuned the secrets engine at: pki_int/
vagrant@vagrant:~$ sudo apt-get install jq
vagrant@vagrant:~$ vault write -format=json pki_int/intermediate/generate/internal \
> common_name="netology.ru Intermediate Authority" \
> | jq -r '.data.csr' > pki_intermediate.csr
```
Подпишем промежуточный сертификат закрытым корневым ключом ЦС и сохраним его в файл intermediate.cert.pem
```bash
vagrant@vagrant:~$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
> format=pem_bundle ttl="43800h" \
> | jq -r '.data.certificate' > intermediate.cert.pem
vagrant@vagrant:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
```
Создадим роль, т.е. политику, по которой будут выпускаться сертификаты. в ней укажем название политики, разрешенный домен, максимальное время жизни сертификата и разрешм поддомены:
```bash
vagrant@vagrant:~$ vault write pki_int/roles/netology-dot-ru \
> allowed_domains="netology.ru" \
> allow_subdomains=true \
> allow_bare_domains=true \
> max_ttl="720h"
Success! Data written to: pki_int/roles/netology-dot-ru
```
Создадим сертификат для дальнейшего использования на web-сервере со сроком жизни 1 месяц, т.е. 720 часов и экспортируем его в формате json для удобства дальнейшего использования в web-сервере:
```bash
vagrant@vagrant:~$ vault write -format=json pki_int/issue/netology-dot-ru common_name="test.netology.ru" ttl="720h" > /etc/ssl/test.netology.ru.crt
```
Сделаем из созданного на предыдущем шаге файла сертификаты для сайта, перенаправив вывод парсера jq в файлы:
```bash
root@vagrant:/etc/ssl# cat /etc/ssl/test.netology.ru.crt | jq -r '.data.certificate' > /etc/ssl/test.netology.ru.crt.pem
root@vagrant:/etc/ssl# cat /etc/ssl/test.netology.ru.crt | jq -r '.data.ca_chain[ ]' >> /etc/ssl/test.netology.ru.crt.pem
root@vagrant:/etc/ssl# cat /etc/ssl/test.netology.ru.crt | jq -r '.data.private_key' > /etc/ssl/test.netology.ru.crt.key
```

**5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.**

Ответ.
Корневой сертификат ЦС Vault скопировали на хост и установили в хранилище Доверенных корневых ЦС [скрин CA.PNG](https://github.com/mikeMMmike/devops-netology/blob/main/pcs-devsys-diplom/CA.PNG) 

**6. Установите nginx.**

Ответ.
Установим Nginx командой:
```bash
root@vagrant:/home/vagrant# apt install nginx
```
**7. По инструкции [ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html) настройте nginx на https, используя ранее подготовленный сертификат:**
* **можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;**
* **можно использовать и другой html файл, сделанный вами;**

Ответ.
Настроим Nginx. Скопируем на всякий случай файл конфигурации. я обычно всегда это делаю перед настройкой сервиса:
```bash
root@vagrant:/etc/nginx# cp  nginx.conf  nginx.conf_back1
root@vagrant:/etc/nginx# nano nginx.conf
```
В блоке SSL settings укажем файлы сертификатов и имя сервера, на который выдавали сертификат:
```
server {
            listen              443 ssl;
            server_name         test.netology.ru;
            keepalive_timeout   70;
            ssl_certificate     /etc/ssl/test.netology.ru.cert.crt;
            ssl_certificate_key /etc/ssl/test.netology.ru.crt.key;
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
            ssl_ciphers         HIGH:!aNULL:!MD5;
        }
```
Перезапустим web-сервер:
```bash
root@vagrant:/etc/nginx# systemctl restart nginx.service
```

**8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.**

Ответ.
На хосте добавим в файл hosts запись, чтобы имя сервера разрешалось в IP-адрес:
```
127.0.0.1	test.netology.ru
```
Проверяем работу в браузере страницу https://test.netology.ru/. Работает! Файл скриншота [itWorks.PNG](https://github.com/mikeMMmike/devops-netology/blob/main/pcs-devsys-diplom/itWorks.PNG)


