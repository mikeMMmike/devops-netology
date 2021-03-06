### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-01-bash/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

---


# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | переменная с - строка с текстом a+b|
| `d`  | 1+2  | d переменная - строка с выводом значения переменных а и b|
| `e`  | 3  | Переменная е принимает значение результата арифметической операции сложения переменных а и b, т.к. они заключены в скобки |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```
Необходимо добавить ) и дописать условие завершения скрипта в случае успешного выполнения curl
```bash
#!/usr/bin/env bash
while ((1==1))
do
       curl https://localhost:4757
        if (($? != 0))
        then
                date >> curl.log
        else exit
        fi
done
```


Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
#!/usr/bin/env bash
echo Запущен процесс проверки доступности узлов 192.168.0.1, 173.194.222.113, 87.250.250.242
sleep 2
echo
addr=(192.168.0.1 173.194.222.113 87.250.250.242)
for i in ${addr[@]}
do
a=5
while (($a>0))
    do
    echo
    echo  повторов проверки доступности узла $i осталось: $a
    sleep 2
    echo
    curl -I --connect-timeout 1 http://$i >> /dev/null
       	if (($? !=0))
          then
          a=$(($a-1))        
          echo `date` " IP-адрес "$i" Не доступен" >> log
          else
          echo `date` " IP-адрес "$i" Доступен" >> log
          a=$(($a-1))
       	fi
    done
	if (($a==0))
	then
	echo
	echo Проверка доступности узла $i завершена
	echo
	fi
done
```
Результат вывода в файл log:
```bash
Fri 17 Dec 2021 11:03:02 PM UTC  IP-адрес 192.168.0.1 Не доступен
Fri 17 Dec 2021 11:03:05 PM UTC  IP-адрес 192.168.0.1 Не доступен
Fri 17 Dec 2021 11:03:08 PM UTC  IP-адрес 192.168.0.1 Не доступен
Fri 17 Dec 2021 11:03:11 PM UTC  IP-адрес 192.168.0.1 Не доступен
Fri 17 Dec 2021 11:03:14 PM UTC  IP-адрес 192.168.0.1 Не доступен
Fri 17 Dec 2021 11:03:17 PM UTC  IP-адрес 173.194.222.113 Доступен
Fri 17 Dec 2021 11:03:19 PM UTC  IP-адрес 173.194.222.113 Доступен
Fri 17 Dec 2021 11:03:21 PM UTC  IP-адрес 173.194.222.113 Доступен
Fri 17 Dec 2021 11:03:24 PM UTC  IP-адрес 173.194.222.113 Доступен
Fri 17 Dec 2021 11:03:26 PM UTC  IP-адрес 173.194.222.113 Доступен
Fri 17 Dec 2021 11:03:28 PM UTC  IP-адрес 87.250.250.242 Доступен
Fri 17 Dec 2021 11:03:30 PM UTC  IP-адрес 87.250.250.242 Доступен
Fri 17 Dec 2021 11:03:33 PM UTC  IP-адрес 87.250.250.242 Доступен
Fri 17 Dec 2021 11:03:35 PM UTC  IP-адрес 87.250.250.242 Доступен
Fri 17 Dec 2021 11:03:37 PM UTC  IP-адрес 87.250.250.242 Доступен
```

## Обязательная задача 3
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/bin/bash
echo Запущен процесс проверки доступности узлов 192.168.0.1, 173.194.222.113, 87.250.250.242
sleep 2
echo
addr=(192.168.0.1 173.194.222.113 87.250.250.242)

while ((1==1))
do
for i in ${addr[@]}
do
sleep 2
curl -I --connect-time 1 http://$i >/dev/null
       if (($?!=0))
	    then
	    echo `date` " IP-адресс "$i"  недоступен" >> error
	    sleep 2
	    echo
	    echo "IP-адресс "$i"  недоступен"
	    echo
	    break 2
       fi
done
done
```
результат вывода  в файл error:
```bash
Fri 17 Dec 2021 11:26:36 PM UTC  IP-адресс 192.168.0.1  недоступен
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Ваш скрипт:
```bash
???
```