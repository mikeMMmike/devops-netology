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

Ответ
------