# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

## Решение.

Установил, используя менеджер пакетов apt:

```bash
root@make-lptp:/home/mike# apt-get install golang
Чтение списков пакетов… Готово
Построение дерева зависимостей       
Чтение информации о состоянии… Готово
Будут установлены следующие дополнительные пакеты:
  golang-1.13 golang-1.13-doc golang-1.13-go golang-1.13-race-detector-runtime
  golang-1.13-src golang-doc golang-go golang-race-detector-runtime golang-src
Предлагаемые пакеты:
  bzr | brz mercurial subversion
Следующие НОВЫЕ пакеты будут установлены:
  golang golang-1.13 golang-1.13-doc golang-1.13-go
  golang-1.13-race-detector-runtime golang-1.13-src golang-doc golang-go
  golang-race-detector-runtime golang-src
Обновлено 0 пакетов, установлено 10 новых пакетов, для удаления отмечено 0 пакетов, и 0 пакетов не обновлено.
Необходимо скачать 63,5 MB архивов.
После данной операции объём занятого дискового пространства возрастёт на 329 MB.
Хотите продолжить? [Д/н] y
Пол:1 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-1.13-src amd64 1.13.8-1ubuntu1 [12,6 MB]
Пол:2 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-1.13-go amd64 1.13.8-1ubuntu1 [47,6 MB]
Пол:3 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-1.13-doc all 1.13.8-1ubuntu1 [2 525 kB]
Пол:4 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-1.13 all 1.13.8-1ubuntu1 [11,2 kB]
Пол:5 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-src amd64 2:1.13~1ubuntu2 [4 044 B]
Пол:6 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-go amd64 2:1.13~1ubuntu2 [22,0 kB]
Пол:7 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-doc all 2:1.13~1ubuntu2 [2 948 B]
Пол:8 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang amd64 2:1.13~1ubuntu2 [2 900 B]
Пол:9 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-1.13-race-detector-runtime amd64 0.0+svn332029-0ubuntu2 [713 kB]
Пол:10 http://ru.archive.ubuntu.com/ubuntu focal/main amd64 golang-race-detector-runtime amd64 2:1.13~1ubuntu2 [3 836 B]
Получено 63,5 MB за 42с (1 522 kB/s)                                           
Выбор ранее не выбранного пакета golang-1.13-src.
(Чтение базы данных … на данный момент установлено 304276 файлов и каталогов.)
Подготовка к распаковке …/0-golang-1.13-src_1.13.8-1ubuntu1_amd64.deb …
Распаковывается golang-1.13-src (1.13.8-1ubuntu1) …
Выбор ранее не выбранного пакета golang-1.13-go.
Подготовка к распаковке …/1-golang-1.13-go_1.13.8-1ubuntu1_amd64.deb …
Распаковывается golang-1.13-go (1.13.8-1ubuntu1) …
Выбор ранее не выбранного пакета golang-1.13-doc.
Подготовка к распаковке …/2-golang-1.13-doc_1.13.8-1ubuntu1_all.deb …
Распаковывается golang-1.13-doc (1.13.8-1ubuntu1) …
Выбор ранее не выбранного пакета golang-1.13.
Подготовка к распаковке …/3-golang-1.13_1.13.8-1ubuntu1_all.deb …
Распаковывается golang-1.13 (1.13.8-1ubuntu1) …
Выбор ранее не выбранного пакета golang-src.
Подготовка к распаковке …/4-golang-src_2%3a1.13~1ubuntu2_amd64.deb …
Распаковывается golang-src (2:1.13~1ubuntu2) …
Выбор ранее не выбранного пакета golang-go.
Подготовка к распаковке …/5-golang-go_2%3a1.13~1ubuntu2_amd64.deb …
Распаковывается golang-go (2:1.13~1ubuntu2) …
Выбор ранее не выбранного пакета golang-doc.
Подготовка к распаковке …/6-golang-doc_2%3a1.13~1ubuntu2_all.deb …
Распаковывается golang-doc (2:1.13~1ubuntu2) …
Выбор ранее не выбранного пакета golang.
Подготовка к распаковке …/7-golang_2%3a1.13~1ubuntu2_amd64.deb …
Распаковывается golang (2:1.13~1ubuntu2) …
Выбор ранее не выбранного пакета golang-1.13-race-detector-runtime.
Подготовка к распаковке …/8-golang-1.13-race-detector-runtime_0.0+svn332029-0ubuntu2_amd64.deb …
Распаковывается golang-1.13-race-detector-runtime (0.0+svn332029-0ubuntu2) …
Выбор ранее не выбранного пакета golang-race-detector-runtime.
Подготовка к распаковке …/9-golang-race-detector-runtime_2%3a1.13~1ubuntu2_amd64.deb …
Распаковывается golang-race-detector-runtime (2:1.13~1ubuntu2) …
Настраивается пакет golang-1.13-src (1.13.8-1ubuntu1) …
Настраивается пакет golang-1.13-race-detector-runtime (0.0+svn332029-0ubuntu2) …
Настраивается пакет golang-1.13-go (1.13.8-1ubuntu1) …
Настраивается пакет golang-src (2:1.13~1ubuntu2) …
Настраивается пакет golang-race-detector-runtime (2:1.13~1ubuntu2) …
Настраивается пакет golang-go (2:1.13~1ubuntu2) …
Настраивается пакет golang-1.13-doc (1.13.8-1ubuntu1) …
Настраивается пакет golang-1.13 (1.13.8-1ubuntu1) …
Настраивается пакет golang-doc (2:1.13~1ubuntu2) …
Настраивается пакет golang (2:1.13~1ubuntu2) …
Обрабатываются триггеры для man-db (2.9.1-1) …
root@make-lptp:/home/mike# exit
exit
mike@make-lptp:~$ go
Go is a tool for managing Go source code.

Usage:

	go <command> [arguments]

```

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
   
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 

## Решение.

1. [Модифицировал](./src/foot.go) приведенный в задании код:
```bash
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Введите количество метров: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 0.3048
    
        fmt.Println((input), " м. равняется", (output), "фт.")    
    }

```
Результат:
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/07-terraform-05-golang/src$ go run foot.go 
Введите количество метров: 7
7  м. равняется 2.1336 фт.
```

2. Наименьший элемент будем искать, [используя цикл for](./src/minimum.go):
```bash
 package main

import "fmt"

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	minimum := x[0]
	for _, n := range x {
		if n < minimum {
			minimum = n
		}
	}
	fmt.Println(minimum)
}

```

Результат:
```bash
 mike@make-lptp:~/PycharmProjects/devops-netology/07-terraform-05-golang/src$ go run ./minimum.go
9
```

3. [Программа для вывода чисел от 0 до 100](./src/0to100.go), которые целочисленно делятся на 3


```bash
  package main
  
  import "fmt"
  
  func main() {
      end := 0
      for n := 0; n<100; n++ {
          end +=n
          if n % 3 ==0 && n != 0 {
          fmt.Println(n)
          }
      }
  }

```
Результат:
```bash
mike@make-lptp:~/PycharmProjects/devops-netology/07-terraform-05-golang/src$ go run ./0to100.go 
3
6
9
12
15
18
21
24
27
30
33
36
39
42
45
48
51
54
57
60
63
66
69
72
75
78
81
84
87
90
93
96
99

```


## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
