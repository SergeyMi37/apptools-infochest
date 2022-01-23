Include apptools.core

/// http://hp-msw:52773/apptoolsrest/a/infochest
Class apptools.lte.infochest Extends apptools.lte.adminTabs [ ClassType = "", DependsOn = apptools.core.msg, ProcedureBlock ]
{

/// Application title
Parameter HeaderText = "Info Chest";

/// Global Name Store Referens files
Parameter GNStore = "^apptools.infochest";

Parameter AppRoles;

/// do ##class(apptools.lte.adminsample).Init()
ClassMethod Init() As %Status
{
	set ServerPort=##class(apptools.core.net).GetURI(.prop)
	write !,"Open in browser "
    do ##class(apptools.core.Installer).AddAndWriteFavorite(##class(apptools.core.Installer).#AppName_" SampleAdminPanel","/"_##class(apptools.core.Installer).#AppCSP_"rest/a/infochest",ServerPort)
}

/// Replace parameters
ClassMethod MainParameter(ByRef h, par) As %Status
{
 set path=par("=path=")
  set base64=##class(apptools.core.rest).getStatic(..%ClassName(1)_":image")
 set par("=Brand-Text=")="Info Chest"
 set par("=Logo-image=")=base64
 set par("=titleAppToolsadmin=")=..#HeaderText
 set par("<!--=LinkIcon=-->")=..GetAppIcon(,"png",base64)
 quit ..RepaceParameter(.h,.par)
 quit $$$OK
}

/// write ##class(apptools.lte.infochest).GetAppRootdir()
ClassMethod GetAppRootdir() As %String
{
	set rootdir=##class(%File).GetDirectory($zu(86))_"mgr/infochest-files/files/"
	quit ##class(%File).GetDirectory(##class(%File).GetDirectory($zu(86))_"mgr/infochest-files/files/")
}

/// do ##class(apptools.lte.infochest).SetAppRootdir("d:\!\")
ClassMethod SetAppRootdir(path) As %String
{
	set @..#GNStore@("rootdir")=path
	quit $$$OK
}

ClassMethod GetAllApps(opt) As %Status
{
	if ..IsPermiss(..#AppRoles) {
	;------------ side menu
	s LeftMenuName="Treasure Сhest" i $i(LeftMenuNumer)
	s rootdir=..GetAppRootdir()

	s key="camera"
	s List(key,"ItemName")="Photo & Video"
	s key="audio"
	s List(key,"ItemName")="Music"
	s key="books"
	s List(key,"ItemName")="Books"
 	
 	s i="" for { s i=$o(List(i)) q:i=""  
 	s ItemName=$g(List(i,"ItemName"))
 	i $i(count)
 	s key="find-"_i
	s opt(key)=ItemName 
	s opt(key,"id")="GDiv"_i
	s opt(key,"TabName")=ItemName_"-"
	s opt(key,"ClassName")=..%ClassName(1)
	s opt(key,"Method")="ShowTabS"
	s opt(key,"TabMenu","Close")=1
	s opt(key,"Menu")=$lb(LeftMenuNumer,LeftMenuName,1)
	s:count=1 opt(key,"Active")=1
	s opt(key,"Dir")=rootdir_i
 }
 if ..IsPermiss("%All") {	
 	i $i(LeftMenuNumer)
	s key="menu-topOpt"
	s opt(key)="Parameter"
	s opt(key,"id")="Option"
	s opt(key,"TabMenu","Close")=1
	s opt(key,"TabName")="Parameter"
	s opt(key,"ClassName")=..%ClassName(1)
	s opt(key,"Method")="ShowTabSample"
	s opt(key,"Menu")=$lb(LeftMenuNumer,"Option") ;has no sub-items
 }
	;------------ top-accoun
	s LeftMenuName="Account",LeftMenuNumer=99

	s key="menu-top-account3"
	s opt(key)="Exit"
	s opt(key,"id")="AccountExit"
	s opt(key,"TabName")="Exit" 
	s opt(key,"ClassName")=..%ClassName(1)
	s opt(key,"Method")="Logout"
	s opt(key,"MenuTop")=$lb(LeftMenuNumer,LeftMenuName)
	
	s key="Search"
	s opt(key)="Искать"
	s opt(key,"id")="Search-"
	s opt(key,"TabName")="Search-"
	s opt(key,"ClassName")=..%ClassName(1)
	s opt(key,"Method")="ShowTabSearch"
	s opt(key,"TabMenu","Close")=1
	s opt(key,"TabMenu","Mode")=0
	}
	q $$$OK
}

ClassMethod ShowTabSearch(key = "") As %Status
{
 ;do ..GetAllApps(.opt) 
 ;if $g(opt(key,"Disable")) write ..GetSupportInfo() quit $$$OK
 ;set NSpace=$zu(5)
 w $$$aText("Context","")_" :"_$g(key)
 q $$$OK
}

ClassMethod ShowTabS(Par = "") As %Status
{
 if $g(Par("appPar"))'="" set key=Par("appPar")
 do ..GetAllApps(.opt) 
 set divId=$g(opt(key,"id"))
 set mcont=divId_"MainContent"
 set mhead=divId_"MainHeader"
 if $g(Par("dir"))'="" set opt(key,"Dir")=..DeCode(Par("dir"))
 &html<
<form id="#(divId_"MainForm")#">
<div class="uk-grid">
    <div class="uk-width-1-1 "id="#(mhead)#" >
    >   
 ;Folders icon
 set srcFolder="data:image/gif;base64,R0lGODlhEAAOALMAAOazToeHh0tLS/7LZv/0jvb29t/f3//Ub//ge8WSLf/rhf/3kdbW1mxsbP//mf///yH5BAAAAAAALAAAAAAQAA4AAARe8L1Ekyky67QZ1hLnjM5UUde0ECwLJoExKcppV0aCcGCmTIHEIUEqjgaORCMxIC6e0CcguWw6aFjsVMkkIr7g77ZKPJjPZqIyd7sJAgVGoEGv2xsBxqNgYPj/gAwXEQA7"
 set dir=$g(opt(key,"Dir"),"!")

 do ..GetSortedList(key,dir,.List,.sort)

 if '$d(List) { write "No files and directories "_dir
	 quit $$$OK }
 ;If there are no directories, then we will immediately show the files
 if '$d(sort("n","D")) {
	 do ..FilesShow(.Par,dir,.sort)
	 quit $$$OK
 }
 
 set on=$$$blockui("Wait...")_";"_##class(apptools.core.Action).WriteActJs(%request,"",mcont,..%ClassName(1),"NexLevelTree","&key="_key_"&divId="_divId_"&count=*&dir=***")

 set IdTab=$tr($p($zts,",",2),".")
 set fields(1)="<img class='uk-preserve-width uk-border-circle' src='"_$g(sort("icon"))_"' width='40' alt=''>" ;,fields(1,"attr")="class='uk-table-shrink'"
 set fields(2)="Name",fields(2,"attr")="class='uk-table-expand'"
 do ..DrawTableUi("beg","Table"_IdTab,"style='overflow: auto;'",.fields)
 
 ;If there are files then show them
 if $d(sort("n","F")) {
	s on2=$replace(on,"***",..EnCode(dir))
 	s on2=$replace(on2,"*",(IdTab))
 	if key["camera" { s on2=$replace(on2,"NexLevelTree","FilesShow") ;we will replace it with the show program
 	} else { s on2=$replace(on2,"NexLevelTree","NextLevelInDir")
 	}
 	s row(2)=$G(sort("n"))_" в '"_$p(dir,$$$slash,*)_"' - "_$G(sort("n","F"))
 	s row(2,"attr")="class='uk-table-expand' onclick="""_on2_""""
 	s row(1)="<img class='uk-preserve-width uk-border-circle' src='"_$g(sort("icon"))_"' width='40' alt=''>"
 	d ..DrawTableUi("tr",,,.row)
 }
 s i=""
  for { s i=$o(List(i)) q:i=""  
 	s ItemName=$g(List(i,"ItemName"))
 	continue:$g(List(i,"Type"))="F"
 	k sort2
	d ..GetSortedList(key,dir_$$$slash_ItemName,,.sort2)
	;w "<li>"_ItemName_" "_key zw sort2
	i '$d(sort2("n","F"))&&('$d(sort2("n","D"))) continue
	s on2=on
	i '$d(sort2("n","D")) {
 		s:key["camera" on2=$replace(on2,"NexLevelTree","FilesShow") ;we will replace it with the show program
	}
 	i $i(count)
  	s on2=$replace(on2,"***",..EnCode(dir_$$$slash_ItemName))
 	s on2=$replace(on2,"*",(IdTab+count))
 	s row(2)=ItemName_" - "_$tr($G(sort2("n","F")),"'")
 	s row(2,"attr")="class='uk-table-expand' onclick="""_on2_""""
 	s row(1)="<img class='uk-preserve-width uk-border-circle' src='"_srcFolder_"' width='40' alt=''>"
 	d ..DrawTableUi("tr",,,.row)
 }
 d ..DrawTableUi("end")
 &html<
  </div>
  <div id="#(mcont)#"></div>
 </div>
</form>
>
 quit $$$OK
}

/// Show files in the root of the directory
ClassMethod NextLevelInDir(Par = "") As %Status
{
	s Par("InDir")=1
	d ..NexLevelTree(.Par)
}

/// Create a tab with the next level
ClassMethod NexLevelTree(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set dir=..DeCode(Par("dir"))
	set count=$g(Par("count"))
 	do ..GetAllApps(.opt)
 	if '$d(opt(key)) {
	 	i key["audio" s key="find-audio"
	 	i key["camera" s key="find-camera"
	 	i key["books" s key="find-books"
	 	s count=count+10  ;костыль
 	}
 	s key2=key_count
 	m opt(key2)=opt(key)
 	s opt(key2,"id")=$s(divId'="":divId,1:opt(key,"id"))_count
 	if $g(Par("InDir")) {
	 	s addtab="--"
	 	s opt(key2,"Method")="FilesShow"
 	}
	s opt(key2,"TabName")=opt(key,"TabName")_$p($p(dir,$$$slash,*),".")_$g(addtab)
	
 	s opt(key2,"Dir")=dir
 	s opt(key2,"CGIvar")="&dir="_..EnCode(dir)
 	s Par=key2
 	;w dir
    d ..ShowTabApps(.Par,.opt)
    q $$$OK
}

/// Get a sorted list of files and directories
ClassMethod GetSortedList(key, dir, List, sort) As %Status
{
	set wildcard=$s($zversion(1)=3:"*",1:"*.*")
    d ##class(apptools.core.files).GetList(dir,wildcard,.List)
	if key["audio" {
		s wc=##class(apptools.core.filesMimeTypes).GetTypesWildcards("audio")
		s sort("n")="Listen"
		;Gramophone icon (G)
		s sort("icon")="data:image/ico;base64,AAABAAEAICAQAAAAAADoAgAAFgAAACgAAAAgAAAAQAAAAAEABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAACAAAAAgIAAgAAAAIAAgACAgAAAwMDAAICAgAAAAP8AAP8AAAD//wD/AAAA/wD/AP//AAD///8AEREREREREREREAAAAAAAABk5OTk5OTk5MREAAAARERETk5OTk5OTk5EREQAAERERGTk5OTk5OTkxEREQABEREROTk5OTk5OTkRG7sAAAAAAZOTk5OTk5OTERERAAAAAAEREREREREREREREQAPAAAAF3d3d3dwd3d3EREADwCAAAEXd3dwAAd3d3cRAAALAAAAAQERAAAAEREREQAICwgAAAC/AAAAAAAA//AAcIuwAAD7sAAAAAAAAA/wB3C7sAAPu7AAAAAAAADw8HeAu7DAC/sAAAAAAAAA8Ad3CLu4gA+7AAAAAAAAAAB3ewi7uwAL+wAAAA8AAAAHd7cIu7sAALuwAAAAd4B3e3t7C7u7AAD7u3u7e3t3t7e3twu7vwAAALu7v7+/v39/f38Lu7uAAAAA+7u7u7u7u7u7C7u7gAAAAAAPv797u7u7uw+7uwAAAAAAAAALu7u7u7sLu7sAAAAAAAAAAAD7+/v7C7u7AAAAAAAAAAAIAA+/vwu7uwAAAAAAAAAAAAAA+/sIu7sAAAAAAAAAAAAAAA+/CLu4gAAAAAAAAAAAAAAA+3C7sAAAAAAAAAAAAAAAAA+wu7AAAAAAAAAAAAAAAAAA8IuwAAAAAAAAAAAAAAAAAAcLCAAAAAAAAAAAAAAAAAAACwAAAAAAAAAAAAAAAAAAAACAAAAB//AAAPwAAAAwAAAAFAAAAAfwAAAf8AAAHfAAABw8AAAcPwAAGB4AHjAcCB8gGBw+gAg//oAIP/8ACD8AAAwAAAAMAAAADAAAAA+AAAAP4AAAD/wAAA//wAAP//AAD///AA///4AP///AH///4B////Af///4H////D////4w=="
	}
	elseif key["camera" {
		s wc=##class(apptools.core.filesMimeTypes).GetTypesWildcards("image")_";"_##class(apptools.core.filesMimeTypes).GetTypesWildcards("video")
		s sort("n")="Watch"
		;Camera icon
		s sort("icon")="data:image/gif;base64,R0lGODlhEAAQAKIAAAAAAHt7AL29vXt7e/8AAP///wAAAAAAACH5BAkIAAEALAAAAAAQABAAAANJGBrT7iuOQmsRI6ppqSiZ1FFACYijB4RMqjbY01DwWn4CIGDroJcBk27nu/w2uyTPltsQdr/i7RQUCivNBSeV3biMEqW4W7VaEwA7"
	} else {
		s wc="*.fb2;*.zip;*.doc*"
		s sort("n")="To read"
		;Reader icon
		s sort("icon")="data:image/ico;base64,AAABAAIAICAQAAAAAADoAgAAJgAAABAQEAAAAAAAKAEAAA4DAAAoAAAAIAAAAEAAAAABAAQAAAAAAIACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAgAAAAICAAIAAAACAAIAAgIAAAICAgADAwMAAAAD/AAD/AAAA//8A/wAAAP8A/wD//wAA////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACIAAAAAAAAAAAAAAAAAACQd4gAAAAAAAAAAAAAAAAJkHd3iAAAAAAAAAAAAAAAmZgAd3eIAAAAAAAAAAAACZmAmQB3d4gAAAAAAAAAAJmYCZmZAHd3AAAAAAAAAAmZgJmZmZkAdwAAAAAAAACZmAmZmZmZmQAAAAAAAAAJmYCZmZmZmZmZAAAAAAAAmZgJmZmZmZmZmQAAAAAAAJmAmZmZmZmZmZAAAAAAAACYCZmZmZmZmZkAAAAAAAAAgJmZmZmZmZmQAAAAAAAAAACZmZmZmZmZAAAAAAAAAAAAAJmZmZmZkAAAAAAAAAAAAAAAmZmZmQAAAAAAAAAAAAAAAACZmZAAAAAAAAAAAAAAAAAAAJkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////////////////////////////////////////x////4H///8Af//+AB///AAH//gAAf/wAAP/4AAD/8AAA/+AAAH/AAAD/wAAB/8AAA//AAAf/4AAP//gAH//+AD///4B////g////+f///////////////////////////8oAAAAEAAAACAAAAABAAQAAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAgAAAAICAAIAAAACAAIAAgIAAAICAgADAwMAAAAD/AAD/AAAA//8A/wAAAP8A/wD//wAA////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkHAAAAAAAAmAeIAAAAAAmAAHeAAAAAmAmZAHAAAAmAmZmZAAAACAmZmZkAAAAAmZmZkAAAAAAJmZkAAAAAAAAJkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAP//AAD//wAA/48AAP8DAAD+AAAA/AEAAPgBAADwAAAA8AEAAPADAAD4BwAA/g8AAP+fAAD//wAA//8AAA=="
	}
    s i="" 	s sort("d")=wc
	 for { s i=$o(List(i)) q:i=""  
 		s ItemName=$g(List(i,"ItemName"))
 		s DateModified=$tr($g(List(i,"DateModified")),"- :")
 		s type=$g(List(i,"Type"))
	 	if type="F" {
		 	s ext=$p(ItemName,".",*)
		 	continue:wc'[("*."_ext)
	 	}
	 	s sort("d",type,DateModified,$i(sort(type,DateModified)))=$lb(i,ItemName) ;sort by date
	 	s sort("n",type,ItemName)=$lb(i) ;sort by name
	 	i $i(sort("n",type))
	 }
	 q $$$OK
}

/// Show pictures
ClassMethod FilesShow(Par = "", dir = "", sort) As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	s key=$g(Par)
	set divId=$g(Par("divId"))
	s:key="" key=$g(Par("appPar"))
	s:key="" key=$g(Par("key"))
	s:dir="" dir=..DeCode($g(Par("dir")))
	set dynamic=%request.Application_"get-files/" ;dynamic path
	if '$d(sort) {
		d ..GetSortedList(Par, dir, .List, .sort)
	}
	s IdTab=$tr($p($zts,",",2),".")
	
	if key["-audio" { ;Show playlist
	 ;Header
	 set fields(1)="<img class='uk-preserve-width uk-border-circle' src='"_$g(sort("icon"))_"' width='40' alt=''>"
 	 set fields(2)=$p(dir,$$$slash,*),fields(2,"attr")="class='uk-table-expand'"
 	 do ..DrawTableUi("beg","TableAudio"_IdTab,"style='overflow: auto;'",.fields)
	 set i="" for num=1:1 { s i=$o(sort("n","F",i)) q:i=""
	  	s row(2)=$p($p($lg(sort("n","F",i),1),$$$slash,*),".",1,*-1)
 		s row(2,"attr")="class='uk-table-expand' "
 		set fileId=##class(apptools.core.files).GetFileIdView($lg(sort("n","F",i),1)) 
 		s nextrack="Track"_IdTab_"-"_$S($o(sort("n","F",i))="":1,1:num+1)
 		s row(1)="<audio id='Track"_IdTab_"-"_num_"'  src="""_dynamic_fileId_""" onended=""document.getElementById('"_nextrack_"').play();"" controls preload=""metadata""></audio>"
 		d ..DrawTableUi("tr",,,.row)
 		}
 	d ..DrawTableUi("end")
	$$$jsstart
	w "$('audio').on(""play"", function (me) {"_$C(13,10)
    w " $('audio').each(function (i,e) {"_$C(13,10)
    w "  if (e !== me.currentTarget) {"_$C(13,10)
    w "   this.pause(); "_$C(13,10)
	w "      }"_$C(13,10)
    w " });"_$C(13,10)
    w "});"_$C(13,10)
	 $$$jsstop
	q $$$OK
	} 
	elseif key["-books" { ;Show books
	 ;Header
	 set fields(1)="<img class='uk-preserve-width uk-border-circle' src='"_$g(sort("icon"))_"' width='40' alt=''>"
 	 set fields(2)=$p(dir,$$$slash,*),fields(2,"attr")="class='uk-table-expand'"
 	 do ..DrawTableUi("beg","TableBooks"_IdTab,"style='overflow: auto;'",.fields)
	 set i="" for { s i=$o(sort("n","F",i)) q:i=""
	  	s row(2)=$p($p($lg(sort("n","F",i),1),$$$slash,*),".",1,*-1)
 		s row(2,"attr")="class='uk-table-expand' "
 		set fileId=##class(apptools.core.files).GetFileIdView($lg(sort("n","F",i),1),,"application/force-download") 
 		s row(1)="<a href="""_dynamic_fileId_""">Download</a>"
 		d ..DrawTableUi("tr",,,.row)
 		}
 	d ..DrawTableUi("end")
	}
	else {
		;Show pictures sorted by modification date
		k List
		s i="" for { s i=$o(sort("d","F",i)) q:i=""
			s ii="" for { s ii=$o(sort("d","F",i,ii)) q:ii=""
				s List($i(List),"ItemName")=$lg(sort("d","F",i,ii),2)
				s List(List,"Name")=$lg(sort("d","F",i,ii),1)
			}
		}
		;zw List
		 $$$jsstart
	 	 write "UIkit.lightboxPanel({"
	   		write "items: [ "
			  do ..LighboxDrawJson(.List,,dynamic)
	  		write " ] }).show();"
		$$$jsstop
	}
	quit $$$OK
}

/// download template forms search
ClassMethod OptionFirstHead(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	s path= ##class(apptools.lte.infochest).GetAppRootdir()
	set onclick=$$$blockui("Load...")_";"_##class(apptools.core.Action).WriteActJs(%request,divId_"MainForm",divId_"MainContent",..%ClassName(1),divId_"Result","~key="_key_"~divId="_divId_"~mode=*")
		&html<
		<table width="90%" style="border-radius: 10px; border: 1px solid #72a7cf" cellpadding="2" cellspacing="0" class="DetailTable" bgcolor="#c4d6d6" >
		<tr>
			<td>
		Path to files
			</td>
			<td>
				#($$$appText(divId_"Path_to_files","title='path to files' size=80 ",path))#
			</td>		
		</tr>
		<tr>
			<td>
			
			</td>
			<td>
			#($$$appButton(divId_"appButtonResult1","onclick="""_$tr(onclick,"*",1)_"""","Save"))#
			</td>
		</tr>
		</table>
	>
	quit $$$OK
}

/// Search result
ClassMethod OptionResult(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set mode=Par("mode")
	;Geting elements from form and prepare array Par
	set Name=##class(apptools.core.Action).GetElemForm(%request,.Par,divId_"Path_to_files")	
	set st=$$$OK
	if mode=1 {
		write ..ButtonAgain(divId,key)
		if Name="" w $$$appError($$$aText("Context is empty","")) quit $$$OK
		do ##class(apptools.lte.infochest).SetAppRootdir(Name)
		write $$$appMsg(Name_" saved")
	} 
	write "<br>"
	quit $$$OK
}

/// set base64 = ##class(apptools.core.rest).getStatic("apptools.lte.smarthome:image") w !,base64,!
XData image [ MimeType = application/yaml ]
{
data:image/x-png;base64,
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
3qEHAAAAAElFTkSuQmCC
}

}
