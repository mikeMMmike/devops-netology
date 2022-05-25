# Домашнее задание к занятию "09.04 Teamcity"

## Подготовка к выполнению

1. Поднимите инфраструктуру [teamcity](./teamcity/docker-compose.yml)
2. Если хочется, можете создать свою собственную инфраструктуру на основе той технологии, которая нравится. Инструкция по установке из [документации](https://www.jetbrains.com/help/teamcity/installing-and-configuring-the-teamcity-server.html)
3. Дождитесь запуска teamcity, выполните первоначальную настройку
4. Авторизуйте агент
5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity)

## Лог
```bash
23:04:53 j0 mike@mike-VirtualBox:~/devops/09-ci-04-teamcity
$ nano docker-compose.yml
23:16:31 j0 mike@mike-VirtualBox:~/devops/09-ci-04-teamcity
$ docker-compose up
Creating network "09-ci-04-teamcity_default" with the default driver
Pulling teamcity (jetbrains/teamcity-server:)...
latest: Pulling from jetbrains/teamcity-server
8e5c1b329fe3: Pulling fs layer
8e5c1b329fe3: Downloading [>                                                  ] 8e5c1b329fe3: Pull complete
64dee48628f0: Pull complete
5a2d719b40dc: Pull complete
ca2e8e6655af: Pull complete
4c008ffb7caf: Pull complete
175900217477: Pull complete
975c3a4cd854: Pull complete
2f5d07f4b386: Pull complete
ae346c1c7409: Pull complete
00688a883120: Pull complete
3e7bbae24930: Pull complete
9cee82ded787: Pull complete
Digest: sha256:b4d2a754120e5127c7cf25a7fa2f7a5d6e1fb29c8ceebd23f15617973f34ea9b
Status: Downloaded newer image for jetbrains/teamcity-server:latest
Pulling teamcity-agent (jetbrains/teamcity-agent:)...
latest: Pulling from jetbrains/teamcity-agent
8e5c1b329fe3: Already exists
af04e3b0d368: Pull complete
751fa93adcf3: Pull complete
9804fd17adee: Pull complete
abd0efc03b48: Pull complete
c9676889c693: Pull complete
a8ef19137703: Pull complete
e354b09d03a9: Pull complete
4e83712a9f67: Pull complete
76f757d1188f: Pull complete
a515f4a9ff60: Pull complete
Digest: sha256:9dcd7e6704d6dae4ce2ca1768f304edcdbc40c28441ab692fa5bf39573bbca50
Status: Downloaded newer image for jetbrains/teamcity-agent:latest
Creating 09-ci-04-teamcity_teamcity_1 ... done
Creating 09-ci-04-teamcity_teamcity-agent_1 ... done
Attaching to 09-ci-04-teamcity_teamcity_1, 09-ci-04-teamcity_teamcity-agent_1
teamcity_1        | /run-services.sh
teamcity_1        | /services/check-server-volumes.sh
teamcity-agent_1  | /run-services.sh
teamcity-agent_1  | /services/run-docker.sh
teamcity_1        | 
teamcity_1        | >>> Permission problem: TEAMCITY_DATA_PATH '/data/teamcity_server/datadir' is not a writeable directory
teamcity_1        | >>> Permission problem: TEAMCITY_LOGS '/opt/teamcity/logs' is not a writeable directory
teamcity_1        | 
teamcity_1        |     Looks like some mandatory directories are not writable (see above).
teamcity_1        |     TeamCity container is running under 'tcuser' (1000/1000) user.
teamcity_1        | 
teamcity_1        |     A quick workaround: pass '-u 0' parameter to 'docker run' command to start it under 'root' user.
teamcity_1        |     The proper fix: run 'chown -R 1000:1000' on the corresponding volume(s), this can take noticeable time.
teamcity_1        | 
teamcity_1        |     If the problem persists after the permission fix, please check that the corresponding volume(s)
teamcity_1        |     are not used by stale stopped Docker containers ("docker container prune" command may help).
teamcity_1        | 
09-ci-04-teamcity_teamcity_1 exited with code 1
teamcity-agent_1  | /run-agent.sh
teamcity-agent_1  | Will create new buildAgent.properties using distributive
teamcity-agent_1  | TeamCity URL is provided: http://teamcity:8111
teamcity-agent_1  | Will prepare agent config
teamcity-agent_1  | cp: cannot create regular file '/data/teamcity_agent/conf/buildAgent.dist.properties': Permission denied
teamcity-agent_1  | cp: cannot create regular file '/data/teamcity_agent/conf/buildAgent.properties': Permission denied
teamcity-agent_1  | cp: cannot create regular file '/data/teamcity_agent/conf/log4j.dtd': Permission denied
teamcity-agent_1  | cp: cannot create regular file '/data/teamcity_agent/conf/teamcity-agent-log4j2.xml': Permission denied
teamcity-agent_1  | Error! Stopping the script.
09-ci-04-teamcity_teamcity-agent_1 exited with code 1

```

Столкнулся с проблемой отсутствия разрешений на запись в директорию. С разрешениями суперпользователя проблема сохранилась
Создал каталоги и файлы вручную, предоставил разрешения записи всем:

```bash
23:37:43 j0 mike@mike-VirtualBox:~/teamcity/data
$ sudo mkdir -p /opt/teamcity/logs
23:37:47 j0 mike@mike-VirtualBox:~/teamcity/data
$ sudo chmod 777 /opt/teamcity/logs
23:38:32 j0 mike@mike-VirtualBox:~/teamcity/data
$ sudo mkdir -p /data/teamcity_agent/conf/
23:38:37 j0 mike@mike-VirtualBox:~/teamcity/data
$ sudo chmod 777 /data/teamcity_agent/conf/
23:38:53 j0 mike@mike-VirtualBox:~/teamcity/data
$ touch /data/teamcity_agent/conf/buildAgent.dist.properties
23:39:27 j0 mike@mike-VirtualBox:~/teamcity/data
$ touch /data/teamcity_agent/conf/buildAgent.properties
23:39:38 j0 mike@mike-VirtualBox:~/teamcity/data
$ touch /data/teamcity_agent/conf/log4j.dtd
23:39:50 j0 mike@mike-VirtualBox:~/teamcity/data
$ touch /data/teamcity_agent/conf/teamcity-agent-log4j2.xml
$ mkdir -p ~/teamcity/agent/
00:17:18 j0 mike@mike-VirtualBox:~/teamcity/data
$ sudo chmod 777 ~/teamcity/agent/
[sudo] пароль для mike: 
00:17:49 j0 mike@mike-VirtualBox:~/teamcity/data
$ docker run -it jetbrains/teamcity-agent bash
buildagent@247ad5c12d89:/$ 
```
**"Это не то решение, которое вы ищете"(с)**. Насоздавав неверных директорий, которые должны присутствовать не на хосте, но в контейнере, воспользовался быстрым костылём "A quick workaround: pass '-u 0' parameter to 'docker run' command to start it under 'root' user." от Jetbrains, т.к. "нормальный" их совет "The proper fix: run 'chown -R 1000:1000' on the corresponding volume(s), this can take noticeable time." не возымел эффекта. [Работает](./src/teamcityStart.PNG) 

```bash
00:12:02 j0 mike@mike-VirtualBox:~/devops/09-ci-04-teamcity
$ docker run -u 0 jetbrains/teamcity-server
/run-services.sh
/services/check-server-volumes.sh

/run-server.sh
TeamCity server.xml parameter: -config conf/server.xml
Java executable is found: '/opt/java/openjdk/bin/java'
2022-05-24 19:12:21 UTC: Starting TeamCity server

CTRL+C


00:15:24 j0 mike@mike-VirtualBox:~/devops/09-ci-04-teamcity
$ docker-compose up
Recreating 09-ci-04-teamcity_teamcity_1 ... done
Recreating 09-ci-04-teamcity_teamcity-agent_1 ... done
Attaching to 09-ci-04-teamcity_teamcity_1, 09-ci-04-teamcity_teamcity-agent_1
teamcity-agent_1  | /run-services.sh

-------------------------
Сокращенный вывод
-------------------------
teamcity_1        | Startup confirmation is required. Open TeamCity web page in the browser. Server is running at http://localhost:8111

```

4. [Аторизовываем агента](./src/teamcityAgent.PNG)

## Основная часть

1. Создайте новый проект в teamcity на основе fork
2. Сделайте autodetect конфигурации
3. Сохраните необходимые шаги, запустите первую сборку master'a
4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean package`, иначе `mvn clean test`
5. Мигрируйте `build configuration` в репозиторий
6. Создайте отдельную ветку `feature/add_reply` в репозитории
7. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`
8. Дополните тест для нового метода на поиск слова `hunter` в новой реплике
9. Сделайте push всех изменений в новую ветку в репозиторий
10. Убедитесь что сборка самостоятельно запустилась, тесты прошли успешно
11. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`
12. Убедитесь, что нет собранного артефакта в сборке по ветке `master`
13. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки
14. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны
15. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity
16. В ответ предоставьте ссылку на репозиторий



## Лог выполнения
1. [Создали проект](./src/project.png)
2. [Autodetect](./src/buildStep.png)
3. [Первая сборка](./src/3_firstBuild.png)
4. [Условия изменили](./src/4.Test&Clean.png):

```xml

 package _Self.buildTypes

import jetbrains.buildServer.configs.kotlin.*
import jetbrains.buildServer.configs.kotlin.buildSteps.maven
import jetbrains.buildServer.configs.kotlin.triggers.vcs

object Build : BuildType({
    name = "Build"

    vcs {
        root(HttpsGithubComMikeMMmikeExampleTeamcityGitRefsHeadsMaster)
    }
steps {
    maven {
        name = "first_step_test"

        conditions {
            doesNotContain("teamcity.build.branch", "master")
        }
        goals = "clean test"
        runnerArgs = "-Dmaven.test.failure.ignore=true"
    }
    maven {
        name = "second_step_clean"

        conditions {
            contains("teamcity.build.branch", "master")
        }
        goals = "clean package"
        runnerArgs = "-Dmaven.test.failure.ignore=true"
    }
}
    triggers {
        vcs {
        }
    }
})
```
5. [Настройка миграции `build configuration` в репозиторий](./src/5.ExportSettings.PNG): Настройки проекта "Versioned Settings" > Выбираем "Synchronization enabled" > Выбираем единственный на данный момент проект "VCS Root" > Apply. Когда экспорт будет завершен, нажимаем "Commit current project settings"
6. Создали отдельную ветку `feature/add_reply` [в репозитории](https://github.com/mikeMMmike/example-teamcity/tree/feature/add_reply)
7. Добавим новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter` в [файл](https://github.com/mikeMMmike/example-teamcity/blob/feature/add_reply/src/main/java/plaindoll/Welcomer.java)  

```json
package plaindoll;

public class Welcomer{
	public String sayWelcome() {
		return "Welcome home, good hunter. What is it your desire?";
	}
	public String sayFarewell() {
		return "Farewell, good hunter. May you find your worth in waking world.";
	}
	public String sayReplica() {
		return "Oh my hunter";
    }
}
```
8. Дополните тест для нового метода на поиск слова `hunter` в новой реплике в [файл](https://github.com/mikeMMmike/example-teamcity/blob/feature/add_reply/src/test/java/plaindoll/WelcomerTest.java): 
```json
@Test
	public void welcomersayReplica() {
		assertThat(welcomer.sayReplica(), containsString("hunter"));
	}
```
9. Заpushили изменения в новую ветку в репозиторий
10. Сборка самостоятельно запустилась, [тесты прошли успешно](./src/10.test_feature.PNG):

```bash
[23:32:35]The build is removed from the queue to be prepared for the start
[23:32:35]Collecting changes in 1 VCS root
[23:32:35]Starting the build on the agent "09-ci-04-teamcity_teamcity-agent_1"
[23:32:36]Free disk space requirement (3s)
[23:32:39]Updating tools for build
[23:32:39]Clearing temporary directory: /opt/buildagent/temp/buildTmp
[23:32:39]Publishing internal artifacts
[23:32:39]Using vcs information from agent file: 5bf4f477376a0e1a.xml
[23:32:39]Checkout directory: /opt/buildagent/work/5bf4f477376a0e1a
[23:32:39]Updating sources: auto checkout (on agent) (1s)
[23:32:41]Free disk space requirement (3s)
[23:32:44]Free disk space requirement (2s)
[23:32:47]Step 1/2: first_step_test (Maven) (45s)
[23:33:32]Step 2/2: second_step_clean (Maven)
[23:33:32]Publishing internal artifacts
[23:33:33]Build finished
```
11. [Внесите изменения из произвольной ветки](./src/11.merge.PNG) `feature/add_reply` в `master` через `Merge`
12. Убедитесь, что нет собранного артефакта в сборке по ветке `master`
13. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки
14. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны
15. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity
16. В ответ предоставьте ссылку на репозиторий

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---