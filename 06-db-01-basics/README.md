Введение
Перед выполнением задания вы можете ознакомиться с [дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

Задача 1
=====
Архитектор ПО решил проконсультироваться у вас, какой тип БД лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

* Электронные чеки в json виде
* Склады и автомобильные дороги для логистической компании
* Генеалогические деревья
* Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации
* Отношения клиент-покупка для интернет-магазина

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

Ответ:
-----
* Электронные чеки в json виде. Документо-ориентированная БД. Чек - это документ, имеющий определенную стандартизованную структуру. Также существует специальный тип NoSQL СУБД для хранения подобных данных, и имя ему - Документоориентированный. 

* Склады и автомобильные дороги для логистической компании. Для хранения информации, используемой в логистической компании необходимо использовать реляционную СУБД, т.к. количество данных большое, 
такие данные нельзя подвести по формат 1 СУБД. в Реляционной СУБД для объединения данных используются связи полей в таблицах, это позволит создать целостную СУБД для хранения и обработки данных. Другие СУБД не подойдут для реализации этой задачи.  

* Генеалогические деревья. Такие данные хранить правильнее в Иерархических СУБД, т.к. генеалогическое дерево представляет собой иерархию родственных связей. Также можно применить реляционную СУБД для решения этой задачи. Поля "Отец" и "Мать" будут предоставлять информацию по ветвлениям.

* Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации. Эту задачу прекрасно закроет NoSQL СУБД Key-value. Ветвления какого-либо или сложных связей данных здесь не предполагается, идентификатор и кэш прекрасно сохранится в Key-Value БД. 

* Отношения клиент-покупка для интернет-магазина. NoSQL СУБД Key-value прекрасно подойдет: ключ, например - клиент, значение - либо 0, если покупки не было, либо 1, если покупка состоялась. 
Если же потребуется детализировать данные, например, добавить данные, какой товар приобретен, сумма и прочие - тогда лучшим решением будет Реляционная СУБД.
Если данные о сумме покупки не требуются, то можно использовать NoSQL графовые СУБД.


Задача 2
=====
Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если (каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

* Данные записываются на все узлы с задержкой до часа (асинхронная запись)
* При сетевых сбоях, система может разделиться на 2 раздельных кластера
* Система может не прислать корректный ответ или сбросить соединение
* А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

Ответ:
-----

Классификация по CAP:

* Данные записываются на все узлы с задержкой до часа (асинхронная запись)
Система доступна в любой момент времени благодаря асинхронной записи, и также благодаря
ей не может обеспечить согласованность, поэтому классифицируется как AP 
* При сетевых сбоях система может разделиться на 2 раздельных кластера 
CA. Система не противостоит разделению.
* Система может не прислать корректный ответ или сбросить соединение
CP, т.к. система не может обеспечить доступность, т.е. корректный отклик на любой запрос к системе.

Классификация по PACELC:

* Данные записываются на все узлы с задержкой до часа (асинхронная запись)
Система доступна в любой момент времени благодаря асинхронной записи, и также благодаря
ей не может обеспечить согласованность, поэтому классифицируется как PA\EL. 
* При сетевых сбоях система может разделиться на 2 раздельных кластера 
Система не противостоит разделению. Т.к. система делится на 2 раздельных кластера и не может обеспечить согласованности, 
значит перед нами, скорее всего, EL. 
* Система может не прислать корректный ответ или сбросить соединение
PC\EC, т.к. система не может обеспечить доступность, т.е. корректный отклик на любой запрос к системе.


Задача 3
=====
Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

Ответ:
-----
Скорее всего нет, не может. На принципе ACID проектируются и строятся высоконадежные системы. Принцип на первое место 
ставит надежность и целостность. Принцип BASE позволяет строить высокопроизводительные системы. На первое место выдвигается
скорость обработке данных в ущерб целостности и доступности.

Задача 4
=====
Вам дали задачу написать системное решение, основой которого бы послужили:

* фиксация некоторых значений со временем жизни
* реакция на истечение таймаута
Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

Ответ:
-----

Что это за система?
* Это СУБД вида ключ-значение Redis. Она удовлетворяет поставленной задаче, т.к. имеетcя возможность сохранить данные, 
хранящиеся в оперативной памяти, на диск по истечению тайм-аута 


* Какие минусы выбора системы Redis? 
Основной минус - в Redis из коробки нет механизма консенсуса и при отказе ведущей реплики необходимо вручную выбирать мастер-реплику. Нивелируется применением системы управления
системой управления базами данных (каламбур - СУСУБД) Redis Sentinel. Также в незначительный минус можно записать Pub\Sub, 
т.к. для нее придется организовывать очередь отправляемых сообщений. 