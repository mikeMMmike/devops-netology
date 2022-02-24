Введение
=====
Перед выполнением задания вы можете ознакомиться с дополнительными материалами.

Задача 1
=====
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

Ответ: 
-----
Docker-compose манифест:
```bash
version: '3.1'

volumes:
  database:
  backup:

services:
  pg_db:
    image: postgres:12
    restart: always
    environment:
      - POSTGRES_PASSWORD=test
      - POSTGRES_USER=test
    volumes:
      - database:/home/mike/devops/06-db-02-sql/database
      - backup:/home/mike/devops/06-db-02-sql/backup
    ports:
      - ${POSTGRES_PORT:-5432}:5432
```

Листинг.
```bash
root@mike-VirtualBox:/home/mike/devops/06-db-02-sql# docker-compose up
Starting 06-db-02-sql_pg_db_1 ... done
```




Задача 2
=====
В БД из задачи 1:

* создайте пользователя test-admin-user и БД test_db
* в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
* предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
* создайте пользователя test-simple-user
* предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:

* id (serial primary key)
* наименование (string)
* цена (integer)

Таблица clients:

* id (serial primary key)
* фамилия (string)
* страна проживания (string, index)
* заказ (foreign key orders)

Приведите:

* итоговый список БД после выполнения пунктов выше,
* описание таблиц (describe)
* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
* список пользователей с правами над таблицами test_db


Ответ: 
-----
Подключаемся к запущенному контейнеру:
```bash
root@mike-VirtualBox:/home/mike/devops/06-db-02-sql# docker-compose up
Starting 06-db-02-sql_pg_db_1 ... done
root@mike-VirtualBox:/home/mike# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS       PORTS                                       NAMES
e56335ceec64   postgres:12   "docker-entrypoint.s…"   2 hours ago   Up 2 hours   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   06-db-02-sql_pg_db_1
root@mike-VirtualBox:/home/mike# docker exec -it e56335ceec64 bash
root@e56335ceec64:/# psql -U test
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

test=#
```
Создаем пользователя test_admin_user: 
```bash
test=# create user test_admin_user;
CREATE ROLE
```
Создаем таблицы orders и clients, индекс:
```bash
test_db=# create table orders (id serial primary key, Наименование varchar, Цена integer);
CREATE TABLE

test_db=# create table clients (id serial primary key, фамилия varchar, "страна проживания" varchar, заказ serial references orders (id));
CREATE TABLE

test_db=# create index "страна проживания" on clients ("страна проживания");
CREATE INDEX
```
Работа с пользователями. Предоставление разрешений на таблицы, создание:

```bash
test_db=# grant all on orders to test_admin_user;
GRANT
test_db=# grant all on clients to test_admin_user;
GRANT
test_db=# create user test_simple_user;
CREATE ROLE
test_db=# grant SELECT,INSERT,UPDATE,DELETE on orders to test_simple_user;
GRANT
test_db=# grant SELECT,INSERT,UPDATE,DELETE on clients to test_simple_user;
GRANT

```
Итоговый список БД:
```bash
test_db=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 postgres  | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
           |       |          |            |            | test=CTc/test
 template1 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
           |       |          |            |            | test=CTc/test
 test      | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
 test_db   | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
(5 rows)
```
Описание таблиц (describe)
```bash
test_db=# \dt
        List of relations
 Schema |  Name   | Type  | Owner 
--------+---------+-------+-------
 public | clients | table | test
 public | orders  | table | test
(2 rows)

test_db-# \d clients
                                         Table "public.clients"
      Column       |       Type        | Collation | Nullable |                 Default                  
-------------------+-------------------+-----------+----------+------------------------------------------
 id                | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying |           |          | 
 страна проживания | character varying |           |          | 
 заказ             | integer           |           | not null | nextval('"clients_заказ_seq"'::regclass)
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "страна проживания" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db-# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default               
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 Наименование | character varying |           |          | 
 Цена         | integer           |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)


```
SQL-запрос для выдачи списка пользователей с правами над таблицами test_db. В данном случае решили конкретизировать запрос, т.к. без уточнения WHERE получим список более 1500 строк, включающий служебные УЗ СУБД: 
```bash
test_db=# SELECT table_catalog, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'test_admin_user';
 table_catalog | table_schema | table_name | privilege_type 
---------------+--------------+------------+----------------
 test_db       | public       | orders     | INSERT
 test_db       | public       | orders     | SELECT
 test_db       | public       | orders     | UPDATE
 test_db       | public       | orders     | DELETE
 test_db       | public       | orders     | TRUNCATE
 test_db       | public       | orders     | REFERENCES
 test_db       | public       | orders     | TRIGGER
 test_db       | public       | clients    | INSERT
 test_db       | public       | clients    | SELECT
 test_db       | public       | clients    | UPDATE
 test_db       | public       | clients    | DELETE
 test_db       | public       | clients    | TRUNCATE
 test_db       | public       | clients    | REFERENCES
 test_db       | public       | clients    | TRIGGER
(14 rows)

test_db=# SELECT table_catalog, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'test_simple_user';
 table_catalog | table_schema | table_name | privilege_type 
---------------+--------------+------------+----------------
 test_db       | public       | orders     | INSERT
 test_db       | public       | orders     | SELECT
 test_db       | public       | orders     | UPDATE
 test_db       | public       | orders     | DELETE
 test_db       | public       | clients    | INSERT
 test_db       | public       | clients    | SELECT
 test_db       | public       | clients    | UPDATE
 test_db       | public       | clients    | DELETE
(8 rows)
```


Список пользователей с правами над таблицами test_db
```bash
test_db-# \dp
                                          Access privileges
 Schema |       Name        |   Type   |      Access privileges       | Column privileges | Policies 
--------+-------------------+----------+------------------------------+-------------------+----------
 public | clients           | table    | test=arwdDxt/test           +|                   | 
        |                   |          | test_admin_user=arwdDxt/test+|                   | 
        |                   |          | test_simple_user=arwd/test   |                   | 
 public | clients_id_seq    | sequence |                              |                   | 
 public | clients_заказ_seq | sequence |                              |                   | 
 public | orders            | table    | test=arwdDxt/test           +|                   | 
        |                   |          | test_admin_user=arwdDxt/test+|                   | 
        |                   |          | test_simple_user=arwd/test   |                   | 
 public | orders_id_seq     | sequence |                              |                   | 
(5 rows)

```


Задача 3
=====
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

| Наименование  | Цена |
| ------------- | ------------- |
| Шоколад  | 10  |
| Принтер	| 3000  |
| Книга	| 500 |
| Монитор | 	7000 |
| Гитара	| 4000 |

 Таблица clients

| ФИО	| Страна проживания |
| ------------- | ------------- |
| Иванов Иван Иванович	| USA |
| Петров Петр Петрович	| Canada |
| Иоганн Себастьян Бах	| Japan |
| Ронни Джеймс Дио	| Russia |
| Ritchie Blackmore	| Russia |

Используя SQL синтаксис:

* вычислите количество записей для каждой таблицы
* приведите в ответе:
  * запросы
  * результаты их выполнения.


Ответ: 
-----
Добавление данных в таблицу orders:
```bash
test_db=# insert into orders (Наименование, Цена) values ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
INSERT 0 5
est_db=# select * from orders;
 id | Наименование | Цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

```
Добавление данных в таблицу clients
```bash
test_db=# insert into clients (фамилия, "страна проживания") values ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# select * from clients;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     1
  2 | Петров Петр Петрович | Canada            |     2
  3 | Иоганн Себастьян Бах | Japan             |     3
  4 | Ронни Джеймс Дио     | Russia            |     4
  5 | Ritchie Blackmore    | Russia            |     5
(5 rows)
```
Количество записей в таблице orders
```bash
test_db=# select count(*) from orders;
 count 
-------
     5
(1 row)

```
Количество записей в таблице clients
```bash
test_db=# select count(*) from clients;
 count 
-------
     5
(1 row)
```



Задача 4
=====
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

| ФИО	| Заказ | 
| ------------- | ------------- |
| Иванов Иван Иванович	| Книга | 
| Петров Петр Петрович	| Монитор | 
| Иоганн Себастьян Бах	| Гитара | 
Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказка - используйте директиву UPDATE.


Ответ: 
-----
```bash
test_db=# update clients set заказ=3 where id=1;
UPDATE 1
test_db=# update clients set заказ=4 where id=2;
UPDATE 1
test_db=# update clients set заказ=5 where id=3;
UPDATE 1

```
SQL-запрос для выдачи всех пользователей, которые совершили заказ

```bash
test_db=# select фамилия,заказ from clients where id != заказ;
       фамилия        | заказ 
----------------------+-------
 Иванов Иван Иванович |     3
 Петров Петр Петрович |     4
 Иоганн Себастьян Бах |     5
(3 rows)
```


Задача 5
=====
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.


Ответ: 
-----
Результат выполнения плана запроса. 
```bash
explain select фамилия,"страна проживания",заказ from clients where заказ !=0;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..20.12 rows=806 width=68)
   Filter: ("заказ" <> 0)
(2 rows)
```
cost. Приблизительная стоимость запуска (первое значение) - время, которое проходит, прежде чем начнётся этап вывода данных. Приблизительная общая стоимость (второе значение) вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки.
rows. Ожидаемое число строк, которое должен вывести этот узел плана.
width. Ожидаемый средний размер строк в байтах, выводимых этим узлом плана

Задача 6
=====
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

Ответ: 
-----
Сделаем backup:
```bash
pg_dump -U test test_db > /backup/test_db.bkp
```
Запустим новый контейнер:
```bash
root@mike-VirtualBox:/home/mike/devops/06db02sql# docker run --name testbkp -e POSTGRES_PASSWORD=test -v /home/mike/devops/06-db-02-sql/backup:/media/database/backup -d -p 5432:5432 postgres:12
```
Восстановление БД:
```bash
root@a9d9d78e33f4:/# psql -U postgres  < /media/database/backup/test_db.bkp
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
ERROR:  role "test" does not exist
CREATE SEQUENCE
ERROR:  role "test" does not exist
ALTER SEQUENCE
CREATE SEQUENCE
ERROR:  role "test" does not exist
ALTER SEQUENCE
CREATE TABLE
ERROR:  role "test" does not exist
CREATE SEQUENCE
ERROR:  role "test" does not exist
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
     10
(1 row)

 setval
--------
      9
(1 row)

 setval
--------
      6
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
ERROR:  role "test_admin_user" does not exist
ERROR:  role "test_simple_user" does not exist
ERROR:  role "test_admin_user" does not exist
ERROR:  role "test_simple_user" does not exist
```

Готово. БД восстановлена, исключая роли пользователей