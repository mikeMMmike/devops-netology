# Домашнее задание к занятию "09.06 Gitlab"

## Подготовка к выполнению

1. Необходимо [зарегистрироваться](https://about.gitlab.com/free-trial/)
2. Создайте свой новый проект
3. Создайте новый репозиторий в gitlab, наполните его [файлами](./repository)
4. Проект должен быть публичным, остальные настройки по желанию

## Лог

1. Зарегистрировались
2. Создайте проект: https://gitlab.com/mikezzzz/devops-netology
3. Создали репозиторий https://gitlab.com/mikezzzz/devops-netology/-/tree/main/09-ci-06-gitlab с файлом https://gitlab.com/mikezzzz/devops-netology/-/tree/main/09-ci-06-gitlab/repository/python-api.py
4. Проект публичный


## Основная часть

### DevOps

В репозитории содержится код проекта на python. Проект - RESTful API сервис. Ваша задача автоматизировать сборку образа с выполнением python-скрипта:
1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated)
2. Python версии не ниже 3.7
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`
4. Создана директория `/python_api`
5. Скрипт из репозитория размещён в /python_api
6. Точка вызова: запуск скрипта
7. Если сборка происходит на ветке `master`: Образ должен пушится в docker registry вашего gitlab `python-api:latest`, иначе этот шаг нужно пропустить


## Лог
По шагам 1-6 создан dockerfile с содержимым:
```FROM centos:7

RUN yum update -y && yum install -y python3 python3-pip
RUN pip3 install flask flask_restful flask_jsonpify

ADD ./09-ci-06-gitlab/repository/python-api.py /python_api/python-api.py

ENTRYPOINT ["python3", "/python_api/python-api.py"]

```
 Шаг 7.
Результатом выполнения шага явился файл .gitlab-ci.yml. 
```yaml
image: docker:latest
variables:
  DOCKER_TLS_CERTDIR: ''
  DOCKER_HOST: tcp://192.168.200.12:2375
  DOCKER_DRIVER: overlay2
services:
    - docker:dind
stage_build:
    stage: build
    script:
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker build -t $CI_REGISTRY/mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab/image:latest .
    except:
        - main
stage_deploy:
    stage: deploy
    script:
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker build -t $CI_REGISTRY//mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab/repository/python-api.py:latest .
        - docker push $CI_REGISTRY//mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab/repository/python-api.py:latest
    only:
        - main
```
Но при попытке запустить pipeline на исполнение была получена [ошибка](./src/1-7-error-validate.PNG), т.к. требуется подтвердить аккаунт кредитной картой. Gitlab предлагает использовать локальный раннер: https://docs.gitlab.com/runner/install/
UPD. После добавления раннера возникла ошибка подключения по [инструкции](https://sysadm.ru/devops/gitops/cvs/gitlab/errors/) добавил в .gitlab-ci.yml:
```bash
variables:
  DOCKER_TLS_CERTDIR: ''
  DOCKER_HOST: tcp://192.168.200.12:2375
  DOCKER_DRIVER: overlay2
```

## Итак, переходим к установке.
```bash
23:31:31 j0 mike@mike-VirtualBox:~/devops/09-ci-06-gitlab
$ sudo su
[sudo] пароль для mike:
root@mike-VirtualBox:/home/mike/devops/09-ci-06-gitlab# curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  6885  100  6885    0     0  18966      0 --:--:-- --:--:-- --:--:-- 18914
Detected operating system as Ubuntu/focal.
Checking for curl...
Detected curl...
Checking for gpg...
Detected gpg...
Running apt-get update... done.
Installing apt-transport-https... done.
Installing /etc/apt/sources.list.d/runner_gitlab-runner.list...done.
Importing packagecloud gpg key... done.
Running apt-get update... done.

The repository is setup! You can now install packages.
root@mike-VirtualBox:/home/mike/devops/09-ci-06-gitlab# apt install gitlab-runner
------- вывод сокращен --------
Check and remove all unused containers (both dangling and unreferenced) including volumes.
------------------------------------------------------------------------------------------
Total reclaimed space: 0B
root@mike-VirtualBox:/home/mike/devops/09-ci-06-gitlab# systemctl enable --now gitlab-runner
```
Установка завершена. Теперь в GitLab: Проект - Settings - CI/CD - Runners - Expand - Отключить "Enable shared runners for this project" - В разделе Specific runners получить URL и токен авторизации - Зарегистрировать Runner на сервере с использованием данных, полученных на предыдущем шаге. 

```bash
root@mike-VirtualBox:/home/mike/devops/09-ci-06-gitlab# gitlab-runner register
Runtime platform                                    arch=amd64 os=linux pid=49534 revision=febb2a09 version=15.0.0
Running in system-mode.                            
                                                   
Enter the GitLab instance URL (for example, https://gitlab.com/):
https://gitlab.com/
Enter the registration token:
********************
Enter a description for the runner:
[mike-VirtualBox]: Ubuntu-VBox
Enter tags for the runner (comma-separated):
ubuntu2020
Enter optional maintenance note for the runner:

Registering runner... succeeded                     runner=***************
Enter an executor: virtualbox, docker+machine, parallels, shell, ssh, docker-ssh+machine, kubernetes, custom, docker, docker-ssh:
docker+machine
Enter the default Docker image (for example, ruby:2.7):
centos:7
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded! 
root@mike-VirtualBox:/home/mike/devops/09-ci-06-gitlab# gitlab-runner verify
Runtime platform                                    arch=amd64 os=linux pid=49626
Running in system-mode.                            
                                                   
Verifying runner... is alive                        runner=*****
```

При выполнении пайплайна возникла ошибка:
```bash
$ docker build -t $CI_REGISTRY/mikeMMmike/devops-netology/09-ci-06-gitlab/repository/python-api.py:latest .
invalid argument "registry.gitlab.com/mikeMMmike/devops-netology/09-ci-06-gitlab/repository/python-api.py:latest" for "-t, --tag" flag: invalid reference format: repository name must be lowercase
See 'docker build --help'.
```
Насколько смог разобраться, проблема в символах верхнего регистра, в моем случае в логине. Для решения проблемы завел новый аккаунт. Соответственно, файл .gitlab-ci.yml имеет теперь такое содержимое: 
```bash
image: docker:latest
variables:
  DOCKER_TLS_CERTDIR: ''
  DOCKER_HOST: tcp://192.168.200.130:2375
  DOCKER_DRIVER: overlay2

services:
    - docker:dind
stage_build:
    stage: build
    script:
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker build -t $CI_REGISTRY/mikezzzz/devops-netology/09-ci-06-gitlab/image:latest .
    except:
        - main
stage_deploy:
    stage: deploy
    script:
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker build -t $CI_REGISTRY/mikezzzz/devops-netology/09-ci-06-gitlab/repository/python-api.py:latest .
        - docker push $CI_REGISTRY/mikezzzz/devops-netology/09-ci-06-gitlab/repository/python-api.py:latest
    only:
        - main

```



### Product Owner

Вашему проекту нужна бизнесовая доработка: необходимо поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:
1. Какой метод необходимо исправить
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`
3. Issue поставить label: feature


## Лог



### Developer

Вам пришел новый Issue на доработку, вам необходимо:
1. Создать отдельную ветку, связанную с этим issue
2. Внести изменения по тексту из задания
3. Подготовить Merge Requst, влить необходимые изменения в `master`, проверить, что сборка прошла успешно


## Лог



### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:
1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый

## Итог

После успешного прохождения всех ролей - отправьте ссылку на ваш проект в гитлаб, как решение домашнего задания

## Необязательная часть

Автомазируйте работу тестировщика, пусть у вас будет отдельный конвейер, который автоматически поднимает контейнер и выполняет проверку, например, при помощи curl. На основе вывода - будет приниматься решение об успешности прохождения тестирования

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---