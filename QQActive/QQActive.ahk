#SingleInstance force  ; force reloading
Menu, Tray, Icon, gahk.ico
/*
为QQ增加热键
这个脚本前提是，你要激活的窗口需要事先打开的（且主面板不能最小化）。
然后用win+f1 探测它们；
然后就自动做如下绑定：
win q 消息盒子
win a 会话列表
win z 激活主面板

只有主窗体绑定热键前是不能最小化
Author:             sunwind <1576157@qq.com>
Blog:               http://blog.csdn.net/liuyukuan
Copyright:          2016 sunwind
Date:               2016年2月19日23:36:07z
AutoHotkey Version: 1.1.23.01
OS:                 WIN_7
*/
#Persistent
DetectHiddenText, On
SetTitleMatchMode,2
;~ 2: 窗口标题的某个位置必须包含WinTitle。.
WinTitle=ahk_class TXGuiFoundation
main:
WinGet, winList,List,%WinTitle%
wins:=[]
Loop,%winList%
{
    this_id=% winList%A_Index%
    WinGetTitle,this_title,ahk_id %this_id%
    wins.Insert({index:A_Index,title:this_title,id:this_id})
}
main_flag:=box_flag:=message_flag:=0
for each,win in wins
{
        if InStr(win.title,"QQ")
        {
            main_flag:=1
            main_id:=win.id
            Hotkey,#F2,bind
        }
        ;else if InStr(win.title,"消息盒子")
        else if InStr(win.title,"消息管理器")
        {
            box_flag:=1
            box_id:=win.id
            Hotkey,#F3,box
        }
        else 
        {
            message_flag:=1
            message_id:=win.id
            Hotkey,#F1,message
        }
}
if (main_flag=1)
{
    ;MsgBox  已经绑定热键#F2为主面板激活热键
;disable Msgbox so each reload would have no interrupts
}
if(main_flag=0)
{
    ;MsgBox 请先运行主窗体后，再用#F4探测窗口，程序会自动绑定热键#F2为主面板激活热键。
}
if(box_flag=1)
{
;    MsgBox  已经绑定热键#F3为消息盒子激活热键
}
if(box_flag=0)
{
    ;MsgBox 请先运行消息盒子后，再用#F4探测窗口，程序会自动绑定热键#F3为消息盒子激活热键。
}
if(message_flag=1)
{
    ;MsgBox  已经绑定热键#F1为会话列表窗口激活热键
}
if(message_flag=0)
{
    ;MsgBox 请先运行会话列表窗口后，再用#F4探测窗口，程序会自动绑定热键#F1为行会话列表窗口激活热键。
}

return
;~ #q
box: 
WinActivate,ahk_id %box_id%
return

;~ #a
message:
WinActivate,ahk_id %message_id%
return

;~ #z
bind:
WinActivate,ahk_id %main_id%
return
#f4::gosub main

#f5::
IfWinExist 群通话
WinActivate
return

::rq::
reload
return