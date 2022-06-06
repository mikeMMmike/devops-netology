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
3. Настройка.

Получаем пароль
```bash
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
ae7343fe7a364f81b71eef5dc3b0ca4d
```
Залогинились. [Установили плагины](./src/Jenkins_Plugin.PNG) 
Dashboard - Настройка - Сменили количество сборщиков с 2 на 0 на  Мастере. 


6. Для динамических агентов используется [образ](https://hub.docker.com/repository/docker/aragast/agent)
```bash
03:06:14 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins
$ docker pull aragast/agent:7
7: Pulling from aragast/agent
ab5ef0e58194: Pull complete 
1e72a26aff50: Pull complete 
f77543c42f4c: Pull complete 
7422d683f4c6: Pull complete 
e71ed7ae47d2: Pull complete 
Digest: sha256:ebf0a78bcb580c8497efdc256c8b9a9b8293e50adc1e05a7549e7d861c93edf8
Status: Downloaded newer image for aragast/agent:7
docker.io/aragast/agent:7
03:12:27 j0 mike@mike-VirtualBox:~/devops/09-ci-03-jenkins
$ docker run -it  aragast/agent:7
[root@57046f13d4c6 /]#
```

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