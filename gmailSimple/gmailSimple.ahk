#SingleInstance force  ; force reloading
AutoTrim,On
Menu, Tray, Icon, gahk1.ico
SetTitleMatchMode Regex  ;可以使用正则表达式对标题进行匹配; 关键是这样F5查找就失效了(\+ needs escape)。所以把F5放到common.ahk并设置mode 2
#Hotstring EndChars -?!`n `t
#Hotstring O1 Z1 *0 ?0 ; this makes hotstring not appending extra space anymore ! take care if any hotstring relys on a space 2016-04-29   ;#Hotstring O0 ;default appending a space
SetWorkingDir %A_ScriptDir%
;-------------------------------------------------------------------------------------
/*
;~find the "Location navigation" plugin very helpful:^+- and ^- navigates to the place course has been. ^!z goes to last edit place. ^!y goes back to edit more
;~ using the menu in this ahk once makes all Hotkey command fails since they are not executed. move menu to runz user ahk then put in global menu and use label helps a lot
;~SendMode Input  ; this causes all problem ! made /caps win + a s unable to use as ^{PgUp} etc !
;~found that the tab opened by vimperator would go to the last but not next to the current acticve tab. this is annoying and I thought my addons go bad. 
*/
;-------------------------------------------------------------------------------------
/*
SetTitleMatchMode Regex ;可以使用正则表达式对标题进行匹配
#IfWinActive ahk_class ExploreWClass|CabinetWClass
^!h::toggle_hide_file_in_explore()
#IfWinActive
*/
;-------------------------------------------------------------------------------------
global g_WindowName2 := "Give an Command"

Hotkey, IfWinActive,RunZ|Give an Command      ;fails WinActive(%g_WindowName2%) or . but works after SetTitleMatchMode Regex set. this even works when editing runz.ahk in notepad++. remove % should help
;Hotkey, ^Left, hi
;Hotkey, WheelUp, up ;fails
;Hotkey, WheelDown, down ;fails
;Hotkey, CapsLock & WheelDown, down ;fails
;Hotkey, #WheelUp, up  ;fails
;Hotkey, #WheelDown, down ;fails
Hotkey, If
;------------------------------------------------------------------------------------- 
Hotkey, IfWinActive, File Switcher
Hotkey, WheelUp, up
Hotkey, WheelDown, down
Hotkey,CapsLock & WheelDown, PgDn
Hotkey,CapsLock & WheelUp, PgUp
Hotkey,LAlt & WheelDown, Enter
Hotkey,LAlt & WheelUp, PgUp
Hotkey,LWin & WheelUp, PgUp
Hotkey,LWin & WheelDown, PgDn
Hotkey, LWin & s, PgDn
Hotkey, LWin & w, PgUp
;Hotkey, LCtrl & WheelUp, PgUp
;Hotkey, LCtrl & WheelDown, PgDn
Hotkey, IfWinActive
;------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;Hotkey, IfWinActive, ahk_exe Cmder.exe|ConEmu64.exe|ConEmu.exe|Cmd.exe
Hotkey, IfWinActive, ahk_class ConsoleWindowClass|VirtualConsoleClass
;Hotkey, ^Left, hi
Hotkey, IfWinActive
;-------------------------------------------------------------------------------------
Hotkey, IfWinActive, ahk_class VirtualConsoleClass
Hotkey, !Space, CloseTabAll
Hotkey, IfWinActive
;-------------------------------------------------------------------------------------
global g_chrome := "ahk_exe chrome.exe"
Hotkey, IfWinActive, % g_chrome
Hotkey, CapsLock & a, CtrlShiftTab
Hotkey, CapsLock & d, CtrlTab
Hotkey, IfWinActive
;-------------------------------------------------------------------------------------
;#### start of QQ gui 
Hotkey, IfWinActive, ahk_class TXGuiFoundation
Hotkey, $Tab, CtrlTab ;otherwise alt-tab not work in qq chat
Hotkey, $+Tab, CtrlShiftTab ;otherwise alt-tab not work in qq chat
Hotkey, IfWinActive
;-------------------------------------------------------------------------------------
Hotkey, IfWinActive, ahk_exe PotPlayerMini.exe
Hotkey, !x,CtrlEnter
Hotkey, IfWinActive
;------------------------------------------------------------------------------------- 
Hotkey, IfWinActive, ahk_exe notepad\+\+.exe
;Hotkey,LCtrl & x, delwordafter
Hotkey,CapsLock & PgUp,ctrlhome
Hotkey,CapsLock & PgDn,ctrlend
;Hotkey,CapsLock & [,ctrlparaup
;Hotkey,CapsLock & ],ctrlparadown
Hotkey,!+d,hi
Hotkey, IfWinActive

;-------------------------------------------------------------------------------------
;#### start of all apps
Hotkey, IfWinActive
Hotkey,^!q,qurun
Hotkey,^!r,srrun
Hotkey,^!m,mmrun
Hotkey,^!k,kbrun
Hotkey,^!g,google
Hotkey,^!b,baidu
Hotkey,#o,explorerparent
Hotkey,!c,Dictionary2 ;unable to call ci or Dictionary label in Misc ahk or Demo ahk since not able to include them
Hotkey,^+1,Dictionary2
Hotkey,^+``,Dictionary2
Hotkey,CapsLock & -,editplace
Hotkey,!-,editplace
Hotkey,#PgDn,ctrlwinright
Hotkey,#PgUp,ctrlwinleft
Hotkey,!p,shiftenddel
Hotkey,!u,shifthomedel
Hotkey,!+-,editplaceback
Hotkey,CapsLock & ',homequote
Hotkey,CapsLock & `;,homecomment
Hotkey,CapsLock & \,homecomment
Hotkey,CapsLock & 3,homesharp
Hotkey,CapsLock & Tab,wint
;ready to use it in firefox as well . also use Wgesture to control text select and copy!
Hotkey,^Up,shiftHome ;OK to use , so it seems the same is applied to other keys 
Hotkey,^Down,shiftEnd
Hotkey,!x,Enter ;play enter
Hotkey, +PgUp,home
Hotkey, +PgDn,end
Hotkey, !PgUp,home
Hotkey, !PgDn,end
Hotkey,^!Left,CtrlPgUp
Hotkey,^!Right,CtrlPgDn
Hotkey, LWin & a, CtrlPgUp
Hotkey,LWin & w,TwoWheelUp
Hotkey,LWin & s,TwoWheelDown
Hotkey,LWin & d,WinDCaps
Hotkey,MButton,PasteEnter
Hotkey,MButton,PasteOnly
Hotkey,LCtrl & v,PasteEnter
Hotkey,LCtrl & v,off
Hotkey,#F9,cn
Hotkey,#F10,en
Hotkey,#F12,OffPasteEnter
Hotkey,#F11,OnPasteEnter
Hotkey,CapsLock & x,LineCut
;CapsLock & x::send ^a{Del} ;earse all input 
;CapsLock & x::send +{Home}{Del} ;earse all input 
Hotkey,CapsLock & 7,ctrlhome
Hotkey,CapsLock & 8,ctrlend
Hotkey,CapsLock & q,ctrlhome
Hotkey,CapsLock & e,ctrlend
Hotkey, !a,home
Hotkey, !+a,shifthome
Hotkey, !e,end
Hotkey, !+e,shiftend
Hotkey,CapsLock & (,shiftHome
Hotkey,CapsLock & ),EndShiftHome
;Hotkey,CapsLock & ),shiftend
;CapsLock & +::send {Home}{Del} ;either = or + works!
Hotkey,CapsLock & +,delhome
Hotkey,CapsLock & BackSpace,delend
Hotkey,!b,CtrlLeft
Hotkey,!h, Left
Hotkey,!k, Up
Hotkey,!f,ctrlRight
Hotkey,!l,Right
Hotkey,!j,Down ;everything used !s
Hotkey,CapsLock & [,en
Hotkey,CapsLock & ],cn

Hotkey, IfWinActive
;Hotkey,#e, clover ; this command seems weak. this seems unable to replace the system hotkey combination. so use #e outside again
;-------------------------------------------------------------------------------------
;below fails sometimes
;;-------------------------------------------------------------------------------------
Hotkey, IfWinActive, ahk_exe eclipse.exe
Hotkey,^Enter, NewLine
Hotkey,^Tab, CtrlF6
Hotkey,#Tab, CtrlF8
Hotkey, IfWinActive
;-------------------------------------------------------------------------------------
Hotkey, IfWinNotActive, ahk_exe eclipse.exe
;Hotkey,^+r,srrun ;不推荐使用,推荐^!r全局使用的
Hotkey,^+r, includeAhktest
HotKey, `;, cn
HotKey, `', en
HotKey, ^!`; , simo
HotKey, ^`; , simo
HotKey, ^' , SQuote
HotKey, ^!``, BelowEsc
HotKey, +``, BelowEsc
Hotkey, IfWinNotActive
;-------------------------------------------------------------------------------------
Hotkey, IfWinNotActive, ahk_exe notepad\+\+.exe|eclipse.exe|TIBCOBusinessStudio.exe
Hotkey,^!Down,LineCutPaste
Hotkey,^d,delwordafter
Hotkey,+^d,LineCut
Hotkey,^l,LineCut ;fails in firefox
Hotkey,^+l,LineCopy
Hotkey,#Tab,WinTab
Hotkey, IfWinNotActive
;-------------------------------------------------------------------------------------
Hotkey, IfWinActive, 收件箱|"回好的"
;#If WinActive("收件箱") or WinActive("回好的")  ; the next fails as it has "" by default 
;help gmail web to navigate better
Hotkey,!Left,CtrlPgUp  ;strang as it shows a window of all firefox opened tabs
Hotkey,!Right,CtrlPgDn
;Hotkey,^Left,CtrlPgUp
;Hotkey,^Right,CtrlPgDn ;防止编辑时光标移动不方便
Hotkey,CapsLock & d,CtrlPgDn
Hotkey,CapsLock & a,CtrlPgUp
Hotkey, IfWinActive
;#### end of mail
;-------------------------------------------------------------------------------------
Hotkey, IfWinNotActive, ahk_exe firefox.exe
Hotkey,!i,PgUp
Hotkey,!o,PgDn
Hotkey, IfWinNotActive
;-------------------------------------------------------------------------------------
Hotkey, IfWinNotActive, SR ;如果不这样就无法通过滚动来看下一个sr回复了
Hotkey,^Enter, NewLine
Hotkey, IfWinNotActive
;-------------------------------------------------------------------------------------
global g_WindowNameTest := "ahk_exe firefox.exe"
;Hotkey, IfWinActive, % g_WindowNameTest
Hotkey, IfWinActive, ahk_exe firefox.exe ; can not help to set to notepad++ because \+ needed as escape
Hotkey, CapsLock & PgUp,CtrlPgUp
Hotkey, CapsLock & PgDn,CtrlPgDn
;Hotkey, !Left,CtrlPgUp
;Hotkey, !Right,CtrlPgDn
;Hotkey, ^Tab,tab ;默认就是,注释了gmail也可以用默认的了而不是vimp的
Hotkey,CapsLock & p,Pocket
Hotkey,CapsLock & l,LastPass
Hotkey,CapsLock & k,GoogleKeep ;^+k also works now changes it to ^!k
Hotkey,CapsLock & g, lastpasslogin
Hotkey,CapsLock & o, onetab
;Hotkey, !a,ctrla ;用来把光标移到最前了现在
Hotkey, LCtrl & a,ctrla ; use LCtrl & a to send ^a before ;not sure if vimperator makes c-a unable to use so write this line  ;cause ctrl+shift+a unable to work to manage addons
Hotkey, IfWinActive
;-------------------------------------------------------------------------------------
/*
#IfWinNotActive, ahk_exe firefox.exe ;this fix below problem !
!i::send {PgUp}  ;this is making the walkinput js plugin unable to work in vimperator since the key combination performs PgUp instead.
#IfWinNotActive 
*/

;=====================================================================o
;                   Feng Ruohang's AHK Script                         | 
;                      CapsLock Enhancement                           |
;---------------------------------------------------------------------o
;Description:                                                         |
;    This Script is wrote by Feng Ruohang via AutoHotKey Script. It   |
; Provieds an enhancement towards the "Useless Key" CapsLock, and     |
; turns CapsLock into an useful function Key just like Ctrl and Alt   |
; by combining CapsLock with almost all other keys in the keyboard.   |
;                                                                     |
;Summary:                                                             |
;o----------------------o---------------------------------------------o
;|CapsLock;             | {ESC}  Especially Convient for vim user     |
;|CaspLock + `          | {CapsLock}CapsLock Switcher as a Substituent|
;|CapsLock + hjklwb     | Vim-Style Cursor Mover                      |
;|CaspLock + uiop       | Convient Home/End PageUp/PageDn             |
;|CaspLock + nm,.       | Convient Delete Controller                  |
;|CapsLock + zxcvay     | Windows-Style Editor                        |
;|CapsLock + Direction  | Mouse Move                                  |
;|CapsLock + Enter      | Mouse Click                                 |
;|CaspLock + {F1}!{F7}  | Media Volume Controller                     |
;|CapsLock + qs         | Windows & Tags Control                      |
;|CapsLock + ;'[]       | Convient Key Mapping                        |
;|CaspLock + dfert      | Frequently Used Programs (Self Defined)     |
;|CaspLock + 123456     | Dev-Hotkey for Visual Studio (Self Defined) |
;|CapsLock + 67890-=    | Shifter as Shift                            |
;-----------------------o---------------------------------------------o
;|Use it whatever and wherever you like. Hope it help                 |
;=====================================================================o
;=====================================================================o
;                         CapsLock Escaper:                          ;|
;----------------------------------o----------------------------------o
;                        CapsLock  |  {ESC}                          ;|
;----------------------------------o----------------------------------o
;CapsLock::Send, {ESC}                                                ;|
;---------------------------------------------------------------------o
                                                      ;|
;=====================================================================o
;                       CapsLock Media Controller                    ;|
;-----------------------------------o---------------------------------o
;                    CapsLock + F1  |  Volume_Mute                   ;|
;                    CapsLock + F2  |  Volume_Down                   ;|
;                    CapsLock + F3  |  Volume_Up                     ;|
;                    CapsLock + F3  |  Media_Play_Pause              ;|
;                    CapsLock + F5  |  Media_Prev                    ;|
;                    CapsLock + F6  |  Media_Next                    ;|
;                    CapsLock + F7  |  Media_Stop                    ;|
;-------------------------------------------------------------------------------------
/*
; in firefox it gets a loop:^p
; ctrl u/i/o/p by default has meanings in firefox, why ? vimperator ?
*/
;------------------------------------------------------------------------------
/*
this is great than use "^i" which would cause a loop here in firefox!
*/
;;=============================SpecialSimualte============================||
/*
nav inside firefox by set common link click 
*/
;;=============================Navigator============================||




;=====================================================================o
;                       CapsLock Initializer                         ;|
;---------------------------------------------------------------------o
SetCapsLockState, AlwaysOff                                          ;|
;---------------------------------------------------------------------o
;=====================================================================o
;                       CapsLock Switcher:                           ;|
;---------------------------------o-----------------------------------o
;                    CapsLock + ` | {CapsLock}                       ;|
;---------------------------------o-----------------------------------o
/*
CapsLock & `::                                                       ;|
GetKeyState, CapsLockState, CapsLock, T                              ;|
if CapsLockState = D                                                 ;|
    SetCapsLockState, AlwaysOff                                      ;|
else                                                                 ;|
    SetCapsLockState, AlwaysOn                                       ;|
KeyWait, ``                                                          ;|
return       
*/
;;=============================SpecialSimualte============================||                      
;CapsLock & z::send ^z                                                       ;|
CapsLock & z::                                                       ;|
if GetKeyState("alt") = 0                                            ;|
{                                                                    ;|
    Send, ^w                                                         ;|
}                                                                    ;|
else {                                                               ;|
    Send, !{F4}                                                      ;|
    return                                                           ;|
}                                                                    ;|
return    
;-------------------------------------------------------------------------------------
^#c::
send ^c
run,%ComSpec% /k cd /d %clipboard%
return
;------------------------------------------------------------------------------------- 
;#### start of explorer
#If WinActive("ahk_exe explorer.exe") or WinActive("ahk_class CabinetWClass")  ; there could be "," after IfWinActive, earse it for easier searching
;not sure why fails, it seems ctrl not used . found it because of the "SendMode Input "!
WheelDown::Down
WheelUp::Up
CapsLock & WheelDown:: send {Enter}
CapsLock & WheelUp::send !{Up}
LAlt & WheelDown::send {Enter}
LAlt & WheelUp::send !{Up}
LCtrl & WheelDown::send {Enter}
LCtrl & WheelUp::send !{Up}
LWin & WheelDown::send {Enter}
LWin & WheelUp::send !{Up}
!k::!up
!j::send {Enter}
~^+c::FileManage(Explorer_GetSelected())
~^!c::FileManage(Explorer_GetPath())
;works also in everything, fail if the file's edit is not enabled or linked to other applications
F1:: ;open file in clover with notepad
IfWinActive,ahk_exe explorer.exe
{
	path := Explorer_GetPath()
	all := Explorer_GetAll()
	sel := Explorer_GetSelected()
	
	;send +{F10}
	;send n
	;send {Enter}
	;change it to make lnk file readable in win8.1
	;MsgBox % sel ; some times windows fail to get the file name because of explorer . needs restart
	openfile(sel) 
}
return
/*
#IfWinActive ;end of explorer
;可惜不支持"|"语法 但是可以用Group 或 if expression. set title match mode 
*/
#If
;#### end of explorer
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;#### start of general commands which needs further changes

/*
want to commented on 20160301 the end should be checked again
*/ 

;the only problem that i need win+r is to pass args to bat scripts like "netfind 8090", which fails in AHK 
;#q::send #r ; comment on 20160309 0:15 as I am trying Wox. COMMENT on 2016-05-07 5:28:47 since RunZ used
;CapsLock & F8::arrayaction("G:\SRAll\ToAttach\GoodLearn\BashGood\GreatAHK\TestArrayAHK.txt","open")
;-------------------------------------------------------------------------------------
;#h::actwinbest("SnippingTool.exe") ;snap the screen; comment this since #h function from hh helps build a hotstring quickly
;this is a great function and now it forces the use of # key better than other functions I have tried!
; maybe work if use "$#s" instead !
;-------------------------------------------------------------------------------------
;#s:: ;disabled since LWin & s used to scorll
!s::SearchSelectViaEverything()
;-------------------------------------------------------------------------------------
#c::IfWinActAll("ConEmu64.exe","E:\EasyOSLink\PCMasterMove\Downloads\Compressed\cmder_mini\vendor\conemu-maximus5\ConEmu64.exe")
;#c::StringActivate("Cmder.exe","cmder")
;#c::actwinbest("cmd.exe") ;wrong as %windir% is not used as ENV
;-------------------------------------------------------------------------------------

;CapsLock & F9::FileToInputBox("F:\Program Files\AutoHotkey\Scripts\Good\ms.txt","mstsc") ;function FileToInputBox is commented
;commented on 2016-06-14 5:02 pm since they are in the global menu 常用文档
;#F10::CheckFile("G:\SRAll\Experience\GoodEmail\PadAllBeforeNS.txt")
;#F11::CheckFile("G:\SRAll\ToAttach\GoodLearn\BashGood\1122GoodDayLearn.xml")
;-------------------------------------------------------------------------------------

CapsLock & F10::openfile("G:\SRAll\Experience\GoodEmail\PadAllBeforeNS.txt")
CapsLock & F11::openfile("G:\SRAll\ToAttach\GoodLearn\BashGood\1122GoodDayLearn.xml")
;-------------------------------------------------------------------------------------
LWin & Numpad8::CheckFile("E:\tibco513\designer\5.10\bin\designer.tra")
LWin & Numpad7::
CheckFile("F:\tibco\tibcojre64\1.7.0\lib\security\java.security")
send jdk.tls.disabledAlgorithms=
return

LWin & Numpad6::
CheckFile("E:\tibco513\tibcojre64\1.8.0\lib\security\java.security")
send jdk.tls.disabledAlgorithms=
return

;#k::AnySearch()
;search() function needs better solution as in firefox the slected content is copied but then un highlighted, so use UseClipBoardRun function
;-------------------------------------------------------------------------------------
MButton::send ^v ;use this in cmd fails 
; commented since DragKing used MButton and cause double paste
/*
MButton::
send %Clipboard%
return
*/
;-------------------------------------------------------------------------------------
::rg::
reload
return
::sa::
suspend
return
::sg::
suspend
return
;-------------------------------------------------------------------------------------
!`::
;run "F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\habitA.lnk"; why fails ? needs win+r ? learn from runz
run,F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\RunZ.ahk
;Run,F:\Program Files\AutoHotkey\AutoHotkeyA32.exe "F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\!Habit1542_32bit.ahk" ;works now
;CoordMode,Mouse ; the third parm is Screen and it is the default . This sets the mouse at an absolute position to the screen 
;MouseClick,Left,960,480
reload ;if this line is before above two lines to run new ahk files. those ahk files are not run
return

;-------------------------------------------------------------------------------------

;found textselect ahk only copy when you select with drag but fails if you double click a word

;seer.lnk is run by RunZ but not by this file. why

!F3::
run,"F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scriptsNeedsUpdate\allchm.ahk"
;run,"F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scriptsNeedsUpdate\chms.ahk"
return

!F1:: ;next type method
gosub NextIME
return
;-------------------------------------------------------------------------------------
/*
CapsLock & x::send ^x
*/ 
;------------------------------------------------------------------------------------- 

;-------------------------------------------------------------------------------------
#n::ClickNoInNotepad() ;it is working !
;!n::ClickNoParms("Button2","notepad++.exe") ;it is working after giving the right program name !
!n::ClickNoParms("否","notepad++.exe") ;it is working after giving the right program name !  ControlClick, 否,WinTitle ; also  works
!z::ClickNoParmsA("否") ;it is working after giving the right program name !
!y::ClickNoParmsA("是") ;it is working after giving the right program name !
;-------------------------------------------------------------------------------------

!+z::ClickNoParmsA("TUiButton.UnicodeClass1")
;TUiButton.UnicodeClass1  不保存(&N)

;-------------------------------------------------------------------------------------
;#### end of general commands which need further changes
;-------------------------------------------------------------------------------------
;#### start of srun inside hotstring
;#srun simulate slickrun #head of ahk
;#IfWinActive ,Give an Command, ahk_class #32770 ; wy fails ? want to use it since mm used for f12 in firefox for gmail. fails as , is used 
#If WinActive("Give an Command ahk_exe AutoHotkey.exe") or WinActive("RunZ ahk_exe AutoHotkey.exe") or WinActive("ahk_exe Listary.exe") or WinActive("ahk_exe Wox.exe")  ;this is a good way to expand RunZ ability to use functions not defined in its ahk . as good as include command !
;-------------------------------------------------------------------------------------
::aa::
openfile(A_ScriptDir "\gmailSimple.ahk")
return

::a1::
openfile("..\..\AHK管理器.ahk")
;openfile("F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\AHK Script Manager.ahk")
return

::a2::
openfile("..\HotKeyManagerV1\HotKeyManagerV1.ahk")
return

/*
::sh1::
StringActivateName("AHK管理器","..\..\AHK管理器.ahk")
return

::sh2::
StringActivateName("HotKeyManagerV1.ahk","..\HotKeyManagerV1\HotKeyManagerV1.ahk")
return
*/

::git::
StringActivate("GitHub.exe","GitHub.lnk")
return

::ha::
::shha::
;StringActivateName("Habit-1625","F:\Program Files\AutoHotkey\AutoHotkeyA32.exe %A_ScriptDir%\..\..\AHKManager\UserDefine\moreFunc\Habit1625\Habit-1621-LiuMeng.ahk")  ;strang path
StringActivateName("Habit-1625","F:\Program Files\AutoHotkey\AutoHotkeyA32.exe ..\..\..\QQDown\1625\Habit.ahk") ;only able to run but not to show gui
return
::aha::
::a3::
::ahh::
;openfile(A_ScriptDir "\..\AHKManager\UserDefine\moreFunc\Habit1625\Habit-1621-LiuMeng.ahk") 
openfile("F:\Program Files\AutoHotkey\Scripts\QQDown\1625\Habit.ahk")
return
::alc::
::a4::
openfile("F:\Program Files\AutoHotkey\Scripts\QQDown\LabelControl_vZz_键盘党利器\LabelControl_vZz.ahk")
return
;-------------------------------------------------------------------------------------

::ofile::
arrayaction("G:\SRAll\ToAttach\GoodLearn\BashGood\GreatAHK\TestArrayAHK.txt","open")
return 

::qtalk::
StringActivateName("群通话","")
return

::con::
IfWinExist,Console
WinActivate
return
::afuck::
openfile("F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\FuckAHK.xml")
return
::fsb::
run,"F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scriptsNeedsUpdate\allchm.ahk"
return

::fsa::
Run,"F:\Program Files\AutoHotkey\Scripts\Good\LearnHH_ListView.ahk"
return
::fsv::
openfile("F:\Program Files\AutoHotkey\Scripts\Good\LearnHH_ListView.ahk")
return
::fsl::
openfile("F:\Program Files\AutoHotkey\Scripts\Good\ListViewFolder\folderLink.xml")
return
::fsf::
openfile("F:\Program Files\AutoHotkey\Scripts\Good\ListViewFolder\folderLinkFiles.xml")
return

::rfl::
openfile("F:\Program Files\AutoHotkey\Scripts\Good\ListViewFolder\RecentLink.xml")
return

::aqf::
openfile("E:\Sort1113OldNote\UseOldDell\reusesoft\sim_linux\cygwin\tmp\testpaste\goodpasten_testThreeLine,.txt")
return 
::xx::
openfile("E:\Sort1113OldNote\UseOldDell\reusesoft\sim_linux\cygwin\tmp\testpaste\goodpasten_testThreeLine,.txt")
return 

::at2::
openfile("F:\Program Files\AutoHotkey\Scripts\Test\StringGetPos.ahk")
return

::afm::
openfile("F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\UserDefine\menu\WinFastMenu.ahk")
return
::fsahk::
openfile("F:\Program Files\AutoHotkey\Scripts\Good\ListViewFolder\AllAhkLearn.xml")
return

;-------------------------------------------------------------------------------------
::ms::
ms()
return


::test:: ;test use of = and :=
a=1
b:=a
c=a
MsgBox a
MsgBox % a
MsgBox % b  ;1
MsgBox % c 
MsgBox % a " " b " " c ;1 1 a
MsgBox % a "" b "" c ;11a .concat strings!
MsgBox % a + b + c ;null because "2+a" is null for number count
MsgBox %a% + %b% + %c% ;null because "2+a" is null for number count . string : 1+1+a
MsgBox % a + b ; 2
MsgBox % a . b . c ;11a
MsgBox % a . "://" . b . c ;1://1a
MsgBox % "http::" . a . "://" . b . c ;1://1a ;right
tt= % "http::" . a . "://" . b . c ;1://1a ;right
MsgBox %tt%
MsgBox "http::" . %a% . "://" . %b% . %c% ;wrong
return
/*
tmp=% "http://" . ColorArray[2] . ":" . ColorArray[3] ;try to use pass in args 
MsgBox,%tmp%
*/

::tel::
Run,cmd /k telnet 192.168.69.124 9694
send ^]
send {Enter}
send ^v
return


::e::
::en:: 
gosub en
 return
 
::c::
::cn:: 
gosub cn
 return
 

::ime::
Run,F:\Program Files\AutoHotkey\AutoHotkeyA32.exe "F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\!Habit1542_32bit.ahk"
;Run,F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\根据程序配置输入法.ahk
return 

;-------------------------------------------------------------------------------------
::tip::
#Persistent
ToolTip, Timed ToolTip`nThis will be displayed for 2 seconds.
SetTimer, RemoveToolTip2, 2000
return
RemoveToolTip2:
SetTimer, RemoveToolTip2, Off
ToolTip
return

::shcon::
#Persistent
; This working example will continuously update and display the
; name and position of the control currently under the mouse cursor:
Loop
{
    Sleep, 100
    MouseGetPos, , , WhichWindow, WhichControl
    ControlGetPos, x, y, w, h, %WhichControl%, ahk_id %WhichWindow%
    ToolTip, %WhichControl%`nX%X%`tY%Y%`nW%W%`t%H%
}
return

;http://fanyi.youdao.com/openapi?path=data-mode
::dao::
run,http://fanyi.youdao.com/
return
;-------------------------------------------------------------------------------------
::frboy::
gosub frboy
return
;-------------------------------------------------------------------------------------
;both space and enter works for hotstring. but only enter works for threeline file sincer enter acts as end of inputbox
;space::Enter ; how can I take care of both "ww" hotstring and commands in the threeline file ?
;Space::sendinput {Enter} ;strang!both space and enter works by default for "ww". but now space works like enter but it makes "ww" looks like a command hence fails
^Space::send {Enter}
!Space::send {Enter} ;this helps to use threeline file better 
;-------------------------------------------------------------------------------------
::allarray::
Run,"F:\Program Files\AutoHotkey\Scripts\Good\20160105ArrayAllOK\AllBestArray.ahk"
return

#IfWinActive ;#end of ahk
;#### end of srun inside hotstring
;-------------------------------------------------------------------------------------
;below needs check every time you want other key bindings
/*
try t make more functions F1-F12
not working only in notepad,bash2,bash.exe from everything,nor everything. work if in firefox,cmd,clover,命令提示符,win+R bash 和Alt+Q bash 不一样,bash.exe from everything 也不一样。 
;same like above  also give a system shortcut as Alt+Shift+A
*/ 
CapsLock & F1::arrayaction("G:\SRAll\ToAttach\GoodLearn\BashGood\GreatAHK\ActAppArrayAHK.txt","win")
;CapsLock & F2::OpenFireLink("1")
CapsLock & F3::GoIndex_WinExist("ArrayFunctions\2_IndexFilePath.txt","ArrayFunctions\2_FilePath.txt")
CapsLock & F4::GoIndex_WinExist("ArrayFunctions\3_Index_msact.txt","ArrayFunctions\3_ms_name_run.txt")
CapsLock & F5::openfilebest("search file")
CapsLock & F6::ms()
CapsLock & F7::GoIndex_WinExist("ArrayFunctions\1_Index_AppName.txt","ArrayFunctions\1_AppPath.txt")
;------------------------------------------------------------------------------------- 
#include ..\AHKManager\Core\Common.ahk
#include ..\AHKManager\Lib\JSON.ahk  ;if disabled, ci function fails to parse json although dict2 label is in common ahk. you would not want to include json ahk in that common ahk. but should find a ahk that would not need include any ahk 
;-------------------------------------------------------------------------------------
::killahk::
gosub ahkkill
return

::kall::
::kal::
gosub ahkkill
Return

::ahkkill::
gosub ahkkill
return

;-------------------------------------------------------------------------------------
;use #q for RunZ now
!2::
!r:: 
;this would not help because it would hang there and not executing again if the input box is there . you may try loop to listen on key press or learn from RunZ
ThreeLineBest("Give an Command")
return
;-------------------------------------------------------------------------------------
/*
labelControl conflicts with hh,exe. also closed zz , crash ll
*/
;-------------------------------------------------------------------------------------

::/en:: 
gosub en
 return

::/cn:: 
gosub cn
 return
 ;-------------------------------------------------------------------------------------
/*
#IfWinActive,File Switcher
CapsLock & WheelDown:: send {Enter}
CapsLock & WheelUp::send !{Up}
LAlt & WheelDown::send {Enter}
LAlt & WheelUp::send !{Up}
LCtrl & WheelDown::send {Enter}
LCtrl & WheelUp::send !{Up}
LWin & WheelDown::send {Enter}
LWin & WheelUp::send !{Up}
#IfWinActive
*/
;-------------------------------------------------------------------------------------
;needs further work
CapsLock & 2::MouseMoveClick(621,64) ; LastPass
CapsLock & 4::MouseClick(659, 57) ;Google Keep
CapsLock & 1::MouseMoveClick(526, 54) ;Pocket
CapsLock & 5::MouseMoveClick(976, 99) ;Login Automatically
;functions not in this file
;-------------------------------------------------------------------------------------
uStr(str)
{
    charList:=StrSplit(str)
	SetFormat, integer, hex
    for key,val in charList
    out.="{U+ " . ord(val) . "}"
	return out
}

::belowesc::
::fuc::
BelowEsc:
Sendinput  % uStr("``")
return

::simo::
simo:
Sendinput  % uStr(";")
return

::SQuote::
SQuote:
Sendinput  % uStr("'")
return
;-------------------------------------------------------------------------------------
::/cu::
Sendinput  % uStr("^")
return
::/alt::
Sendinput  % uStr("!")
return
::ustrred::
Sendinput  % uStr("[红色]#,##0.00;-#,##0.00;-;@")
return
;-------------------------------------------------------------------------------------
Esc::CapsLock

^CapsLock::  ; control + capslock to toggle capslock.  alwaysoff/on so that the key does not blink
	GetKeyState t, CapsLock, T
	IfEqual t,D, SetCapslockState AlwaysOff
	Else SetCapslockState AlwaysOn
Return

CapsLock::
Send, {Esc}
SetCapsLockState AlwaysOff
return

;CapsLock::Send {ESC} ; if , used after send there comes problem in qq. If use this, firefox fails to delete all input by CapsLock & b
;this makes caps b fail in firefox


LAlt & Capslock::SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"

Shift & CapsLock::SendInput, {Shift Down}{Blind}{Esc}{Shift Up}