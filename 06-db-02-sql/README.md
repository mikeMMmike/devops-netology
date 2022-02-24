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
```bash

```

```bash

```

```bash

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

```

```bash

```

```bash

```


Задача 5
=====
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.


Ответ: 
-----
```bash

```

```bash

```

```bash

```


Задача 6
=====
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

Ответ: 
-----
```bash

```

```bash

```

```bash

```