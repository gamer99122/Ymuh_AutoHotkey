; **************************************
; 共用函式
; **************************************

HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}

ClipStrReplace(search, replace)
{
  Send ^c
  ClipWait
  Clipboard := StrReplace(Clipboard, search, replace, All)
  Send ^v
  return 
}

ClipSend(text, sleep)
{
  ClipSaved := ClipboardAll
  Clipboard := text
  ClipWait
  sleep %sleep%
  if(false)
  {
    Send ^v
  }
  else
  {
    Send %text%
  }
  Clipboard := ClipSaved
  ClipSaved =  
}

; **************************************
; 截圖相關（原腳本1）
; **************************************

; 全畫面截圖自動存檔
~PRINTSCREEN::
  outputFile = %A_Now%.png
  Run, E:\Software\Nircmd\nircmd.exe savescreenshot E:\screenshot\%outputFile%
  HideTrayTip()
  TrayTip, , 截圖存成 %outputFile%, 1, 
return

; 單一視窗截圖自動存檔
!~PRINTSCREEN::
  outputFile = %A_Now%.png
  Run, E:\Software\Nircmd\nircmd.exe savescreenshotwin E:\screenshot\%outputFile%
  HideTrayTip()
  TrayTip, , 截圖存成 %outputFile%, 1, 
return

; **************************************
; 原腳本2 熱鍵區
; **************************************

; Reload AutoHotKey
^+r::
  MsgBox Reloading AutoHotKey
  Reload
return

; Edit AutoHotKey（修改 D → E）
^+e::
  Run "notepad++.exe" E:\Software\bin\Pin4Key\Pin4Key.ahk
return

; Re/Install（修改 D → E）
^+i::
  run robocopy \\172.17.101.142\Share\HotKey\Pin4Key\ E:\Software\bin\Pin4Key\ /E
  MsgBox Reloading AutoHotKey
  Reload  
return

; Alt + V : SQL View with Table Schema
!v::
SetTitleMatchMode, 2
IfWinActive, SQL Server Management Studio
{
  current_clipboard = %Clipboard%
  Send ^c 
  ClipWait, 2

  WinGetTitle, SSMSTitle
  run \\Hisupdatea\HIS2Tools\SchemaView.exe -t="%SSMSTitle%",,,OutputVarPID
  WinWait, ahk_pid %OutputVarPID%
return
}

^F5::
  InputBox, searchTxt, Search:
  if( Trim(searchTxt) != "" )
  {
	run E:\Software\bin\Pin4Key\bin\GrepString.bat %searchTxt%
  }
return
  
^F6::
SetTitleMatchMode, 2
IfWinActive, SQL Server Management Studio
{
  Send {Shift}  ; 切換到英文輸入法
  Sleep 100
  ClipSend("select top 100 * from DB_GEN..", 200)
}
return

^F7::
SetTitleMatchMode, 2
IfWinActive, SQL Server Management Studio
{
  Send {Shift}  ; 切換到英文輸入法
  Sleep 100
  ClipSend("select top 100 * from DB_ADM..", 200)
}
return

^F8::
SetTitleMatchMode, 2
IfWinActive, SQL Server Management Studio
{
  Send {Shift}  ; 切換到英文輸入法
  Sleep 100
  ClipSend("select top 100 * from DB_OPD..", 200)
}
return

^F9::
SetTitleMatchMode, 2
IfWinActive, SQL Server Management Studio
{
  Send ^c
  ClipWait

  WinGetTitle, SSMSTitle
  WinGet, SSMSPID

  Run, "\\Hisupdatea\HIS2Tools\QPin.exe" -t="%SSMSTitle%",,,OutputVarPID

  WinWait, ahk_pid %OutputVarPID%
  WinActivate, ahk_pid %OutputVarPID%
  WinWaitClose, ahk_pid %OutputVarPID%

  WinActivate, ahk_pid %SSMSPID%
  Sleep 100
  Send ^v
  
  return
}

!c::
SetTitleMatchMode, 2
IfWinActive, SQL Server Management Studio
{
  Send ^+c
  ClipWait
  Run "c:\tmptools\Pin4key.exe"
  return
}

^F11::
SetTitleMatchMode, 2
IfWinActive, SQL Server Management Studio
  InputBox, fromTxt, 原本字串: