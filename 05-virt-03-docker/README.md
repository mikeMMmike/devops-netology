Задача 1
=======
Сценарий выполнения задачи:

* создайте свой репозиторий на [https://hub.docker.com](https://hub.docker.com/);
* выберете любой образ, который содержит веб-сервер Nginx;
* создайте свой fork образа;
* реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.


Ответ
------

* Репозиторий https://hub.docker.com/u/mikemmmike
* Выбрали репозиторий ubuntu/nginx
Создадим докер-образ на базе образа ubuntu/nginx, включающий следующие изменения:
* Установлен редактор nano
* файл /var/www/html/index.nginx-debian.html пустой
* сервис nginx остановлен

```bash
mike@mike-VirtualBox:~/devops/05-virt-03-docker/docker$ nano Dockerfile
FROM ubuntu/nginx

#установим nano(для редактирования конфигов), остановим nginx и очистим дефолтную страницу
MAINTAINER mikemmmike
RUN apt-get update && apt-get install -y nano && service nginx stop && echo "" > /var/www/html/index.nginx-debian.html && service nginx stop
```
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker build -t ubuntu-nginx-devops:test .
Sending build context to Docker daemon  4.096kB
Step 1/3 : FROM ubuntu/nginx
 ---> 2b4ebbe96785
Step 2/3 : MAINTAINER mikemmmike
...............
Successfully built 8d7247403e7b
Successfully tagged ubuntu-nginx-devops:test
```
Готово:
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker images
REPOSITORY                       TAG               IMAGE ID       CREATED             SIZE
ubuntu-nginx-devops              test              8d7247403e7b   About an hour ago   171MB
mikemmmike/ubuntu-nginx-devops   test              8d7247403e7b   About an hour ago   171MB
ubuntu-nginx-devops              latest            3883be43da96   2 hours ago         171MB
ubuntu/nginx                     1.18-21.10_beta   2b4ebbe96785   12 days ago         136MB
ubuntu/nginx                     latest            2b4ebbe96785   12 days ago         136MB

```


Так запустим же контейнер, отредактируем содержимое html файла и запустим web-сервер: 
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker run -it -p 8080:80 8d7247403e7b bash
root@5a096bbbfaa8:/# nano /var/www/html/index.nginx-debian.html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I'm DevOps Engineer!</h1>
</body>
</html>

root@5a096bbbfaa8:/# service nginx start
 * Starting nginx nginx
```
Проверим страницу на хосте по адресу http://localhost:8080/. Результат: [devops.PNG](https://github.com/mikeMMmike/devops-netology/blob/main/05-virt-03-docker/devops.PNG)

**И здесь возникли у меня вопросы из-за недостатка знаний. Дело в том, что по заданию необходимо сделать запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код.
Но при редактировании данных в запущенном докере они будут актуальны, пока он активен и при завершении изменения не сохранятся. Т.е в образ не попадут. 
Есть вариант редактирования дефолтного файла nginx при помощи echo, но это такое себе решение. Прошу подсказать, как можно реализовать
редактирование файлов при помощи Dockerfile для сборки образа. Вот мой вариант, для этого сценария он работоспособен, но только лишь для выполнения 
простого редактирования и для написания более сложных файлов не подойдет:**
```bash
MAINTAINER mikemmmike
RUN service nginx stop && echo "<html><head>Hey, Netology</head>" > /var/www/html/index.nginx-debian.html && \
echo "<body><h1>I’m DevOps Engineer</h1></body></html>" >> /var/www/html/index.nginx-debian.html && service nginx start
```
Продолжим выполнение.
Необходимо опубликовать наш форк.
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker login -u mikemmmike
Password: 
Login Succeeded
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker push mikemmmike/ubuntu-nginx-devops:test
The push refers to repository [docker.io/mikemmmike/ubuntu-nginx-devops]
c6ea66f6124d: Pushed 
58027612532d: Pushed 
2ad091084a94: Pushed 
eeab1ec83910: Pushed 
32e5d0569349: Pushed 
test: digest: sha256:1ec8143585a975c672a3ded4cdab7ae0afbf707cdc2fd9706ebbc5a834c03c40 size: 1367
```
Образ лежит в [публичном репозитории](https://hub.docker.com/layers/mikemmmike/ubuntu-nginx-devops/test/images/sha256-1ec8143585a975c672a3ded4cdab7ae0afbf707cdc2fd9706ebbc5a834c03c40?context=explore) 


Задача 2
=======
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

* Высоконагруженное монолитное java веб-приложение;
* Nodejs веб-приложение;
* Мобильное приложение c версиями для Android и iOS;
* Шина данных на базе Apache Kafka;
* Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
* Мониторинг-стек на базе Prometheus и Grafana;
* MongoDB, как основное хранилище данных для java-приложения;
* Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Ответ
------
**Т.к. у меня вовсе нет опыта работы и представления об указанных технологиях, буду давать ответы исходя из характеристик вроде "высоконагруженное, основное, база данных, web приложение":) 
Поэтому прошу в случае ошибки дать комментарий, какую технологию развертки корректно применить. Немного информации для поверхностного понимания технологий почерпнул.**

* Высоконагруженное монолитное java веб-приложение. Для этого сценария я бы применил либо отдельную ВМ, либо контейнер при использовании сети Host.
Это позволит проще обновлять и переносить приложение, при этом контейнеру будут доступны ресурсы хоста, включая высокую утилизацию канала связи 
* Nodejs веб-приложение. Web-приложения можно располагать в контейнерах. Это решение позволит масштабировать, добавляя ноды при росте нагрузки и 
сворачивать лишние экземпляры в периоды минимальной нагрузки на сервис. 
* Мобильное приложение c версиями для Android и iOS. Контейнеры. Предоставляют удобство тестирования, быструю развертку при обеспечении идемпотентности среды и быструю доставку кода. 
* Шина данных на базе Apache Kafka. Можно применить в ВМ или на физическом сервере. Шина данных требует большую пропускную способность сети, а также может хранить большое количество холодных данных. 
Контейнеризировать такой сервис нет большой необходимости в силу громоздкости сервиса. Это решение требует хорошего планирование сервиса и, скорее всего, не требует быстрой доставки и развертывания. 
* Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana. На мой взгляд есть 2 варианта: виртуализация и контейнеризация.
Контейнеризация позволит избавиться от виртуализации оборудования и разместить несколько сервисов на 1 хосте, а при увеличении нагрузки контейнеры можно переместить на другой хост. 
В случае с применением ВМ мы получаем возможность миграции ВМ для обслуживания оборудования, либо для переезда сервиса на более производительный хост   
* Мониторинг-стек на базе Prometheus и Grafana. Можно использовать контейнеры и ВМ. в случае с контейнерами сервисы можно разместить каждый в своем контейнере, используя 1 общую смонтированную 
директорию для обмена данными между сервисами
* MongoDB, как основное хранилище данных для java-приложения. БД лучше располагать на ВМ, т.к. проще обслуживать и бекапить. Также это позволит избежать просадки производительности
и сохранит возможность увеличения производительности ВМ за счет добавления вычислительных ресурсов при необходимости.
* Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. Лучшим решением в данном случае будет ВМ, т.к. контейнеры скорее всего 
не смогут предоставить такой надежности и большого количества инструментов для обслуживания данных сервисов как ВМ. Также поддержка и конфигурация такого 
контейнера будет непростой.

Задача 3
=======
* Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
* Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
* Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
* Добавьте еще один файл в папку /data на хостовой машине;
* Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.


Ответ
------
Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;

```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker pull centos:centos8.4.2105
centos8.4.2105: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:centos8.4.2105
docker.io/library/centos:centos8.4.2105

root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker images
REPOSITORY                       TAG               IMAGE ID       CREATED        SIZE
ubuntu-nginx-devops              test              8d7247403e7b   3 hours ago    171MB
mikemmmike/ubuntu-nginx-devops   test              8d7247403e7b   3 hours ago    171MB
ubuntu-nginx-devops              latest            3883be43da96   4 hours ago    171MB
ubuntu/nginx                     1.18-21.10_beta   2b4ebbe96785   12 days ago    136MB
ubuntu/nginx                     latest            2b4ebbe96785   12 days ago    136MB
centos                           centos8.4.2105    5d0da3dc9764   4 months ago   231MB

root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker run -it -v /home/mike/devops/05-virt-03-docker/data:/tmp/data 5d0da3dc9764 bash
[root@db77e4c008d8 /]#
ctrl+p ctrl+q
```

Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера:
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker pull debian
Using default tag: latest
latest: Pulling from library/debian
0e29546d541c: Pull complete 
Digest: sha256:2906804d2a64e8a13a434a1a127fe3f6a28bf7cf3696be4223b06276f32f1f2d
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker images
REPOSITORY                       TAG               IMAGE ID       CREATED        SIZE
mikemmmike/ubuntu-nginx-devops   test              8d7247403e7b   3 hours ago    171MB
ubuntu-nginx-devops              test              8d7247403e7b   3 hours ago    171MB
ubuntu-nginx-devops              latest            3883be43da96   4 hours ago    171MB
ubuntu/nginx                     1.18-21.10_beta   2b4ebbe96785   12 days ago    136MB
ubuntu/nginx                     latest            2b4ebbe96785   12 days ago    136MB
debian                           latest            6f4986d78878   5 weeks ago    124MB
centos                           centos8.4.2105    5d0da3dc9764   4 months ago   231MB
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker run -it -v /home/mike/devops/05-virt-03-docker/data:/tmp/data 6f4986d78878 bash
```

Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker exec -it db77e4c008d8 bash
[root@db77e4c008d8 /]# echo "this message from centos container" > /tmp/data/centos_file.txt
[root@db77e4c008d8 /]# ls /tmp/data/
centos_file.txt
ctrl+p ctrl+q
```

Добавьте еще один файл в папку /data на хостовой машине
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# echo "this is file from host" > ./data/host_file.txt
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# ls ./data/
host_file.txt
```

Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker ps
CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS          PORTS     NAMES
414c08a2d146   6f4986d78878   "bash"    24 minutes ago   Up 24 minutes             bold_brahmagupta
db77e4c008d8   5d0da3dc9764   "bash"    35 minutes ago   Up 35 minutes             thirsty_elbakyan
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# docker exec -it 414c08a2d146 bash
root@414c08a2d146:/# ls /tmp/data/
centos_file.txt
root@414c08a2d146:/# cat /tmp/data/centos_file.txt 
this message from centos container
```

**По какой-то причине файл из Контейнера Centos отображается в контейнере Debian, но недоступен на хосте. Файл из контейнера Debian не отображается ни в контейнере Centos, ни на хосте. Файл из хоста не отображается в обоих контейнерах. Проверил параметры запуска контейнеров - вроде верно. Пробовал менять директорию монтирования - тщетно. В чем может быть причина? Не правильная реализация? Буду рад обратной связи**  


Доработка задания 1.
=====

Задание 1
Вместо apt-get нужно использовать apt.
Посмотрите, что выполняет команда COPY в докер-файле.

Ответ.
-----
Благодарю за подсказки:)

На хостовой машине создали файл example.html

```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# nano ./example.html

<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

Поправил Dockerfile:
```bash
FROM ubuntu/nginx

#скопируем файл HTML, установим nano(для редактирования конфигов), перезапустим nginx
MAINTAINER mikemmmike
COPY ./example.html /var/www/html/index.nginx-debian.html
RUN apt update && apt install -y nano && service nginx start
```



Доработка Задания 3.
=====
Задание 3
Не увидел создания файла из debian. Оно точно было?

вы подключали в контейнер /home/mike/devops/05-virt-03-docker/data
а создавали на хосте в /home/mike/devops/05-virt-03-docker/docker/data/

Ответ.
-----
Да, действительно: проверил пути и выяснил, что создавал файл на хосте не в той директории. Пересоздал файл в корректной директории:

```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker/docker# cd ..
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker# echo "this is file from host" > ./data/host_file.txt
```
Запустил контейнер с дебиан:

```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker# docker run -it -v /home/mike/devops/05-virt-03-docker/data:/tmp/data 6f4986d78878 bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker# docker ps
CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS          PORTS     NAMES
4b679c1c0780   6f4986d78878   "bash"    13 minutes ago   Up 13 minutes             sleepy_archimedes
db77e4c008d8   5d0da3dc9764   "bash"    9 days ago       Up 9 days                 thirsty_elbakyan
```

Листинг и содержимое файлов в контейнере Debian:
```bash
root@mike-VirtualBox:/home/mike/devops/05-virt-03-docker# docker exec -it 4b679c1c0780 bash
root@4b679c1c0780:/# ls /tmp/data/
centos_file.txt  host_file.txt
root@4b679c1c0780:/# cat /tmp/data/centos_file.txt && cat /tmp/data/host_file.txt 
this message from centos container
this is file from host
```

По условиям задачи в Debian нужно только просмотреть смонтированную директорию и файлы в ней. Все действительно работает:)