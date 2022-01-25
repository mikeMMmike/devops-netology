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
Так запустим же его, отредактируем содержимое html файла, запустим web-сервер: 
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
Проверим страницу на хосте по адресу http://localhost:8080/. Результат: [devops.PNG](https://github.com/mikeMMmike/devops-netology/blob/main/05-virt-03-docker/wellDone.PNG)



```* Запустим docker:
```bash
mike@mike-VirtualBox:~/devops/05-virt-03-docker/docker$ docker run -it -p 8080:80 ubuntu/nginx bash
```
Установим nano, откроем на редактирование файл и заменим содержимое. Сохраним и запустим сервис nginx:
```bash
root@deeced2f189f:/# apt-get install nano
root@deeced2f189f:/# nano /var/www/html/index.nginx-debian.html 
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I'm DevOps Engineer!</h1>
</body>
</html>
root@deeced2f189f:/# service nginx start
 * Starting nginx nginx
```
`Проверим страницу на хосте по адресу http://localhost:8080/. Результат: [devops.PNG](https://github.com/mikeMMmike/devops-netology/blob/main/05-virt-03-docker/wellDone.PNG)`
```
```
