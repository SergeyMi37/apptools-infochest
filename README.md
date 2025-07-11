 [![Repo-GitHub](https://img.shields.io/badge/dynamic/xml?color=gold&label=GitHub%20module.xml&prefix=ver.&query=%2F%2FVersion&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fapptools-infochest%2Fmaster%2Fmodule.xml)](https://raw.githubusercontent.com/sergeymi37/apptools-infochest/master/module.xml)
[![OEX-apptools-infochest](https://img.shields.io/badge/dynamic/json?url=https:%2F%2Fpm.community.intersystems.com%2Fpackages%2Fapptools-infochest%2F&label=ZPM-pm.community.intersystems.com&query=$.version&color=green&prefix=apptools-infochest)](https://pm.community.intersystems.com/packages/apptools-infochest)

[![Docker-ports](https://img.shields.io/badge/dynamic/yaml?color=blue&label=docker-compose&prefix=ports%20-%20&query=%24.services.iris.ports&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fapptools-infochest%2Fmaster%2Fdocker-compose.yml)](https://raw.githubusercontent.com/sergeymi37/apptools-infochest/master/docker-compose.yml)

## apptools-infochest

[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/apptools-infochest)
[![Demo](https://img.shields.io/badge/Demo%20on-Cloud%20Run%20Deploy-F4A460)](https://infochest.demo.community.intersystems.com/apptoolsrest/a/infochest)

## What's new

Added auto load

A project in which multimedia treasures of files are collected in Photo Album, Music Player and Book Library in a user-friendly responsive interface.

Load http://your-host:your-port/apptoolsrest/a/infochest

Change the path to your treasure files and start viewing, listening or reading from any convenient device: desktop, tablet or smartphone.

![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_1.png)

The example will be located at ${CSPdir}/apptools/files
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_2.png)

After saving and updating the panel, you can select a music track.
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_3.png)
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_pg.png)

The built-in HTML5 player is used to play music.
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_4.png)

![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_5.png)

The Lightbox Component is used to view pictures and videos: UiKit.
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_6.png)
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_rc.png)

## Installation with ZPM

If ZPM the current instance is not installed, then in one line you can install the latest version of ZPM.
```
zn "%SYS" d ##class(Security.SSLConfigs).Create("z") s r=##class(%Net.HttpRequest).%New(),r.Server="pm.community.intersystems.com",r.SSLConfiguration="z" d r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
```
If ZPM is installed, then ZPM can be set with the command
```
zpm:USER>install apptools-infochest
```
## Installation with Docker

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/SergeyMi37/apptools-infochest.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test it
Open IRIS terminal:

```
$ docker-compose exec iris iris session iris
USER>
USER>zpm
zpm:USER>install apptools-infochest
```
