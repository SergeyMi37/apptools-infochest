Include apptools.core

/// apptools favourite commands in %ZLANGC00.mac
/// ZAPP(pArgs...) Do ##class(apptools.util.zapp).prompt(pArgs...) 
/// try { do ##class(apptools.util.zapp).UpdateLanguageExtensions() } catch ex {}
Class apptools.util.zapp [ Abstract ]
{

/// Storage of work history
Parameter GN = "^%apptools.zapp";

/// do ##class(apptools.util.zapp).prompt("globuff")
ClassMethod prompt(comm = "") As %Status
{
	for {
		set prom=$zu(110)_"-"_$$$escGreen($p($zu(86),"*",2))_"-"_$namespace_$$$escGreen(">")
		if comm="" {
			write !,prom," " read cmd 
		}
		else {
			set cmd=comm
		}
		if cmd="" {
			continue
		}
		elseif cmd="q"||(cmd="Q")||(cmd="."||(cmd="^")) {
			Quit
		}
		elseif $p(cmd," ")'="",$d(@..#GN@("indx",$p(cmd," ")),command) { 
			;extention command
			set %cmd=cmd
			xecute $lg(command,1)
			quit:cmd=comm
			continue
		}
		elseif $$iszpmcmd($p(cmd," ")) { 
			;zpm command
			d ##class(%ZPM.PackageManager).Shell(cmd)
			do addhist(cmd)
			quit:cmd=comm
			continue
		}
		elseif cmd="zpm" {
			d ##class(%ZPM.PackageManager).Shell()
			continue
		}
		elseif $e(cmd="?")||(cmd'=(+cmd)) {
			do ..help($tr(cmd,"?")) 
			quit:cmd=comm
			continue
		}
		
		set command=$g(%zapp(cmd))
		if $d(%zapp(cmd),command) {
			set yes=$lg(command,2)
			if $e(yes)="y" {
				write !!,"  ",$lg(command,1)_" ; "_$lg(command,4)
				write !,"     Are you sure ? [yes] " 
				 read sure continue:$e($zconvert(sure,"L"))'="y"
				 set yes="n"
			}
			if yes="n" {
				write !,"Executing "_$lg(command,1),!
				do addhist(command)
				xecute $lg(command,1) 
				quit:cmd=comm
				continue
			}
			else {
				write !,"Command "_$lg(command,1),!
				if $lg(command,1)["##class(" write ##class(apptools.core.msg).man($p($p($lg(command,1),"##class(",2),"(",1))
				do addhist(command)
			}
		}
		else { 
			do ..help()
		}
	}
	quit $$$OK
addhist(cmd) ;add to history
	set gn=..#GN_"hist"
	if $GET(@gn),$GET(@gn@((@gn)))=cmd q 0
	set @gn@($I(@gn))=cmd
	q 1
iszpmcmd(cmd) ;If is a zpm command
 if $lf(##class(apptools.util.zpm).cmdzpm(),cmd) q $$$OK
 q 0
}

/// do ##class(apptools.util.zapp).Favourite("dark")
ClassMethod help(mask = "") As %Status
{
	#define escRed(%t) $Select($$$escBg=0:%t,1:$c(27)_"[1;31;"_$$$escBg_"m"_%t_$$$escClear)
	kill %zapp,@..#GN@("indx")
	write !,$$$escViolet("Extending ZPM commands, the standard ZPM commands also work as from zpm shell.")
		,!,"Enter the command "_$$$escRed("number")_" or "_$$$escViolet("name")_" to execute."
	do ..favourite(.list)
	merge list=@..#GN@("cmd")
	set i=""
	for {
		set i=$Order(list(i)) q:i=""
		set ii="" 
		for { 
			set ii=$O(list(i,ii),1,val) q:ii=""
			set vall=$zconvert($lts(val),"L")
			set namecmd=$lg(val,3)
			if namecmd'="" set @..#GN@("indx",namecmd)=val
			if vall["##class(apptools.util.zpm).extcmd(%cmd)" continue
			if mask'="" {
				if vall[mask set %zapp($i(%zapp))=val do write(i,%zapp,%zapp(%zapp))
			}
			else {
				set %zapp($i(%zapp))=val do write(i,%zapp,%zapp(%zapp))
			}
		}
	}
	do write("","Qq ^",$lb("Exit"))
	q $$$OK
write(part,num,cmd)
	if part="" {write !! 
	}
	elseif part'=$g(partit) { set partit=part
		w !!,$$$escGreen(part)	
	}
	write !,$$$escRed(num)_"."_$$$escViolet($lg(cmd,3))_" "_$lg(cmd,1)_" // "_$lg(cmd,4)
 quit
}

/// do ##class(apptools.util.zapp).favourite(.list)
ClassMethod favourite(ByRef list) As %Status
{
	;sys		           execute code     prompt:yes,no,never=""  name-cmd   description
	set list("sys",$i(list))=$lb("do 1^%SS","n",                    "sys",     "system status")
	set list("sys",$i(list))=$lb("zn ""%SYS"" do ^JOBEXAM","y","","job examing")
	set list("sys",$i(list))=$lb("zn ""%SYS"" do display^GLOBUFF(25)","n","globuff","show global buffer")
	set list("sys",$i(list))=$lb("zn ""%SYS"" do ^LOCKTAB","n","","show lock table")
	set list("sys",$i(list))=$lb("zn ""%SYS"" do ^SECURITY","n","","security utility")
	set list("sys",$i(list))=$lb("zn ""%SYS"" write ##class(Security.System).ExportAll(""/backup/iris/SecureItem-"_$zu(110)_"-"_$p($zu(86),"*",2)_".xml"", .NumExported)","","")
	
	;zmp
	set list("zpm",$i(list))=$lb("zpm ""zn *"" ","n","zna","navigate to namespases")
	set list("zpm",$i(list))=$lb("do ##class(apptools.util.zpm).SetColorScheme()","n","setcolor","set default color scheme")
	set list("zpm",$i(list))=$lb("do ##class(apptools.util.zpm).CreateDBNSAndLoad(""zppretty"")","y","","create new db,namespace and install module")
	set list("zpm",$i(list))=$lb("do ##class(apptools.util.zpm).extcmd(%cmd)","n","newdb","create new db,namespace and install module")
	set list("zpm",$i(list))=$lb("write ##class(apptools.util.zpm).LoadFromRepo(""https://github.com/Vassil2010/iris-sms"")","","","Example Load module from repo")
	set list("zpm",$i(list))=$lb("do ##class(apptools.util.zpm).extcmd(%cmd)","n","load","Extension Load module from repo")
	set list("zpm",$i(list))=$lb("do ##class(apptools.util.zpm).extcmd(%cmd)","n","help","Extension help command")
	
	;apptools
	set list("app",$i(list))=$lb("do ##class(apptools.core.code).imp(""/backup/iris/distr/app/"_$zu(110)_"/apptools/xml/"")","","","import release")
	set list("app",$i(list))=$lb("d ##class(apptools.Security.LockDown).Apply()","","","LockDown")
	;zapp
	set list("zapp",$i(list))=$lb("do ##class(apptools.util.zapp).addcmd(""new $namespace zn """"zpmshow"""" do ^zpmshow"",""zapp"",""n"",""zshow"",""Show a zpm modules with extention description"")","n","addzshow","")
	
	;production
	set list("prod",$i(list))=$lb("do ##class(apptools.core.Production).SaveAndStop()","y","","saving status and stoping productions")
	set list("prod",$i(list))=$lb("do ##class(apptools.core.Production).StartAll()","y","","starting all productions")
	q $$$OK
}

/// do ##class(apptools.util.zapp).addcmd("new $namespace zn ""zpmshow"" do ^zpmshow","zpm","n","zshow","Show a zpm modules with extention description")
ClassMethod addcmd(cmd = "", partion = "", prompt = "", namecmd = "", description = "") As %Status
{
	if partion="" set partion="other"
	set @..#GN@("cmd",partion,$i(@..#GN@("cmd")))=$lb(cmd,prompt,namecmd,description)
	write !,"added "_$zr,!,cmd
}

/// do ##class(apptools.util.zapp).init()
ClassMethod init() As %Status
{
	new $namespace
	set $namespace="%sys"
	do ##class(apptools.util.zapp).UpdateLanguageExtensions()
	do ##class(%ZPM.PackageManager).UpdateLanguageExtensions()
}

/// do ##class(apptools.util.zapp).UpdateLanguageExtensions()
ClassMethod UpdateLanguageExtensionsOne(RoutineName As %String, pTestOnly As %Boolean = 0, Output pFound As %Boolean = 0, ByRef tGenLines) As %Status
{
	#def1arg STARTTAGQ " ;Generated by apptools.util.zapp: Start"
	#def1arg ENDTAGQ " ;Generated by apptools.util.zapp: End"
	#def1arg STARTTAG ##Expression($$$STARTTAGQ)
	#def1arg ENDTAG ##Expression($$$ENDTAGQ)
	Set tRtn = ##class(%Routine).%New(RoutineName)
	If ##class(%Routine).Exists(RoutineName) {
		Set tEnded = 1
		While 'tRtn.AtEnd {
			Set tLine = tRtn.ReadLine()
			If (tLine = $$$STARTTAGQ) {
				// Read through the ending tag.
				While ('tRtn.AtEnd) && (tRtn.ReadLine() '= $$$ENDTAGQ) {}
				
				// Generate the lines.
				Set pFound = 1
				For i=1:1:tGenLines {
					Set tRtnLines($i(tRtnLines)) = tGenLines(i)
				}
			} Else {
				Set tIsZAPP = ($ZConvert($Extract(tLine,1,4),"U") = "ZAPP(")
				If tIsZAPP {
					Set pFound = 1
					Set tEnded = 0
					Set tRtnLines($i(tRtnLines)) = $$$STARTTAGQ
				}
				If '(tIsZAPP || tEnded) {
					If ($ZStrip($Extract(tLine),"*W") '= "") {
						Set tRtnLines($i(tRtnLines)) = $$$ENDTAGQ
						Set tEnded = 1
					}
				}
				Set tRtnLines($i(tRtnLines)) = tLine
			}
		}
		If 'tEnded {
			Set tRtnLines($i(tRtnLines)) = $$$ENDTAGQ
		} ElseIf 'pFound {
			For i=1:1:tGenLines {
				Set tRtnLines($i(tRtnLines)) = tGenLines(i)
			}
		}
	} Else {
		Merge tRtnLines = tGenLines
	}
	If (pTestOnly) {
		Quit
	}
	Do tRtn.Clear()
	For i=1:1:tRtnLines {
		Do tRtn.WriteLine(tRtnLines(i))
	}
	$$$ThrowOnError(tRtn.Save())
	$$$ThrowOnError(tRtn.Compile())
	Quit $$$OK
}

ClassMethod UpdateLanguageExtensions(pVerbose As %Boolean = 0, pTestOnly As %Boolean = 0, Output pFound As %Boolean = 0) As %Status
{
	#def1arg STARTTAGQ " ;Generated by apptools.util.zapp: Start"
	#def1arg ENDTAGQ " ;Generated by apptools.util.zapp: End"
	#def1arg STARTTAG ##Expression($$$STARTTAGQ)
	#def1arg ENDTAG ##Expression($$$ENDTAGQ)

	Set tSC = $$$OK
	Set tInitTLevel = $TLevel
	Try {
		TSTART
		// Get routine lines to generate
		Set tOffset = 0
		Set tStarted = 0
		For {
			Set tLineName = "zUpdateLanguageExtensions"_"+"_$i(tOffset)_"^"_$ZName
			Set tExtLine = $Text(@(tLineName))
			If (tExtLine=$$$STARTTAGQ) {
				Set tStarted = 1
			}
			If (tStarted) {
				Set tGenLines($i(tGenLines)) = tExtLine
			}
			Quit:(tExtLine=$$$ENDTAGQ)
			Quit:(tExtLine="")
		}

		If '$Data(tGenLines) {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Could not find %ZLANGC00 routine contents in "_$classname()))
		}
		Do ..UpdateLanguageExtensionsOne("%ZLANGC00.MAC", pTestOnly,.pFound,.tGenLines)
		Quit:pTestOnly
		Set i="" 
		For { set i=$Order(tGenLines(i),1,tStr) Quit:i=""
			If tStr[" Do ##class" Set tGenLines(i)=$Replace($Replace(tStr," Quit","")," Do "," Quit ") Quit
		}
		Do ..UpdateLanguageExtensionsOne("%ZLANGF00.MAC", pTestOnly,.pFound,.tGenLines)
		TCOMMIT
	} Catch e {
		Set tSC = e.AsStatus()
	}
	While ($TLevel > tInitTLevel) {
		TROLLBACK 1
	}
	Quit tSC
#; These are the actual contents of %ZLANGC00 (to be added/updated)
$$$STARTTAG
ZAPP(pArgs...) Do ##class(apptools.util.zapp).prompt(pArgs...) Quit
$$$ENDTAG
#; Need an extra line down here to avoid the end bracket being on the same line as $$$ENDTAG - a comment is just fine.
}

}

