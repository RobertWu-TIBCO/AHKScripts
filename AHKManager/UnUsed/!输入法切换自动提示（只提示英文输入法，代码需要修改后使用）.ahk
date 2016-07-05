/*
如果你们能让光标竖线分中英文状态显示不同颜色就流弊了

其实也是可以的，有修改光标的ahk代码
你只需要制作两个不同颜色的光标，互相切换就行了。关键问题是，谁来做呢

不同系统肯定不通用，注意去那个注册表项目中找自己的对应码
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts
需要修改的行已经在备注上标注了

*/

/*
用法：
在用到shift或者Ctrl Space切换输入法的时候，如果是英文输入法，会提示。中文输入法不会。
对于用shift切换中英文的，又很少在英文输入法下用Shift输入大写的人，有一定帮助，而且不会造成很大困扰。
*/
~LShift Up::

~^Space::
Sleep,300
T:=GetImeLayout(WinExist("A"))
If !InStr(T,"中文")
    ;ToolTip(T,1)
	ToolTip,Timed ToolTip`nThis will be displayed for 2 seconds. %T%
SetTimer, RemoveToolTip, 2000
Return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return
 


GetImeLayout(_hWnd,OutputType:="Name") { ;取指定窗口使用的输入法代号
    SetFormat, Integer, h
    ThreadID:=DllCall("GetWindowThreadProcessId", "UInt", _hWnd, "UInt", 0)
    InputLocaleID:=DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
    SetFormat, integer, d
    If (OutputType="ID")
        Return,%InputLocaleID%
    Layout:=InputLocaleID
    StringUpper,Layout,Layout
    StringReplace,Layout,Layout,0x ;移除0x
    If (Layout=8040804) ;需要自己找对应关系，然后修改
        Layout:="00000804" ;需要自己找对应关系，然后修改
    Else
    If (Layout=4090409) ;需要自己找对应关系，然后修改
        Layout:="00000409" ;需要自己找对应关系，然后修改
    RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%Layout%,Layout Text
    Return,%IMEName%
}

::rm::
reload
return