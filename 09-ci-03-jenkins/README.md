# Домашнее задание к занятию "09.03 Jenkins"

## Подготовка к выполнению

1. Установить jenkins по любой из [инструкций](https://www.jenkins.io/download/)
2. Запустить и проверить работоспособность
3. Сделать первоначальную настройку
4. Настроить под свои нужды
5. Поднять отдельный cloud
6. Для динамических агентов можно использовать [образ](https://hub.docker.com/repository/docker/aragast/agent)
7. Обязательный параметр: поставить label для динамических агентов: `ansible_docker`
8.  Сделать форк репозитория с [playbook](https://github.com/aragastmatb/example-playbook)

### Лог
1. Установка Jenkins на Ubuntu
```bash
02:40:40 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins
$ curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
> /usr/share/keyrings/jenkins-keyring.asc > /dev/null
[sudo] пароль для mike: 
02:40:58 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins
$ echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
>     https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
>     /etc/apt/sources.list.d/jenkins.list > /dev/null
02:41:10 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins
$ sudo apt-get update
02:41:30 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins
$ sudo apt-get install fontconfig openjdk-11-jre
02:41:36 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins
$ sudo apt-get install jenkins
```
2. Проверка работоспособности:
```bash
02:50:21 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins
$ curl localhost:8080
<html><head><meta http-equiv='refresh' content='1;url=/login?from=%2F'/><script>window.location.replace('/login?from=%2F');</script></head><body style='background-color:white; color:white;'>


Authentication required
<!--
-->

</body></html> 
```
3,4. Настройка.

Получаем пароль
```bash
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
ae7343fe7a364f81b71eef5dc3b0ca4d
```
Залогинились. [Установили плагины](./src/Jenkins_Plugin.PNG) 
Dashboard - Настройка - Сменили количество сборщиков с 2 на 0 на  Мастере. 

[comment]: <> (5,6. Для динамических агентов используется [образ]&#40;https://hub.docker.com/repository/docker/aragast/agent&#41;)
5,6  Настраиваем агента:

[comment]: <> (```bash)

[comment]: <> (#00:31:43 j0 mike@mike-VirtualBox:~)

[comment]: <> (#$ docker pull jenkins/ssh-agent)

[comment]: <> (#00:48:46 j0 mike@mike-VirtualBox:~)

[comment]: <> (#$ docker run -it jenkins/ssh-agent /bin/bash)
```bash
03:07:48 j0 mike@mike-VirtualBox:~
$ ssh-keygen -f ~/.ssh/jenkins_agent_key
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/mike/.ssh/jenkins_agent_key
Your public key has been saved in /home/mike/.ssh/jenkins_agent_key.pub
The key fingerprint is:
SHA256:D1qix9Uh82cKgEBpbA0EZjBZuoLdtbj55TKAoAS0Wec mike@mike-VirtualBox
The key's randomart image is:
+---[RSA 3072]----+
|*@*= .           |
|=oO.+.           |
|o=  .Eo o .      |
|o+ . o o = .     |
|*...o o S o o    |
|o . .= = + +     |
|    +.+ . o      |
|     ooo         |
|      .o.        |
+----[SHA256]-----+
```

В настройках Jenkins -> Manage Credentials -> Add credentials -> Вариант `SSH Username with private key` -> id: jenkins -> username: jenkins -> Private Key: выбрали Enter directly -> Указали закрытый ключ


Запуск агента:
```bash
03:22:28 j0 mike@mike-VirtualBox:~
$ cat /home/mike/.ssh/jenkins_agent_key.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDINHubHAeUsxZW7dUzNsyIN4Qd8lB2EoWovVjU+vjhl2q1tgUGz+05JuIzFjJm6ENVK76b2rrpeILOhZ4ljAzmiJAt3n0N1r02P1gTqa+MbRU5nkeZm+5cxkXBjDgCbYoKizo9xzwsLVBlZ3dVyarg8RQnnrw+VonMAemh2rq4e6Ya1PcaDQetW6lTHpsUaVPaa0pVFB5kMaFf12/pFsWIEmgdxu+TOGfIj4yPGruBzA3buNTsfSTcSE0Z95X2vkwZSjebiya0cy8slIHSw47p4Km2JEtrV9GHHg5vNEjqDe7bGFl/7FoDIpnLsFY9YFe+GPVNNsSBYWgU6XrRBcseKV29FdsUQyI5Rj6qZ19QPUCjY/v90XiMLWYLbSvnfMravvkDXt5mlA7a/KaW4NMVYYSbN5LF4GqzMcLTMkzzFsXTPnB+DXk4mw6zsDJyhGb5NsrEBlfTXdZ8QglO9u/8j6+2iWRR1Sxf3jjeSVEFxoFdBiAue/7UMX62/HjXcx0= mike@mike-VirtualBox
03:25:51 j0 mike@mike-VirtualBox:~
$ docker run -d --name=agent1 -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDINHubHAeUsxZW7dUzNsyIN4Qd8lB2EoWovVjU+vjhl2q1tgUGz+05JuIzFjJm6ENVK76b2rrpeILOhZ4ljAzmiJAt3n0N1r02P1gTqa+MbRU5nkeZm+5cxkXBjDgCbYoKizo9xzwsLVBlZ3dVyarg8RQnnrw+VonMAemh2rq4e6Ya1PcaDQetW6lTHpsUaVPaa0pVFB5kMaFf12/pFsWIEmgdxu+TOGfIj4yPGruBzA3buNTsfSTcSE0Z95X2vkwZSjebiya0cy8slIHSw47p4Km2JEtrV9GHHg5vNEjqDe7bGFl/7FoDIpnLsFY9YFe+GPVNNsSBYWgU6XrRBcseKV29FdsUQyI5Rj6qZ19QPUCjY/v90XiMLWYLbSvnfMravvkDXt5mlA7a/KaW4NMVYYSbN5LF4GqzMcLTMkzzFsXTPnB+DXk4mw6zsDJyhGb5NsrEBlfTXdZ8QglO9u/8j6+2iWRR1Sxf3jjeSVEFxoFdBiAue/7UMX62/HjXcx0= mike@mike-VirtualBox" jenkins/ssh-agent:alpine
Unable to find image 'jenkins/ssh-agent:alpine' locally
alpine: Pulling from jenkins/ssh-agent
f84cab65f19f: Pull complete 
6a20433e61dc: Pull complete 
51e0996f10ef: Pull complete 
e52686d34eca: Pull complete 
49ef91cd1d8d: Pull complete 
ffd661cbb5ae: Pull complete 
f1c84308c764: Pull complete 
Digest: sha256:86e742e593edea676cf1f0ad36f9a1a0c5d6513ce3c7b14f147e85ed7b0a6cb8
Status: Downloaded newer image for jenkins/ssh-agent:alpine
2c10f5bd967674a1bef9e5f8c67fa665afa90b716ff4bd286c8a52ffae13d58f

```

[comment]: <> (```bash)

[comment]: <> (03:06:14 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins)

[comment]: <> ($ docker pull aragast/agent:7)

[comment]: <> (7: Pulling from aragast/agent)

[comment]: <> (ab5ef0e58194: Pull complete )

[comment]: <> (1e72a26aff50: Pull complete )

[comment]: <> (f77543c42f4c: Pull complete )

[comment]: <> (7422d683f4c6: Pull complete )

[comment]: <> (e71ed7ae47d2: Pull complete )

[comment]: <> (Digest: sha256:ebf0a78bcb580c8497efdc256c8b9a9b8293e50adc1e05a7549e7d861c93edf8)

[comment]: <> (Status: Downloaded newer image for aragast/agent:7)

[comment]: <> (docker.io/aragast/agent:7)

[comment]: <> (03:12:27 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins)

[comment]: <> ($ docker run -it  aragast/agent:7)

[comment]: <> ([root@57046f13d4c6 /]#)

[comment]: <> (```)

[comment]: <> (Настройка сети:)

[comment]: <> (```bash)

[comment]: <> ($ docker network create --driver=bridge jenkins)

[comment]: <> (0d66a038ca96109a0704965e1727637da5cc9594816327436abc904a6337d052)

[comment]: <> (03:40:46 j0 mike@mike-VirtualBox:~)

[comment]: <> ($ docker network connect jenkins f7f8df29bcdf)

[comment]: <> ($ docker network inspect 0d66a038ca96)

[comment]: <> ([)

[comment]: <> (    {)

[comment]: <> (        "Name": "jenkins",)

[comment]: <> (        "Id": "0d66a038ca96109a0704965e1727637da5cc9594816327436abc904a6337d052",)

[comment]: <> (        "Created": "2022-06-07T03:40:46.468827239+05:00",)

[comment]: <> (        "Scope": "local",)

[comment]: <> (        "Driver": "bridge",)

[comment]: <> (        "EnableIPv6": false,)

[comment]: <> (        "IPAM": {)

[comment]: <> (            "Driver": "default",)

[comment]: <> (            "Options": {},)

[comment]: <> (            "Config": [)

[comment]: <> (                {)

[comment]: <> (                    "Subnet": "172.21.0.0/16",)

[comment]: <> (                    "Gateway": "172.21.0.1")

[comment]: <> (                })

[comment]: <> (```)



## Основная часть

1. Сделать Freestyle Job, который будет запускать `ansible-playbook` из форка репозитория
2. Сделать Declarative Pipeline, который будет выкачивать репозиторий с плейбукой и запускать её
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`
4. Перенастроить Job на использование `Jenkinsfile` из репозитория
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline)
6. Заменить credentialsId на свой собственный
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозитрий в файл `ScriptedJenkinsfile`
8. Отправить ссылку на репозиторий в ответе

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, которые завершились хотя бы раз неуспешно. Добавить скрипт в репозиторий с решеним с названием `AllJobFailure.groovy`
2. Установить customtools plugin
3. Поднять инстанс с локальным nexus, выложить туда в анонимный доступ  .tar.gz с `ansible`  версии 2.9.x
4. Создать джобу, которая будет использовать `ansible` из `customtool`
5. Джоба должна просто исполнять команду `ansible --version`, в ответ прислать лог исполнения джобы 

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---