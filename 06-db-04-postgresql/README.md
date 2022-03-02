# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

Ответ
-----

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
Подключитесь к БД PostgreSQL используя `psql`.
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.
```bash
mike@mike-VirtualBox:~/devops/06-db-04-postgresql$ docker pull postgres:13
mike@mike-VirtualBox:~/devops/06-db-04-postgresql$ docker run --name postgres-devops -v /home/mike/devops/06-db-04-postgresql/db:/var/lib/postgresql/data -e POSTGRES_PASSWORD=devops -d postgres:13
cfd6a5ee0f369699635f0cc7686683f01bcd13c676e2621ea35debc8b77522df
mike@mike-VirtualBox:~/devops/06-db-04-postgresql$ docker exec -it postgres-devops bash
root@cfd6a5ee0f36:/# psql -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=# \?
General
  \copyright     
  ***************
  
```
**Найдите и приведите** управляющие команды для:
- вывода списка БД
```bash
Informational
  (options: S = show system objects, + = additional detail)
\l[+]   [PATTERN]      list databases
```
- подключения к БД
```bash
Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")

```
- вывода списка таблиц
```bash
Informational
  (options: S = show system objects, + = additional detail)
  \d[S+]                 list tables, views, and sequences

```
- вывода описания содержимого таблиц
```bash
Informational
  (options: S = show system objects, + = additional detail)
 \d[S+]  NAME           describe table, view, sequence, or index
```
- выхода из psql
```bash
General
  \q                     quit psql
```




## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/mikeMMmike/devops-netology/tree/main/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

Ответ
-----
Используя `psql` создайте БД `test_database`.
Восстановите бэкап БД в `test_database`.
```bash
postgres=# create database test_database
postgres-# ;
CREATE DATABASE
postgres=# \q
root@cfd6a5ee0f36:/# pg_dump -U postgres  test_database < var/lib/postgresql/data/test_dump.sql 
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6 (Debian 13.6-1.pgdg110+1)
-- Dumped by pg_dump version 13.6 (Debian 13.6-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--
```

Перейдите в управляющую консоль `psql` внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.
```bash
root@cfd6a5ee0f36:/# psql -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=# \c test_database 
You are now connected to database "test_database" as user "postgres".

```
**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```bash

```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Ответ
-----

```bash

```

```bash

```

```bash

```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Ответ
-----

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