# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

Ответ.
-----
Текст Dockerfile манифеста

```bash
FROM centos:7
MAINTAINER Mike Sinica <kish_forever@bk.ru>

RUN yum update -y && \
      yum install wget -y && \
      yum install perl-Digest-SHA -y && \
      yum install java-1.8.0-openjdk.x86_64 -y

WORKDIR /usr/elastic/

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz && \
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512

RUN shasum -a 512 -c elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 && \
tar -xzf elasticsearch-8.0.1-linux-x86_64.tar.gz

RUN groupadd -g 3000 elasticsearch && \
    adduser -u 3000 -g elasticsearch -s /bin/sh elasticsearch && \
    echo -e "devops123\ndevops123\n" | passwd elasticsearch &&\
    chmod 777 -R /var/lib/ && \
    chmod 777 -R /usr/elastic/elasticsearch-8.0.1/

USER 3000
EXPOSE 9200
EXPOSE 9300

WORKDIR /usr/elastic/elasticsearch-8.0.1/bin/
CMD ["./elasticsearch", "-Enode.name=netology_test", "-Epath.data=/var/lib/data", "-Epath.logs=/var/lib/logs", "-Enetwork.host=0.0.0.0", "-Ediscovery.type=single-node"]2
```




Процесс создания образа и отправки в dockerhub:
```bash
mike@mike-VirtualBox:~/devops/06-db-05-elasticsearch$ docker build -t mikemmmike/elsticksearch:netology .
Sending build context to Docker daemon  3.584kB
Step 1/12 : FROM centos:7
 ---> eeb6ee3f44bd
Step 2/12 : MAINTAINER Mike Sinica <kish_forever@bk.ru>
 ---> Using cache
 ---> 29c0584be916
Step 3/12 : RUN yum update -y &&       yum install wget -y &&       yum install perl-Digest-SHA -y &&       yum install java-1.8.0-openjdk.x86_64 -y
 ---> Using cache
 ---> 9af86abd2a12
Step 4/12 : WORKDIR /usr/elastic/
 ---> Using cache
 ---> 34ac23ad7847
Step 5/12 : RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512
 ---> Using cache
 ---> b37f2cc3f09a
Step 6/12 : RUN shasum -a 512 -c elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 && tar -xzf elasticsearch-8.0.1-linux-x86_64.tar.gz
 ---> Using cache
 ---> d4bb647dd8c5
Step 7/12 : RUN groupadd -g 3000 elasticsearch &&     adduser -u 3000 -g elasticsearch -s /bin/sh elasticsearch &&     chmod 777 -R /var/lib/ &&     chmod 777 -R /usr/elastic/elasticsearch-8.0.1/
 ---> Using cache
 ---> aea863c8a902
Step 8/12 : USER 3000
 ---> Using cache
 ---> b3c70f916104
Step 9/12 : EXPOSE 9200
 ---> Using cache
 ---> 2f6db0f5eff9
Step 10/12 : EXPOSE 9300
 ---> Using cache
 ---> 9008c07c3cbc
Step 11/12 : WORKDIR /usr/elastic/elasticsearch-8.0.1/bin/
 ---> Running in 61e773be7c18
Removing intermediate container 61e773be7c18
 ---> cd5460b5e66a
Step 12/12 : CMD ["./elasticsearch", "-Enode.name=netology_test", "-Epath.data=/var/lib/data", "-Epath.logs=/var/lib/logs", "-Enetwork.host=0.0.0.0", "-Ediscovery.type=single-node"]
 ---> Running in 4c709be31f4b
Removing intermediate container 4c709be31f4b
 ---> 50d341d4b96d
Successfully built 50d341d4b96d
Successfully tagged mikemmmike/elsticksearch:netology
mike@mike-VirtualBox:~/devops/06-db-05-elasticsearch$ docker push mikemmmike/elsticksearch:netology
The push refers to repository [docker.io/mikemmmike/elsticksearch]
e31e31c240d9: Pushed 
c7f27cbd20e1: Pushed 
c0d0e90198bd: Pushed 
b10898396870: Pushed 
16b325e5c9c1: Layer already exists 
6073f594a2b6: Pushed 
174f56854903: Layer already exists 
netology: digest: sha256:85c29578c818c6b230005d19a9ff153d008cc95c60609f286f3540d4d272fd7e size: 1795


mike@mike-VirtualBox:~/devops/06-db-05-elasticsearch$ docker ps
CONTAINER ID   IMAGE                               COMMAND                  CREATED          STATUS          PORTS                                                 NAMES
51c611bbd051   mikemmmike/elsticksearch:netology   "./elasticsearch -En…"   51 seconds ago   Up 46 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 9300/tcp   elastic_test1

```


Установка ограничения по памяти и запуск docker:
```bash
mike@mike-VirtualBox:~/devops/06-db-05-elasticsearch$ sudo sysctl -w vm.max_map_count=262144
[sudo] пароль для mike: 
vm.max_map_count = 262144

mike@mike-VirtualBox:~/devops/06-db-05-elasticsearch$ docker run -p 9200:9200 --name elastic --memory="1g" -d mikemmmike/elsticksearch:netology_pass1
2625acc602c38ccb6b1e8748922ba462c01bf4cb7747ca0970f07dbed41dbb2d

```


Ответ `elasticsearch` на запрос пути `/` в json виде:

```bash
mike@mike-VirtualBox:~/devops/06-db-05-elasticsearch$ curl -u elasticsearch:devops123 -X GET "localhost:9200/?pretty"
{
  "error" : {
    "root_cause" : [
      {
        "type" : "security_exception",
        "reason" : "unable to authenticate user [elasticsearch] for REST request [/?pretty]",
        "header" : {
          "WWW-Authenticate" : [
            "Basic realm=\"security\" charset=\"UTF-8\"",
            "ApiKey"
          ]
        }
      }
    ],
    "type" : "security_exception",
    "reason" : "unable to authenticate user [elasticsearch] for REST request [/?pretty]",
    "header" : {
      "WWW-Authenticate" : [
        "Basic realm=\"security\" charset=\"UTF-8\"",
        "ApiKey"
      ]
    }
  },
  "status" : 401
}
```

PS. Застрял на данном этапе. Ранее в докер-файле отсутствовала строка смены пароля (да, так делать нельзя и это небезопасно) `echo -e "devops123\ndevops123\n" | passwd elasticsearch &&\`, и при неавторизованном запросе `curl -X GET "localhost:9200/?pretty"` я также получал ошибку 401. Установка пароля для пользователя elasticsearch не помогла мне решить проблему авторизации при запросе.
Задачу решал в рамках поставленной цели. Из вариантов у меня осталось - копия elasticsearch.yml в контейнер вместо передачи переменных окружения в CMD и запуск докер-контейнера из образа elasticksearch. 
Но я считаю, что ни 1 ни 2 вариант не помогут в данной ситуации, поэтому прошу помочь.

Ссылка на образ в репозитории dockerhub:
https://hub.docker.com/repository/docker/mikemmmike/elsticksearch


Сменил пароль в контейнере:

```bash
[elasticsearch@d1402bb559d4 config]$ cd /usr/elastic/elasticsearch-8.0.1/bin/
[elasticsearch@d1402bb559d4 bin]$ ./elasticsearch-reset-password -a -b -s -u elastic
WARNING: Owner of file [/usr/elastic/elasticsearch-8.0.1/config/users] used to be [root], but now is [elasticsearch]
WARNING: Group of file [/usr/elastic/elasticsearch-8.0.1/config/users] used to be [root], but now is [elasticsearch]
WARNING: Owner of file [/usr/elastic/elasticsearch-8.0.1/config/users_roles] used to be [root], but now is [elasticsearch]
WARNING: Group of file [/usr/elastic/elasticsearch-8.0.1/config/users_roles] used to be [root], but now is [elasticsearch]
--Em-dDwVFYVHb9le2dj
```
После получения теперь можно смотреть вывод команды:

```bash
mike@mike-VirtualBox:~$ curl -u elastic:--Em-dDwVFYVHb9le2dj -X GET "localhost:9200/?pretty"
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "Uz-KqoPvSse1fkrlWig9PA",
  "version" : {
    "number" : "8.0.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "801d9ccc7c2ee0f2cb121bbe22ab5af77a902372",
    "build_date" : "2022-02-24T13:55:40.601285296Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}

```


```bash

```


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.


Ответ.
-----

```bash

```

```bash

```

```bash

```

```bash

```


## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

Ответ.
-----

```bash

```

```bash

```

```bash

```

```bash

```


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---