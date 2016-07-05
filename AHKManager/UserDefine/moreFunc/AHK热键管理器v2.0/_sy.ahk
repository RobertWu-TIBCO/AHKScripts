#SingleInstance Force
#NoEnv
#NoTrayIcon
SetWorkingDir %A_ScriptDir%


#ifwinactive,
::hy::Hotkey,
#ifwinactive,
::hy::Hotkey,
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
Warn(text){
SplashTextOn, , , %text%
Sleep, 1000
SplashTextOff
}
;-------------------------------------------------------------------------------------
hi:
MsgBox hi
return
;------------------------------------------------------------------------------------- 
CtrlLeft:
send ^{Left}
return 
CtrlRight:
send ^{Right}
return 
;------------------------------------------------------------------------------------- 
CtrlPgUp:
send ^{PgUp}  ;also fails in clover and filelocater like /caps a . only PgDn or PgUp used according the effect because of sendmode input
return
CtrlPgDn:
send ^{PgDn} 
return
;-------------------------------------------------------------------------------------
tab:
send {Tab}
return
;-------------------------------------------------------------------------------------
ctrla:
send ^a
return
;-------------------------------------------------------------------------------------
home:
send {Home}
return
end:
send {End}
return
;-------------------------------------------------------------------------------------
shifthome:
send +{Home}
return
shiftend:
send +{End}
return
;-------------------------------------------------------------------------------------
ctrlhome:
send ^{Home}
return
ctrlend:
send ^{End}
return
;-------------------------------------------------------------------------------------
qurun:
UseClipBoardRun("http://10.106.148.71/query?q=","")
return
srrun:
UseClipBoardRun("http://10.106.148.71/sr/","")
return
mmrun:
UseClipBoardRun("https://mail.google.com/mail/u/0/#search/label%3A�غõ�++","")
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
-------------------------------------------------------------------------------------
CtrlF6:
send ^{F6}
return
CtrlF8:
send ^{F8}
return
clover:
RunOrActivateProgram("D:\Program Files (x86)\Clover\clover.exe")
return
;------------------------------------------------------------------------------------- 
TwoWheelUp:
MouseClick, WheelUp, , , 2  ; Turn it by two notches.
return
TwoWheelDown:
MouseClick, WheelDown, , , 2
return
;-------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------- 
delwordafter:
Send, ^{Del} 
return
delwordbefore:
Send, ^{BS}   
return
;-------------------------------------------------------------------------------------
delend:
send {End}{BS}
return
delhome:
send {Home}{Del} 
return
;-------------------------------------------------------------------------------------
delcharbefore:
Send, {BS} 
return
delcharafter:
Send, {Del}
return
;-------------------------------------------------------------------------------------
DelAllAfter:
 Send, +{End}{Del}        ; / = Del all  after
return 
DelAllBefore:
 Send, +{Home}{Del}       ; b = Del all  before; 
return 
;-------------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------
CloseTabAll:
send !{F4}
return 
;------------------------------------------------------------------------------------- 
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
;-------------------------------------------------------------------------------------
search3(url,append) 
{
Run %url%%Clipboard%%append%
Return
}
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------- 
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
;-------------------------------------------------------------------------------------
#ifwinactive,
;-------------------------------------------------------------------------------------
!+s::
send ^c
FileLocate(clipboard)
return
;-------------------------------------------------------------------------------------
FileLocate(word,path:="F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\")
{
run,"F:\Program Files\FileLocate\FileLocatorPro.exe" -c %word% -r -d "%path%" ;how to enforce only one program window?
}
;-------------------------------------------------------------------------------------
^!z::
send ^c
StringReplace, clipboard, clipboard, .zip\
send ^v
return
;------------------------------------------------------------------------------------- 
::/op::
sendbyclip("openfile`(")
send "
sendinput ^v
send "){Enter}
send return
return
;-------------------------------------------------------------------------------------
sendbyclip(var_string)
{
    ClipboardOld = %ClipboardAll%
    Clipboard =%var_string%
    sleep 100
    send ^v
    sleep 100
    Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
}
;-------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------- 
/*
autohotkey �ж�chrome����Ƿ�������
*/ 
/*
184����ν�ĳ�ַ����е�Ӣ����ĸȫ��ת��Ϊ��д��Сд�������е�T��ʲô���ã�
Сд��StringLower, OutputVar, InputVar [, T]
��д��StringUpper, OutputVar, InputVar [, T]
T ����������ʹ����ĸ T ���ַ�������ת��Ϊ�����ʽ��
*/ 
::/up::
;send ^c ;you can not copy it when you have override it
StringUpper, clipboard, clipboard
Send ^v
return
::/low::
;send ^c ;you can not copy it when you have override it
StringLower, clipboard, clipboard
Send ^v
return
;good t use in firefox now !
^+u::
send ^c ;you can not copy it when you have override it
StringUpper, clipboard, clipboard
Send ^v
return
^!u::
send ^c ;you can not copy it when you have override it
StringLower, clipboard, clipboard
Send ^v
return
;-------------------------------------------------------------------------------------
; auto add quote surrounding selected contents
^+"::
send ^c
send "%clipboard%"
return
;-------------------------------------------------------------------------------------
#ifwinactive,
;-------------------------------------------------------------------------------------
::/pa111::%%ServiceWrapper/IH/Inbound/Identity/KeyPwd%%1
;-------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------
::/7ja::PATH="F:\Program Files\Java\jdk1.7.0_09\bin\jar.exe";%PATH%
::/cmd::F:\GeekWorkLearn\Cmder
;-------------------------------------------------------------------------------------
::/cert::F:\tibco\ems\8.1\samples\certs
;-------------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------
actwin(Name)
{
WinActivate ,ahk_exe %Name%
}
;-------------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------
#ifwinactive,
;-------------------------------------------------------------------------------------
#F6:: ;if absolute position could be used , it would be better.
WinGetPos, X, Y, , , A  ; "A" to get the active window's pos.
MsgBox, The active window is at %X%`,%Y%
MouseMove,X,Y
return
;-------------------------------------------------------------------------------------
#F7::SetTimer,ReleaseCaps,Off
#F8::SetTimer,ReleaseCaps,200
ReleaseCaps:
SetCapsLockState, AlwaysOff
return
SetTimer,ReleaseCaps,200
;-------------------------------------------------------------------------------------
#ifwinactive,ahk_exe notepad++.exe				
^!F5::	;��ʾ���
msgbox,���
return
;------------------------------------------------------------------------------------- 
/*
http://www.haiyun.me/archives/autohotkey-bash-cmd-hotkey.html
����ʱ�䣺March 5, 2013
ϰ����Bash�Ŀ�ݼ�������CMDҲ��������Bash�ĳ��ù��ܿ�ݼ���������AutoHotkeyӳ��CMD��ݼ�ΪBash��ݼ���
*/ 
#IfWinActive,ahk_class ConsoleWindowClass 
^a::Send {Home} ;ת������  but fails like ctrl+l since ahk is not able to override the system key combination especially for admin apps
!a::Send {Home} ;ת������  
!e::Send {End} ;ת����β  
^e::Send {End} ;ת����β  
!f::Send ^{Right} ;��һ������  
!b::Send ^{Left} ;ǰһ������  
^f::Send {Right} ;ת����һ���ַ�  
^b::Send {Left} ;ת��ǰһ���ַ�  
^u::Send ^{Home} ;ɾ����ǰ�й��ǰ����  
^k::Send ^{End} ;ɾ����ǰ�й�������  
^p::Send {Up} ;��һ������  
^n::Send {Down} ;��һ������  
^d::Send {Delete} ;ɾ����һ���ַ�  
;^v::send %Clipboard% ;ճ��  there already!
^l::Send cls{Enter} ;�����Ļ  
!l::Send cls{Enter} ;�����Ļ  
#IfWinActive ;either this or return is OK. return is not OK! it would not apply to special apps but globally
;~ ������ʾ���ǳ����������һ���ǣ������ÿ�ݼ� Ctrl+V ճ�������ԣ����������˧���˵Ĵ��룺
#IfWinActive ahk_class ConsoleWindowClass
^v::
send %Clipboard%
return
MButton::
send %Clipboard%
return
#IfWinActive 
;-------------------------------------------------------------------------------------
;[ȫ��|testahk|send,testahk]
:*?:testahk::
msgbox,��ִ����testahk
return
;[ȫ��|reques|send,requestor]
:*?:reques::
send,requestor
return
::sed::
sendinput send{space}
return
;-------------------------------------------------------------------------------------
;!v::send %Clipboard% ;ճ��  there already!
::sdv::send ^v
;-------------------------------------------------------------------------------------
CapsLock & c::send ^c
CapsLock & v::send ^v
;-------------------------------------------------------------------------------------
::/it::autohotkey,vimperator,everything,wgesture,seer,idm
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;#### start of firefox
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
;-------------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------

;#### start of TSC
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
;#### end of TSC

;-------------------
;#### start of SR
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
;#### end of SR
#ifwinactive,
::hy::Hotkey,
;-------------------------------------------------------------------------------------
StringActivateName(name,cmd)
{
IfWinExist %name%
WinActivate
else
Run,%cmd%
return
}
;-------------------------------------------------------------------------------------
ActQQ(name)
{
IfWinExist %name%
WinActivate
else
Run,% "E:\EasyOSLink\PCMasterMove\Desktop\desk3\AHkQQ\" . name . ".lnk"
return
}
;-------------------------------------------------------------------------------------
CheckFile(file)
{
openfile(file)
sleep,200
send ^j
return
}
;------------------------------------------------------------------------------
openfile(Name)
{
Run,"F:\Program Files\Notepad++\notepad++.exe" %Name%
}
;-------------------------------------------------------------------------------------
actwinclass(Name)
{
WinActivate ,ahk_class %Name%
}
actwinname(Name)
{
WinActivate , %Name%
}
;;=============================Navigator============================||
/*
active any window in any way
*/
NameIf(Name)
{
If WinExist(Name) ;fails
{
actwinname(Name)
return true
}
}
;-------------------------------------------------------------------------------------
ExeIf(Name)
{
If WinExist("ahk_exe" Name)
{
actwin(Name)
return true
}
}
;-------------------------------------------------------------------------------------
ClassIf(Name)
{
If WinExist("ahk_class" Name)
{
actwinclass(Name)
return true
}
}
;-------------------------------------------------------------------------------------
IfWinActAll(Name,Cmd)
{
if(NameIf(Name)=true or ExeIf(Name)=true or ClassIf(Name)=true) ;understand why you use "return true" in above functions now
{
NameIf(Name)
ExeIf(Name) ;how could I know if it breaks once NameIf matches ? This is what I want.
ClassIf(Name)
;MsgBox, good
}
else
{
;MsgBox, no
Run,%Cmd%
}
}
;-----------------------------------o---------------------------------o
StringActivate(name,cmd)
{
IfWinExist ahk_exe %name%
WinActivate
else
Run,%cmd%
return
}
;-------------------------------------------------------------------------------------