#NoTrayIcon

Gui, Color, Black
Gui +AlwaysOnTop +LastFound
WinSet, Transparent, 30
Gui -Caption -Border +ToolWindow
W = %A_ScreenWidth%
H = %A_ScreenHeight%
Gui, Show, x0 y0 h%H% w%W%
gui, +LastFound +AlwaysOnTop
WinSet, ExStyle, +0x20
return

GuiEscape:
GuiClose:
ExitSub:
ExitApp
return