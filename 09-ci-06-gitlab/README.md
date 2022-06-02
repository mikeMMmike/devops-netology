# Домашнее задание к занятию "09.06 Gitlab"

## Подготовка к выполнению

1. Необходимо [зарегистрироваться](https://about.gitlab.com/free-trial/)
2. Создайте свой новый проект
3. Создайте новый репозиторий в gitlab, наполните его [файлами](./repository)
4. Проект должен быть публичным, остальные настройки по желанию

## Лог

1. Зарегистрировались
2. Создайте проект: https://gitlab.com/mikeMMmike/devops-netology/
3. Создали [репозиторий](https://gitlab.com/mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab) с [файлом](https://gitlab.com/mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab/repository/python-api.py)
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
7. Если сборка происходит на ветке `master`: Образ должен пушиться в docker registry вашего gitlab `python-api:latest`, иначе этот шаг нужно пропустить


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
  DOCKER_HOST: tcp://192.168.200.130:2375
  DOCKER_DRIVER: overlay2
services:
    - docker:dind
before_script:
   - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
stage_build:
    stage: build
    script:
        - docker build -t $CI_REGISTRY/mikemmmike/devops-netology/image:latest .
    except:
        - main
stage_deploy:
    stage: deploy
    script:
        - docker build -t $CI_REGISTRY/mikemmmike/devops-netology/repository/python-api.py:latest .
        - docker push $CI_REGISTRY/mikemmmike/devops-netology/repository/python-api.py:latest
    only:
        - main
```
Но при попытке запустить pipeline на исполнение была получена [ошибка](./src/1-7-error-validate.PNG), т.к. требуется подтвердить аккаунт кредитной картой. Gitlab предлагает использовать локальный раннер: https://docs.gitlab.com/runner/install/


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
[mike-VirtualBox]: gitlab-runner
Enter tags for the runner (comma-separated):
gitlab-runner
Enter optional maintenance note for the runner:

Registering runner... succeeded                     runner=***************
Enter an executor: virtualbox, docker+machine, parallels, shell, ssh, docker-ssh+machine, kubernetes, custom, docker, docker-ssh:
docker
Enter the default Docker image (for example, ruby:2.7):
docker:latest
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded! 
root@mike-VirtualBox:/home/mike/devops/09-ci-06-gitlab# gitlab-runner verify
Runtime platform                                    arch=amd64 os=linux pid=49626
Running in system-mode.                            
                                                   
Verifying runner... is alive                        runner=*****
```

Результат работы раннера:

```bash
Running with gitlab-runner 15.0.0 (febb2a09)
  on docker-run ******
Resolving secrets
00:00
Preparing the "docker" executor
Using Docker executor with image docker:latest ...
Starting service docker:dind ...
Authenticating with credentials from /root/.docker/config.json
Pulling docker image docker:dind ...
Using docker image sha256:1f6c0346b90562fa44a32011666df7a7f413ee260a0510b52ca974bef4d50f15 for docker:dind with digest docker@sha256:56ef400f08be1ca817d7e2cfdb43803786ab28d84c8167e8590622d9bab5b415 ...
Waiting for services to be up and running (timeout 30 seconds)...
*** WARNING: Service runner-qufa2qd7-project-30919229-concurrent-0-8bdf070031e2edc7-docker-0 probably didn't start properly.
Health check error:
service "runner-qufa2qd7-project-30919229-concurrent-0-8bdf070031e2edc7-docker-0-wait-for-service" timeout
Health check container logs:
Service container logs:
2022-06-02T16:50:22.164250393Z ip: can't find device 'ip_tables'
2022-06-02T16:50:22.168051902Z ip_tables              32768  2 iptable_filter,iptable_nat
2022-06-02T16:50:22.168076579Z x_tables               49152  6 xt_conntrack,xt_MASQUERADE,xt_addrtype,iptable_filter,iptable_nat,ip_tables
2022-06-02T16:50:22.168481970Z modprobe: can't change directory to '/lib/modules': No such file or directory
2022-06-02T16:50:22.171026660Z mount: permission denied (are you root?)
2022-06-02T16:50:22.171055385Z Could not mount /sys/kernel/security.
2022-06-02T16:50:22.171059042Z AppArmor detection and --privileged mode might break.
2022-06-02T16:50:22.183880598Z mount: permission denied (are you root?)
*********
Authenticating with credentials from /root/.docker/config.json
Pulling docker image docker:latest ...
Using docker image sha256:2a153cb5c7c52610ceb46876231f1c7ab8d2a0926aaeb5283994ef3d6f78def9 for docker:latest with digest docker@sha256:5bc07a93c9b28e57a58d57fbcf437d1551ff80ae33b4274fb60a1ade2d6c9da4 ...
Preparing environment
00:01
Running on runner-qufa2qd7-project-30919229-concurrent-0 via mike-VirtualBox...
Getting source from Git repository
00:02
Fetching changes with git depth set to 50...
Reinitialized existing Git repository in /builds/mikeMMmike/devops-netology/.git/
Checking out b395b0c8 as main...
Skipping Git submodules setup
Executing "step_script" stage of the job script
Using docker image sha256:2a153cb5c7c52610ceb46876231f1c7ab8d2a0926aaeb5283994ef3d6f78def9 for docker:latest with digest docker@sha256:5bc07a93c9b28e57a58d57fbcf437d1551ff80ae33b4274fb60a1ade2d6c9da4 ...
$ docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Login Succeeded
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
$ docker build -t $CI_REGISTRY/mikemmmike/devops-netology/repository/python-api.py:latest .
Step 1/5 : FROM centos:7
 ---> eeb6ee3f44bd
Step 2/5 : RUN yum update -y && yum install -y python3 python3-pip
 ---> Using cache
 ---> 4f80e8c82b7b
Step 3/5 : RUN pip3 install flask flask_restful flask_jsonpify
 ---> Using cache
 ---> 8de21cce79bc
Step 4/5 : ADD /09-ci-06-gitlab/repository/python-api.py /python_api/python-api.py
 ---> Using cache
 ---> a29207b7d38d
Step 5/5 : ENTRYPOINT ["python3", "/python_api/python-api.py"]
 ---> Using cache
 ---> fc0852c372e2
Successfully built fc0852c372e2
Successfully tagged registry.gitlab.com/mikemmmike/devops-netology/repository/python-api.py:latest
$ docker push $CI_REGISTRY/mikemmmike/devops-netology/repository/python-api.py:latest
The push refers to repository [registry.gitlab.com/mikemmmike/devops-netology/repository/python-api.py]
205f4fcbdb06: Preparing
343bfea6a17d: Preparing
10e96df63f6c: Preparing
174f56854903: Preparing
205f4fcbdb06: Layer already exists
343bfea6a17d: Layer already exists
174f56854903: Layer already exists
10e96df63f6c: Pushed
latest: digest: sha256:53a2b7b3062b4077a8bce1e6bf8f2e530a2dbb4a9e4438967c7b16d78f13898d size: 1160
Cleaning up project directory and file based variables
00:00
Job succeeded
```



### Product Owner

Вашему проекту нужна бизнесовая доработка: необходимо поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:
1. Какой метод необходимо исправить
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`
3. Issue поставить label: feature


## Лог
Создали [Issue](https://gitlab.com/mikeMMmike/devops-netology/-/issues/1) с темой `поменять JSON ответа на вызов метода GET` и описанием `необходимо исправить метод GET /rest/api/get_info, текст с { "message": "Already started" } на { "message": "Running"}`. Метка установлена feature  


### Developer

Вам пришел новый Issue на доработку, вам необходимо:
1. Создать отдельную ветку, связанную с этим issue
2. Внести изменения по тексту из задания
3. Подготовить Merge Requst, влить необходимые изменения в `master`, проверить, что сборка прошла успешно


## Лог
На основе полученного [Issue](https://gitlab.com/mikeMMmike/devops-netology/-/issues/1) проводим операцию `Create merge request`, ветка `1-json-get` с параметром по умолчанию `Delete source branch when merge request is accepted.`

Переходим в созданную [ветку](https://gitlab.com/mikeMMmike/devops-netology/-/tree/1-json-get) и меняем текст с `{ "message": "Already started" }` на `{ "message": "Running"}` в файле python-api.py. 
Выполняем коммит изменений в ветку `1-json-get`. [Процесс CI/CD](https://gitlab.com/mikeMMmike/devops-netology/-/jobs/2540736162) завершился успешно. 
Выполняем merge request `From 1-json-get into main` с параметром `Delete source branch when merge request is accepted.` При выполнении случайно закрыл Issue, после чего открыл. 
Изменения из ветки`1-json-get` попали в `main`. [Процесс CI/CD был выполнен автоматически успешно](https://gitlab.com/mikeMMmike/devops-netology/-/jobs/2540758362):
```bash
$ docker push $CI_REGISTRY/mikemmmike/devops-netology/repository/python-api.py:latest
The push refers to repository [registry.gitlab.com/mikemmmike/devops-netology/repository/python-api.py]
8e00af92e5c1: Preparing
343bfea6a17d: Preparing
10e96df63f6c: Preparing
174f56854903: Preparing
174f56854903: Layer already exists
343bfea6a17d: Layer already exists
10e96df63f6c: Layer already exists
8e00af92e5c1: Pushed
latest: digest: sha256:e17450da7eddfd81470e992509db0c54f8ee9be7f894216733d2c7a737ccb195 size: 1160
Cleaning up project directory and file based variables
00:00
Job succeeded
```


### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:
1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый


## Лог
1. Запуск докер-контейнера с образом `python-api:latest`, проверка возврата метода на корректность.
* Запуск контейнера
```bash
01:29:23 j0 mike@mike-VirtualBox:~
$ docker pull registry.gitlab.com/mikemmmike/devops-netology/repository/python-api.py:latest
latest: Pulling from mikemmmike/devops-netology/repository/python-api.py
Digest: sha256:e17450da7eddfd81470e992509db0c54f8ee9be7f894216733d2c7a737ccb195
Status: Image is up to date for registry.gitlab.com/mikemmmike/devops-netology/repository/python-api.py:latest
registry.gitlab.com/mikemmmike/devops-netology/repository/python-api.py:latest
01:29:26 j0 mike@mike-VirtualBox:~
$ docker container run -p 5290:5290 -d registry.gitlab.com/mikemmmike/devops-netology/repository/python-api.py:latest
6e3638a18def6ac2fd42853cd8a3f32f2a69df8d9b21ac1da237696b8b5c6d94
```
* Проверка ответа
```bash
01:34:16 j0 mike@mike-VirtualBox:~
$ curl localhost:5290
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<title>404 Not Found</title>
<h1>Not Found</h1>
<p>The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.</p>
01:34:21 j0 mike@mike-VirtualBox:~
$ curl localhost:5290/get_info
{"version": 3, "method": "GET", "message": "Running"}
01:34:42 j0 mike@mike-VirtualBox:~
$ docker container stop 6e3638a18def6ac2fd42853cd8a3f32f2a69df8d9b21ac1da237696b8b5c6d94
6e3638a18def6ac2fd42853cd8a3f32f2a69df8d9b21ac1da237696b8b5c6d94
```

2. Вернулся корректный ответ, отражающий последние изменения. [Обращение](https://gitlab.com/mikeMMmike/devops-netology/-/issues/1) закрыли с комментарием 
`Провели тест. согласно последним изменениям возвращается корректный ответ:
$ curl localhost:5290/get_info
{"version": 3, "method": "GET", "message": "Running"}`.


## Итог

После успешного прохождения всех ролей - отправьте ссылку на ваш проект в гитлаб, как решение домашнего задания

## Необязательная часть

Автомазируйте работу тестировщика, пусть у вас будет отдельный конвейер, который автоматически поднимает контейнер и выполняет проверку, например, при помощи curl. На основе вывода - будет приниматься решение об успешности прохождения тестирования

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---