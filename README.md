![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/infochest.png)

## apptools-infochest
[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/apptools-infochest)
[![license](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Application tools for technical support and DBMS administrator. View and edit arrays, execute queries, including JDBC/ODBC, sending results to email as XLS files. A few simple graphs on the protocols of the system.
This solution can be installed in earlier versions of Caché and Ensemble (tested 2016.1+). This can be done by importing xml.

## What's new
This project is not only a set of [tools for the administrator](#PanelAdmin), but a platform for the rapid creation of a prototype of any solution.
For example, Photo Album, Music Player, and Personal Books Library all come together in a user-friendly treasure chest design.

Load http:// your-host:your-port/apptoolsrest/a/infochest

Change the path to your treasure files and start viewing, listening or reading from any convenient device: desktop, tablet or smartphone.

![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_1.png)

The example will be located at ${CSPdir}/apptools/files
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_2.png)

After saving and updating the panel, you can select a music track.
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_3.png)

The built-in HTML5 player is used to play music.
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_4.png)

![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_5.png)

The Lightbox Component is used to view pictures and videos: UiKit.
![](https://raw.githubusercontent.com/SergeyMi37/apptools-infochest/master/doc/chest/Screenshot_6.png)

## Installation with ZPM

If ZPM the current instance is not installed, then in one line you can install the latest version of ZPM.
```
set $namespace="%SYS", name="DefaultSSL" do:'##class(Security.SSLConfigs).Exists(name) ##class(Security.SSLConfigs).Create(name) set url="https://pm.community.intersystems.com/packages/zpm/latest/installer" Do ##class(%Net.URLParser).Parse(url,.comp) set ht = ##class(%Net.HttpRequest).%New(), ht.Server = comp("host"), ht.Port = 443, ht.Https=1, ht.SSLConfiguration=name, st=ht.Get(comp("path")) quit:'st $System.Status.GetErrorText(st) set xml=##class(%File).TempFilename("xml"), tFile = ##class(%Stream.FileBinary).%New(), tFile.Filename = xml do tFile.CopyFromAndSave(ht.HttpResponse.Data) do ht.%Close(), $system.OBJ.Load(xml,"ck") do ##class(%File).Delete(xml)
```
If ZPM is installed, then ZAPM can be set with the command
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
