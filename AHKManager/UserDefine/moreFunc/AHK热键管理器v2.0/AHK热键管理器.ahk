#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
Process, Priority,, High
DetectHiddenWindows,On
;SendMode Input



Menu, Tray, NoStandard                  ;删除自带托盘菜单
Menu, tray, add, 查看,ShowGui   ;  显示gui
Menu, tray, add  ; 创建分隔线.
Menu, tray, Add,关于,About							;关于
Menu, tray, Add,帮助,帮助							;帮助
Menu, tray, add  ; 创建分隔线.
Menu, tray, Add,重启,reload							;重启
Menu, tray, Add, 退出, ExitSub                  ; 创建     退出
Menu, Tray, Default, 查看  ;;默认   查看
Menu, Tray, Icon, Shell32.dll, 254


if FileExist("_sy.ahk")
run,_sy.ahk,%A_ScriptDir%,,ahkpid				;启动后台脚本
else
	MsgBox,没有后台_sy.ahk脚本,你现在需要新建

_sylvh=
说明=
(
--------------------------sixtyone------------------------------------------
AHK热键管理器说明(名字暂时就这,没想好)：			  
支持2种信息模式:

①:
;[窗口|热键|说明]
脚本区


②:
#IfWinactive,ahk_exe 软件.exe  或#IfWinactive,窗口名
热键::		;可以这样备注说明
脚本区

注:由于第二种比较局限,所以建议用第一种。

举例:
①内容如下时: 管理器中[窗口、热键、说明]为[记事本、F4、弹出你好]
;[记事本|F4|弹出你好]
#ifwinactive,ahk_exe notepad.exe
F4::
msgbox,你好
return

②内容如下时: 管理器中[窗口、热键、说明]为[notepad.exe、F5、显示你好]
#ifwinactive,ahk_exe notepad.exe				
F5::	;显示你好
msgbox,你好
return
---------------------------sixtyone----------------------------------------
)

Gui,1:Destroy
gui 1:new 
gui,1:font, s10, 微软雅黑
Gui,1:Add,GroupBox,x10 y10 w516 h630, 信息 S
Gui,1:Add,GroupBox,x598 y10 w516 h630, 脚本 L
Gui 1:Add, ListView,x18 y30 w500 h600 NoSortHdr AltSubmit Grid  -Multi  vList g_syselect, <窗口>|<热键>|<说明>
Gui,1:Add,Edit,x606 y30 w500 h600 -Wrap WantTab  +0x00100000 v_syedit,%说明%		;关闭自动换行属性  Tab输入制表符而不是切换控件 滚动条 
Gui 1:Add,Button,x529 y30,增加脚本
;Gui 1:Add,Button, x529 y100,已设置自更新
Gui 1:Add,Button, x529 y100,删除条目
Gui 1:Add,Button,x529 y169,向上排序
Gui 1:Add,Button,x529 y238,向下排序
Gui 1:Add,Button,x529 y307,取消配置
Gui 1:Add,Button,x529 y376,保存配置
Gui 1:Add,Button,x529 y445,启动后台
Gui 1:Add,Button,x529 y524,退出后台
Gui 1:Add,Button,x529 y603,退出脚本
Gui 1:-MinimizeBox
Gui 1:Default


LV_ModifyCol(1, "left 100")
LV_ModifyCol(2, "left 100")
LV_ModifyCol(3, "left 295")

IniRead,_once,_sy.ini		;循环获取 <窗口、热键、备注、动作>
loop,Parse,_once,`n,`r`t			
{
	if !A_LoopField
		continue
	_nn++
	_sy :=A_LoopField
	IniRead,%_sy%1,_sy.ini,%A_LoopField%,窗口
	IniRead,%_sy%2,_sy.ini,%A_LoopField%,热键
    IniRead,%_sy%3,_sy.ini,%A_LoopField%,备注
	IniRead,%_sy%4,_sy.ini,%A_LoopField%,动作
	
    ;_sy%A_Index%_1 :=RegExReplace(_sy%A_Index%_1,"i)^\s*#ifwinactive,?")				;获取  #ifwinactive后面的  窗口

	_sy%A_Index%_4 :=RegExReplace(_sy%A_Index%_4,"\*\*`t\*\*","`n")				;把动作中的 **	** 替换成 换行符
}

loop,%_nn%		;增加 <窗口、热键、备注、动作> 到Gui中
{
	_listviewV :=_sy%A_Index%_1 . _sy%A_Index%_2
if !trim(_listviewV)
	continue
LV_Add("",_sy%A_Index%_1,_sy%A_Index%_2,_sy%A_Index%_3)
}

showgui:
Gui,1:Show
return

_syselect:		;gui Edit中显示对应的代码
if A_GuiControl = List  
{	
	if _syzdpl				;增、删、排序为真，增跳过   检查是否发生变化  到刷新显示
	{
		_syzdpl=
		goto,刷新显示
	}
	if A_GuiEvent =C					;添加事件为单击 才执行
	{
	if _sylvh 			;&& !_syaddmode && !_sydelmode && !_sypxmode			;edit要失去焦点时,检查脚本是否变化	     -添、减脚本、排序模式:_syaddmode=1 _sydelmode=1 _sypxmode =1取消 检查变化  > 已取消
{
	Gui,Submit,NoHide
	if _sy%_sylvh%_4 <> %_syedit%
	{
	;msgbox,4,脚本已发生变化,脚本已修改是否保存				;已设置自动更新
	;IfMsgBox Yes
	gosub,Button更新脚本
	}
}	
_syRN = 0
Loop,% LV_GetCount()
{
_syRN := LV_GetNext(_syRN)
if !_syRN
{
_sylvh=
GuiControl,,_syedit,%说明%
Return
}
break
}
if _syRN=0					;   这里不知为什么  上面设置了 if !(RowNumber) return   在某种情况下还是会运行下来,所以加入此行  后面几处同。
	GuiControl,,_syedit,%说明%
else
GuiControl,,_syedit,% _sy%_syRN%_4
_sylvh :=_syRN
return
}
}
return

/*			;;这是建立右键  弹出  菜单:删除
GuiContextMenu:  ; 运行此标签来响应右键点击或按下 Appskey.
if A_GuiControl = List  ; 这个检查是可选的. 让它只为 ListView 中的点击显示菜单.
{
RowNumber = 0
Loop,% LV_GetCount()
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
Return
break
}
if RowNumber=0
	return
Menu,PopC,Add,删除行,删除
menu,PopC,Show
return
}
return
*/

删除:
RowNumber = 0
_syll :=LV_GetCount()
Loop,% LV_GetCount()
{
RowNumber := LV_GetNext(RowNumber)
if !RowNumber 
	return
break
}
if RowNumber=0							;   这里不知为什么  上面设置了 if !(RowNumber) return   在某种情况下还是会运行下来,所以加入此行  后面几处同。
	return
删除2:
LV_Delete(RowNumber)
_syzdpl=1						;增、删、排序模式开启
if RowNumber<>%_syll%
LV_Modify(RowNumber,"Select")
else
{
dddd :=% _syll - 1
LV_Modify(dddd,"Select")	
}
_synn :=RowNumber
loop,% LV_GetCount() - RowNumber + 1				;代码的变量 序号  从新排列
{
	RowNumber++
	_sy%_synn%_4 :=_sy%RowNumber%_4 
	_synn++
}
_synn=
RowNumber=
return

Button增加脚本:
Gui,Submit,NoHide
_sylvnu :=LV_GetCount() + 1
loop,Parse,_syedit,`n,`r`t			;添加 脚本内容到 listview   注:未保存到文件
{
	if !A_LoopField
		continue
	if (RegExMatch(A_LoopField,";+\[(.*?)\|(.+?)(\|(.*?))?\]",$))
	{
	_sy%_sylvnu%_1 :=$1
	_sy%_sylvnu%_2 :=$2
	_sy%_sylvnu%_3 :=$4
	_sy%_sylvnu%_4 :=_syedit
	break
}
else
{
if (RegExMatch(A_LoopField,"i)^\s*#ifwinactive,?(\s*ahk_exe\s+)?([^;]*)",$))
	_sy%_sylvnu%_1 :=$2
if (RegExMatch(A_LoopField,"i)^\s*(.+?)::(\s+;+(.+))?",$))
{
	_sy%_sylvnu%_2 :=$1
	_sy%_sylvnu%_3 :=$3
	_sy%_sylvnu%_4 :=_syedit
	break
}
}
}
if !_sy%_sylvnu%_2
	return
_syzdpl=1						;增、删、排序模式开启
LV_Add("select",_sy%_sylvnu%_1,_sy%_sylvnu%_2,_sy%_sylvnu%_3)
return

Button更新脚本:
_syold_1 :=_sy%_sylvh%_1			;先将原始数据保存,若下面更新选择no,将恢复
_syold_2 :=_sy%_sylvh%_2
_syold_3 :=_sy%_sylvh%_3
_syold_4 :=_sy%_sylvh%_4

Gui,Submit,NoHide
if !_sylvh
return
_sy%_sylvh%_1 =
_sy%_sylvh%_2 =
_sy%_sylvh%_3 =
_sy%_sylvh%_4 =
loop,Parse,_syedit,`n,`r`t			;更新 脚本内容到 listview   注:未保存到文件
{
	if !A_LoopField
		continue
	if (RegExMatch(A_LoopField,";+\[(.*?)\|(.+?)(\|(.*?))?\]",$))
	{
	_sy%_sylvh%_1 :=$1
	_sy%_sylvh%_2 :=$2
	_sy%_sylvh%_3 :=$4
	_sy%_sylvh%_4 :=_syedit
	break
}
else
{
if (RegExMatch(A_LoopField,"i)^\s*#ifwinactive,?(\s*ahk_exe\s+)?([^;]*)",$))
	_sy%_sylvh%_1 :=$2
if (RegExMatch(A_LoopField,"i)^\s*(.+?)::(\s+;+(.+))?",$))
{
	_sy%_sylvh%_2 :=$1
	_sy%_sylvh%_3 :=$3
	_sy%_sylvh%_4 :=_syedit
	break
}
}
}
if !_sy%_sylvh%_2
{
	MsgBox,260,警告!,热键为空,将删除该条目?
	IfMsgBox No
	{
		_sy%_sylvh%_1 :=_syold_1
        _sy%_sylvh%_2 :=_syold_2
		_sy%_sylvh%_3 :=_syold_3
		_sy%_sylvh%_4 :=_syold_4			;其他恢复,但是脚本行  保持现在编辑
		LV_Modify(_sylvh,"Select")
		return
	}
	RowNumber :=_sylvh
	_syll :=LV_GetCount()
	goto,删除2
}
LV_Modify(_sylvh,"",_sy%_sylvh%_1,_sy%_sylvh%_2,_sy%_sylvh%_3)
return

Button删除条目:
goto,删除
return

Button向上排序:
Gui,Submit,NoHide
RowNumber = 0
Loop,% LV_GetCount()
{
RowNumber := LV_GetNext(RowNumber)
if !RowNumber
Return
break
}
if RowNumber=0
	return
if RowNumber=1
	return
_bbb :=RowNumber - 1
loop,4
{
_ccc :=_sy%RowNumber%_%A_Index%
_sy%RowNumber%_%A_Index% :=_sy%_bbb%_%A_Index%
_sy%_bbb%_%A_Index% :=_ccc
}
_syzdpl=1						;增、删、排序模式开启
LV_Modify(RowNumber,"",_sy%RowNumber%_1,_sy%RowNumber%_2,_sy%RowNumber%_3)
LV_Modify(_bbb,"Select",_sy%_bbb%_1,_sy%_bbb%_2,_sy%_bbb%_3)
return

Button向下排序:
Gui,Submit,NoHide
RowNumber = 0
Loop,% LV_GetCount()
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
Return
break
}
if RowNumber=% LV_GetCount()
	return
_bbb :=RowNumber + 1
loop,4
{
_ccc :=_sy%RowNumber%_%A_Index%
_sy%RowNumber%_%A_Index% :=_sy%_bbb%_%A_Index%
_sy%_bbb%_%A_Index% :=_ccc
}
_syzdpl=1						;增、删、排序模式开启
LV_Modify(RowNumber,"",_sy%RowNumber%_1,_sy%RowNumber%_2,_sy%RowNumber%_3)
LV_Modify(_bbb,"Select",_sy%_bbb%_1,_sy%_bbb%_2,_sy%_bbb%_3)
return

Button取消配置:
gui,Destroy
goto, Reload
return

Button保存配置:
gosub,Button更新脚本
Gui,Submit,NoHide
if ahkpid			;如果后台_sy.ahk已启动,则先结束
{
WinClose, ahk_pid %ahkpid%				;结束 _sy.ahk后台脚本
IfWinExist,ahk_pid %ahkpid%
 Process,Close,%ahkpid%
 ahkpid=
}
FileDelete,_sy.ahk
FileDelete,_sy.ini

FileAppend,					;写入_sy.ahk脚本前部内容
(
#SingleInstance Force
#NoEnv
#NoTrayIcon
SetWorkingDir `%A_ScriptDir`%


),_sy.ahk	

run,_sy.ahk,%A_ScriptDir%,,ahkpid

 loop,% LV_GetCount()				
{
	FileAppend,% "`n"  _sy%A_Index%_4 ,_sy.ahk						;写入脚本到_sy.ahk文件中
	
	LV_GetText(_sy%A_Index%_1,A_Index,1)
	LV_GetText(_sy%A_Index%_2,A_Index,2)
	LV_GetText(_sy%A_Index%_3,A_Index,3)
	
	_syj1 :=_sy%A_Index%_1
	_syj2 :=_sy%A_Index%_2
	_syj3 :=_sy%A_Index%_3	
	_syj4 :=RegExReplace(_sy%A_Index%_4,"`n+","**`t**")	;替换 脚本中的 换行符号 为  **	**
	
	FileAppend,										;写入到 ini  配置文件
(
	
[_sy%A_Index%_]
窗口=%_syj1%
热键=%_syj2% 
备注=%_syj3% 
动作=%_syj4% 

),_sy.ini
}
return

刷新显示:
_syRN = 0
Loop,% LV_GetCount()
{
_syRN := LV_GetNext(_syRN)
if !_syRN
{
_sylvh=
GuiControl,,_syedit,%说明%
Return
}
break
}
if _syRN=0					;   这里不知为什么  上面设置了 if !(RowNumber) return   在某种情况下还是会运行下来,所以加入此行  后面几处同。
	GuiControl,,_syedit,%说明%
else
GuiControl,,_syedit,% _sy%_syRN%_4
_sylvh :=_syRN
return

ExitSub:
WinClose, ahk_pid %ahkpid%				;结束 _sy.ahk后台脚本
IfWinExist,ahk_pid %ahkpid%
 Process,Close,%ahkpid%
 ExitApp
return
 
 Reload:
 WinClose, ahk_pid %ahkpid%				;结束 _sy.ahk后台脚本
IfWinExist,ahk_pid %ahkpid%
 Process,Close,%ahkpid%
Reload
return

Button退出脚本:
goto,ExitSub
return

Button启动后台:
if ahkpid
{
	MsgBox,后台已经存在
	return
}
else
{
	if FileExist("_sy.ahk")
	{
   run,_sy.ahk,%A_ScriptDir%,,ahkpid
   return
}
else
{
	msgbox,没有后台_sy.ahk脚本,你现在需要新建
   return
}
}
return

Button退出后台:
if ahkpid
{
WinClose, ahk_pid %ahkpid%				;结束 _sy.ahk后台脚本
IfWinExist,ahk_pid %ahkpid%
 Process,Close,%ahkpid%
 ahkpid=
}
return

About:
About1=
(
名字:AHK热键管理器(暂时就这吧,没想好)
版本:2016.5.15
作者:sixtyone
Q Q:3300372390
)
msgbox,%About1%
return

帮助:
帮助1=
(
添加脚本:
把脚本内容添加到信息栏中  
注意:如果无"热键"将会添加失败,未保存配置时不会生效

删除条目:
功能如名

向上排序:
功能如名

向下排序:
功能入名

取消配置:
刚发生的变化,恢复

保存配置:
刚发生的变化,保存

启动后台:
启动后台的_sy.ahk脚本  
注意:所以写入的脚本代码  都由它来执行

退出后台:
退出_sy.ahk

退出脚本:
退出_sy.ahk与本ahk
)
msgbox,%帮助1%
return

::svv::
gosub Button保存配置
return