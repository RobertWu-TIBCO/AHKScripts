SetTitleMatchMode 2  ; AHK doesn't seem to recognize the window title otherwise
AutoTrim,On
#Hotstring O1 Z1 *0 ?0 ; this makes hotstring not appending extra space anymore ! take care if any hotstring relys on a space 2016-04-29   ;#Hotstring O0 ;default appending a space
FileEncoding, CP936
; http://ahk8.com/archive/index.php/thread-1927.html
UnicodeDecode(text)
{
    while pos := RegExMatch(text, "\\u\w{4}")
    {
        tmp := UrlEncodeEscape(SubStr(text, pos + 2, 4))
        text := RegExReplace(text, "\\u\w{4}", tmp, "", 1)
    }
    return text
}

; http://ahk8.com/archive/index.php/thread-1927.html
UrlEncodeEscape(text)
{
    text := "0x" . text
    VarSetCapacity(LE, 2, "UShort")
    NumPut(text, LE)
    return StrGet(&LE, 2)
}

; https://autohotkey.com/board/topic/113942-solved-get-cpu-usage-in/
CPULoad()
{
    static PIT, PKT, PUT
    if (Pit = "")
    {
        return 0, DllCall("GetSystemTimes", "Int64P", PIT, "Int64P", PKT, "Int64P", PUT)
    }
    DllCall("GetSystemTimes", "Int64P", CIT, "Int64P", CKT, "Int64P", CUT)
    IdleTime := PIT - CIT, KernelTime := PKT - CKT, UserTime := PUT - CUT
    SystemTime := KernelTime + UserTime
    return ((SystemTime - IdleTime) * 100) // SystemTime, PIT := CIT, PKT := CKT, PUT := CUT
}

; https://autohotkey.com/board/topic/113942-solved-get-cpu-usage-in/
GlobalMemoryStatusEx()
{
    static MEMORYSTATUSEX, init := VarSetCapacity(MEMORYSTATUSEX, 64, 0) && NumPut(64, MEMORYSTATUSEX, "UInt")
    if (DllCall("Kernel32.dll\GlobalMemoryStatusEx", "Ptr", &MEMORYSTATUSEX))
    {
        return { 2 : NumGet(MEMORYSTATUSEX,  8, "UInt64")
               , 3 : NumGet(MEMORYSTATUSEX, 16, "UInt64")
               , 4 : NumGet(MEMORYSTATUSEX, 24, "UInt64")
               , 5 : NumGet(MEMORYSTATUSEX, 32, "UInt64") }
    }
}

; https://autohotkey.com/board/topic/113942-solved-get-cpu-usage-in/
GetProcessCount()
{
    proc := ""
    for process in ComObjGet("winmgmts:\\.\root\CIMV2").ExecQuery("SELECT * FROM Win32_Process")
    {
        proc++
    }
    return proc
}

SwitchIME(dwLayout)
{
    HKL := DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus, ctl, A
    SendMessage, 0x50, 0, HKL, %ctl%, A
}

SwitchToEngIME()
{
    SwitchIME(00000409) ; 英语(美国) 美式键盘
	 Warn("English Now")
}

SwitchToCnIME()
{
    SwitchIME(00000804) ; 中文(中国) 简体中文-美式键盘
	 Warn("Chinese Now")
}

; 0：英文 1：中文
GetInputState(WinTitle = "A")
{
    ControlGet, hwnd, HWND, , , %WinTitle%
    if (A_Cursor = "IBeam")
        return 1
    if (WinActive(WinTitle))
    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize := 4 + 4 + (PtrSize * 6) + 16, 0)
        NumPut(cbSize, stGTI, 0, "UInt")   ;   DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint, 0, Uint, &stGTI)
                        ? NumGet(stGTI, 8 + PtrSize, "UInt") : hwnd
    }
    return DllCall("SendMessage"
        , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint, hwnd)
        , UInt, 0x0283  ;Message : WM_IME_CONTROL
        , Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
        , Int, 0)      ;lParam  : 0
}

; 根据字节取子字符串，如果多删了一个字节，补一个空格
SubStrByByte(text, length)
{
    textForCalc := RegExReplace(text, "[^\x00-\xff]", "`t`t")
    textLength := 0
    realRealLength := 0

    Loop, Parse, textForCalc
    {
        if (A_LoopField != "`t")
        {
            textLength++
            textRealLength++
        }
        else
        {
            textLength += 0.5
            textRealLength++
        }

        if (textRealLength >= length)
        {
            break
        }
    }

    result := SubStr(text, 1, round(textLength - 0.5))

    ; 删掉一个汉字，补一个空格
    if (round(textLength - 0.5) != round(textLength))
        result .= " "

    return result
}

; 修改自万年书妖的 Candy 里的 SksSub_UrlEncode 函数，用于转换编码。感谢！
UrlEncode(url, enc = "UTF-8")
{
    enc := Trim(enc)
    If enc=
        return url
    formatInteger := A_FormatInteger
    SetFormat, IntegerFast, H
    VarSetCapacity(buff, StrPut(url, enc))
    Loop % StrPut(url, &buff, enc) - 1
    {
        byte := NumGet(buff, A_Index-1, "UChar")
        encoded .= byte > 127 or byte < 33 ? "%" SubStr(byte, 3) : Chr(byte)
    }
    SetFormat, IntegerFast, %formatInteger%
    return encoded
}

UrlDownloadToString(url, headers := "")
{
    static whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", url, true)

    if (headers != "")
    {
        for key, value in headers
        {
            whr.SetRequestHeader(key, value)
        }
    }

    whr.Send()
    whr.WaitForResponse()
    return whr.ResponseText
}
;-------------------------------------------------------------------------------------
;added on 2016-05-20 4:18 上午 from gmail ahk functions 

downfile(url,file)
{
UrlDownloadToFile, %url%, %file% ;without %, it fails . so what if no %?
return
}
;-------------------------------------------------------------------------------------
UrlDownloadToVarPOST(url, headers = "")
{
    static whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("POST", url, true)
    if (headers != "")
    {
        for key, value in headers
        {
            whr.SetRequestHeader(key, value)
        }
    }
    whr.Send()
    whr.WaitForResponse()
    return whr.ResponseText
}
;-------------------------------------------------------------------------------------
UrlDownloadToVarPOST_Content(url, headers = "",content = "")
{
    static whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("POST", url, true)
    if (headers != "")
    {
        for key, value in headers
        {
            whr.SetRequestHeader(key, value)
        }
    }
    whr.Send(content)
    whr.WaitForResponse()
    return whr.ResponseText
}
;-------------------------------------------------------------------------------------
UrlDownloadToVarGet(url)
{
    static whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", url, true)
    whr.Send()
    whr.WaitForResponse()
    return whr.ResponseText
}
;-------------------------------------------------------------------------------------
;#### functions
FrenchEncode(word)
{
str:=UrlEncode(word)
ColorArray := StrSplit(str,"%","%")  
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
return NewStr
}
;-------------------------------------------------------------------------------------


;------------------------------------------------------------------------------
/*
	Library for getting info from a specific explorer window (if window handle not specified, the currently active
	window will be used).  Requires AHK_L or similar.  Works with the desktop.  Does not currently work with save
	dialogs and such.
	
	-
	Explorer_GetSelected(hwnd="")   - paths of target window's selected items
	Explorer_GetAll(hwnd="")        - paths of all items in the target window's folder
	Explorer_GetPath(hwnd="")       - path of target window's folder
	
	example:
		F1::
			path := Explorer_GetPath()
			all := Explorer_GetAll()
			sel := Explorer_GetSelected()
			MsgBox % path
			MsgBox % all
			MsgBox % sel
		return
	
	Joshua A. Kinnison
	2011-04-27, 16:12
*/
Explorer_GetPath(hwnd="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All 
	
	; thanks to polyethene
	Loop
		If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		Else Break
	return path
}
Explorer_GetAll(hwnd="")
{
	return Explorer_Get(hwnd)
}
Explorer_GetSelected(hwnd="")
{
	return Explorer_Get(hwnd,true)
}
Explorer_GetWindow(hwnd="")
{
	; thanks to jethrow for some pointers here
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%
	
	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				return window
	}
	else if (class ~= "Progman|WorkerW") 
		return "desktop" ; desktop found
}
Explorer_Get(hwnd="",selection=false)
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
	{
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
		if !hwWindow ; #D mode
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			path := base "\" A_LoopField
			IfExist %path% ; ignore special icons like Computer (at least for now)
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
		for item in collection
			ret .= item.path "`n"
	}
	return Trim(ret,"`n")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ed Cottrell's AutoHotKey script for toggling the "Find Results" pane/window in Notepad++
; Released under the MIT License (http://opensource.org/licenses/MIT)
; Version: 1.1
; Release Date: January 15, 2014
; Released on Superuser.com: http://superuser.com/questions/700357/create-a-hotkey-keyboard-shortcut-to-close-the-notepad-find-results-window
; Also released at www.edcottrell.com/2014/01/11/toggle-find-results-window-notepad-hotkey/
;http://www.edcottrell.com/2014/01/11/toggle-find-results-window-notepad-hotkey/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Turn F7 into a toggle for the Notepad++ search results window; currently it shows it, but doesn't hide it.
; The $ prevents this from firing itself
*$F7::
Open := 0
SetTitleMatchMode 2  ; AHK doesn't seem to recognize the window title otherwise
; See if Notepad++ is the active window or if the undocked results window (ahk_class #32770) is the active window
If WinActive("Notepad++")
{
    ; If the results pane is open, close it
    ; Button1 is the class name for the title bar and close button of the results pane when docked
    ControlGet, OutputVar, Visible,, Button1, Notepad++
    if ErrorLevel = 0
    {
        If OutputVar > 0
        {
            ; Found it docked
            Open := 1
            ; Get the size and coordinates of the title bar and button
            ControlGetPos, X, Y, Width, Height, Button1
            ; Set the coordinates of the close button
            X := Width - 9
            Y := 5
            ; Send a click
            ControlClick, Button1,,,,, NA x%X% y%Y%
        }
    }
}
; If it is undocked, use ahk_class #32770
else If WinExist("Find result ahk_class #32770")
{
    ; Found it undocked
    Open := 1
    ; Close it
    WinClose
}
; It's not open, so open it
if Open = 0
{
    SendInput {F5}
}
return
;著作权归作者所有。
;商业转载请联系作者获得授权，非商业转载请注明出处。
;作者：冯若航
;链接：http://www.zhihu.com/question/19645501/answer/39906404
;来源：知乎

;------------------------------------------------------------------------------------
openfilebest(Name)
{
InputBox, UserInput, File Name, Please enter a file name `n bash`n chrome`n pad`n lea`n profile`n bashy`n tc`n share`n eveconf`n bashhis`n caps`n pro`n vimp`n array`n quit`n , , 600, 400
if !ErrorLevel
    ;MsgBox, CANCEL was pressed.
;else
    ;MsgBox, You entered "%UserInput%"
;openfile(Name)
if UserInput=bash
{
openfile("G:\SRAll\ToAttach\GoodLearn\BashGood\BashShortcutAltN.xml")
}
else if UserInput=chrome
{
openfile("F:\GeekWorkLearn\MyFootPrint\SystemManage\chromevimconfig.xml")
}
else if UserInput=pad
{
openfile("G:\SRAll\Experience\GoodEmail\PadAllBeforeNS.txt")
}
else if UserInput=lea
{
openfile("G:\SRAll\ToAttach\GoodLearn\BashGood\1122GoodDayLearn.xml")
}
else if UserInput=profile
{
openfile("D:\Program Files (x86)\Git\etc\profile")
}
else if UserInput=bashy
{
openfile("G:\SRAll\ToAttach\GoodLearn\BashGood\BashShortcutAltY.xml")
}
else if UserInput=tc
{
openfile("G:\SRAll\ToAttach\GoodLearn\BashGood\Total Commander Shortcut.xml")
}
else if UserInput=share
{
openfile("Z:\Robert\docs\web.config")
}
else if UserInput=eveconf
{
openfile("F:\Program Files\Everything\Everything.ini")
}
else if UserInput=bashhis
{
openfile("G:\SRAll\ToAttach\GoodLearn\BashGood\ZipBashHistory\ZipBashHistory.txt")
}
else if UserInput=caps
{
openfile("F:\Program Files\AutoHotkey\Scripts\Good\CapsEscAllShortcutAHKScript.ahk")
}
else if UserInput=pro
{
openfile("D:\Program Files (x86)\Git\etc\profile")
}
else if UserInput=vimp
{
openfile("C:\Users\robert\_vimperatorrc")
}
else if UserInput=array
{
openfile("G:\SRAll\ToAttach\GoodLearn\BashGood\GreatAHK\TestArrayAHK.txt")
}
else if UserInput=quit
{
;如何利用快捷键退出脚本？
ExitApp
}
}
;-------------------------------------------------------------------------------
;------------------------------------------------------------------------------
arrayaction(FileName,Action)
{
ArrayCount = 0
content:= 
Loop, Read, % FileName
{
    ArrayCount += 1  ; Keep track of how many items are in the array.
    Array%ArrayCount% := A_LoopReadLine  ; Store this line in the next array element.
}
; Read from the array:
Loop %ArrayCount%
{
    element := Array%A_Index%  ; A_Index is a built-in variable.
    ;content=%content%`n%A_Index% : `n%element%`n
    content=%content%`n%A_Index% : `n%element%
}
	InputBox, UserInput, File Name, Please enter an app/file name. %content%, , 600, 800
if !ErrorLevel
{
Name :=UserInput  
;MsgBox %Action%
if Action = open
{
openfile(Array%Name%)
}
else if Action = win
{
ArrayCount2 = 0
Loop, Read, G:\SRAll\ToAttach\GoodLearn\BashGood\GreatAHK\ActAppArrayAHKApps.txt
{
    ArrayCount2 += 1  ; Keep track of how many items are in the array.
    Array2%ArrayCount2% := A_LoopReadLine  ; Store this line in the next array element.
}
;MsgBox % Array2%Name% ":" Name
actwinbestarray(Array%Name%,Array2%Name%)
}
else
{
MsgBox No Common Action
}
}
}

;------------------------------------------------------------------------------------
ReturnArrayObjectOneFile(File)
{
Array := Object()
Loop, Read, % File
{
    Array.Insert(A_LoopReadLine) ; Append this line to the array.
}
return Array
}
ReturnArrayObjectContentOneFile(Array)
{
content :=
tmp:=0
for index, element in % Array ; Recommended approach in most cases.
{
if mod(index,2)=1
{
tmp+=1
    content=%content%`n%tmp% :   %element%
}
}
    return content
}
;-------------------------------------------------------------------------------------
FileToInputBoxReturnIndexOneFile(File)
{
TestArray:=ReturnArrayObjectOneFile(File)
TestContent:=ReturnArrayObjectContentOneFile(TestArray)
InputBox, UserInput, Give an Index, Please enter an Index. %TestContent%, , 600, 800
if !ErrorLevel
{
index :=UserInput 
IfWinActAll(TestArray[2*index-1],TestArray[2*index])
}
}

;-------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------
ms()
{
ArrayCount = 0
content:= 
Loop, Read, F:\Program Files\AutoHotkey\Scripts\Good\ms.txt
{
    ArrayCount += 1  ; Keep track of how many items are in the array.
    Array%ArrayCount% := A_LoopReadLine  ; Store this line in the next array element.
}
; Read from the array:
Loop %ArrayCount%
{
    element := Array%A_Index%  ; A_Index is a built-in variable.
    ;content=%content%`n%A_Index% : `n%element%`n
    content=%content%`n%A_Index% : `n%element%
}
	InputBox, UserInput, Server Name, Please enter server name. %content%, , 600, 800
if !ErrorLevel
{
Name :=UserInput  
If WinExist(Array%Name%)
{
MsgBox % Array.MaxIndex()
WinActivate,% Array%Name%
}
else
{
ArrayCount2 = 0
Loop, Read, msrun.txt
{
    ArrayCount2 += 1  ; Keep track of how many items are in the array.
    Array2%ArrayCount2% := A_LoopReadLine  ; Store this line in the next array element.
}
tmp:=Array2%Name%
Run,E:\EasyOSLink\Run\SR\ms.lnk %tmp%
}
}
}

;-------------------------------------------------------------------------------------
/*
1. want to monitor the mstsc windows by arranging them together
2. caps q, caps s, caps 0
3. want to build functions to use arrays and return the array.
*/
;------------------------------------------------------------------------------------
ReturnArrayObject(File)
{
Array := Object()
Loop, Read, % File
{
    Array.Insert(A_LoopReadLine) ; Append this line to the array.
}
return Array
}
ReturnArrayObjectContent(Array)
{
content :=
for index, element in % Array ; Recommended approach in most cases.
{
    ;content=%content%`n%index% : `n%element%
    content=%content%`n%index% :   %element%
}
    return content
}
FileToInputBoxReturnIndex(File)
{
TestArray:=ReturnArrayObject(File)
TestContent:=ReturnArrayObjectContent(TestArray)
InputBox, UserInput, Give an Index, Please enter an Index. %TestContent%, , 600, 800
if !ErrorLevel
{
index1 :=UserInput 
return index1 
}
}
;------------------------------------------------------------------------------------
GoIndex_WinExist(File,File2)
{
index1 :=FileToInputBoxReturnIndex(File)
Array :=ReturnArrayObject(File)
TestContent:=ReturnArrayObjectContent(Array)
Array2:=ReturnArrayObject(File2)
;ActAllBest(Array[index1],Array2[index1])
IfWinActAll(Array[index1],Array2[index1])
}
;------------------------------------------------------------------------------------
/*
ActAllBest(Name,Cmd)
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
Run,%Cmd%
}
}
*/
;------------------------------------------------------------------------------------
/*
NoTitle()
{
sleep, 500 ; 延时，确保
WinSet,Transparent,220,A;使得窗口变透明。取值范围0-255.0为完全透明，255完全不透明。
WinSet, Style, -0xC00000,A  ;去掉标题栏
}
*/

;-------------------------------------------------------------------------------------
/*            
unable to use a function directly after short string as it is treated as string if you put them in one line!
start a new line works !
*/
ReplaceSlash(a)
{
StringReplace, clipboard, a, \, /, All
Send ^v
return
}

;-------------------------------------------------------------------------------------
DisplayResult2(result := "")
{
MsgBox % result
}
;------------------------------------------------------------------------------
/*
Features:
CopyFilePath
FindAllOfSelectedContentInNotepad
SwitchBetweenNotepadMainFrameAndChild
OpenCurrentAHKFile
OpenPad
OpenLearn
OpenFileBest
OpenOrSwitchToCommonApps
Win+Apps
*/
;-------------------------------------------------------------------------------------
FileManage(Name)
{
	sel := Name
	clipboard = % sel
}
;-------------------------------------------------------------------------------------
PadManage(tmp)
{
SetControlDelay -1
if(tmp="Scintilla1")
{
ControlClick,Scintilla1,ahk_exe Notepad++.exe
return
}
else if(tmp="Scintilla2")
{
ControlClick,Scintilla2,ahk_exe Notepad++.exe
return
}
ControlClick,Scintilla3,ahk_exe Notepad++.exe
}

;-------------------------------------------------------------------------------------
FindAll(tmp)
{
if(tmp="copied")
{
Send ^f
sleep 150
}
SetControlDelay -1
ControlClick,Button24,ahk_class #32770
Sleep 200
}
;-------------------------------------------
Dock()
{
SetControlDelay -1
;ControlClick,nsdockspliter2,ahk_exe Notepad++.exe
;ControlClick,Button1,ahk_exe Notepad++.exe
ControlGetPos, x, y, w, h, Button1,ahk_exe Notepad++.exe
DllCall("SetCursorPos", int, (x+500), int, (y-13))
return
}

;------------------------------------------------------------------------------------- 
;this has been combined to alt q checkinput function
AnySearch()
{
   old=clipboard
   clipboard =  
   Send ^c  
var:=clipboard  
if (var="")  ;if has no bracket then it controls only one line 
{
InputBox,var,请输入,你想search啥`n g d sr qu kb `n mm allqu bwkb bwqu 
ColorArray := StrSplit(var, A_Space, "`")  
if(ColorArray.MaxIndex()>2)
{
par1:=ColorArray[1] 
;clipboard=% ColorArray[2]
clipboard=% var
if(par1="g")
search3("https://www.google.com/#newwindow=1&q=","")
if(par1="d")
search3("http://www.baidu.com/s?wd=","")
if(par1="sr") ;better combine this to Alt + Q which would help a lot 
search3("http://10.106.148.71/sr/","")
if(par1="allqu")
search3("http://10.106.148.71/query?q=","")
if(par1="kb")
search3("http://10.106.148.71/ka/000/",".htm")
if(par1="mm")
search3("https://mail.google.com/mail/u/0/#search/label%3A回好的++","")
if(par1="bwkb")
search3("http://10.106.148.71/query?q=","&s=ka&p=kwbw")
if(par1="bwqu")
search3("http://10.106.148.71/query?q=","&s=all&p=kwbw")
if(par1="qu")
search3("http://10.106.148.71/query?q=","&s=all&p=kwbw")
clipboard=%old%
}
return
}
clipboard=% var
search3("http://www.baidu.com/s?wd=","") 
clipboard=%old% 
}

;-------------------------------------------------------------------------------------
search(url,append)  
{
   clipboard =  
   Send ^c  
var:=clipboard  
if (var="")  ;if has no bracket then it controls only one line 
InputBox,var,请输入,你想search啥  
if (var="") ;if no input then just cancel search
return
clipboard=% var
FileAppend %clipboard% `n, pasts.txt 
Run %url%%Clipboard%%append%
return  
}
;------------------------------------------------------------------------------------- 
MouseMoveClick(x,y)
{
MouseMove,x,y
MouseClick
}
;-------------------------------------------------------------------------------------
MouseClick(x,y)
{
MouseClick,,x, y
}
;-------------------------------------------------------------------------------------
/*
http://macrochen.javaeye.com/blog/791788
; Function to run a program or activate an already running instance 
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
^!w::RunOrActivateProgram("D:/Program Files/EditPlus/editplus.exe") 
^!c::RunOrActivateProgram("D:/Program Files/SecureCRT+FX/SecureCRT.exe") 
^!d::RunOrActivateProgram("D:/Program Files/Q-Dir/Q-Dir.exe") 
*/ 
;-------------------------------------------------------------------------------------
/*
ahkend
I assume all below contents define most key bindings and I need modify them all the time
*/ 
;select the content and add bracket for it.
;-------------------------------------------------------------------------------------
send_bracket(start,end) 
{
  current_clipboard = %Clipboard%
  Clipboard =
  Send, ^c
  ClipWait,1
  clipboard = %start%%clipboard%%end%
  Send ^v{left}
  Clipboard = %current_clipboard%
  return
}


;-------------------------------------------------------------------------------------
ThreeLineBest(Name)
{
FileToInputBoxReturnIndexOneFile_ThreeLinesBestAppSwitch("E:\Sort1113OldNote\UseOldDell\reusesoft\sim_linux\cygwin\tmp\testpaste\goodpasten_testThreeLine,.txt")
}
;-------------------------------------------------------------------------------------
FileToInputBoxReturnIndexOneFile_ThreeLinesBestAppSwitch(File)
{
TestArray:=ReturnArrayObjectOneFile(File)
AutoTrim,On
OnMessage(0x06, "WM_ACTIVATE_RunZ")
InputBox, UserInput, Give an Command, Please enter a command and we will active it. , , 300, 100
if !ErrorLevel
{
;indexTmp :=UserInput
indexTmp :=% Trim(UserInput)  ; trim the space generated by hot string like "javasecurity "
;MsgBox , % indexTmp
Loop, read, %File%
{
    ;IfInString, A_LoopReadLine ,%indexTmp% 
	IfEqual, A_LoopReadLine, %indexTmp%
	{
	index := % A_Index
    IfWinActAll(TestArray[index+1],TestArray[index+2])
    RETURN
	}
}
IfEqual ,indexTmp,q
{
send {Esc}
}
else
{
CheckInput(indexTmp)
}
RETURN
}
}
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;#### start of srun function
;now this could replace the srun program I downloaded before. It could even run apps that has no shortcut links in PATH. Just add them to the threeline file! The threeline file could also save the third line which is the command line if all apps have shortcut in PATH.Just make sure the shortcut are the same as what you type as userinput.
;-------------------------------------------------------------------------------------
;aq
CheckInput(indexTmp)
{
ColorArray := StrSplit(indexTmp, A_Space, "")  
par1:=ColorArray[1] 
;set clipboard
Loop % ColorArray.MaxIndex()
{
    item1 := ColorArray[a_index+1] ;this ignores the first param1 for clipboard
    tmpstr1=%tmpstr1% %item1%
}
;MsgBox %tmpstr1%
if(ColorArray.MaxIndex()>1)
clipboard=%tmpstr1% ;give the rest params to clipboard
/*
;set clipboard if inputs are more params
if(ColorArray.MaxIndex()>1)
{
par2:=ColorArray[2] 
clipboard=% par2
if(ColorArray.MaxIndex()>2) ;use loop and append array items one by one !
{
par3:=ColorArray[3]
clipboard=% par2 " " par3 ;what about 4 ? :)
}
}
*/
;below is a great way to use clipboard or args ! it is as good as RunZ in this aspect
if(par1="c")
Run,%comspec% /k  %clipboard%
;Run,%comspec% /k  %tmpstr1%
else if(par1="g")
search3("https://www.google.com/#newwindow=1&q=","")
else if(par1="d")
search3("http://www.baidu.com/s?wd=","")
else if(par1="url")
gosub Url
else if(par1="enc")
gosub Enc
else if(par1="sr") ;better combine this to Alt + Q which would help a lot 
search3("http://10.106.148.71/sr/","")
else if(par1="allqu")
search3("http://10.106.148.71/query?q=","")
else if(par1="kb")
search3("http://10.106.148.71/ka/000/",".htm")
else if(par1="jira")
search3("https://jira.tibco.com/browse/","")
else if(par1="cert")
search3("http://certificate.fyicenter.com/index.php?Q=","&submit=Search")
else if(par1="ma") ;note if no param gived(mm is used earlier), it would use to activate mdesk app
search3("https://mail.google.com/mail/u/0/#search/","")  
else if(par1="mm") ;note if no param gived(mm is used earlier), it would use to activate mdesk app
search3("https://mail.google.com/mail/u/0/#search/label%3A回好的++","")
else if(par1="bwkb")
search3("http://10.106.148.71/query?q=","&s=ka&p=kwbw")
else if(par1="mykb")
search3("http://10.106.148.71/query?q=&","&s=ka&p=kwbw&fcowner=yawu")
else if(par1="myqu")
search3("http://10.106.148.71/query?q=&","&s=all&p=kwbw&fcowner=yawu")
else if(par1="fy" or par1="tr")
search3("http://fanyi.baidu.com/?aldtype=23#en/zh/","")
else if(par1="yd" or par1="ci")
gosub Dictionary2
else if(par1="site")
search3("https://www.google.com/search?q=","+site%3Apan.baidu.com&ie=utf-8&oe=utf-8")
else if(par1="bwqu" or par1="qu")
search3("http://10.106.148.71/query?q=","&s=all&p=kwbw")
else if(par1="findjar")
search3("http://www.findjar.com/index.x?query=","")
else if(par1="254s")
search3("http://192.168.72.254:8888/?search=","")
else if(par1="se")
search3("http://localhost:8899/?search=","")
else if(par1="s")
SearchSelectViaEverything()
else if(par1="h")
SearchHH()
else if(par1="a")
;SearchAHK("F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\gmailFireCloverPad_simple.ahk",clipboard)
SearchAHK("..\gmailSimple\gmailSimple.ahk",clipboard)
else if(par1="v")
SearchAHK("C:\Users\robert\_vimperatorrc",clipboard) ; test(p1,p2="") would help to save writing the second parameter
else if(par1="p")
SearchAHK("G:\SRAll\Experience\GoodEmail\PadAllBeforeNS.txt",clipboard)
else if(par1="b")
SearchAHK("G:\SRAll\Experience\GoodEmail\mail\mail0630Bigmail.txt",clipboard)
;openfile("G:\SRAll\Experience\GoodEmail\mail\mail0630Bigmail.txt")
else if(par1="big")
;Run,cmd /k grep -in -A 3 -B 3 %clipboard% G:\SRAll\Experience\GoodEmail\mail\mail0630Bigmail.txt
Run,cmd /k grep -in %clipboard% G:\SRAll\Experience\GoodEmail\mail\mail0630Bigmail.txt
else if(par1="l")
SearchAHK("G:\SRAll\ToAttach\GoodLearn\BashGood\1122GoodDayLearn.xml",clipboard)
else if(par1="tra13")
SearchAHK("E:\tibco513\designer\5.10\bin\designer.tra",clipboard)
else if(par1="dec")
Run,cmd /k java -jar G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\decrypt.jar %clipboard% ;because MANIFEST-MF file has "Class-Path" and "Main-class".
;java -cp G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\enttoolkit.jar;G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\decrypt.jar;G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\TIBCrypt.jar;G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\slf4j-jdk14.jar myDecryption #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx
;java -cp G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\decrypt.jar myDecryption #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx 
;java myDecryption #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx works using TIBCO jar. but with errors and this is faster. this issue could be used to compare performance caused by log jars
else if(par1="dec2")
Run,cmd /k java -jar G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\decrypt.jar %clipboard%
;#!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx robert
;#!OO4logwv6c0INZxUfMSj4wKQpZAvE0WU admin
;E:\tibco513\tra\domain\513Admin59\AdministrationDomain.properties
;UserID=robert
;Domain=513Admin59
;Credential=\#\!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx
else if(par1="dec3")
Run,cmd /k java -jar G:\SRAll\AllMayDay\ToAttach\QQDown\decrypt\decrypt.jar #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx
else if(par1="map")
 search3("http://www.gaode.com/search?query","")
else if(par1="bj")
 search3("http://www.gaode.com/search?query=","&city=110000")
else if(par1="zjk")
 search3("http://www.gaode.com/search?query=","&city=130700")
else if(par1="dict")
 search3("http://dict.cn/","")
else if(par1="jd")
Run,"G:\SysManage\SoftFolders\Decompiler\jd-gui.exe" %clipboard%
;Run,jd.lnk %clipboard%
else if(par1="getipport") ;get2 localhost 7888
{
;tmp="http://"+ColorArray[2]+":"+ColorArray[3] ;try to use pass in args but fail due to wrong use of =,:=,"" and method to concat strings
tmp=% "http://" . ColorArray[2] . ":" . ColorArray[3] ;try to use pass in args and works now after concating the strings correctly! you could even hit baidu website 
result := UrlDownloadToVarGet(tmp)
MsgBox,%result%
}
else if(par1="get69port") ;get 69.79 7888 ;found you have to set up a http server by BW. simply using TcpTrace to forward request would fail. need solutions!
{
tmp=% "http://192.168." . ColorArray[2] . ":" . ColorArray[3] ;try to use pass in args and works now after concating the strings correctly! you could even hit baidu website 
result := UrlDownloadToVarGet(tmp)
MsgBox,%result%
}
else if(par1="udfrarg") 
{
tmp=% "http://dict.youdao.com/w/fr/" . UrlEncode(ColorArray[2]) 
;result :=UrlDownloadToVarPOST("http://dict.youdao.com/w/fr/%E5%A5%B3%E5%AD%A9/",{Host:"dict.youdao.com"})  ;想当然的使用了浏览器的url结果怎么都出不来。不用Fiddler截取request不行啊！
;result :=UrlDownloadToVarPOST(tmp,{Host:"dict.youdao.com"})

;result :=UrlDownloadToVarGet(tmp)
;MsgBox,%result%

downfile(tmp,"R:\OSTmp\Local\UrlDownloadToFile.html") ; ud ip port . great! falils now ~
Run,"R:\OSTmp\Local\UrlDownloadToFile.html"
}
else if(par1="post69port") ; post 69.79 7888 name robert 
{
tmp=% "http://192.168." . ColorArray[2] . ":" . ColorArray[3] 
;key1:=ColorArray[4] 
key1=% ColorArray[4]
MsgBox %key1%
value1=% ColorArray[5] 
result := UrlDownloadToVarPOST(tmp, {key1 : value1})  ;needs to override key1 with pass in args
MsgBox,%result%
}
else if(par1="post124") ;post2
{
result := UrlDownloadToVarPOST("http://192.168.69.124:9694", { "key1" : "value1", "key2" : "value2" })
MsgBox,%result%
}
else if(par1="udipport")
{
tmp=% "http://" . ColorArray[2] . ":" . ColorArray[3] 
downfile(tmp,"R:\OSTmp\Local\UrlDownloadToFile.html") ; ud ip port . great! falils now ~
;downfile("http://192.168.69.124:9694","R:\OSTmp\Local\UrlDownloadToFile.html") ;ok to save a http response to a html file. http or ftp protocol must be specified !
Run,"R:\OSTmp\Local\UrlDownloadToFile.html"
Run,R:\OSTmp\Local\
}
else
{
;form a command to run
Loop % ColorArray.MaxIndex()
{
    item := ColorArray[a_index]
    tmpstr=%tmpstr% %item%
}
;MsgBox %tmpstr%
try
   Run,%tmpstr%
catch e
    Run,%comspec% /k %tmpstr%  ;if any erros, do not prompt but find a good way to go on
/*
;above loop helps the function more flexible
;form a cmd commnad depending on params given by input box
if(ColorArray.MaxIndex()==3)
{
Run %comspec% /k %par1% %par2% %par3%
}
else if(ColorArray.MaxIndex()==2)
{
Run %comspec% /k %par1% %par2%
}
else
Run %par1% 
*/ 
}
}



;#### end of srun function


	
;------------------------------------------------------------------------
;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2    
Activate(t)
{
  IfWinActive,%t%
  {
    WinMinimize
    return
  }
  SetTitleMatchMode 2    
  DetectHiddenWindows,on
  IfWinExist,%t%
  {
    WinShow
    WinActivate           
    return 1
  }
  return 0
}
ActivateAndOpen(t,p)
{
  if Activate(t)==0
  {
    Run %p%
    WinActivate
    return
  }
}
/*
#b::ActivateAndOpen("UltraEdit","C:\Program Files\UltraEdit\UltraEdit.exe")
#c::Activate("UltraEdit")
*/
;------------------------------------------------------------------------------------- 
Join(sep, params*) {
    for index,param in params
        str .= param .  sep
		;MsgBox % str
    return SubStr(str, 1, -StrLen(sep))
}
/*
#j::
MsgBox % Join("`n", "one", "two", "three")
return
*/
;------------------------------------------------------------------------------------- 
/*
FileToInputBox(File,Action)
{
TestArray:=ReturnArrayObject(File)
TestContent:=ReturnArrayObjectContent(TestArray)
;MsgBox, % TestArray._MaxIndex()  
;MsgBox, % TestContent
InputBox, UserInput, Give an Index, Please enter an Index. %TestContent%, , 600, 800
if !ErrorLevel
{
index1 :=UserInput  
GoIndex_mstsc(TestArray,index1,Action)
}
}
GoIndex_mstsc(TestArray,index1,Action)
{
If WinExist(TestArray%index1%)
{
WinActivate,% TestArray%index1%
}
else
{
TestArray2:=ReturnArrayObject("F:\Program Files\AutoHotkey\Scripts\Good\msrun.txt")
MsgBox, % TestArray2._MaxIndex()
MsgBox,% TestArray2%index1%
Run,E:\EasyOSLink\Run\SR\ms.lnk %tmp11%
}
}
*/
;------------------------------------------------------------------------------------- 

;-------------------------------------------------------------------------------------
/*
ahk(autohotkey) capslock与esc互换
	一直想将capslock切换成使用率更高的esc键同时支持hjkl的方向键切换，mac平台下的karabiner作为改键神器可轻松实现，win下相应的功能可以由ahk部分实现；
	最终效果为按一下capslock是esc，按capslock + hjkl是方向键
	
;~SetCapsLockState , AlwaysOff
;~CapsLock & h::SendInput {Left}
;~CapsLock & j::SendInput {Down}
;~CapsLock & k::SendInput {Up}
;~CapsLock & l::SendInput {Right}
;~CapsLock & a::SendInput {Home}
;~CapsLock & e::SendInput {End}
;~CapsLock & d::SendInput {Delete}
;~Shift & CapsLock::SendInput, {Shift Down}{Blind}{Esc}{Shift Up}
;~CapsLock::SendInput {Esc}
;~Esc::CapsLock
*/
;------------------------------------------------------------------------------------- 
/*
;模拟右键的动作来粘贴.因为我们不知道当前的鼠标是不是停留在命令提示符的上方，所以直接 Send {RButton} 的办法是不通用的。
;MouseClick 的相关参数请看中文版的 ahk 帮助文件。A_CaretX 又是一个 ahk 自带的变量，它的值就是当前光标——特指那个文本框中一闪一闪的光标——的 X 坐标，A_CaretY 当然就是 Y 坐标了。AHK 无法正确得到光标在 Firefox 下的坐标。
;Send p ，就是在右键菜单弹出来后，按下 p，点击粘贴命令。
#IfWinActive ahk_class ConsoleWindowClass
^v::
MouseClick, Right, %A_CaretX%, %A_CaretY%,,0
send p
return
#IfWinActive
*/

;------------------------------------------------------------------------------------- 
/*
Loop % ColorArray.MaxIndex()
{
    this_color := ColorArray[a_index]
    MsgBox, Color number %a_index% is %this_color%.
}
*/ 

;------------------------------------------------------------------------------------- 


/*
;find tc abnormal when left click the tabs

#IfWinActive, ahk_exe Totalcmd64.exe
~LButton::
MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
PixelGetColor, OutputVarColor, OutputVarX, OutputVarY, RGB
If ((OutputVarControl = "LCLListBox2" and OutputVarColor = "0xFFFFFF") or (OutputVarControl = "LCLListBox1" and OutputVarColor = "0xFFFFFF"))   ;can not distinguish in in TC where double clicked on folder or not 
{
if (A_PriorHotKey = "~LButton" and A_TimeSincePriorHotkey < 400)
{
send {BS}
}
}
#IfWinActive
;found run the ahk file is not the same as to reload it .
;comment on 20160425 to use it to paste contents 
$MButton::  ;WHY NOT WORKING IN WIN10
WinGetClass,sClass,A
if (sClass="TFcFormMain" or sClass="TTOTAL_CMD" or sClass="ExploreWClass")
Send, {BS}
else if (sClass="CabinetWClass" || sClass="#32770")
Send, !{up}
else
sendplay {MButton}
return
*/
;-------------------------------------------------------------------------------------
/*
;commented to help gmail using CapsLock & a
CapsLock & d::
if getkeystate("alt") != 0
     MoveMouse(80,0)
else if getkeystate("ctrl") != 0
     MoveMouse(10,0)
else
     MoveMouse(160,0)
return
CapsLock & a::
if getkeystate("alt") != 0
     MoveMouse(-80,0)
else if getkeystate("ctrl") != 0
     MoveMouse(-10,0)
else
     MoveMouse(-160,0)
return
CapsLock & s::
if getkeystate("alt") != 0
     MoveMouse(0,80)
else if getkeystate("ctrl") != 0
     MoveMouse(0,10)
else
     MoveMouse(0,160)
return
CapsLock & w::
if getkeystate("alt") != 0
     MoveMouse(0,-80)
else if getkeystate("ctrl") != 0
     MoveMouse(0,-10)
else
     MoveMouse(0,-160)
return
*/
;//////////////////////////////////////////////////////////////

/*
;comment on 20160323 in win10 since win10 has its way and this link file can not run in win10
#Tab::  ;find out that AltTab is a bug in win 8 because of permission less to call it  https://autohotkey.com/board/topic/86218-how-can-i-emulate-alt-tab-function-on-win-8-using-ahk/
run,"E:\EasyOSLink\Run\AdminWork\switch.lnk"
Sleep, 100 ; 1,000 = 1 second
;SendInput, {tab}
sendinput {Enter}
return
*/
;------------------------------------------------------------------------------------- 
;replace CapsLock to LeftEnter; CapsLock = Alt CapsLock
;LCtrl & LShift::Run,E:\EasyOSLink\Run\AdminWork\switch.lnk  ;this makes key combination unusable

;LWin & LAlt::Run,E:\EasyOSLink\Run\AdminWork\switch.lnk  ;COMMENTED on 2016-05-20 12:092016-05-20 12:09 上午to use it for restore all windows
;LAlt & LWin::sendinput {Enter}   ; hope to make it so I could easily change apps . fail since mouse course not focused "send {Enter} " fails but "sendinput {Enter} " works !
;RButton & LButton::Run,E:\EasyOSLink\Run\AdminWork\switch.lnk ; making the single right button stuck
;LWin & WheelDown::Run,E:\EasyOSLink\Run\AdminWork\switch.lnk ; it is too quick 
;RButton & WheelUp::Run,E:\EasyOSLink\Run\AdminWork\switch.lnk ;this works but disables firefox to use those from its addons
;------------------------------------------------------------------------------------- 
;comment on 2016-05-20 3:38 上午 since it causes runz to double ahk hotstring. but the root cause is not this
WinTab:
Run,E:\EasyOSLink\Run\AdminWork\switch.lnk
return
;LAlt & RButton::Run,E:\EasyOSLink\Run\AdminWork\switch.lnk
/*
combine with ctrl+win
*/
/*
~LAlt::  ; why unable to use in input box by srun
if (A_PriorHotkey <> "~LAlt" or A_TimeSincePriorHotkey > 400)
{
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, LAlt
    return
}
;SendInput {Enter}
gosub cn
return

~LCtrl::  ; why unable to use in input box by srun
if (A_PriorHotkey <> "~LCtrl" or A_TimeSincePriorHotkey > 400)
{
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, LCtrl
    return
}
;gosub NextIME
gosub en
return
*/
;------------------------------------------------------------------------------------- 
;amazing ! you can leave the mouse pointer in Firefox but type in Noetpad++!
;#up::MouseClick, WheelUp, , , 2  ; Turn it by two notches.
;#down::MouseClick, WheelDown, , , 2a
;it is hard to get rid of the typing error !
;-------------------------------------------------------------------------------------
;~ 我想这样：
;~ 1. 选中内容 按热键即发音
;~ 2. 如果未选中任何内容，按热键的话就弹出提示窗，手动输入提示内容后，回车再发音
;the problem is if the function is not finished the whole ahk file is blocked ! how to stop the speaking ?
#i::  
   clipboard =  
   Send ^c  
   gosub sound  
Return  

;-----------------------------------------------------------------------
/*
copy from robertblue after computer fixed
hide the title bar ; Bus to Zhangjiakou
; 899 Bus from ZHuxinzhuang B Kou to Xiahuayuan Qu :$24  (898 ZhuLu)
;880 HuiLongguan A Kou to ShaChengKEYuanZhan : $24
*/
;------------------------------------------------------------------------------
/*
 caps y hiddle title and caps t shows title
 u i o p pageup,home,end,pagedown, combine with caps and ctrl
 ctrl i : home ; ctrl o:end
*/

;-------------------------------------------------------------------------------------
/*
http://ahk8.com/archive/index.php/thread-5157.html
inputbox只有一个timeout参数，只能指定弹出框存在的时间。我希望鼠标点击其他地方，输入框在失去焦点的时候自动关闭，请问如何实现？
这不是InputBox该考虑的。
但你可以把他看做一个窗体，当它失去焦点时，则关闭...
窗体的检测、操作，具体看手册目录中‘窗口管理’类。
再具体化一点就是，你程序中需要有一个部分，不断的检测当前焦点窗口是不是inputbox，不是的话，就把它关了。
*/ 
/*
;comment on 2016-05-18 3:04 上午 to use the better onefrm RunZ
WM_ACTIVATE(wParam, lParam) {
    If (wParam >= 1) ; 窗口激活
        Return
    Else If (wParam <= 0) ; 窗口非激活
        IfWinExist, Give an Command
            WinClose
}
*/

WM_ACTIVATE_RunZ(wParam, lParam)
{
    if (wParam >= 1) ; 窗口激活
    {
        return
    }
    else if (wParam <= 0) ; 窗口非激活
    {
	  IfWinExist, Give an Command
            WinClose
    }
}

;-------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------
/*
;double click in explorer or clover works but since clover is used. disable this on 2016-05-11 1:20:11 pm
#IfWinActive, ahk_class CabinetWClass ;works in win8.1 after clover cleaned on 2016-05-05 1:36:41
~LButton::
MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
PixelGetColor, OutputVarColor, OutputVarX, OutputVarY, RGB
If ((OutputVarControl = "DirectUIHWND2" and OutputVarColor = "0xFFFFFF") or (OutputVarControl = "DirectUIHWND3" and OutputVarColor = "0xFFFFFF") or (OutputVarControl = "SysTreeView321" and OutputVarColor = "0xFFFFFF"))
{
if (A_PriorHotKey = "~LButton" and A_TimeSincePriorHotkey < 400)
send !{up}
}
return
#if
#IfWinActive, ahk_class #32770
~LButton::
MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
PixelGetColor, OutputVarColor, OutputVarX, OutputVarY, RGB
If ((OutputVarControl = "DirectUIHWND2" and OutputVarColor = "0xFCFCFC") or (OutputVarControl = "SysListView321" and OutputVarColor = "0xFFFFFF"))
{
if (A_PriorHotKey = "~LButton" and A_TimeSincePriorHotkey < 400)
send !{up}
}
return
#if
用于win7的打开，另存为等窗口的，可以双击空白处返回上一级，把ahk_class #32770改成资源管理器的wintitle，把颜色值和控件值改成win10的应该可以用
$MButton::
WinGetClass,sClass,A
if (sClass=”TFcFormMain” or sClass=”TTOTAL_CMD” or sClass=”ExploreWClass”)
Send, {BS}
else if (sClass=”CabinetWClass” || sClass=”#32770″)
Send, !{up}
else sendplay {MButton}
return
*/

;-------------------------------------------------------------------------------------
#If WinActive("ahk_exe notepad++.exe") or WinActive("ahk_exe eclipse.exe")
::rs::return
#IfWinActive

;#### start of notepad
#IfWinActive ahk_exe notepad++.exe
::##::{;}{# 4}
::headof::{#}head of ahk
::qw::
send ^{Home}
sleep 200
send ^s
return
::qa::
send ^{End}
sleep 200
send ^s
return
::/a::
send {Home}
sleep 200
send ^s
return
::/d::
send {End}
sleep 200
send ^s
return
::sv::
send ^s
sleep 200
reload
return
F4::Dock()
F5::FindAll("copied")
F6::FindAll("nocopied")
F8::PadManage("Scintilla3") ;double  tab
F9::PadManage("Scintilla1")
F10::PadManage("Scintilla2")
;use to move course to last edit place
!Left::send ^-
!Right::send ^+-
/*
LCtrl & Up::send +{Home} ;disables line copy combination of notepad++
LCtrl & Down::send +{End}
*/
::/*::/**/{left 2}{Enter 2}{Up} ;inside notepad.exe

^!\:: ;unable to use after app switch key combination; actually able to use when tried again
send ^c
send /*{Enter}
send ^v
send {Enter}*/
return

;ctrl+alt+shift+c uses to comment xml/html files

::jj::
send ^j
return
#IfWinActive  ;end of notepad++
;#### end of notepad
;------------------------------------------------------------------------------------- 
/*
#n::  
   clipboard =  
   Send ^c  
   gosub search
Return  
search:  
var:=clipboard  
if (var="")  
InputBox,var,请输入,你想search啥  
clipboard=% var
UseClipBoardRun("http://www.baidu.com/s?wd=","")
return  
*/
/*
amazing I made a full serach over the system !
*/ 
;------------------------------------------------------------------------------------- 
UseAQFile(UserInput,File="E:\Sort1113OldNote\UseOldDell\reusesoft\sim_linux\cygwin\tmp\testpaste\goodpasten_testThreeLine,.txt"){
TestArray:=ReturnArrayObjectOneFile(File)
indexTmp :=% Trim(UserInput)  ; trim the space generated by hot string like "javasecurity "
Loop, read, %File%
{
	IfEqual, A_LoopReadLine, %indexTmp%
	{
	index := % A_Index
    IfWinActAll(TestArray[index+1],TestArray[index+2])
    RETURN
	}
}
}
;------------------------------------------------------------------------------------- 
;-------------------------------------------------------------------------------------
qa(UserInput,File="E:\Sort1113OldNote\UseOldDell\reusesoft\sim_linux\cygwin\tmp\testpaste\goodpasten_testThreeLine,.txt")
{
TestArray:=ReturnArrayObjectOneFile(File)
indexTmp :=% Trim(UserInput)  ; trim the space generated by hot string like "javasecurity "
Loop, read, %File%
{
	IfEqual, A_LoopReadLine, %indexTmp%
	{
	 index := % A_Index
    IfWinActAll(TestArray[index+1],TestArray[index+2])
    RETURN
	}
}
CheckInput(indexTmp)
}



;------------------------------------------------------------------------------------- 
/*
FileRead, fileContent, pasts.txt
last_line := SubStr(fileContent, InStr(fileContent, "`n", False, 0))
MsgBox "%last_line%"
Return
;we have to delete the last line to revert clipboard content
;or we could use a file content list to show history
*/ 

;------------------------------------------------------------------------------------- 
::/bra::
send_bracket("{ "," }")
return
^+]::
send_bracket("{ "," }")
return
/*
;fails but I found other way
^+[::
send_bracket("" "," "")
return
*/

;end of surround selected contents
;-------------------------------------------------------------------------------------
;commented learning 
/*
~RControl::
if (A_PriorHotkey <> "~RControl" or A_TimeSincePriorHotkey > 400)
{
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, RControl
    return
}
MsgBox You double-pressed the right control key.
return
search(url,append)  
{
var:=%clipboard%
send ^c
if (%clipboard%="")  
{
InputBox,var,请输入,你想search啥  
clipboard=% var
}
FileAppend %clipboard% `n, pasts.txt 
Run %url%%Clipboard%%append%
return  
}
*/ 

;-------------------------------------------------------------------------------------
;no worry about that threeline file ! I have replace the two contents , x:\windows\system32\taskmgr.exe /7    "x:\windows\system32\cmd.exe".  no worry that app short name is the same as cmd cause we have a "return" inside IfEqual, which means only the first matched line in that threeline file would be ued

;use to auto press enter after a paste
^+v::
gosub PasteEnter
return

;-------------------------------------------------------------------------------------
en:
SwitchToEngIME()
return

cn:
SwitchToCnIME()
return
;-------------------------------------------------------------------------------------
CtrlShiftTab:
send ^+{Tab}
return

CtrlTab:
;MsgBox tab
send ^{Tab}
return
;-------------------------------------------------------------------------------------
CtrlEnter:
send ^{Enter}
return

Enter:
send {Enter}
return
;-------------------------------------------------------------------------------------
ahkkill:
Run,taskkill /F /im AutoHotkey.exe
Run,taskkill /F /im AutoHotkeyA32.exe
Run,taskkill /F /im AutoHotkeyU32.exe
return
::awox::
Run,taskkill /F /im Wox.exe
return

;------------------------------------------------------------------------------------- 
WinDCaps:
if getkeystate("alt") != 0
	 WinMinimizeAllUndo  ; unable to use since it is used to switch apps
else if getkeystate("ctrl") != 0
WinMinimizeAll
else
     send ^{PgDn}
return

/*
LWin & d::
if getkeystate("alt") != 0
	 WinMinimizeAllUndo  ; unable to use since it is used to switch apps
else if getkeystate("ctrl") != 0
WinMinimizeAll
else
     send ^{PgDn}
return
*/

;-------------------------------------------------------------------------------------
explorer:
send ^c
run,explorer %clipboard%
return

explorerparent:
send ^c
;RunAndGetOutput("explorer /e,/select,G:\SysManage\HelpSoft\MemoryAnalyzer\workspace\.metadata")
RunAndGetOutput("explorer /e,/select," clipboard)
;explorer /e,/select,"%1" ; use the command run would fail
return

NewLine:
send {End}
send {Enter}
return
;-------------------------------------------------------------------------------------
PgUp:
send {PgUp} 
return

PgDn:
send {PgDn}
return
;-------------------------------------------------------------------------------------
up:
send {Up}
return
down:
send {Down}
return
right:
send {Right}
return
left:
send {Left}
return
;-------------------------------------------------------------------------------------
::desk::
gosub HideDeskFiles
Return
;------------------------------------------------------------------------------------- 
IMEcn:
return

IMEen:
return
;-------------------------------------------------------------------------------------
ctrlparaup:
send ^[
return

ctrlparadown:
send ^]
return
;-------------------------------------------------------------------------------------
/*
CapsLock & -::send ^-
CapsLock & '::send {Home}"
CapsLock & `;::send {Home};
CapsLock & \::send {Home};
CapsLock & 3::send {Home}{#}
*/
;-------------------------------------------------------------------------------------
homequote:
send {Home}"
return

homecomment:
send {Home};
return

editplace:
send ^-
return

editplaceback:
send ^+-
return

ctrlwinleft:
send ^#{Left}
return

ctrlwinright:
send ^#{Right}
return
;-------------------------------------------------------------------------------------
shifthomedel:
Send +{Home}{Del} ;删除当前行光标前内容  
return

shiftenddel:
Send +{End}{Del} ;删除当前行光标后内容  
return

homesharp:
send {Home}{#}
return

wint:
sendinput #t
return

;-------------------------------------------------------------------------------------
LastPass:
MouseMoveClick(621,64) ; LastPass
return
GoogleKeep:
MouseClick(659, 57) ;Google Keep
return
Pocket:
;MouseMoveClick(515, 58) ;Pocket
MouseMoveClick(526, 54) ;Pocket
return
onetab:
MouseMoveClick(547, 58) ;oneTab
return
lastpasslogin:
MouseMoveClick(976, 99) ;Login Automatically
return
-------------------------------------------------------------------------------------
/* 
comment on 20160309 since /8 is used for * now 
RShift & ,::send ^{PgUp}
RShift & .::send ^{PgDn}
;+/::send ^w
* /
;-------------------------------------------------------------------------------------

;------------------------------------------- 
/*
SetTitleMatchMode 2
; OR:
SetTitleMatchMode RegEx
可以有 1 2 3 Fast Slow ,RegEx ,六种值
    1: 表示前端匹配，
    2: 表示部分匹配
    3: 表示完全匹配
    RegEx:表示使用正则表达式进行匹配
*/

CapsLock & t::
;SetTitleMatchMode, 2 ;设定ahk匹配窗口标题的模式
winactivate,A ; 激活此窗口
sleep, 500 ; 延时，确保
WinSet,Transparent,220,A;使得窗口变透明。取值范围0-255.0为完全透明，255完全不透明。
WinSet, Style, -0xC00000,A  ;去掉标题栏
return
CapsLock & y::
;SetTitleMatchMode, 2
winactivate,A ; 激活此窗口
sleep, 500 ; 延时，确保
WinSet,Style, +0xC00000,A ;恢复标题栏
return
;-------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------- 
;maybe I will use alt+` to reload the ahk since it is free after listary changes.
/*
!`::
Run "F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\VimEdit.ahk"
Run "F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\TextSelectCopy.ahk" ; replace "F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\DragKingCopy.ahk" since it copies everything including folders
Run "F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\AutoCorrectSpell.ahk"
reload
;Run "F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\gmailFireCloverPad_simple.ahk"
;Run,"F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\windesktop_win_switchapp.ahk" ;fail to use win only simualting single double and triple click to switch apps
;Run "F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\windesktop_win.ahk"
;Run "F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\windesktop.ahk"
return
*/
;use this in Win10 since win10 seems unable to deal with ESC and CapsLock key exchange because pad run by admin privilege
;the problem comes if you use "#a" but works if "$#a" is used ! {Blind} would help

;-------------------------------------------------------------------------------------
WM_ACTIVATE_All(wParam, lParam,title) {
    If (wParam >= 1) ; 窗口激活
        Return
    Else If (wParam <= 0) ; 窗口非激活
        IfWinExist, %title%
            WinClose
}


;-------------------------------------------------------------------------------------

RunAndGetOutput(command)
{
    tempFileName := "RunZ.stdout.log"
	
 fullCommand = %ComSpec% /C "%command% > %A_Temp%\%tempFileName%"
    ;fullCommand = %ComSpec% /C %command% > %A_Temp%\%tempFileName%

    /*
    fullCommand = bash -c "%command% &> %tempFileName%"

    if (!FileExist("c:\msys64\usr\bin\bash.exe"))
    {
        fullCommand = %ComSpec% /C "%command% > %tempFileName%"
    }
    */
    ;A_Temp2 := "F:\GeekWorkLearn\Cmder"
    RunWait, %fullCommand%, %A_Temp%, Hide
    FileRead, result, %A_Temp%\%tempFileName%
    ;FileDelete, %A_Temp%\%tempFileName%
	;MsgBox %result% ;乱码 cmd chcp default 936(gb2312) so set  FileEncoding, CP936 for all RunZ ahk files
    return result
}
;-------------------------------------------------------------------------------------

Url:
    ;word := Arg == "" ? clipboard : Arg
    word = % clipboard  
    result := UrlEncode(word)
    DisplayResult2(result)
Return
Enc:
    ;word := Arg == "" ? clipboard : Arg
    word = % clipboard  
	ColorArray := StrSplit(word, A_Space, "")  
	str:=ColorArray[1]
	enc:=ColorArray[2]
    result :=UrlEncode(str,enc)
    ;result :=UrlEncode(str)
    DisplayResult2(result)
Return

;-------------------------------------------------------------------------------------
HideDeskFiles:
ControlGet, HWND, Hwnd,, SysListView321, ahk_class Progman
If HWND =
ControlGet, HWND, Hwnd,, SysListView321, ahk_class WorkerW
If DllCall("IsWindowVisible", UInt, HWND)
WinHide, ahk_id %HWND%
Else
WinShow, ahk_id %HWND%
Return
;-------------------------------------------------------------------------------------
Dictionary2:
    word := Arg == "" ? clipboard : Arg
    url := "http://fanyi.youdao.com/openapi.do?keyfrom=YouDaoCV&key=659600698&"
            . "type=data&doctype=json&version=1.2&q=" UrlEncode(word)
    jsonText := StrReplace(UrlDownloadToString(url), "-phonetic", "_phonetic")
    if (jsonText == "no query")
    {
        DisplayResult2("未查到结果")
        return
    }
    parsed := JSON.Load(jsonText)
    result := parsed.query
    if (parsed.basic.uk_phonetic != "" && parsed.basic.us_phonetic != "")
    {
        result .= " UK: [" .basic.uk_phonetic "], US: [" parsed.basic.us_phonetic "]`n"
    }
    else if (parsed.basic.phonetic != "")
    {
        result .= " [" parsed.basic.phonetic "]`n"
    }
    else
    {
        result .= "`n"
    }
    if (parsed.basic.explains.Length() > 0)
    {
        result .= "`n"
        for index, explain in parsed.basic.explains
        {
            result .= "    * " explain "`n"
        }
    }
    if (parsed.web.Length() > 0)
    {
        result .= "`n----`n"
        for i, element in parsed.web
        {
            result .= "`n    * " element.key
            for j, value in element.value
            {
                if (j == 1)
                {
                    result .= "`n       "
                }
                else
                {
                    result .= "`; "
                }
                result .= value
            }
        }
    }
    DisplayResult2(result)
    clipboard := result
return
;-------------------------------------------------------------------------------------
NextIME:
DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("ActivateKeyboardLayout", UInt, 1, UInt, 256))
;-- 对当前窗口激活下一输入法
Return
;-------------------------------------------------------------------------------------
sound:  
var:=clipboard  
if (var="")  
InputBox,var,请输入,你想说啥  
spovice:=ComObjCreate("sapi.spvoice")  
spovice.Speak(var)  
return  
/*
SAPI—SpVoice的使用方法  
要使用SAPI，首先添加引用DotNetSpeech，请自行下载DotNetSpeech.dll。
初始化对象，SpVoice voice = new DotNetSpeech.SpVoiceClass();
朗读时，使用
voice.Speak(string,SpeechVoiceSpeakFlags.SVSFlagsAsync);
暂停，使用
voice.Pause();
从暂停中继续刚才的朗读，使用
voice.Resume();
停止功能是大多资料都没有写清楚的，而且在网上很少能找到，这里使用
voice.Speak(string.Empty, SpeechVoiceSpeakFlags.SVSFPurgeBeforeSpeak);
这样就可以完整地实现了“朗读”、“暂停”、“继续”、“停止”的功能。
*/ 
;-------------------------------------------------------------------------------------
frboy:  ;使用 男孩 的编码做默认值 ; this could not be used in RunZ since it is limited to the input box  . this could be moved here because it does not require args. but others can only be used for input box or move to RunZ plugin
;type=ZH_CN2FR&i=%C3%A5%C2%A5%C2%B3%C3%A5%C2%AD%C2%A9&doctype=json&xmlVersion=1.8&keyfrom=fanyi.web&ue=UTF-8&action=FY_BY_CLICKBUTTON&typoResult=true  
result := UrlDownloadToVarPOST_Content("http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=http://dict.youdao.com/",{"Content-Type":"application/x-www-form-urlencoded; charset=UTF-8"},"type=ZH_CN2FR&i=%C3%A7%C2%94%C2%B7%C3%A5%C2%AD%C2%A9&doctype=json&xmlVersion=1.8&keyfrom=fanyi.web&ue=UTF-8&action=FY_BY_CLICKBUTTON&typoResult=true")
MsgBox,%result%
return

;------------------------------------------------------------------------------------
/*
not sure why the script disables $ in vi to go to the line end. 
*/
;why fails ? because it works only when ahk input is active

$#z:: ;I will decide not to use this line if it fails in nex restart  good now ! after use the new ActivateAndOpen function !
ActivateAndOpen("Taskmgr.exe","Taskmgr.exe")
return
;------------------------------------------------------------------------------------
#include F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\Scripts\HotKeyManagerV1\HotKeyManagerV1.ahk
;#include F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\UserDefine\moreFunc\AHK热键管理器v2.0\_sy.ahk