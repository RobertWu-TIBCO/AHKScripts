#SingleInstance Force
#NoEnv
FileEncoding,utf-8
SetWorkingDir %A_ScriptDir%


;建立读取热键信息-star-
FileRead,Tex,%A_ScriptFullPath%

Menu, Tray, NoStandard                  ;删除自带托盘菜单
Menu, tray, add, 查看,ShowGui   ;  显示gui
Menu, tray, add  ; 创建分隔线.
Menu, tray, Add,重启,reload							;关于
Menu, tray, Add,帮助,helpAKM							;帮助
Menu, tray, Add, 退出, ExitSub                  ; 创建     退出
Menu, Tray, Default, 查看  ;;默认   查看
Menu, Tray, Icon, Shell32.dll, 255

Gui,Destroy
gui, font, s10, 微软雅黑
Gui,Add,GroupBox,x10 y10 w516 h630, 热键列表 L
Gui Add, ListView,x18 y28 w500 h600 Grid, <窗口>|<热键>|<动作>|<备注>
LV_ModifyCol(1, "left 90")
LV_ModifyCol(2, "left 80")
LV_ModifyCol(3, "left 115")
LV_ModifyCol(4, "left")

loop,Parse,tex,`n,`r
{
	ff :=RegExMatch(A_LoopField,"^;+>\[.*\]",var)
	if ff
		bb .=RegExReplace(var,"^;+>\[(.*)\]","$1") . "`n"
}

loop,Parse,bb,`n,`r
{
	if !A_LoopField
		continue
	jiuu++
	StringSplit, Array%A_Index%, A_LoopField ,|
}

loop,%jiuu%
{
LV_Add("",Array%A_Index%1,Array%A_Index%2,Array%A_Index%3,Array%A_Index%4)
}
;gui,Show
return

::shhk::
::shk::
::sh2::
ShowGui:
gui,Show
return

helpAKM:
gg2=
(
热键处需标记   示例:
";>[窗口|热键|动作|备注]"
)
msgbox,%gg2%
return

::rk::
::rhk::
::r2::
reload:
Reload
return

::hidhk::
::hid2::
GuiEscape:
GuiClose:
Gui, Hide
return

ExitSub:
ExitApp
return
;建立读取热键信息-end-



;==========以下开始AHK脚本================================

;>[记事本|F4|msgbox|提示Hello World]

#IfWinActive,ahk_exe notepad++.exe
::go::
send gosub{Space}
return


;>[记事本|F4|msgbox|提示Hello World]
#If WinActive("RunZ") or WinActive("Give an Command ")
WheelUp::
#WheelUp::
^WheelUp::
send {up} 
return

#WheelDown::
^WheelDown::
CapsLock & WheelDown::
 WheelDown::
send {DOWN} 
return
#If

;>[记事本|F5|msgbox|提示你好]
#IfWinActive,ahk_exe notepad++.exe
;introduced on 2016-05-03 9:51:17
CapsLock & d::
if getkeystate("alt") != 0
  send +{Right}
else if getkeystate("ctrl") != 0
  send +{Home}
else
    send ^{Right}
return
CapsLock & a::  ; why fails in clover ?
if getkeystate("alt") != 0
     send +{Left}
else if getkeystate("ctrl") != 0
     send +{End}
else
    send ^{Left}
return

;>[全局|Label|Label|QuickSearchContent_Use]
#IfWinActive
::/op::
gosub OpenFileHotString
return
::/strn::
gosub StringActivateNameHotString
return
::/str::
gosub StringActivateHotString
return
::glabel::
gosub GlobalLabelHotString
return
::/up::
gosub uppaste
return
::/low::
gosub lowpaste
return
::qcp::
gosub QuoteCP
return
::nozip::
gosub NoZip
return
!+h::
SearchHHBetter()
return
;>[全局|Label|Label|QuickSearchContent]
#IfWinActive

OpenFileHotString:
sendbyclip("openfile`(")
send "
sendinput ^v
send "){Enter}
send return
return

StringActivateNameHotString:
sendbyclip("StringActivateName`(")
send "
sendinput ^v
send "){Enter}
send return
return

StringActivateHotString:
sendbyclip("StringActivate`(")
send "
sendinput ^v
send "){Enter}
send return
return

GlobalLabelHotString:
sendbyclip(";>[全局|Label|Label|QuickSearchContent]")
send {Enter}
sendbyclip("`#IfWinActive")
send {Enter}
send return
return

/*
autohotkey 判断chrome光标是否在输入
*/ 
/*
184、如何将某字符串中的英文字母全部转换为大写或小写？参数中的T有什么作用？
小写：StringLower, OutputVar, InputVar [, T]
大写：StringUpper, OutputVar, InputVar [, T]
T 如果这个参数使用字母 T ，字符串将被转换为标题格式。
*/ 

uppaste:
;send ^c ;you can not copy it when you have override it
StringUpper, clipboard, clipboard
Send ^v
return

lowpaste:
StringLower, clipboard, clipboard
Send ^v
return

^!+u::
upper:
send ^c ;you can not copy it when you have override it
gosub uppaste
return

^!u::
lower:
send ^c ;you can not copy it when you have override it
gosub lowpaste
return

^+"::
QuoteCP:
send ^c
send "%clipboard%"
return

^!z::
NoZip:
send ^c
StringReplace, clipboard, clipboard, .zip\
send ^v
return

;>[全局|KeyRemap|KeyRemap|KeyRemapForCaps_QuickCapsDel]
#ifwinactive,
;-------------------------------------------------------------------------------------
;CapsLock & \::send +{F10}
;CapsLock & =::send {Home}{Del}
;CapsLock & 0::send {Home};
;CapsLock & 9::send {Home}{Del} 
;;=============================Deletor==============================||
CapsLock & ,:: Send, {Del}              ; , = Del char after
CapsLock & .:: Send, ^{Del}             ; . = Del word after
CapsLock & /:: Send, +{End}{Del}        ; / = Del all  after;
CapsLock & m:: Send, {BS}               ; m = Del char before; 
CapsLock & n:: Send, ^{BS}              ; n = Del word before; 			
CapsLock & b:: Send, +{Home}{Del}       ; b = Del all  before; 
;-----------------------------------o---------------------------------o
;CapsLock & F11:: Send, {Volume_Mute}                                  ;|
;CapsLock & F12:: Send, {Volume_Down}                                  ;|
;CapsLock & F10:: Send, {Volume_Up}                                    ;|
^+0:: Send, {Volume_Mute}                                  ;|
^+8:: Send, {Volume_Down}                                  ;|
^+9:: Send, {Volume_Up}               
;-------------------------------------------------------------------------------------

;>[全局|KeyRemap|KeyRemap|KeyRemapForCaps]
#ifwinactive,


;>[全局|Label|Label|AHKTest]
#IfWinActive

GetWindowPos: ;if absolute position could be used , it would be better.
WinGetPos, X, Y, , , A  ; "A" to get the active window's pos.
MsgBox, The active window is at %X%`,%Y%
MouseMove,X,Y
return

SelectMenuBar:
WinGetActiveStats, Title, Width, Height, X, Y
MsgBox, The active window "%Title%" is %Width% wide`, %Height% tall`, and positioned at %X%`,%Y%.
;WinMenuSelectItem, A, , 1&, 6& ;save as 
WinMenuSelectItem, A, , 1&,2&      
/*
WinGet, ActiveControlList, ControlList, A
Loop, Parse, ActiveControlList, `n
{
    MsgBox, 4,, Control #%a_index% is "%A_LoopField%". Continue?
    IfMsgBox, No
        break
}
*/
return

#!F7::
^#F7::
CreateShortLink:
IfWinActive,ahk_class TTOTAL_CMD
	Send ^3
else
{
	clipboard=
	send ^c
	ClipWait, 2
	if ErrorLevel
	{
		MsgBox, The attempt to copy text onto the clipboard failed.
		return
	}

	clipboard=%clipboard%
}
Path_:=clipboard
links=E:\EasyOSLink\Run\AdminWork
InputBox, alias,请为快捷方式起个名字,%Path_%
if ErrorLevel
    MsgBox, CANCEL was pressed.
else ;如果注释掉以上判断,就会没有输入,导致依然创建了空的链接文件,没有名字!危险!
    FileCreateShortcut, %Path_%, %links%\%alias%.lnk
IfExist,%links%\%alias%.lnk
	TrayTip,,成功创建快捷方式!,10
return

;~ FileCreateShortcut, %path%, C:\Windows\System32\%alias%.lnk

; 最后一个参数中的字母 "i" 将快捷键设成 Ctrl-Alt-I ：
;~ FileCreateShortcut, Notepad.exe, %A_Desktop%\My Shortcut.lnk, C:\, "%A_ScriptFullPath%", My Description, C:\My Icon.ico, i


setip:
InputBox, tail, 提示, 192.168.68.  subnet 输入后缀
ip = 192.168.68.%tail%
gateway = 192.168.68.254
dns = 192.168.65.9
runwait, %ComSpec% /c netsh interface ip set address name=`"本地连接`" source=static addr=%ip% mask=255.255.255.0 gateway=%gateway% gwmetric=10, , Hide
RunWait, %ComSpec% /c netsh interface ip set dns name=`"本地连接`" source=static addr=%dns% , ,Hide
MsgBox, Ok
return



LocateReg:
InputBox, NewLastKey, 注册表自动定位工具, 请输入要定位到的路径, , 800, 130
;If(ErrorLevel = 1)
    ;ExitApp
IfWinExist, 注册表编辑器 ahk_class RegEdit_RegEdit
{
    WinClose
    WinWaitClose
}
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %NewLastKey%
If(ErrorLevel = 1)
MsgBox failed
Run, regedit.exe
return

AddToRun:
winget, path, ProcessPath, A ;test withHabit but it only uses AHK32 exe as path
wingettitle, title, A
RegWrite, REG_SZ, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %title%, %path%
return

ListPrograms:
WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    MsgBox, 4, , Visiting All Windows`n%a_index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
    IfMsgBox, NO, break
}

;>[全局|Label|Label|KeyCombine]
#IfWinActive
ctrlc:
send ^c
return

ctrlv:
send ^v
return

;>[全局|Label|Label|ActWindow]
#IfWinActive

#e::
gosub clover
;RunOrActivateProgram("D:\Program Files (x86)\Clover\clover.exe")
return

clover:
RunOrActivateProgram("D:\Program Files (x86)\Clover\clover.exe")
return

;>[全局|Label|Label|ForTest]
#IfWinActive
hi:
MsgBox hi
return

;>[全局|Shortcut|Shortcut|Firefox Service]
#IfWinActive,Service Request
LCtrl & m::
send f
send New Email
send {ENTER}
sleep 2000
actwin("notepad++.exe")
send ^n
return
LCtrl & a::
send f
send Activities
send {ENTER}
return
_::OpenFireLink("pro") ;b mail.google.com<cr>
+::OpenFireLink("cus")  ;noremap <A-PageUp> b TIBCO Support Central<cr>
{::OpenFireLink("own")  ;noremap <A-PageDown> b Send<cr>
}::OpenFireLink("act")  ;noremap <A-PageDown> b Send<cr>
:::OpenFireLink("att")   ; noremap <C-End>  b Service Request<cr>
"::OpenFireLink("aud")   ; noremap <C-End>  b Service Request<cr>
<::OpenFireLink("mail")   ; noremap <C-End>  b Service Request<cr>
>::OpenFireLink("note")   ; noremap <C-End>  b Service Request<cr>
|::OpenFireLink("save")   ; noremap <C-End>  b Service Request<cr>
#IfWinActive

;>[全局|Shortcut|Shortcut|Firefox TSC]
#IfWinActive,TIBCO Support Central
LCtrl & o::
send f
sleep 100
send My Open SRs
send {ENTER}
return
LCtrl & l::
send f
sleep 100
send My L2 W
send {ENTER}
return
(::OpenFireLink("my") ;b mail.google.com<cr>
)::OpenFireLink("l2")  ;noremap <A-PageUp> b TIBCO Support Central<cr>
#IfWinActive

;>[全局|Shortcut|Shortcut|Firefox]
#IfWinActive ahk_exe firefox.exe
F1::OpenFireLink("mm")  ;noremap <A-PageDown> b Send<cr>
F2::OpenFireLink("tsc") ;b mail.google.com<cr>
F3::OpenFireLink("ser")  ;noremap <A-PageUp> b TIBCO Support Central<cr>
F4::OpenFireLink("send")  ;noremap <A-PageDown> b Send<cr>
F5::OpenFireLink("play")  
F6::OpenFireLink("qu")  
F7::OpenFireLink("webex")  
F8::OpenFireLink("163") 
F9::UseClipBoardRun("http://10.106.148.71/sr/","")
F10::UseClipBoardRun("http://10.106.148.71/query?q=","")
F11::UseClipBoardRun("http://www.baidu.com/s?wd=","")
F12::OpenFireLink("1") ;show input box for hints inside firefox
#o::OpenFireLink("1") ;show input box for hints inside firefox
#IfWinActive

/*
;implemeted by vimp
noremap g1 b mail.google.com<cr>
noremap g2 b TIBCO Support Central<cr>
noremap g3  b Service Request<cr>
noremap g4 b Send<cr>
noremap g5 b inplay<cr>
noremap g6 b query<cr>
noremap g7 b Tibco WebEx Enterprise Site<cr>
noremap g8 b music.163.com<cr>
noremap gq :ttabopen<Space>http://10.106.148.71/query?q=<C-v><cr>
noremap gr :ttabopen<Space>http://10.106.148.71/sr/<C-v><cr>
*/ 


;>[全局|Function|Function|Firefox]
#IfWinActive
OpenFireLink(name)
{
if name!=1
{
FireLinkArg(name)
}
else
{
InputBox, UserInput, Link Name, Please enter a link name `n my`n l2`n prod`n cust : customer info`n own`n act`n att : attachments`n aud : audit`n kb`n mail : New email`n note : New Note`n save`n mm`n tsc`n ser`n send : send email`n play`n qu : query`n we : webex`n 6 or t`n  , , 600, 500
if !ErrorLevel
{
FireLinkArg(UserInput)
}
}
return
}

FireLinkArg(UserInput)
{
if UserInput=my
{
send f
sleep 500
send My Open SRs
send {ENTER}
}
else if UserInput=l2
{
send f
sleep 500
send My L2
send {ENTER}
}
else if UserInput=pro
{
send f
sleep 400
sendbyclip("Product")
send {ENTER}
send {ENTER}
}
else if UserInput=cus
{
send f
sleep 400
send Customer
send {ENTER}
send {ENTER}
}
else if UserInput=own
{
send f
sleep 300
send Ownership
send {ENTER}
}
else if UserInput=act
{
send f
sleep 300
send Activities
send {ENTER}
}
else if UserInput=att
{
send f
sleep 300
send Attachments
send {ENTER}
}
else if UserInput=aud
{
send f
sleep 300
send Audit
send {ENTER}
}
else if UserInput=mail
{
send f
sleep 300
send New Mail
send {ENTER}
sleep 2000
actwin("notepad++.exe")
send ^n
}
else if UserInput=save
{
send f
sleep 500
send 2
send {ENTER}
}
else if UserInput=wai
{
send f
sleep 300
send as
send {ENTER}
send {Down}
send {Down}
}
else if UserInput=note
{
send f
sleep 300
send New Note
send {ENTER}
}
else if UserInput=kb
{
send f
sleep 300
send Kno
send {ENTER}
}
else if UserInput=mm
{
send b
sleep 500
send mail.google.com
send {ENTER}
}
else if UserInput=tsc
{
send b
sleep 500
send TIBCO Support Central
send {ENTER}
}
else if UserInput=send
{
send b
sleep 500
sendbyclip("Send Email")
send {ENTER}
}
else if UserInput=ser
{
send b
sleep 500
send Service Request
send {ENTER}
}
else if UserInput=6
{
send ^6
}
else if UserInput=t
{
send ^6
}
}

;>[全局|Function|Function|Notice]
#IfWinActive
;-------------------------------------------------------------------------------------
ClickNoInNotepad()
{
SetControlDelay -1
ControlClick,Button2,ahk_class #32770
Sleep 200
}
;-------------------------------------------------------------------------------------
ClickNoParms(par1,par2)
{
SetControlDelay -1
ControlClick,%par1%,ahk_exe %par2%
Sleep 200
}
;-------------------------------------------------------------------------------------
ClickNoParmsA(par1)
{
SetControlDelay -1
ControlClick,%par1%,A
Sleep 200
}

Warn(text){
SplashTextOn, , , %text%
Sleep, 1000
SplashTextOff
}
;-------------------------------------------------------------------------------------
;how to click inside bar or move mouse and focus there  CoordMode needed
Taskbar(Program, WorkingDir="", WindowSize=""){   ; found win+b is the same !
    SplitPath Program, ExeFile 
    Process, Exist, %ExeFile% 
    PID = %ErrorLevel% 
	ControlClick,Button3, ahk_pid %PID% 
	;ControlFocus,Button3, ahk_pid %PID% 
	;MouseMove, A_ScreenWidth-60,A_ScreenHeight-150
	;MouseMove, 1304,560   ; needs CoordMode set to mouse first  
    DllCall("SetCursorPos", int, 1304, int, 560)
    } 

;>[全局|Label|Label|SearchClipboard]
#IfWinActive
!+v::
SearchAHK("C:\Users\robert\_vimperatorrc",clipboard) ; test(p1,p2="") would help to save writing the second parameter
return
!+f::
send ^c
run,%clipboard% ;open in firefox
return
!+g::
SearchAHK("..\gmailSimple\gmailSimple.ahk",clipboard)
return
!+l::
SearchAHK("G:\SRAll\ToAttach\GoodLearn\BashGood\1122GoodDayLearn.xml",clipboard)
return
!+b::
SearchAHK("G:\SRAll\Experience\GoodEmail\mail\mail0630Bigmail.txt",clipboard)
return
!+p::
SearchAHK("G:\SRAll\Experience\GoodEmail\PadAllBeforeNS.txt",clipboard)
return
#+r::
gosub AddToRun
return
#!r::
send ^c
gosub LocateReg
return

!+o::
send ^c
openfile(clipboard)
return


^!o::
send ^c
run,%clipboard%
return

!+s::
send ^c
IfWinActAll("FileLocatorPro.exe","FileLocate")
FileLocateActive(clipboard)
return

qurun:
UseClipBoardRun("http://10.106.148.71/query?q=","")
return

srrun:
UseClipBoardRun("http://10.106.148.71/sr/","")
return

mmrun:
UseClipBoardRun("https://mail.google.com/mail/u/0/#search/label%3A回好的++","")
return
kbrun:
search3("http://10.106.148.71/ka/000/",".htm")
return
google:
UseClipBoardRun("https://www.google.com/#newwindow=1&q=","")
return
baidu:
UseClipBoardRun("http://www.baidu.com/s?wd=","")
return

;>[全局|Label|Label|ForPaste]
#IfWinActive
OffPasteEnter:
Hotkey,LCtrl & v,off
Hotkey,MButton,PasteOnly
Warn("Auto Paste Enter Off")
return 
OnPasteEnter:
Hotkey,LCtrl & v,on
Hotkey,MButton,PasteEnter
Warn("Auto Paste Enter On")
return 
PasteEnter:
send ^v
send {ENTER}
return
PasteOnly:
send ^v
return

;>[全局|Label|Label|ForKeyCombine]
#IfWinActive
CtrlLeft:
send ^{Left}
return 

CtrlRight:
send ^{Right}
return 

CtrlPgUp:
send ^{PgUp}  ;also fails in clover and filelocater like /caps a . only PgDn or PgUp used according the effect because of sendmode input
return

CtrlPgDn:
send ^{PgDn} 
return

tab:
send {Tab}
return

ctrla:
send ^a
return

home:
send {Home}
return

end:
send {End}
return

shifthome:
send +{Home}
return

shiftend:
send +{End}
return

ctrlhome:
send ^{Home}
return

ctrlend:
send ^{End}
return

CtrlF6:
send ^{F6}
return
CtrlF8:
send ^{F8}
return

TwoWheelUp:
MouseClick, WheelUp, , , 2  ; Turn it by two notches.
return
TwoWheelDown:
MouseClick, WheelDown, , , 2
return

;>[全局|Label|Label|ForWordDelete]
#IfWinActive
delwordafter:
Send, ^{Del} 
return
delwordbefore:
Send, ^{BS}   
return

delend:
send {End}{BS}
return
delhome:
send {Home}{Del} 
return

delcharbefore:
Send, {BS} 
return
delcharafter:
Send, {Del}
return

DelAllAfter:
 Send, +{End}{Del}        ; / = Del all  after
return 
DelAllBefore:
 Send, +{Home}{Del}       ; b = Del all  before; 
return 

;>[全局|Label|Label|ForWindowManage]
#IfWinActive
CloseTabAll:
send !{F4}
return 


;>[全局|Label|Label|ForContentManage]
#IfWinActive
EndShiftHome:
send {End}
sleep 100
gosub shifthome
return
LineCut:
gosub EndShiftHome
sleep 100
send ^x
return 
LineCopy:
gosub EndShiftHome
sleep 100
send ^c
return 
LineCutPaste:
gosub LineCut
send {Down}
send ^v
return 

;>[全局|Function|Function|ActWindow]
#IfWinActive
;---------------------------------------------------------------------o
actwinbest(Name)
{
If WinExist(Name) ;fails
{
actwinname(Name)
}
else If WinExist("ahk_exe" Name)
{
actwin(Name)
}
else If WinExist("ahk_class" Name)
{
actwinclass(Name)
}
else
{
if Name = notepad++.exe
{
Run,"F:\Program Files\Notepad++\notepad++.exe"
}
else if Name = QQ.exe
{
Run,"E:\Win10TH2Share\Program Files\QQ\Bin\QQ.exe"
}
else if Name = sh.exe 
{
Run,"E:\EasyOSLink\Run\OS\bash2.lnk"
}
else if Name = Totalcmd64.exe
{
;Run,tc64
Run,"C:\Program Files\TotalCMD64\Totalcmd64.exe" ; may need change
}
else if Name =  cmd.exe 
{
;Run,%windir%\system32\cmd.exe
}
else if Name =  BCompare.exe
{
run,G:\SysManage\SoftFolders\BeyondComparePortable\App\BeyondCompare\BCompare.exe
;Run,"G:\SysManage\Update\Beyond Compare\BCompare.exe"
}
else if Name = firefox.exe
{
Run,"E:\EasyOSLink\Run\AdminWork\fire10.lnk"
}
else if Name =designer.exe
{
Run,"E:\EasyOSLink\Run\SR\desi.lnk"
}
else if Name =WinSCP.exe
{
Run,"G:\SysManage\SoftFolders\winscp556\WinSCP.exe"
}
else if Name =Everything.exe
{
Run,"F:\Program Files\Everything\Everything.exe" -s "%ClipBoard%"
}
else if Name =SnippingTool.exe
{
Run SnippingTool.exe ;snap the screen
}
else if Name =Taskmgr.exe
{
Run,%windir%\system32\taskmgr.exe /7
}
else if Name =  Foxit Reader.exe
{
Run,"G:\SysManage\HelpSoft\FoxitReaderPro\Foxit Reader.exe"
}
else if Name =VirtualBox.exe
{
Run,"E:\EasyOSLink\Run\SR\vbox.lnk"
}
else
{
MsgBox AppName not set in ahk file
}
}
}
;------------------------------------------------------------------------------
actwinbestarray(Name,App)
{
If WinExist("ahk_exe" Name)
{
WinActivate ,ahk_exe %Name%
} 
else
{
Run,%App%
}
}
;-------------------------------------------------------------------------------------
;CapsLock & Right:: MouseMove, 10, 0, 0, R                            ;|
MoveMouse(LeftRight,UpDown)
{
MouseMove, LeftRight, UpDown, 0, R
}

actwin(Name)
{
WinActivate ,ahk_exe %Name%
}

actwinclass(Name)
{
WinActivate ,ahk_class %Name%
}

actwinname(Name)
{
WinActivate , %Name%
}

NameIf(Name)
{
If WinExist(Name) ;fails
{
actwinname(Name)
return true
}
}

ExeIf(Name)
{
If WinExist("ahk_exe" Name)
{
actwin(Name)
return true
}
}

ClassIf(Name)
{
If WinExist("ahk_class" Name)
{
actwinclass(Name)
return true
}
}

IfWinActAll(Name,Cmd)
{
if(NameIf(Name)=true or ExeIf(Name)=true or ClassIf(Name)=true) ;understand why you use "return true" in above functions now
{
NameIf(Name)
ExeIf(Name) ;how could I know if it breaks once NameIf matches ? This is what I want.
ClassIf(Name)
}
else
{
Run,%Cmd%
}
}

StringActivateName(name,cmd)
{
IfWinExist %name%
WinActivate
else
Run,%cmd%
return
}

StringActivate(name,cmd)
{
IfWinExist ahk_exe %name%
WinActivate
else
Run,%cmd%
return
}

RunOrActivateProgram(Program, WorkingDir="", WindowSize=""){ 
    SplitPath Program, ExeFile 
    Process, Exist, %ExeFile% 
    PID = %ErrorLevel% 
    if (PID = 0) { 
    Run, %Program%, %WorkingDir%, %WindowSize% 
    }else{ 
    WinActivate, ahk_pid %PID% 
    } 
} 

ActQQ(name)
{
IfWinExist %name%
WinActivate
else
Run,% "E:\EasyOSLink\PCMasterMove\Desktop\desk3\AHkQQ\" . name . ".lnk"
return
}

;>[全局|Function|Function|Content]
#IfWinActive
------------------------------------------------------------------------------------- 
SearchAHK(file,content)
{
openfile(file)
sleep,200
send ^j
send %content%
return
}

sendbyclip(var_string)
{
    ClipboardOld = %ClipboardAll%
    Clipboard =%var_string%
    sleep 100
    send ^v
    sleep 100
    Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
}

;>[全局|Function|Function|Search]
#IfWinActive

AhkTestAlone:
    FileDelete, %A_Temp%\RunZ.AhkTest.ahk
    FileAppend, #SingleInstance force`n, %A_Temp%\RunZ.AhkTest.ahk
    FileAppend, %clipboard%`n, %A_Temp%\RunZ.AhkTest.ahk
    ;Run,"F:\Program Files\Notepad++\notepad++.exe" %A_Temp%\RunZ.AhkTest.ahk
	;sleep 100
    FileAppend, #include F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\Scripts\AHKManager\Core\Common.ahk`n, %A_Temp%\RunZ.AhkTest.ahk  ; this causes the test ahk unable to run. so you could not use the funcs you have added. this is the only thing needs improved
    Run, %A_Temp%\RunZ.AhkTest.ahk
return

includeAhktest:
send ^c
gosub AhkTestAlone
return

;-------------------------------------------------------------------------------------
EveSearch(sea)
{
Run,"F:\Program Files\Everything\Everything.exe" -s "%sea%"
return
}
SearchSelectViaEverything()
{
current_clipboard = %Clipboard%
Send ^c
ClipWait, 1
Run,"F:\Program Files\Everything\Everything.exe" -s "%ClipBoard%"
Clipboard = %current_clipboard%
return
}
FileLocateActive(word,path:="F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\Scripts\")
{
ControlSetText,Edit3,%word%
ControlSetText,Edit4,%path%
ClickNoParmsA("Button5")
return
}

;FileLocate(word,path:="F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\")
FileLocate(word,path:="F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\Scripts\")
{
run,"F:\Program Files\FileLocate\FileLocatorPro.exe" -c %word% -r -d "%path%" ;how to enforce only one program window?
}

search3(url,append) 
{
Run %url%%Clipboard%%append%
Return
}

UseClipBoardRun(start,end)
{
current_clipboard = %Clipboard%
Send ^c
ClipWait, 1
clipboard = %start%%clipboard%%end%
Run %Clipboard%
Clipboard = %current_clipboard%
return
}

SearchHH()
{
StringActivate("hh.exe","hh.lnk")
ControlClick,Edit1,ahk_exe hh.exe  ;activate the search edit automatically! ;edit1 for seaqrch and edit2 for index
sleep 200
sendinput +{Home}
sleep 200
send {BS}
sleep 200
send ^v
send {Enter}
}

SearchHHBetter()
{
send ^c
StringActivate("hh.exe","hh.lnk")
ControlSetText,Edit1,%clipboard%  ;activate the search edit automatically! ;edit1 for seaqrch and edit2 for index
send {Enter}
}


;>[全局|Function|Function|FileOperate]
#IfWinActive
CheckFile(file)
{
openfile(file)
sleep,200
send ^j
return
}

openfile(Name)
{
Run,"F:\Program Files\Notepad++\notepad++.exe" %Name%
}



;>[全局|HotString|HotString|ForWork]
#IfWinActive
::mqlib::G:\SRAll\ToAttach\SRHelps\Sr\collect\mq_lib
::/logback::E:\EasyOSLink\PCMasterMove\Downloads\Compressed\SampleLogger
::/cert::F:\tibco\ems\8.1\samples\certs



;>[全局|HotString|HotString|ForSystem]
#IfWinActive
::/7ja::PATH="F:\Program Files\Java\jdk1.7.0_09\bin\jar.exe";%PATH%
::/cmder::F:\GeekWorkLearn\Cmder

;>[全局|HotString|HotString|ForAHK]
#IfWinActive
::/arg::word := Arg == "" ? clipboard : Arg
::sed::
sendinput send{space}
return
::hy::HotKey,

::sdv::send ^v
::/it::autohotkey,vimperator,everything,wgesture,seer,idm

;>[全局Type|HotString|HotString|ActiveWindowLink]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
::keep::
IfWinActAll("Google Keep","chrome.exe")
return

::qy::
IfWinActAll("爱奇艺视频","cmd")
return

::ws::
IfWinActAll("WinSCP.exe","ws2")
return

::spy::
::sp::
StringActivate("AU3_Spy.exe","spy")
Return

::gg::
StringActivate("chrome.exe","gmail")
return

;-------------------------------------------------------------------------------------
::id::
WinGetTitle, Title, A
;MsgBox, The active window is "%Title%". ;2016-04-29 10:23:27
StringActivate("IDMan.exe","idm.lnk")
Return
::idm::
StringActivate("IDMan.exe","idm.lnk")
Return
::YXS::
StringActivate("QQYXS.exe","cmd")
Return


;>[全局Type|HotString|HotString|ActiveWindow]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
::ec::
StringActivate("eclipse.exe","G:\WorkDocSoft\Java\eclipse-jee-indigo-SR2-win32\eclipse\eclipse.exe") ;RunOrActivateProgram fails in win10 why ?
return

::gw:: ;use to disable wgesture if needed
send ^!+w
return

::vm::
StringActivate("vmware.exe","C:\Program Files\VMwareWorkstation\vmware.exe")
return

::wd::
;StringActivate("WINWORD.EXE","X:\Program Files\Microsoft Office 2016\Office16\WINWORD.exe")
StringActivate("WINWORD.EXE","C:\Program Files (x86)\Microsoft Office\Office15\WINWORD.EXE")
return

::dt::
StringActivateName("Ditto","F:\Program Files\Ditto\Ditto.exe")
return

::ma::
StringActivate("MSACCESS.EXE","MSACCESS.EXE")
return
::reg::
StringActivate("regedit.exe","regedit.exe")
return

::dl::
IfWinActAll("sh.exe","F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\Scripts\FromAutoHotkeyScriptFolder\Bak20160308_To_2015Nov\dockerLogin.ahk")
return

::sni::
actwinbest("SnippingTool.exe")
return

::ee::
RunOrActivateProgram("D:\Program Files (x86)\Clover\clover.exe")
return

::c1::
::cx::
actwinbest("cmd.exe")
;RunOrActivateProgram("cmd.exe")
return

::cc::
::cd::
StringActivate("Cmder.exe","Cmder.lnk")
;RunOrActivateProgram("E:\EasyOSLink\PCMasterMove\Downloads\Compressed\cmder_mini\Cmder.exe") ; too slow compared to listary
;RunOrActivateProgram("E:\EasyOSLink\PCMasterMove\Downloads\Compressed\cmder_mini\vendor\conemu-maximus5\ConEmu64.exe")
return

::jj::
RunOrActivateProgram("G:\SysManage\SoftFolders\Decompiler\jd-gui.exe")
return
::ii::
RunOrActivateProgram("F:\Program Files\PCMaster\magiczip.exe")
return
::we::
RunOrActivateProgram("C:\ProgramData\WebEx\WebEx\T30_MC\atmgr.exe")
return

::yy::
RunOrActivateProgram("F:\Program Files\AutoHotkey\AU3_Spy.exe")
Return

::fd::
RunOrActivateProgram("F:\Program Files\Fiddler\Fiddler.exe")
return

::qqgame::
RunOrActivateProgram("F:\Program Files\Tencent\QQGAME\QQGame.exe")
Return
::qq8::
RunOrActivateProgram("F:\Program Files\QQ\Bin\QQ.exe")
return
::/qq::
RunOrActivateProgram("F:\Program Files\QQ\QQProtect\Bin\QQProtect.exe")
return
::/qq10::
RunOrActivateProgram("E:\Win10TH2Share\Program Files\QQ\Bin\QQ.exe")
return

;::cc::
;StringActivate("cmd.exe","cmd")  ;fail because cmd is run as admin
;Return

::vf::
Run,F:\Program Files\VistaSwitcher\vsconfig64.exe
return

::vs::
Run,F:\Program Files\VistaSwitcher\vswitch64.exe
return

::task::
Taskbar("C:\Windows\explorer.exe")
return

;failure if window exists
::tasks::
RunOrActivateProgram("taskmgr.exe")
return

::lang2::
RunOrActivateProgram("D:\Program Files (x86)\Clover\clover.exe")
sleep 300
send !d
sleep 300
sendbyclip("控制面板\所有控制面板项\语言")
sleep 300
send {Enter}
return

::pp::
;StringActivate("Foxit Reader.exe","pdf")
RunOrActivateProgram("G:\SysManage\HelpSoft\FoxitReaderPro\Foxit Reader.exe")
Return
::tt::
;StringActivate("tcpTrace.exe","tcptrace")
StringActivate("tcpTrace.exe","G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 9695 /serverPort 9696 /serverName localhost /title localhost 9695 to 9696")
Return

::pacsend::
;Run,G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 9587 /serverPort 587 /serverName smtp.office365.com /title PacMailSend_9587
Run,G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 9901 /serverPort 587 /serverName smtp.office365.com /title PacMailSend_9587
return 
::pacpick::
Run,G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 9995 /serverPort 995 /serverName outlook.office365.com /title PacMailPick_995  ;pop
;Run,G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 9993 /serverPort 993 /serverName outlook.office365.com /title PacMailPickImap_993  ;imap
return 



::mmu:: ;全局快捷键会让ctrl+alt+down在notepad失效
StringActivate("cloudmusic.exe","E:\Win10TH2Share\CloudMusic\cloudmusic.exe")
return

;>[全局Type|HotString|HotString|QQ]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 

::rent::
ActQQ("刘洋烽火科技刚毕业")
return

::qq::
;StringActivateName("老婆大人","E:\EasyOSLink\PCMasterMove\Desktop\desk3\AHkQQ\老婆大人.lnk")
ActQQ("老婆大人")
Return
::clark::
ActQQ("Clark-刘彻")
Return
::mona::
ActQQ("Mona")
Return
::stu::
ActQQ("李晨 BW西安实习生")
return
::sam::
ActQQ("黄剑锋")
Return
::jing::
ActQQ("Support-井曙光")
Return
::hab::
ActQQ("habit学的农学 干的设计 玩的代码")
return 
::bw::
ActQQ("BW Team")
Return
::cdcq::
StringActivateName("TIBCO-CDC","E:\EasyOSLink\PCMasterMove\Desktop\desk3\AHkQQ\TIBCO-CDC.lnk")
Return
::mate::
ActQQ("喏、一群小逗比")
Return
;VM IP
;server network restart
;manually give the ip ad then disable network and restart it again to use the new ip
;vi /etc/sysconfig/network-scripts/ifcfg-eh0
::xu::
ActQQ("RollingWayne")
Return
;-------------------------------------------------------------------------------------
::9::
ActQQ("9")
Return
::ba::
ActQQ("爸妈")
Return
::it::  ;you could judge it like search(use clipboard or set new args) or use hotstring which may be faster to lanuch by space button
ActQQ("软客")
Return
::ppq::
ActQQ("TIBCO Global Support")
Return
::ahkqq::
Run,E:\EasyOSLink\PCMasterMove\Desktop\desk3\AHkQQ
return 

;>[全局Type|HotString|HotString|Work]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
::hh::
StringActivate("hh.exe","hh.lnk")
return
::vpn::
Run,E:\EasyOSLink\Run\AdminWork\vpn.lnk
return
::bb::
StringActivate("BCompare.exe","compare")
ControlClick,Edit1,ahk_exe BCompare.exe  ;activate the search edit automatically!
Return

::doumail::
run,https://www.douban.com/doumail/
return

::admin::
run,http://robert:8080/administrator/servlet/tibco_administrator?c.fid=com_tibco_administrator_ApplicationFrame_1355312754
return

::cdcwiki::
run,http://192.168.73.3/JSPWiki/Wiki.jsp?page=IT-Relate
return
::11::
Run,\\192.168.65.11
return
::ghost::
run,http://zeus.softweek.net/item-slt-1.html
return

;>[全局Type|HotString|HotString|SystemLink]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
::vv::
CheckFile("C:\Users\robert\_vimperatorrc")
RETURN
::gv::
StringActivate("gvim.exe","vi.bat")
return
::des::
StringActivate("designer.exe","des13")
return
::ss::
StringActivate("Everything.exe","s.lnk")
return
:: s::
SearchSelectViaEverything()
return
::dd::
StringActivate("designer.exe","des13")
return
::6::
StringActivate("TIBCOBusinessStudio.exe","bw6.lnk")
return
::dd1::
StringActivate("designer.exe","desi")
return
::zz::
StringActivate("Taskmgr.exe","Taskmgr.exe")
return
::fr::
::ll::
;StringActivate("FileLocatorPro.exe","filelocate")
IfWinActAll("FileLocatorPro.exe","FileLocate")
return
::ff::
;StringActivate("firefox.exe","fire10p")
;StringActivate("firefox.exe","http://ahkcn.sourceforge.net/docs/AutoHotkey.htm")
;http://10.106.148.71/inplay   https://douban.fm/?from_=shire_top_nav# 
StringActivate("firefox.exe","https://douban.fm/")
return
::md::
StringActivate("MultiDesk64.exe","mdesk")
Return
::tc::
StringActivate("Totalcmd64.exe","tc")
return
::ww::
RunOrActivateProgram("F:\Program Files\Notepad++\notepad++.exe") ;see of faster when too many windows open
;StringActivate("notepad++.exe","pad")
return
::ge::
StringActivate("WGestures.exe","gest")
return
::wg10::
StringActivate("WGestures.exe","X:\ProgramData\Microsoft\Windows\Start Menu\Programs\WGestures\WGestures.lnk")
return
::WG::
StringActivate("WGestures.exe","gest")
return
::nn::
StringActivate("ahk_exe StikyNot.exe","note")
return


;>[全局Type|HotString|HotString|Command]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
::163send::
Run,G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 9977 /serverPort 25 /serverName smtp.163.com /title 163MailSend_9977
return 
::163pick::
Run,G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 12345 /serverPort 110 /serverName pop.163.com /title 163MaiPick_12345
return
::189pick::
Run,G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 9699 /serverPort 110 /serverName pop.189.cn /title 189mailpick_9699
return 
::189send::
Run,G:\SysManage\SoftFolders\TCPTraceLearn\tcpTrace.exe /listen 9901 /serverPort 25 /serverName smtp.189.cn /title 189MailSend_9901
return 



;>[全局Type|HotString|HotString|System]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
;::/hi::shutdown -h ;fails like you run the bat file 
::/h:: ;press space then it works. not sure why a bat file would fail
Run,shutdown -h
return

::host::
WinDir := A_WinDir ;because #NoEnv is used before so set it again
Run %comspec% /k pad.lnk %windir%\system32\drivers\etc\hosts ;this two lines works even env is set none
;openfile("%windir%\system32\drivers\etc\hosts") ;fails even env is set
;MsgBox,"%windir%\system32\drivers\etc\hosts" ;"D:\Windows\System32\drivers\etc\hosts"
return
::ipa::
Run,%comspec% /k ipconfig|find "192"
return 

::sahk::
Run,"F:\Program Files\Everything\Everything.exe" -s ".ahk"
return

;>[全局Type|HotString|HotString|ExeAndPathLink]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
::na::
StringActivate("navicat.exe","navi")
return

::ems::
StringActivate("tibemsd.exe","emsssl")
return
::ge::
::emst::
StringActivateName("Gems v3.4","emstool")
return

::jvm::
StringActivate("Java VisualVM","jvm")
return
::wm::
StringActivate("wmplayer.exe","musicall")
return

;>[全局Type|HotString|HotString|MouseMove]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 

::bar::
DllCall("SetCursorPos", int, 1250, int, 800)
return
::head::
DllCall("SetCursorPos", int, 640, int, 30)
return
::mid::
DllCall("SetCursorPos", int, 640, int, 280)
return
::tail::
::foot::
DllCall("SetCursorPos", int, 640, int, 800)
return
::rup::
DllCall("SetCursorPos", int, 1250, int, 20)
return
::lup::
DllCall("SetCursorPos", int, 20, int, 30)
return
::rfoot::
DllCall("SetCursorPos", int, 1250, int, 800)
return
::lfoot::
DllCall("SetCursorPos", int, 20, int, 800)
return

;>[全局Type|HotString|HotString|OpenLink]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
::/runz::
run, https://github.com/goreliu/runz/releases
return

::share::
run,\\192.168.72.254\Share
return

::samba::
run,\\192.168.72.254\Share\builds (192.168.65.27 (Samba Server))
return

::error::
run,http://download.virtualbox.org/jdk/jdk-api-localizations/jdk-api-zh-cn/builds/latest/html/zh_CN/api/java/lang/package-tree.html
return

::web::
Run,http://www.jeffjade.com/2016/03/30/104-front-end-tutorial/
return

::temp::
Run,R:\OSTmp\Local\
Return

::lang::
Run ::{26EE0668-A00A-44D7-9371-BEB064C98683}\0\::{BF782CC9-5A52-4A17-806C-2A894FFEEAC5}
return 

::net::
Run ::{26EE0668-A00A-44D7-9371-BEB064C98683}\3\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}
return 

::setip::
gosub setip
return

::scr::
;控制面板\所有控制面板项\显示\屏幕分辨率
run,::{26EE0668-A00A-44D7-9371-BEB064C98683}\0\::{C555438B-3C23-4769-A71F-B6D3D9B6053A}\Settings
return

::net2::
Run,ncpa.cpl
return 


::shu::
run,http://www.jianshu.com/writer#/notebooks/845761/notes/4351535
return
::lj::
run,http://www.ximalaya.com/1412917/album/239463?page=1
return
::afc::
run,http://www.appinn.com/chrome-store-foxified/
return
::changepass::
Run,http://directory.tibco-support.com/Partners/
return 
::topcpu::
Run,http://frankzhao.blog.51cto.com/273790/395861
return
::idd::
Run,E:\EasyOSLink\PCMasterMove\Downloads\Compressed 
return 
::music::
run,http://music.163.com/#/artist?id=1078381
return
;-------------------------------------------------------------------------------------
::webex2::
Run,https://tibcomc.webex.com/meet/yawu
return 
;-------------------------------------------------------------------------------------
/*
::webex::
Run,https://tibcomc.webex.com/mw3000/mywebex/default.do?siteurl=tibcomc&service=1&main_url=%2Fmc3000%2Fmeetingcenter%2Fdefault.do%3Fsiteurl%3Dtibcomc%26main_url%3D%252Fmc3000%252Fmeetingcenter%252Fmeetingend%252Flandingpage.do%253Fsiteurl%253Dtibcomc%2526ishost%253Dtrue%2526NM%253Dyawu%2526AD%253Dyawu%2540tibco-support.com%2526STD%253D1&rnd=151464816
return 
*/

::webex::
Run,https://tibcomc.webex.com/mw3000/mywebex/default.do?siteurl=tibcomc&service=1&main_url=`%2Fmc3000`%2Fmeetingcenter`%2Fdefault.do`%3Fsiteurl`%3Dtibcomc`%26main_url`%3D`%252Fmc3000`%252Fmeetingcenter`%252Fmeetingend`%252Flandingpage.do`%253Fsiteurl`%253Dtibcomc`%2526ishost`%253Dtrue`%2526NM`%253Dyawu`%2526AD`%253Dyawu`%2540tibco-support.com`%2526STD`%253D1&rnd=151464816
return 

;>[全局Type|HotString|HotString|OpenFile]
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe") 
::ad::
openfile(A_ScriptDir "\..\AHKManager\Plugins\Demo.ahk")
return
::am::
openfile(A_ScriptDir "\..\AHKManager\Plugins\Misc.ahk")
return
::ah::
openfile(A_ScriptDir "\..\AHKManager\UserDefine\hotstring\May20.ahk")
return

::ac::
openfile(A_ScriptDir "\..\AHKManager\Core\Common.ahk")
return

::usr::
openfile(A_ScriptDir "\..\AHKManager\Doc\用户手册.md")
return
::cz::
openfile(A_ScriptDir "\..\AHKManager\Conf\RunZ.ini")
return
::az::
openfile(A_ScriptDir "\..\AHKManager\RunZ.ahk")
return
::ag::
openfile(A_ScriptDir "\..\AHKManager\Core\GlobalMenu.ahk")
return
::at::
openfile("R:\OSTmp\Local\Temp\RunZ.AhkTest.ahk")
return

::ch::
run, %A_ScriptDir%\..\AHKManager\UserDefine\moreFunc\Habit1625\habit.mdb
return
::ce::
openfile("F:\Program Files\Everything\Everything.ini")
return 
::hlib::
run, %A_ScriptDir%\..\AHKManager\UserDefine\moreFunc\Habit1625\Habit-lib
return



;>[Explorer|^+n5|New Folder|New Folder]
#IfWinActive,ahk_exe explorer.exe
^+n::
        ; 第一行增加快捷键
Click right
Send, wf
Sleep, 125
        ; 把暂停时间改小
clipboard = %A_YYYY%-%A_MM%-%A_DD%
        ; 增加上面这句，把当前的系统日期发送到剪贴板
Send, ^v{Enter}
        ; 发送 Ctrl + v 和回车
return


;>[CMD|Shortcut|Paste Shortcut|Paste Shortcut]
;~ 命令提示符非常令人讨厌的一点是，不能用快捷键 Ctrl+V 粘贴。所以，便有了这段帅呆了的代码：
#IfWinActive ahk_class ConsoleWindowClass
^v::
send %Clipboard%
return
MButton::
send %Clipboard%
return
#IfWinActive 

;>[全局|Shortcut|Right Click|Caps Shortcut]
#IfWinActive,
RAlt::LButton
RCtrl::RButton
;-------------------------------------------------------------------------------------
;considering use this to left ctrl and alt too. also win button 
CapsLock & RCtrl:: Send, {AppsKey}                                       ;|
CapsLock & Enter::
SendEvent {Blind}{LButton down}                                      ;|
KeyWait Enter                                                        ;|
SendEvent {Blind}{LButton up}                                        ;|
return
;-----------------------------------o      
CapsLock & RShift::                                                                 ;|  ;works as Shift+F10 but fails in everything yet
SendEvent {Blind}{RShift down}                                      ;|
SendEvent {Blind}{F10 down}                                      ;|
KeyWait Enter                                                        ;|
SendEvent {Blind}{RShift up}                                        ;|
SendEvent {Blind}{F10 up}                                      ;|
return
;=====================================================================o
;                     CapsLock Mouse Controller                      ;|
;-----------------------------------o---------------------------------o
;                   CapsLock + Up   |  Mouse Up                      ;|
;                   CapsLock + Down |  Mouse Down                    ;|
;                   CapsLock + Left |  Mouse Left                    ;|
;                  CapsLock + Right |  Mouse Right                   ;|
;    CapsLock + Enter(Push Release) |  Mouse Left Push(Release)      ;|
;    Caps Shift:Right Click;Caps Enter:Left Click 
;-----------------------------------o                                ;|                          ;|
/*
CapsLock & Shift::                                                   ;|
SendEvent {Blind}{RButton down}                                      ;|
KeyWait Enter                                                        ;|
SendEvent {Blind}{RButton up}                                        ;|
return                                                               ;|
*/
;---------------------------------------------------------------------o
/*
CapsLock & RShift::   ;这表示在鼠标悬停处右键单击
SendEvent {Blind}{RButton down}                                      ;|
KeyWait Enter                                                        ;|
SendEvent {Blind}{RButton up}                                        ;|
return                                 ;|
*/
;-----------------------------------o                                ;|
;CapsLock & RShift:: Send, +{F10}  ;fails
;CapsLock & RShift:: Send, {AppsKey}                                       ;|  这貌似 Shift+F10 选中文件时可以看到文件的右键菜单
;-------------------------------------------------------------------------------------
/*
;n and m saved for other uses, i.e, open files
CapsLock & n::
SendEvent {Blind}{LButton down}                                      ;|
KeyWait Enter                                                        ;|
SendEvent {Blind}{LButton up}                                        ;|
return
CapsLock & m:: Send, {AppsKey}                                       ;|
*/



;>[全局|Shortcut|Caps Shortcut|Caps awsd]
#IfWinActive,
;introduced on 2016-05-03 9:51:17
CapsLock & d::
if getkeystate("alt") != 0
  send ^{Right}
else if getkeystate("ctrl") != 0
  send ^{PgDn}
else
    send ^{PgDn}
return
CapsLock & a::  ; why fails in clover ?
if getkeystate("alt") != 0
     send ^{Left}
else if getkeystate("ctrl") != 0
     send ^{PgUp}
else
    send ^{PgUp}
return
CapsLock & s::
if getkeystate("alt") != 0
     send !{Down}
else if getkeystate("ctrl") != 0
     send {PgDn}
else
     send {Down}
return
CapsLock & w::
if getkeystate("alt") != 0
    send !{Up}
else if getkeystate("ctrl") != 0
     send {PgUp}
else
     send {Up}
return

;>[全局|Shortcut|Caps Shortcut|MouseMove]
#IfWinActive,

;-----------------------------------------------------------------------
CapsLock & Right::
if getkeystate("alt") != 0
     MoveMouse(10,0)
else if getkeystate("ctrl") != 0
     MoveMouse(80,0)
else
     MoveMouse(160,0)
return
CapsLock & Left::
if getkeystate("alt") != 0
     MoveMouse(-10,0)
else if getkeystate("ctrl") != 0
     MoveMouse(-80,0)
else
     MoveMouse(-160,0)
return
CapsLock & Down::
if getkeystate("alt") != 0
     MoveMouse(0,10)
else if getkeystate("ctrl") != 0
     MoveMouse(0,80)
else
     MoveMouse(0,160)
return
CapsLock & Up::
if getkeystate("alt") != 0
     MoveMouse(0,-10)
else if getkeystate("ctrl") != 0
     MoveMouse(0,-80)
else
     MoveMouse(0,-160)
return

;>[全局|Shortcut|Caps Shortcut|Caps Shortcut]
#IfWinActive,
;===========================;I = Home
CapsLock & i::
if getkeystate("alt") != 0
Send, +{Home}
else if getkeystate("ctrl") != 0
Send,^{Home}
else
Send, {Home}
return
;===========================;O = End
CapsLock & o::
if getkeystate("alt") != 0
Send, +{End}
else if getkeystate("ctrl") != 0
Send, ^{End}
else
Send, {End}
return
;===========================;U = PageUp
CapsLock & u::
if getkeystate("alt") != 0
Send, +{PgUp}
else if getkeystate("ctrl") != 0
Send, ^{PgUp}
else
;Send, {PgUp}
Send, ^[
return
;===========================;P = PageDown
CapsLock & p::
if getkeystate("alt") != 0
Send, +{PgDn}
else if getkeystate("ctrl") != 0
Send, ^{PgDn}
else
;Send, {PgDn}
Send, ^]
return
;===========================;H = Left
CapsLock & h::
if getkeystate("alt") != 0
Send, +{Left}
else if getkeystate("ctrl") != 0
Send, ^{Left}
else
Send, {Left}
return
;===========================;J = Down
CapsLock & j::
if getkeystate("alt") != 0
Send, +{Down}
else if getkeystate("ctrl") != 0
Send, ^{Down}
else
Send, {Down}
return
;===========================;K = UP
CapsLock & k::
if getkeystate("alt") != 0
Send, +{Up}
else if getkeystate("ctrl") != 0
Send, ^{Up}
else
Send, {Up}
return
;===========================;L = Right
CapsLock & l::
if getkeystate("alt") != 0
Send, +{Right}
else if getkeystate("ctrl") != 0
Send, ^{Right}
else
Send, {Right}
return

;>[CMD|Shortcut|Bash Shortcut|Bash Shortcut]
/*
http://www.haiyun.me/archives/autohotkey-bash-cmd-hotkey.html
发布时间：March 5, 2013
习惯了Bash的快捷键，发现CMD也有类似于Bash的常用功能快捷键，试着用AutoHotkey映射CMD快捷键为Bash快捷键
*/ 
;------------------------------------------------------------------------------------- 
#IfWinActive,ahk_class ConsoleWindowClass 
^a::Send {Home} ;转到行首  but fails like ctrl+l since ahk is not able to override the system key combination especially for admin apps
!a::Send {Home} ;转到行首  
!e::Send {End} ;转到行尾  
^e::Send {End} ;转到行尾  
!f::Send ^{Right} ;后一个单词  
!b::Send ^{Left} ;前一个单词  
^f::Send {Right} ;转到后一个字符  
^b::Send {Left} ;转到前一个字符  
^u::Send ^{Home} ;删除当前行光标前内容  
^k::Send ^{End} ;删除当前行光标后内容  
^p::Send {Up} ;上一个命令  
^n::Send {Down} ;下一个命令  
^d::Send {Delete} ;删除后一个字符  
;^v::send %Clipboard% ;粘贴  there already!
^l::Send cls{Enter} ;清除屏幕  
!l::Send cls{Enter} ;清除屏幕  
#IfWinActive ;either this or return is OK. return is not OK! it would not apply to special apps but globally


/*

HotKey, ;, NextIME

`::
*/
/*
#F7::SetTimer,ReleaseCaps,Off
#F8::SetTimer,ReleaseCaps,200
ReleaseCaps:
SetCapsLockState, AlwaysOff
return
SetTimer,ReleaseCaps,200
*/

