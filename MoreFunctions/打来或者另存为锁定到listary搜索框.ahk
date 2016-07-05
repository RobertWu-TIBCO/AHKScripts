;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;脚本功能，在“打开文件”和“另存为”界面，将输入焦点设置到listary搜索框，
;因为没有对所有“打开文件”和“另存为”界面的ahk_class进行测试，所以不保证对所有的都有效。
; 2016-05-18 冰封 qq:124702759
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


#Persistent
#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
Menu, Tray, Icon,F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\Scripts\AHKManager\LISTARY_IS1.ico
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%\cursor  ; Ensures a consistent starting directory.
;控制listary搜索框焦点
IsListary = 0
global IsListary

SetTimer, cursors, 200


cursors:
			if (!IsListary )
			{		
				if WinActive( "ahk_class #32770") 
				{
					Sleep 100 ;这个sleep是必须的， 但是大小有没有影响没有测试
					IsListary = 1			
					;WinActivate ahk_class Listary_WidgetWin_1
					WinActivate ahk_class Listary_WidgetWin_0
					;Sleep 100
					ControlFocus ListarySearchBox1, ahk_class Listary_WidgetWin_0
					;SetControlDelay, 50
				}
			}			
			IfWinNotExist  ahk_class #32770
				IsListary = 0
	  return