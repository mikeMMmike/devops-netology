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

COPY ./elasticsearch.yml /usr/elastic/elasticsearch-8.0.1/config/elasticsearch.yml

RUN groupadd -g 3000 elasticsearch && \
    adduser -u 3000 -g elasticsearch -s /bin/sh elasticsearch && \
    chmod 777 -R /var/lib/ && \
    chmod 777 -R /usr/elastic/elasticsearch-8.0.1/

USER 3000
EXPOSE 9200
EXPOSE 9300

WORKDIR /usr/elastic/elasticsearch-8.0.1/bin/
CMD ["./elasticsearch"]2
```




Процесс создания образа и отправки в dockerhub:
```bash
mike@mike-VirtualBox:~/devops/06-db-05-elasticsearch$ docker build -t mikemmmike/elasticksearch_conf:netology .
Sending build context to Docker daemon  13.82kB
Step 1/13 : FROM centos:7
 ---> eeb6ee3f44bd
Step 2/13 : MAINTAINER Mike Sinica <kish_forever@bk.ru>
 ---> Using cache
 ---> 29c0584be916
Step 3/13 : RUN yum update -y &&       yum install wget -y &&       yum install perl-Digest-SHA -y &&       yum install java-1.8.0-openjdk.x86_64 -y
 ---> Using cache
 ---> 9af86abd2a12
Step 4/13 : WORKDIR /usr/elastic/
 ---> Using cache
 ---> 34ac23ad7847
Step 5/13 : RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512
 ---> Using cache
 ---> b37f2cc3f09a
Step 6/13 : RUN shasum -a 512 -c elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 && tar -xzf elasticsearch-8.0.1-linux-x86_64.tar.gz
 ---> Using cache
 ---> d4bb647dd8c5
Step 7/13 : COPY ./elasticsearch.yml /usr/elastic/elasticsearch-8.0.1/config/elasticsearch.yml
 ---> Using cache
 ---> 32924372f058
Step 8/13 : RUN groupadd -g 3000 elasticsearch &&     adduser -u 3000 -g elasticsearch -s /bin/sh elasticsearch &&     chmod 777 -R /var/lib/ &&     chmod 777 -R /usr/elastic/elasticsearch-8.0.1/
 ---> Using cache
 ---> 5f3aaa8e7cc2
Step 9/13 : USER 3000
 ---> Using cache
 ---> 2e8806344497
Step 10/13 : EXPOSE 9200
 ---> Running in 51d7e14626a6
Removing intermediate container 51d7e14626a6
 ---> 4f350d6e6952
Step 11/13 : EXPOSE 9300
 ---> Running in 7e082407931e
Removing intermediate container 7e082407931e
 ---> 7a791af832de
Step 12/13 : WORKDIR /usr/elastic/elasticsearch-8.0.1/bin/
 ---> Running in 58e411272879
Removing intermediate container 58e411272879
 ---> 5d4d446f78a9
Step 13/13 : CMD ["./elasticsearch"]2
 ---> Running in 7661ff28b723
Removing intermediate container 7661ff28b723
 ---> e66ee14c7b8e
Successfully built e66ee14c7b8e
Successfully tagged mikemmmike/elasticksearch_conf:netology

mike@mike-VirtualBox:~$ docker push mikemmmike/elasticksearch_conf:netology
The push refers to repository [docker.io/mikemmmike/elasticksearch_conf]
846b5001fdbb: Pushed 
50c7dcb92bef: Pushed 
c0d0e90198bd: Mounted from mikemmmike/elsticksearch 
b10898396870: Mounted from mikemmmike/elsticksearch 
16b325e5c9c1: Mounted from mikemmmike/elsticksearch 
6073f594a2b6: Mounted from mikemmmike/elsticksearch 
174f56854903: Mounted from mikemmmike/elsticksearch 
netology: digest: sha256:a5bd1196415fb60ced65b3e3868b65fad3782c457faffa1910bc37ea7aad2aa7 size: 1796

```

Elasticsearch.yml:
```bash
# ======================== Elasticsearch Configuration =========================
#
#
# ---------------------------------- Cluster -----------------------------------
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: netology_test
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data
#
path.data: /var/lib/data
#
# Path to log files:
#
path.logs: /var/lib/logs
#
# ----------------------------------- Memory -----------------------------------
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 0.0.0.0
http.port: 9200
# --------------------------------- Discovery ----------------------------------
discovery.type: single-node
# ---------------------------------- Various -----------------------------------
xpack.security.enabled: false
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
mike@mike-VirtualBox:~$ curl -X GET "localhost:9200/?pretty"
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "Jjk0DCPxQXqUZJd5FWjkTw",
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

Ссылка на образ в репозитории dockerhub:
https://hub.docker.com/repository/docker/mikemmmike/elasticksearch_conf




## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии с таблицей:

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
Создание индексов. 

ind-1
```bash
mike@mike-VirtualBox:~$ curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings":{
>    "number_of_shards": 1,
>    "number_of_replicas": 0
>   }
>  }
>  '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
```

ind-2
```bash
mike@mike-VirtualBox:~$ curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
> {
>  "settings":{
>   "number_of_shards": 2,
>   "number_of_replicas": 1
>  }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
```

ind-3
```bash
mike@mike-VirtualBox:~$ curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
> {
>  "settings":{
>   "number_of_shards": 4,
>   "number_of_replicas": 2
>  }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```

Состояние шард:
```bash
mike@mike-VirtualBox:~$ curl -X GET "localhost:9200/_cat/shards?pretty&v=true"
index            shard prirep state      docs store ip         node
ind-3            3     p      STARTED       0  225b 172.17.0.2 netology_test
ind-3            3     r      UNASSIGNED                       
ind-3            3     r      UNASSIGNED                       
ind-3            1     p      STARTED       0  225b 172.17.0.2 netology_test
ind-3            1     r      UNASSIGNED                       
ind-3            1     r      UNASSIGNED                       
ind-3            2     p      STARTED       0  225b 172.17.0.2 netology_test
ind-3            2     r      UNASSIGNED                       
ind-3            2     r      UNASSIGNED                       
ind-3            0     p      STARTED       0  225b 172.17.0.2 netology_test
ind-3            0     r      UNASSIGNED                       
ind-3            0     r      UNASSIGNED                       
ind-1            0     p      STARTED       0  225b 172.17.0.2 netology_test
ind-2            1     p      STARTED       0  225b 172.17.0.2 netology_test
ind-2            1     r      UNASSIGNED                       
ind-2            0     p      STARTED       0  225b 172.17.0.2 netology_test
ind-2            0     r      UNASSIGNED                       
.geoip_databases 0     p      STARTED               172.17.0.2 netology_test
```
Видно, что шарды индексов находятся в состоянии "Не назначено", т.к. при создании не были указаны в назначении шард. Наш сервис находится в single-mode режиме. Выходит, что в данном режиме нет смысла создавать шарды.

Проверим состояние кластера:
```bash
mike@mike-VirtualBox:~$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```
Кластер в данный момент находится в Yellow статусе. Это означает, что данные доступны, но есть проблемы с репликами. Количество активных шард 44,4%

Удалим индексы:
```bash
mike@mike-VirtualBox:~$ curl -X DELETE "localhost:9200/ind-1?pretty"
{
  "acknowledged" : true
}
mike@mike-VirtualBox:~$ curl -X DELETE "localhost:9200/ind-2?pretty"
{
  "acknowledged" : true
}
mike@mike-VirtualBox:~$ curl -X DELETE "localhost:9200/ind-3?pretty"
{
  "acknowledged" : true
}

```

После удаления индексов статус кластера сменился на Зеленый, т.к. количество активных шард теперь 100%: 
```bash
mike@mike-VirtualBox:~$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

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