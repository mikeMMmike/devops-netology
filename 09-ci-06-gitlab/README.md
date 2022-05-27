# Домашнее задание к занятию "09.06 Gitlab"

## Подготовка к выполнению

1. Необходимо [зарегистрироваться](https://about.gitlab.com/free-trial/)
2. Создайте свой новый проект
3. Создайте новый репозиторий в gitlab, наполните его [файлами](./repository)
4. Проект должен быть публичным, остальные настройки по желанию

## Лог

1. Зарегистрировались
2. Создайте проект: https://gitlab.com/mikeMMmike/devops-netology/
3. Создали репозиторий https://gitlab.com/mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab с файлом https://gitlab.com/mikeMMmike/devops-netology/-/blob/main/09-ci-06-gitlab/repository/python-api.py
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
RUN pip3 install flask flask_jsonpify flask_restful

ADD ./repository/python-api.py /python_api/python-api.py

ENTRYPOINT ["python3", "/python_api/python-api.py"]\
```
 Шаг 7.
Результатом выполнения шага явился файл .gitlab-ci.yml. 
```yaml
image: docker:latest
services:
    - docker:dind
stage_build:
    stage: build
    script:
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker build -t $CI_REGISTRY/mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab .
    except:
        - main
stage_deploy:
    stage: deploy
    script:
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker build -t $CI_REGISTRY//mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab/repository/python-api.py .
        - docker push $CI_REGISTRY//mikeMMmike/devops-netology/-/tree/main/09-ci-06-gitlab/repository/python-api.py
    only:
        - main
```
Но при попытке запустить pipeline на исполнение была получена [ошибка](./src/1-7-error-validate.PNG), т.к. требуется подтвердить аккаунт кредитной картой. Gitlab предлагает использовать локальный раннер: https://docs.gitlab.com/runner/install/



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