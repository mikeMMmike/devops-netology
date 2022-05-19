# Домашнее задание к занятию "09.02 CI\CD"

## Знакомоство с SonarQube

### Подготовка к выполнению

1. Выполняем `docker pull sonarqube:8.7-community`
2. Выполняем `docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community`
3. Ждём запуск, смотрим логи через `docker logs -f sonarqube`
4. Проверяем готовность сервиса через [браузер](http://localhost:9000)
5. Заходим под admin\admin, меняем пароль на свой

В целом, в [этой статье](https://docs.sonarqube.org/latest/setup/install-server/) описаны все варианты установки, включая и docker, но так как нам он нужен разово, то достаточно того набора действий, который я указал выше.


### Лог подготовки:


```bash
mike@mike-VirtualBox:~/devops/09-ci-02-cicd$ docker pull sonarqube:8.7-community
8.7-community: Pulling from library/sonarqube
22599d3e9e25: Pull complete 
00bb4d95f2aa: Pull complete 
3ef8cf8a60c8: Pull complete 
928990dd1bda: Pull complete 
07cca701c22e: Pull complete 
Digest: sha256:70496f44067bea15514f0a275ee898a7e4a3fedaaa6766e7874d24a39be336dc
Status: Downloaded newer image for sonarqube:8.7-community
docker.io/library/sonarqube:8.7-community
mike@mike-VirtualBox:~/devops/09-ci-02-cicd$ docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community
28037385f5eef838466ad4f1ef78f18cd48c65c4b66f93575c294371c1b52c78
mike@mike-VirtualBox:~/devops/09-ci-02-cicd$ docker logs -f sonarqube
2022.05.17 17:36:44 INFO  app[][o.s.a.AppFileSystem] Cleaning or creating temp directory /opt/sonarqube/temp
2022.05.17 17:36:44 INFO  app[][o.s.a.es.EsSettings] Elasticsearch listening on [HTTP: 127.0.0.1:9001, TCP: 127.0.0.1:42717]
--------------
2022.05.17 17:38:49 INFO  app[][o.s.a.SchedulerImpl] SonarQube is up
2022.05.17 17:38:50 INFO  ce[][o.s.c.t.CeWorkerImpl] worker AYDTGdk_3W5wZ_isw30r found no pending task (including indexation task). Disabling indexation task lookup for this worker until next SonarQube restart.

```



### Основная часть

1. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
4. Проверяем `sonar-scanner --version`
5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`
6. Смотрим результат в интерфейсе
7. Исправляем ошибки, которые он выявил(включая warnings)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ


### Лог основной части:
```bash
ike@mike-VirtualBox:~$ export PATH=$PATH:/home/mike/devops/09-ci-02-cicd/sonar-scanner-4.7.0.2747-linux/bin
mike@mike-VirtualBox:~$ sonar-scanner -v
INFO: Scanner configuration file: /home/mike/devops/09-ci-02-cicd/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.13.0-41-generic amd64
```
Запускаем сканирование:
```bash
mike@mike-VirtualBox:~/devops/09-ci-02-cicd/example$ sonar-scanner -Dsonar.login=059b4e78969d4a487289c796477ecbd7bdc501fe -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /home/mike/devops/09-ci-02-cicd/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: /home/mike/devops/09-ci-02-cicd/example/sonar-project.properties
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.13.0-41-generic amd64
INFO: User cache: /home/mike/.sonar/cache
INFO: Scanner configuration file: /home/mike/devops/09-ci-02-cicd/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: /home/mike/devops/09-ci-02-cicd/example/sonar-project.properties
INFO: Analyzing on SonarQube server 8.7.1
INFO: Default locale: "ru_RU", source code encoding: "UTF-8" (analysis is platform dependent)
INFO: Load global settings
INFO: Load global settings (done) | time=92ms
INFO: Server id: BF41A1F2-AYDTsru2SPuG5op-YTJ4
INFO: User cache: /home/mike/.sonar/cache
INFO: Load/download plugins
INFO: Load plugins index
INFO: Load plugins index (done) | time=49ms
INFO: Load/download plugins (done) | time=121ms
INFO: Process project properties
INFO: Process project properties (done) | time=0ms
INFO: Execute project builders
INFO: Execute project builders (done) | time=1ms
INFO: Project key: devOps-netology
INFO: Base dir: /home/mike/devops/09-ci-02-cicd/example
INFO: Working dir: /home/mike/devops/09-ci-02-cicd/example/.scannerwork
INFO: Load project settings for component key: 'devOps-netology'
INFO: Load project settings for component key: 'devOps-netology' (done) | time=57ms
INFO: Load quality profiles
INFO: Load quality profiles (done) | time=150ms
INFO: Load active rules
INFO: Load active rules (done) | time=2302ms
WARN: SCM provider autodetection failed. Please use "sonar.scm.provider" to define SCM of your project, or disable the SCM Sensor in the project settings.
INFO: Indexing files...
INFO: Project configuration:
INFO:   Excluded sources for coverage: fail.py
INFO: 2 files indexed
INFO: Quality profile for py: Sonar way
INFO: ------------- Run sensors on module devOps-netology
INFO: Load metrics repository
INFO: Load metrics repository (done) | time=40ms
INFO: Sensor Python Sensor [python]
INFO: Starting global symbols computation
INFO: 1 source files to be analyzed
INFO: Load project repositories
INFO: Load project repositories (done) | time=34ms
INFO: Starting rules execution
INFO: 1/1 source files have been analyzed
INFO: 1 source files to be analyzed
INFO: Sensor Python Sensor [python] (done) | time=5687ms
INFO: 1/1 source files have been analyzed
INFO: Sensor Cobertura Sensor for Python coverage [python]
INFO: Sensor Cobertura Sensor for Python coverage [python] (done) | time=13ms
INFO: Sensor PythonXUnitSensor [python]
INFO: Sensor PythonXUnitSensor [python] (done) | time=1ms
INFO: Sensor CSS Rules [cssfamily]
INFO: No CSS, PHP, HTML or VueJS files are found in the project. CSS analysis is skipped.
INFO: Sensor CSS Rules [cssfamily] (done) | time=0ms
INFO: Sensor JaCoCo XML Report Importer [jacoco]
INFO: 'sonar.coverage.jacoco.xmlReportPaths' is not defined. Using default locations: target/site/jacoco/jacoco.xml,target/site/jacoco-it/jacoco.xml,build/reports/jacoco/test/jacocoTestReport.xml
INFO: No report imported, no coverage information will be imported by JaCoCo XML Report Importer
INFO: Sensor JaCoCo XML Report Importer [jacoco] (done) | time=3ms
INFO: Sensor C# Properties [csharp]
INFO: Sensor C# Properties [csharp] (done) | time=1ms
INFO: Sensor JavaXmlSensor [java]
INFO: Sensor JavaXmlSensor [java] (done) | time=1ms
INFO: Sensor HTML [web]
INFO: Sensor HTML [web] (done) | time=5ms
INFO: Sensor VB.NET Properties [vbnet]
INFO: Sensor VB.NET Properties [vbnet] (done) | time=1ms
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=0ms
INFO: SCM Publisher No SCM system was detected. You can use the 'sonar.scm.provider' property to explicitly specify it.
INFO: CPD Executor Calculating CPD for 1 file
INFO: CPD Executor CPD calculation finished (done) | time=15ms
INFO: Analysis report generated in 84ms, dir size=92 KB
INFO: Analysis report compressed in 21ms, zip size=12 KB
INFO: Analysis report uploaded in 80ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://localhost:9000/dashboard?id=devOps-netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://localhost:9000/api/ce/task?id=AYDT4kzz811QEunstl-A
INFO: Analysis total time: 10.032 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 11.040s
INFO: Final Memory: 7M/30M
INFO: ------------------------------------------------------------------------
```
6. [Результат в интерфейсе](https://github.com/mikeMMmike/devops-netology/tree/main/09-ci-02-cicd/src/1.sonar-BUGs.PNG)

7. Исправленный fail.py:
```python
    index = 1
def increment(index):
    return index
def get_square(numb):
    return numb*numb
def print_numb(numb):
    print("Number is {}".format(numb))
#    pass

index = 0
while (index < 10):
    index = increment(index)
    print(get_square(index))
```

8. Повторно анализировали:

```bash
mike@mike-VirtualBox:~/devops/09-ci-02-cicd/example$ sonar-scanner -Dsonar.login=059b4e78969d4a487289c796477ecbd7bdc501fe -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /home/mike/devops/09-ci-02-cicd/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: /home/mike/devops/09-ci-02-cicd/example/sonar-project.properties
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.13.0-41-generic amd64
INFO: User cache: /home/mike/.sonar/cache
INFO: Scanner configuration file: /home/mike/devops/09-ci-02-cicd/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: /home/mike/devops/09-ci-02-cicd/example/sonar-project.properties
INFO: Analyzing on SonarQube server 8.7.1
INFO: Default locale: "ru_RU", source code encoding: "UTF-8" (analysis is platform dependent)
INFO: Load global settings
INFO: Load global settings (done) | time=85ms
INFO: Server id: BF41A1F2-AYDTsru2SPuG5op-YTJ4
INFO: User cache: /home/mike/.sonar/cache
INFO: Load/download plugins
INFO: Load plugins index
INFO: Load plugins index (done) | time=46ms
INFO: Load/download plugins (done) | time=114ms
INFO: Process project properties
INFO: Process project properties (done) | time=0ms
INFO: Execute project builders
INFO: Execute project builders (done) | time=1ms
INFO: Project key: devOps-netology
INFO: Base dir: /home/mike/devops/09-ci-02-cicd/example
INFO: Working dir: /home/mike/devops/09-ci-02-cicd/example/.scannerwork
INFO: Load project settings for component key: 'devOps-netology'
INFO: Load project settings for component key: 'devOps-netology' (done) | time=15ms
INFO: Load quality profiles
INFO: Load quality profiles (done) | time=44ms
INFO: Load active rules
INFO: Load active rules (done) | time=1263ms
WARN: SCM provider autodetection failed. Please use "sonar.scm.provider" to define SCM of your project, or disable the SCM Sensor in the project settings.
INFO: Indexing files...
INFO: Project configuration:
INFO:   Excluded sources for coverage: fail.py
INFO: 2 files indexed
INFO: Quality profile for py: Sonar way
INFO: ------------- Run sensors on module devOps-netology
INFO: Load metrics repository
INFO: Load metrics repository (done) | time=31ms
INFO: Sensor Python Sensor [python]
INFO: Starting global symbols computation
INFO: 1 source files to be analyzed
INFO: Load project repositories
INFO: Load project repositories (done) | time=18ms
INFO: 1/1 source files have been analyzed
INFO: Starting rules execution
INFO: 1 source files to be analyzed
ERROR: Unable to parse file: fail.py
ERROR: Parse error at line 1 column 0:

  -->      index = 1
    2: def increment(index):
    3:     return index
    4: def get_square(numb):
    5:     return numb*numb

INFO: 1/1 source files have been analyzed
INFO: Sensor Python Sensor [python] (done) | time=149ms
INFO: Sensor Cobertura Sensor for Python coverage [python]
INFO: Sensor Cobertura Sensor for Python coverage [python] (done) | time=11ms
INFO: Sensor PythonXUnitSensor [python]
INFO: Sensor PythonXUnitSensor [python] (done) | time=0ms
INFO: Sensor CSS Rules [cssfamily]
INFO: No CSS, PHP, HTML or VueJS files are found in the project. CSS analysis is skipped.
INFO: Sensor CSS Rules [cssfamily] (done) | time=1ms
INFO: Sensor JaCoCo XML Report Importer [jacoco]
INFO: 'sonar.coverage.jacoco.xmlReportPaths' is not defined. Using default locations: target/site/jacoco/jacoco.xml,target/site/jacoco-it/jacoco.xml,build/reports/jacoco/test/jacocoTestReport.xml
INFO: No report imported, no coverage information will be imported by JaCoCo XML Report Importer
INFO: Sensor JaCoCo XML Report Importer [jacoco] (done) | time=4ms
INFO: Sensor C# Properties [csharp]
INFO: Sensor C# Properties [csharp] (done) | time=1ms
INFO: Sensor JavaXmlSensor [java]
INFO: Sensor JavaXmlSensor [java] (done) | time=1ms
INFO: Sensor HTML [web]
INFO: Sensor HTML [web] (done) | time=4ms
INFO: Sensor VB.NET Properties [vbnet]
INFO: Sensor VB.NET Properties [vbnet] (done) | time=1ms
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=1ms
INFO: SCM Publisher No SCM system was detected. You can use the 'sonar.scm.provider' property to explicitly specify it.
INFO: CPD Executor Calculating CPD for 0 files
INFO: CPD Executor CPD calculation finished (done) | time=0ms
INFO: Analysis report generated in 105ms, dir size=91 KB
INFO: Analysis report compressed in 17ms, zip size=11 KB
INFO: Analysis report uploaded in 27ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://localhost:9000/dashboard?id=devOps-netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://localhost:9000/api/ce/task?id=AYDUC_Yk811QEunstl-d
INFO: Analysis total time: 3.317 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 4.443s
INFO: Final Memory: 7M/27M
INFO: ------------------------------------------------------------------------

```


9. [Cкриншот](https://github.com/mikeMMmike/devops-netology/tree/main/09-ci-02-cicd/src/2.sonar-Passed.PNG) успешного прохождения анализа


## Знакомство с Nexus

### Подготовка к выполнению

1. Выполняем `docker pull sonatype/nexus3`
2. Выполняем `docker run -d -p 8081:8081 --name nexus sonatype/nexus3`
3. Ждём запуск, смотрим логи через `docker logs -f nexus`
4. Проверяем готовность сервиса через [бразуер](http://localhost:8081)
5. Узнаём пароль от admin через `docker exec -it nexus /bin/bash`
6. Подключаемся под админом, меняем пароль, сохраняем анонимный доступ

### Лог

3. В логах все ок:
```bash
2022-05-19 16:38:12,927+0000 INFO  [jetty-main-1] *SYSTEM org.eclipse.jetty.server.Server - Started @53492ms
2022-05-19 16:38:12,928+0000 INFO  [jetty-main-1] *SYSTEM org.sonatype.nexus.bootstrap.jetty.JettyServer - 
-------------------------------------------------

Started Sonatype Nexus OSS 3.38.1-01

-------------------------------------------------

```

4. [Проверили готовность сервиса через браузер](https://github.com/mikeMMmike/devops-netology/tree/main/09-ci-02-cicd/src/1.nexus.PNG)
5. Получили пароль администратора: 
```bash
21:39:09 j0 mike@mike-VirtualBox:~
$ docker exec -it nexus /bin/bash
bash-4.4$ cat ./nexus-data/admin.password 
c7e1070d-dd93-442d-841d-12ed32546bf8
```
6. [Подключились, сменили пароль и сохранили анонимный доступ](https://github.com/mikeMMmike/devops-netology/tree/main/09-ci-02-cicd/src/2.nexus.PNG)

### Основная часть

1. В репозиторий `maven-public` загружаем артефакт с GAV параметрами:
   1. groupId: netology
   2. artifactId: java
   3. version: 8_282
   4. classifier: distrib
   5. type: tar.gz
2. В него же загружаем такой же артефакт, но с version: 8_102
3. Проверяем, что все файлы загрузились успешно
4. В ответе присылаем файл `maven-metadata.xml` для этого артефекта

### Ответ: [maven-metadata.xml](https://github.com/mikeMMmike/devops-netology/tree/main/09-ci-02-cicd/src/maven-metadata.xml) для этого артефекта

 
### Знакомство с Maven

### Подготовка к выполнению

1. Скачиваем дистрибутив с [maven](https://maven.apache.org/download.cgi)
2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
3. Проверяем `mvn --version`
4. Забираем директорию [mvn](./mvn) с pom

### Лог
2. Разархивируем, делаем так, чтобы binary был доступен:
```bash
02:44:23 j0 mike@mike-VirtualBox:~/devops/09-ci-02-cicd
$ export PATH=$PATH:/home/mike/devops/09-ci-02-cicd/apache-maven-3.8.5-bin/bin/mvn
```
Установили JDK:
```bash
03:09:10 j0 mike@mike-VirtualBox:~
$ sudo apt install default-jdk
```

3. Првоеряем версию:
```bash
03:09:10 j0 mike@mike-VirtualBox:~
$ mvn -v
Apache Maven 3.8.5 (3599d3414f046de2324203b78ddcf9b5e4388aa0)
Maven home: /home/mike/devops/09-ci-02-cicd/apache-maven-3.8.5-bin
Java version: 11.0.15, vendor: Private Build, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: ru_RU, platform encoding: UTF-8
OS name: "linux", version: "5.13.0-41-generic", arch: "amd64", family: "unix"
```

### Основная часть

1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт
4. В ответе присылаем исправленный файл `pom.xml`

### Лог
1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
<modelVersion>4.0.0</modelVersion>
<groupId>netology</groupId>
<artifactId>java</artifactId>
<version>8_282</version>
<repositories>
<repository>
<id>my-repo</id>
<name>maven-public</name>
<url>http://localhost:8081/repository/maven-public/</url>
</repository>
</repositories>
<dependencies>
<!--      <dependency>
      <groupId>somegroup</groupId>
      <artifactId>someart</artifactId>
      <version>somevers</version>
      <classifier>someclass</classifier>
      <type>sometype</type>
    </dependency>  -->
</dependencies>
</project>
```
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
```bash
03:25:48 j0 mike@mike-VirtualBox:~/devops/09-ci-02-cicd/mvn
$ mvn package
[INFO] Scanning for projects...
[INFO] 
[INFO] ---------------------------< netology:java >----------------------------
[INFO] Building java 8_282
[INFO] --------------------------------[ jar ]---------------------------------
Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/2.6/maven-resources-plugin-2.6.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/2.6/maven-resources-plugin-2.6.pom (8.1 kB at 10.0 kB/s)


---------------
сокращено
---------------



Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.0/plexus-utils-3.0.jar (226 kB at 637 kB/s)
Downloaded from central: https://repo.maven.apache.org/maven2/commons-lang/commons-lang/2.1/commons-lang-2.1.jar (208 kB at 575 kB/s)
[WARNING] JAR will be empty - no content was marked for inclusion!
[INFO] Building jar: /home/mike/devops/09-ci-02-cicd/mvn/target/java-8_282.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  29.511 s
[INFO] Finished at: 2022-05-20T03:26:40+05:00
[INFO] ------------------------------------------------------------------------


```

3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт
```bash
$ ls -la ~/.m2/repository/
итого 44
drwxrwxr-x 11 mike mike 4096 мая 20 03:26 .
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 ..
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 backport-util-concurrent
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 classworlds
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 com
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 commons-cli
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 commons-lang
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 commons-logging
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 junit
drwxrwxr-x  3 mike mike 4096 мая 20 03:26 log4j
drwxrwxr-x  6 mike mike 4096 мая 20 03:26 org

```
### Ответ: [Исправленный файл `pom.xml`](https://github.com/mikeMMmike/devops-netology/tree/main/09-ci-02-cicd/src/pom.xml)
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---