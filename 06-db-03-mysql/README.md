# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/mikeMMmike/devops-netology/tree/main/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.


Ответ
-----

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```bash
root@mike-VirtualBox:/home/mike# docker pull mysql:8.0-debian
mike@mike-VirtualBox:~/devops/06-db-03-mysql$ docker run --name devops1 -v /home/mike/devops/06-db-03-mysql/src/db1:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=devops -d mysql:8.0-debian
```
Изучите [бэкап БД](https://github.com/mikeMMmike/devops-netology/tree/main/06-db-03-mysql/test_data) и 
восстановитесь из него.
```bash
mike@mike-VirtualBox:~/devops/06-db-03-mysql$ docker exec -it devops1 bash
root@cab391767585:/# mysql -u root --password="devops"                               
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 8.0.28 MySQL Community Server - GPL
***********************


mysql> CREATE DATABASE test_db;
Query OK, 1 row affected (0.01 sec)
mysql> exit
Bye
root@cab391767585:/# mysql test_db -u root --password="devops" < var/lib/mysql/test_dump.sql
```

Перейдите в управляющую консоль `mysql` внутри контейнера.
```bash
root@cab391767585:/# mysql -u root --password="devops"  
```
Используя команду `\h` получите список управляющих команд.
```bash
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'

```
Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
```bash
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Server version:		8.0.28 MySQL Community Server - GPL

```
Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```bash
mysql> \u test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)


```
**Приведите в ответе** количество записей с `price` > 300.
```bash
mysql> select * from orders where price>300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

```


## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

Ответ
-----
Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```bash
mysql> create user 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
Query OK, 0 rows affected (0.08 sec)

```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
```bash
mysql> grant select on *.*  to test@localhost;
Query OK, 0 rows affected, 1 warning (0.02 sec)

```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```bash
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.03 sec)

```



## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

Ответ
-----

Установите профилирование `SET profiling = 1`.
```bash
mysql> set profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
```

Изучите вывод профилирования команд `SHOW PROFILES;`.
```bash
mysql> show profiles;
Empty set, 1 warning (0.00 sec)
```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**:
Engine: InnoDB

```bash
mysql> SHOW TABLE STATUS \G;
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2022-02-28 21:05:29
    Update_time: 2022-02-28 21:05:29
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)

ERROR: 
No query specified

```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`

```bash
mysql> ALTER TABLE orders ENGINE=MyISAM;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW TABLE STATUS \G;
*************************** 1. row ***************************
           Name: orders
         Engine: MyISAM
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2022-02-28 22:28:17
    Update_time: 2022-02-28 21:05:29
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)


```

- на `InnoDB`
```bash
mysql> ALTER TABLE orders ENGINE=InnoDB;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW TABLE STATUS \G;
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2022-02-28 22:29:04
    Update_time: 2022-02-28 21:05:29
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.01 sec)



```

Время выполнения и запрос на изменения из профайлера:
```bash
mysql> SHOW PROFILES;
+----------+------------+----------------------------------------------+
| Query_ID | Duration   | Query                                        |
+----------+------------+----------------------------------------------+
|        1 | 0.00016675 | SHOW TABLE STATUS like orders                |
|        2 | 0.00010400 | SHOW TABLE STATUS from test_db like orders   |
|        3 | 0.00499600 | SHOW TABLE STATUS from test_db like 'orders' |
|        4 | 0.00673625 | SHOW TABLE STATUS                            |
|        5 | 0.09952625 | ALTER TABLE orders ENGINE=MyISAM             |
|        6 | 0.00335975 | SHOW TABLE STATUS                            |
|        7 | 0.09707575 | ALTER TABLE orders ENGINE=InnoDB             |
|        8 | 0.00433825 | SHOW TABLE STATUS                            |
+----------+------------+----------------------------------------------+

mysql> SHOW PROFILE FOR QUERY 5;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000113 |
| Executing hook on transaction  | 0.000004 |
| starting                       | 0.000034 |
| checking permissions           | 0.000006 |
| checking permissions           | 0.000004 |
| init                           | 0.000023 |
| Opening tables                 | 0.000625 |
| setup                          | 0.000221 |
| creating table                 | 0.001602 |
| waiting for handler commit     | 0.000036 |
| waiting for handler commit     | 0.027382 |
| After create                   | 0.015403 |
| System lock                    | 0.000274 |
| copy to tmp table              | 0.000824 |
| waiting for handler commit     | 0.000044 |
| waiting for handler commit     | 0.000034 |
| waiting for handler commit     | 0.000075 |
| rename result table            | 0.000216 |
| waiting for handler commit     | 0.015031 |
| waiting for handler commit     | 0.000092 |
| waiting for handler commit     | 0.004691 |
| waiting for handler commit     | 0.000050 |
| waiting for handler commit     | 0.017804 |
| waiting for handler commit     | 0.000039 |
| waiting for handler commit     | 0.002222 |
| end                            | 0.007335 |
| query end                      | 0.004954 |
| closing tables                 | 0.000051 |
| waiting for handler commit     | 0.000120 |
| freeing items                  | 0.000090 |
| cleaning up                    | 0.000131 |
+--------------------------------+----------+
31 rows in set, 1 warning (0.00 sec)

mysql> SHOW PROFILE FOR QUERY 7;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000140 |
| Executing hook on transaction  | 0.000012 |
| starting                       | 0.000037 |
| checking permissions           | 0.000010 |
| checking permissions           | 0.000009 |
| init                           | 0.000023 |
| Opening tables                 | 0.000432 |
| setup                          | 0.000233 |
| creating table                 | 0.000156 |
| After create                   | 0.043237 |
| System lock                    | 0.000055 |
| copy to tmp table              | 0.000731 |
| rename result table            | 0.006976 |
| waiting for handler commit     | 0.000051 |
| waiting for handler commit     | 0.008487 |
| waiting for handler commit     | 0.000060 |
| waiting for handler commit     | 0.019489 |
| waiting for handler commit     | 0.000045 |
| waiting for handler commit     | 0.006228 |
| waiting for handler commit     | 0.000062 |
| waiting for handler commit     | 0.004057 |
| end                            | 0.001397 |
| query end                      | 0.002194 |
| closing tables                 | 0.000047 |
| waiting for handler commit     | 0.000085 |
| freeing items                  | 0.000065 |
| cleaning up                    | 0.002762 |
+--------------------------------+----------+
27 rows in set, 1 warning (0.01 sec)
```


## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---

Ответ
-----

Изучите файл `my.cnf` в директории /etc/mysql.
```bash
root@cab391767585:/# cat /etc/mysql/my.cnf
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

```
Содержание согласно ТЗ:

```bash
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
innodb_log_buffer_size = 1M
innodb_log_file_size = 100M
innodb_buffer_pool_size = 570M
innodb_file_per_table = ON
innodb_flush_log_at_trx_commit = 2
```

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---