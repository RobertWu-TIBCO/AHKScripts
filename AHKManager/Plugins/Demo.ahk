; RunZ:Demo
; 插件示例
;
; 第一行为固定格式 ; RunZ:插件名
; 插件名需要和文件名一致
; 第二行为固定格式 ; 插件描述
; 插件需要使用 UTF-8 BOM 编码
;
; 该插件默认不启用，在配置文件可启用该插件

; 该标签名要和首行的插件名一致
Demo:
    ; 第一个参数为标签名
    ; 第二个为搜索项，即该功能的表述，内容随意
    ; 第三个参数为 true 时，当搜索无结果也会显示，默认为 false
    ; 第四个参数为绑定的全局热键，默认无
    @("q", "checkInput")
    @("qqdown", "qqdown")
    @("seat", "seat")
    @("mft", "mft Audit ID A52660000104")
    @("Demo3", "插件实例3")
    @("http", "Http Ip Port Down")
    @("fy", "Fanyi Api Without Json Parse")
    @("frword", "French From Chinese,words need encoded")
    @("fr1", "French translate Chinese directly")
    @("aq", "aq uses the three line file used before")
    @("qa", "this simulates all !q input box does")
    @("fr2", "this was the old function worked to encode words")
    @("des13", "run the app or project by path directly in BW 5.13")
    @("desi", "run the app or project by path directly in BW 5.12")
    @("254s", "search on 254 everything page")
    @("attri", "attrib files unhide")
    @("bwprocess", "copy process and start as project")
    @("netf", "netfind bat")
    @("own", "own bat")
    @("listen", "findlisten bat")
    @("sslclientall", "hit port 9696 with all ss version")
    @("tcpserver", "tcp isten on 9004")
    @("vncport", "vnc to port in 145 docker")
    @("ssh", "ssh to 22 port in 145 docker")
    @("listcert", "listcert of a keystore")
    @("mus", "search music in 163 music")
    @("sship", "ssh to 22 port to any server using ip")
    @("threaddump", "threaddump jar")
    @("play", "inplay")
    @("kb", "kb ")
    @("kbmy", "kbmy ")
    @("sr", "sr ")
    @("tsc", "tsc ")
    @("qu", "query sr ")
    @("mall", "gmail ")
    @("mm", "gmail search ")
    @("fm", "douban FM ")
    @("webex10", "webex10 ")
    @("arf", "arf ")
    @("wrf", "wrf ")
    @("pptx", "pptx")
    @("ppt", "ppt")
	@("vms", "vmdk")
    @("frf", "filelocate any content to ahk files")
	@("comp","comp two files")
	@("xi", "西游记 music")
	@("day", "day range")
	@("decryptsample", "decryptsample")
	@("decryptword", "decrypt word")
	@("decryptfast", "decrypt fast just function name")
	@("decryptfastcp", "decrypt fast with cp")
	@("WlanEnable","Enable Wlan by Netsh Interface command")
	@("WlanDisable","Disable Wlan by Netsh Interface command")
	@("big","grep big mail")
	@("ip","ip grep 192")
	@("short","快捷键 文档")
	@("spa","spackage/BW/")
	@("op","open file location")
	@("40","40")
	@("ecshort","ecshort eclipse short cut")
	@("attend","attend leave ")
	@("chs","chms.ahk F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scriptsNeedsUpdate\chms.ahk")
	@("chm","allchm.ahk F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scriptsNeedsUpdate\allchm.ahk")
return
qqdown:
run,F:\Program Files\AutoHotkey\Scripts\QQDown
return

WlanEnable:
RunAndGetOutput("netsh interface set interface WLAN enabled")
DisplayResult(RunAndGetOutput("netsh interface show interface")) ;乱码
return

WlanDisable:
RunAndGetOutput("netsh interface set interface WLAN disabled")
DisplayResult(RunAndGetOutput("netsh interface show interface"))
return


ecshort:
openfile("G:\MyJavaWayOn\Myeclipse_8.5_快捷键大全.doc")
return

attend:
run,attendance.pactera.com
return

spa:
run,http://reldist.na.tibco.com:8008/spackage/BW/
return

op:
word := Arg == "" ? clipboard : Arg
;run,explorer %~dp1
run,explorer %word%
return

big:
word := Arg == "" ? clipboard : Arg
tmp:="grep -in " word " G:\SRAll\Experience\GoodEmail\mail\mail0630Bigmail.txt"
DisplayResult(RunAndGetOutput(tmp))
return

ip:
tmp := Arg == "" ? "ipconfig|findstr 192"  : "ipconfig|findstr 192|find " Arg
DisplayResult(RunAndGetOutput(tmp))
return
 
seat:
run,E:\EasyOSLink\PCMasterMove\Pictures\Life\Daily\NewSeat.png
return

decryptword:
word := Arg == "" ? clipboard : Arg
tmp:="java -jar G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\decrypt.jar " word
DisplayResult(RunAndGetOutput(tmp))
return

decryptfast:
word := Arg == "" ? clipboard : Arg
tmp:="java myDecryption " word  ; found that the classpath is not there and no output at all
;DisplayResult(RunAndGetOutput(tmp))
DisplayResult(RunAndGetOutput("java myDecryption " word))
return

decryptfastcp:
;tmp:="java myDecryption #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx"
tmp:="java -cp G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\decrypt.jar myDecryption #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx"
DisplayResult(RunAndGetOutput(tmp))
return

decryptsample:
tmp:="java -jar G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\decrypt.jar #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx"
DisplayResult(RunAndGetOutput(tmp))
return

day:
word := Arg == "" ? clipboard : Arg
;Run,javac -cp G:\SRAll\ToAttach\GoodLearn\java G:\SRAll\ToAttach\GoodLearn\java\MyCalendar.java  
;Run,%comspec% /k java -cp G:\SRAll\ToAttach\GoodLearn\java MyCalendar %word%
;tmp:="java -cp G:\SRAll\ToAttach\GoodLearn\java MyCalendar 0323 0615"
tmp:= "java -cp G:\SRAll\ToAttach\GoodLearn\java MyCalendar " word
DisplayResult(RunAndGetOutput(tmp))
return

frf:
word := Arg == "" ? clipboard : Arg
run,"F:\Program Files\FileLocate\FileLocatorPro.exe" -c %word% -r -d "F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\"
return

chs: ;this would not show the menu so use #1 to #5 in aa ahk to show menus
run,F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scriptsNeedsUpdate\chms.ahk
return

chm:
run,"F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scriptsNeedsUpdate\allchm.ahk"
return

40:
run,http://202.201.112.40/
return

wrf:
Run,"F:\Program Files\Everything\Everything.exe" -s ".wrf"
return

arf:
Run,"F:\Program Files\Everything\Everything.exe" -s ".arf"
return

short:
EveSearch("快捷键")
return

vms:
EveSearch(".vmdk")
;Run,"F:\Program Files\Everything\Everything.exe" -s ".vmdk"
return

comp:
word := Arg == "" ? clipboard : Arg
run,G:\SysManage\SoftFolders\BeyondComparePortable\App\BeyondCompare\BCompare.exe %word%
;run,"G:\SysManage\Update\Beyond Compare\BCompare.exe" %word%
return

xi:
run,http://music.163.com/#/album?id=2635055
return

pptx:
EveSearch(".pptx")
return

ppt:
EveSearch(".ppt")
return

fm:
run,https://douban.fm/?from_=shire_top_nav#
return

webex10:
run,E:\EasyOSLink\Run\AdminWork\webex.lnk
return

mall:
run,https://mail.google.com/mail/u/0/#inbox
return

mm:
clipboard := Arg == "" ? clipboard : Arg
search3("https://mail.google.com/mail/u/0/#search/label%3A回好的++","")
return

mus:
word := Arg == "" ? clipboard : Arg
url:= "http://music.163.com/#/search/m/?id=3686&s=" UrlEncode(word) "&type=1"
run,%url%
return

sr:
word := Arg == "" ? clipboard : Arg
url:="http://10.106.148.71/sr/" word
run,%url%
return

tsc:
run,http://support.tibco.com/
return

qu:
word := Arg == "" ? clipboard : Arg
run,http://10.106.148.71/query?q=%word%
return

kbmy:
word := Arg == "" ? clipboard : Arg
run,http://10.106.148.71/query?q=&%word%=ka&p=kwbw&fcowner=yawu
return

kb:
word := Arg == "" ? clipboard : Arg
run,http://10.106.148.71/ka/000/%word%.htm 
return

play:
run,http://10.106.148.71/inplay
return

listcert:
word := Arg == "" ? clipboard : Arg
run,E:\EasyOSLink\Run\AdminWork\listcert.bat %word%
return

vncport:
word := Arg == "" ? clipboard : Arg
run,G:\WorkDocSoft\Docker\supportsharetools\VNC\vncviewer.exe 192.168.69.145:%word% /password tibco123
return

ssh:
run,"D:\Program Files (x86)\Git\bin\ssh.exe"  -l root 192.168.69.145
return

sship:
word := Arg == "" ? clipboard : Arg
run,"D:\Program Files (x86)\Git\bin\ssh.exe"  -l root %word%
return

tcpserver:
run,E:\EasyOSLink\Run\AdminWork\tcpserver.bat
return

threaddump:
run,java -jar G:\SRAll\AllMayDay\ToAttach\QQDown\threaddump440.jar
return

sslclientall:
run,G:\SRAll\ToAttach\SSL\example\javacode_sslTest\originalcode_vector\sslcli9696all.bat
return

own:
word := Arg == "" ? clipboard : Arg
run,E:\EasyOSLink\Run\AdminWork\grant2.bat %word%
return

bwprocess:
return

listen:
tmp := Arg == "" ? "netstat -ano|findstr LISTEN" : "netstat -ano|findstr LISTEN|findstr " Arg
;tmp:="netstat -ano|findstr LISTEN"
DisplayResult(RunAndGetOutput(tmp))
;run,cmd /k E:\EasyOSLink\Run\SR\findlisten.bat %word%
return

netf:
word := Arg == "" ? clipboard : Arg
tmp:="netstat -ano|findstr " word
;run,cmd /k E:\EasyOSLink\Run\SR\netfind.bat %word%
DisplayResult(RunAndGetOutput(tmp))
return


attri:
word := Arg == "" ? clipboard : Arg
run,start /b attrib -r -a -s -h %word%
return

; 和 @ 函数的第一个参数对应
q:
    word := Arg == "" ? clipboard : Arg
    CheckInput(word)
return

mft:
	word := Arg == "" ? clipboard : Arg
	;Run,"http://10.106.148.71/mft/file?id=" word
	Run , http://supportapps.na.tibco.com/mft/file?id=%word%
    DisplayResult("Audit ID : " word) ;Audit ID : A52660000104
return

Demo3:
    ; Arg 为用户输入的参数
    DisplayResult("我的参数：" Arg)
return

http:
word := Arg == "" ? clipboard : Arg
url:="http://" . StrReplace(word," ",":")       ;great !       ;url := "http://localhost:7888" 
;MsgBox % url
UrlDownPlayResult(url)
return

fy:
    word := Arg == "" ? clipboard : Arg
	;http://fanyi.youdao.com/openapi.do?keyfrom=<keyfrom>&key=<key>&type=data&doctype=xml&version=1.2&q=这里是有道翻译API 
    ;url := "http://fanyi.youdao.com/openapi.do?keyfrom=YouDaoCV&key=659600698&" . "type=data&doctype=xml&version=1.1&q=" UrlEncode(word)
    url := "http://fanyi.youdao.com/openapi.do?keyfrom=YouDaoCV&key=659600698&"  . "type=data&doctype=json&version=1.2&q=" UrlEncode(word)
	
UrlDownPlayResult(url)
return


frword:  ;frword %C3%A7%C2%88%C2%B1 -> 爱  %E7%88%B1 -> %C3%A7%C2%88%C2%B1 ; needs the arg encoded properly
word := Arg == "" ? clipboard : Arg

;result:=UrlDownloadToVarPOST_Content("http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=http://dict.youdao.com/",{"Content-Type":"application/x-www-form-urlencoded; charset=UTF-8"},"type=ZH_CN2FR&i=" . word . "&doctype=json&xmlVersion=1.8&keyfrom=fanyi.web&ue=UTF-8&action=FY_BY_CLICKBUTTON&typoResult=true")
;DisplayResult(result)

WordToFrench(word)
return

fr1:
word := Arg == "" ? clipboard : Arg
word:=FrenchEncode(word)

;result:=UrlDownloadToVarPOST_Content("http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=http://dict.you;dao.com/",{"Content-Type":"application/x-www-form-urlencoded; charset=UTF-8"},"type=ZH_CN2FR&i=%C3%A7%C2%94%C2%B7%C3%A5%C2%AD%C2%A9&doctype=json&xmlVersion=1.8&keyfrom=fanyi.web&ue=UTF-8&action=FY_BY_CLICKBUTTON&typoResult=true")

WordToFrench(word)

return

aq:
word := Arg == "" ? clipboard : Arg
UseAQFile(word)
return 

qa:
word := Arg == "" ? clipboard : Arg
qa(word)
return 

fr2:
word := Arg == "" ? UrlEncode(clipboard) : UrlEncode(Arg)  ; %C3%A5%C2%A5%C2%B3%C3%A5%C2%AD%C2%A9 girl

;word :="%E7%94%B7%E5%AD%A9"
ColorArray := StrSplit(word,"%","%")  
Loop % ColorArray.MaxIndex()-1
{
    item1 := ColorArray[a_index+1]
	if(mod(a_index+1,3)==2)
	 tmpstr1=% tmpstr1  . "%C3%" . item1 
	 else
    tmpstr1=% tmpstr1  . "%C2%" . item1 
}
;NewStr := RegExReplace(RegExReplace(tmpstr1, "^%C2%", "%C3%") , "E", "A") 
NewStr := RegExReplace(tmpstr1, "E", "A") ; mod function ensures all c3 right
WordToFrench(NewStr)
NewStr:=
tmpstr1=
return 

des13:
word := Arg == "" ? clipboard : Arg
run,E:\EasyOSLink\Run\SR\des13.lnk %word%
return

desi:
word := Arg == "" ? clipboard : Arg
run,E:\EasyOSLink\Run\SR\desi.lnk %word%
return

254s:
word := Arg == "" ? clipboard : Arg
run,http://192.168.72.254:8888/?search=%word%
return


UrlDownPlayResult(url){
result := StrReplace(UrlDownloadToString(url), "-phonetic", "_phonetic")
	DisplayResult(result)
    clipboard := result
return 
}

WordToFrench(word){
result:=UrlDownloadToVarPOST_Content("http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=http://dict.youdao.com/",{"Content-Type":"application/x-www-form-urlencoded; charset=UTF-8"},"type=ZH_CN2FR&i=" . word . "&doctype=json&xmlVersion=1.8&keyfrom=fanyi.web&ue=UTF-8&action=FY_BY_CLICKBUTTON&typoResult=true")
DisplayResult(result)
return 
}

;#include F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\Plugins\Misc.ahk ; no need since all ahk loaded for RunZ(common+plugin:misc(json),demo)
;#include F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\gmailFireCloverPad_simple.ahk ; funcs now in common.ahk and loaded by RunZ