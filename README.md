# PAM

## Описание домашнего задания:
1. Запретить всем пользователям, кроме группы `admin` логин в выходные (суббота и воскресенье), без учета праздников.
2. Дать конкретному пользователю права работать с `docker` и возможность рестартить докер сервис.

## Описание действий.
 1. Запретить всем пользователям, кроме группы `admin` логин в выходные (суббота и воскресенье), без учета праздников.

Создание группы:
```
groupadd admin
```
Добавление пользователя `root` в группу `admin`:
```
usermod -aG admin root
```
Установка модуля pam_script:
```
for pkg in epel-release pam_script; do yum install -y $pkg; done
```
Добавить в `/etc/pam.d/sshd`:
```
auth       required     pam_script.so
```
Изменить содержимое `/etc/pam_script`:
```
#!/bin/bash

if groups $PAM_USER | grep admin; then
    exit 0;
else
    if [[ $(date +%u) -gt 5 ]]; then
        exit 1;
    fi
fi
```

Пользователи, входящие в группу `admin` смогут заходить по ssh на сервер. Пользователи, у которых нет принадлежности к данной группе, не смогут авторизоваться на сервере:
```
ssh root@localhost -p 3000
root@localhost's password: 
Last failed login: Sun Feb 19 08:48:42 UTC 2023 from 10.0.2.2 on ssh:notty
There were 3 failed login attempts since the last successful login.
Last login: Sun Feb 19 08:43:46 2023 from 10.0.2.2

```
```
ssh vagrant@localhost -p 3000
vagrant@localhost's password: 
Permission denied, please try again.
vagrant@localhost's password: 
Permission denied, please try again.
vagrant@localhost's password: 
vagrant@localhost: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
```

 2. Дать конкретному пользователю права работать с `docker` и возможность рестартить докер сервис.

Для того, чтобы предоставить такие возможности пользователю, его необходимо добавить в группу `docker`
```
$ groups sergey
sergey : sergey adm cdrom sudo dip plugdev lpadmin lxd sambashare
```
```
$ docker ps
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
```
```
# usermod -aG docker sergey
```
```
$ groups sergey
sergey : sergey adm cdrom sudo dip plugdev lpadmin lxd sambashare docker
```
```
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
