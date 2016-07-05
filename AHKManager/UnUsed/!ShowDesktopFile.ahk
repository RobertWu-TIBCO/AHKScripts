#SingleInstance force  ; force reloading
; AutoHotkey Version: 1.x
; Author: Scott Updike scottupdike@gamesbyageek.com http://www.gamesbyageek.com

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#space::
  LoopNum := 0
  Loop, %A_Desktop%\*.lnk
  {
    ; check extension length
    if StrLen(A_LoopFileName) + 1 - InStr(A_LoopFileName, "lnk", StartingPos = 0) = 3
    {
      LoopNum++
    }
  }
  Loop, %A_DesktopCommon%\*.lnk
  {
    ; check extension length
    if StrLen(A_LoopFileName) + 1 - InStr(A_LoopFileName, "lnk", StartingPos = 0) = 3
    {
      LoopNum++
    }
  }
  LoopNum++
  if LoopNum > 40
  {
    LoopNum := 40
  }
  Gui, Add, ListView, List r%LoopNum% w200 gMyListView, shortcut|hidden
  Gui, Add, Button, Hidden Default, OK

  ImageListID := IL_Create(10)
  LV_SetImageList(ImageListID)  ; Assign the above ImageList to the current ListView.
  Loop, %A_Desktop%\*.lnk
  {
    ; check extension length
    if StrLen(A_LoopFileName) + 1 - InStr(A_LoopFileName, "lnk", StartingPos = 0) = 3
    {
      LNKFile := A_Desktop . "\" . A_LoopFileName
      FileGetShortcut, %LNKFile%, OutTarget, OutDir, OutArgs, OutDesc, OutIcon, OutIconNum, OutRunState
      ILOut := IL_Add(ImageListID, OutIcon, OutIconNum)
      if ILOut = 0
      {
        ILOut := IL_Add(ImageListID, OutTarget)
      }
      if ILOut = 0
      {
          if OutTarget =
            ILOut := IL_Add(ImageListID, "SHELL32.dll", 1)
      }
      if ILOut = 0
      {
        StringGetPos, CharPos, OutTarget, \, R1
        StringRight, FileName, OutTarget, StrLen(OutTarget) - CharPos - 1
        IfInString, FileName, .
        {
          ; period found so use generic icon
          IL_Add(ImageListID, "SHELL32.dll", 1)
        }
        else
        {
          ; no period so use folder icon
          IL_Add(ImageListID, "SHELL32.dll", 4)
        }
      }
    }
  }
  Loop, %A_DesktopCommon%\*.lnk
  {
    ; check extension length
    if StrLen(A_LoopFileName) + 1 - InStr(A_LoopFileName, "lnk", StartingPos = 0) = 3
    {
      LNKFile := A_DesktopCommon . "\" . A_LoopFileName
      FileGetShortcut, %LNKFile%, OutTarget, OutDir, OutArgs, OutDesc, OutIcon, OutIconNum, OutRunState
      ILOut := IL_Add(ImageListID, OutIcon, OutIconNum)
      if ILOut = 0
      {
        ILOut := IL_Add(ImageListID, OutTarget)
      }
      if ILOut = 0
      {
          if OutTarget =
            ILOut := IL_Add(ImageListID, "SHELL32.dll", 1)
      }
      if ILOut = 0
      {
        StringGetPos, CharPos, OutTarget, \, R1
        StringRight, FileName, OutTarget, StrLen(OutTarget) - CharPos - 1
        IfInString, FileName, .
        {
          ; period found so use generic icon
          IL_Add(ImageListID, "SHELL32.dll", 1)
        }
        else
        {
          ; no period so use folder icon
          IL_Add(ImageListID, "SHELL32.dll", 4)
        }
      }
    }
  }
  LoopNum := 0
  Loop, %A_Desktop%\*.lnk
  {
    ; check extension length
    if StrLen(A_LoopFileName) + 1 - InStr(A_LoopFileName, "lnk", StartingPos = 0) = 3
    {
      LoopNum++
      LV_Add("Icon" . LoopNum, SubStr(A_LoopFileName, 1, InStr(A_LoopFileName, ".lnk", StartingPos = 0) - 1), 1)
    }
  }
  Loop, %A_DesktopCommon%\*.lnk
  {
    ; check extension length
    if StrLen(A_LoopFileName) + 1 - InStr(A_LoopFileName, "lnk", StartingPos = 0) = 3
    {
      LoopNum++
      LV_Add("Icon" . LoopNum, SubStr(A_LoopFileName, 1, InStr(A_LoopFileName, ".lnk", StartingPos = 0) - 1), 2)
    }
  }

  LV_ModifyCol(1, "Sort")
  ; Display the window and return. The script will be notified whenever the user double clicks a row.
  Gui, Show,, Desktop Shortcuts
  return

  MyListView:
  if A_GuiEvent = DoubleClick
  {
    LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
    LV_GetText(RowText2, A_EventInfo, 2)
    if RowText2 = 1
      Run "%A_Desktop%\%RowText%.lnk"
    else
      Run "%A_DesktopCommon%\%RowText%.lnk"
    Gui, Destroy
  }
  return

  ButtonOK:
  RowNum := LV_GetNext(0, "Focused")
  if RowNum = 0
    return
  LV_GetText(RowText, RowNum)  ; Get the text from the row's first field.
  LV_GetText(RowText2, RowNum, 2)
  if RowText2 = 1
    Run "%A_Desktop%\%RowText%.lnk"
  else
    Run "%A_DesktopCommon%\%RowText%.lnk"
  Gui, Destroy
  return
return

GuiClose:
GuiEscape:
  Gui, Destroy
return