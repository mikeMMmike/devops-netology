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
root@cfd6a5ee0f36:/# psql -U postgres test_database < var/lib/postgresql/data/test_dump.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE

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
test_database=# analyze orders;
ANALYZE
test_database=# select avg_width,attname from pg_stats where tablename = 'orders' order by attname desc limit 1;
 avg_width | attname 
-----------+---------
        16 | title

```


**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
Команда ниже выбирает данные из столбцов avg_width (среднее значение размера элементов в байтах) и attname (Имя столбца, описываемого этой строкой) таблицы pg_stats с сортировкой по убыванию и отображению только одного результата из всех найденных по таблице orders, анализированной ранее. 
```bash
test_database=# select avg_width,attname from pg_stats where tablename = 'orders' order by attname desc limit 1;
 avg_width | attname 
-----------+---------
        16 | title
(1 row)


```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Ответ
-----
Создаем копию таблицы orders:
```bash
CREATE table new_orders (                                                     
      id integer NOT NULL,
      title character varying(80) NOT NULL,
      price integer DEFAULT 0
    );
CREATE TABLE
test_database=# INSERT into new_orders (id, price, title) select id, price, title from orders;
INSERT 0 8
test_database=# drop table orders;                                                     
DROP TABLE
```
Создаем партиционную таблицу orders:
```bash
test_database=# CREATE table orders (                                                     
      id integer NOT NULL,
      title character varying(80) NOT NULL,
      price integer DEFAULT 0
    ) partition by range ( price);
CREATE TABLE
```

Создаем шадры orders_1 и orders_2 для таблицы orders, проверяем таблицу:
```bash
test_database=# create table orders_1 partition of orders for values from (500) to (2147483647);
CREATE TABLE
test_database=# create table orders_2 partition of orders for values from (0) to (500);
CREATE TABLE
test_database=# \d+ orders;
                                    Partitioned table "public.orders"
 Column |         Type          | Collation | Nullable | Default | Storage  | Stats target | Description 
--------+-----------------------+-----------+----------+---------+----------+--------------+-------------
 id     | integer               |           | not null |         | plain    |              | 
 title  | character varying(80) |           | not null |         | extended |              | 
 price  | integer               |           |          | 0       | plain    |              | 
Partition key: RANGE (price)
Partitions: orders_1 FOR VALUES FROM (500) TO (2147483647),
            orders_2 FOR VALUES FROM (0) TO (500)
```
Копируем данные из временной таблицы new_orders в целевую orders:
```bash
test_database=# INSERT into orders (id, price, title) select id, price, title from new_orders;
INSERT 0 8
test_database=# drop table new_orders;
DROP TABLE
```
Проверяем данные в шадрах и самой таблице orders:
```bash
test_database=# select * from orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# select * from orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# select * from orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
(8 rows)
```
Все на месте, задача выполнена.

* Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

```Да, конечно можно было при проектированиии БД учесть необходимость шадрировани таблиц и создавать таблицы с шадрированием по необходимым по задаче условиям```

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