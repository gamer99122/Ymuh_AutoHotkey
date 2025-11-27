; **************************************
; 共用函式
; **************************************

HideTrayTip() {
    TrayTip()  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion, 1, 3) = "10." {
        TraySetIcon(A_WinDir "\System32\shell32.dll", 0)
        Sleep(200)
        TraySetIcon()
    }
}

ClipStrReplace(search, replace) {
    A_Clipboard := ""
    Send("^c")
    ClipWait()
    A_Clipboard := StrReplace(A_Clipboard, search, replace)
    Send("^v")
    return
}

; **************************************
; 截圖相關
; **************************************

; 全畫面截圖自動存檔
~PrintScreen:: {
    outputFile := FormatTime(A_Now, "yyyyMMddHHmmss") ".png"
    Run('E:\Software\Nircmd\nircmd.exe savescreenshot E:\screenshot\' outputFile)
    HideTrayTip()
    TrayTip("截圖存成 " outputFile, "", 1)
}

; 單一視窗截圖自動存檔
!PrintScreen:: {
    outputFile := FormatTime(A_Now, "yyyyMMddHHmmss") ".png"
    Run('E:\Software\Nircmd\nircmd.exe savescreenshotwin E:\screenshot\' outputFile)
    HideTrayTip()
    TrayTip("截圖存成 " outputFile, "", 1)
}

; **************************************
; 熱鍵區
; **************************************

; Reload AutoHotKey
^+r:: {
    MsgBox("Reloading AutoHotKey")
    Reload()
}

; Edit AutoHotKey
^+e:: {
    Run('"notepad++.exe" E:\Software\bin\Pin4Key\Pin4Key.ahk')
}

; Re/Install
^+i:: {
    Run('robocopy \\172.17.101.142\Share\HotKey\Pin4Key\ E:\Software\bin\Pin4Key\ /E')
    MsgBox("Reloading AutoHotKey")
    Reload()
}

; Alt + V : SQL View with Table Schema
!v:: {
    SetTitleMatchMode(2)
    if WinActive("SQL Server Management Studio") {
        current_clipboard := A_Clipboard
        Send("^c")
        if !ClipWait(2) {
            return
        }
        
        SSMSTitle := WinGetTitle("A")
        Run('\\Hisupdatea\HIS2Tools\SchemaView.exe -t="' SSMSTitle '"', , , &OutputVarPID)
        WinWait("ahk_pid " OutputVarPID)
    }
}

^F5:: {
    result := InputBox("Search:", "Search")
    if (result.Result = "OK" && Trim(result.Value) != "") {
        Run('E:\Software\bin\Pin4Key\bin\GrepString.bat ' result.Value)
    }
}

^F6:: {
    SetTitleMatchMode(2)
    if WinActive("SQL Server Management Studio") {
        Sleep(100)
        SendText("select top 100 * from DB_GEN..")
    }
}

^F7:: {
    SetTitleMatchMode(2)
    if WinActive("SQL Server Management Studio") {
        Sleep(100)
        SendText("select top 100 * from DB_ADM..")
    }
}

^F8:: {
    SetTitleMatchMode(2)
    if WinActive("SQL Server Management Studio") {
        Sleep(100)
        SendText("select top 100 * from DB_OPD..")
    }
}

^F9:: {
    SetTitleMatchMode(2)
    if WinActive("SQL Server Management Studio") {
        Send("^c")
        if !ClipWait() {
            return
        }
        
        SSMSTitle := WinGetTitle("A")
        SSMSPID := WinGetPID("A")
        
        Run('"\\Hisupdatea\HIS2Tools\QPin.exe" -t="' SSMSTitle '"', , , &OutputVarPID)
        
        WinWait("ahk_pid " OutputVarPID)
        WinActivate("ahk_pid " OutputVarPID)
        WinWaitClose("ahk_pid " OutputVarPID)
        
        WinActivate("ahk_pid " SSMSPID)
        Sleep(100)
        Send("^v")
    }
}

!c:: {
    SetTitleMatchMode(2)
    if WinActive("SQL Server Management Studio") {
        Send("^+c")
        ClipWait()
        Run('"c:\tmptools\Pin4key.exe"')
    }
}

^F11:: {
    SetTitleMatchMode(2)
    if WinActive("SQL Server Management Studio") {
        result1 := InputBox("原本字串:", "Replace")
        if (result1.Result = "OK") {
            result2 := InputBox("取代成:", "Replace")
            if (result2.Result = "OK") {
                ClipStrReplace(result1.Value, result2.Value)
            }
        }
    }
}

; 測試用：查看當前輸入法代碼
^F12:: {
    hwnd := WinExist("A")
    threadId := DllCall("GetWindowThreadProcessId", "UInt", hwnd, "Ptr", 0, "UInt")
    currentIME := DllCall("GetKeyboardLayout", "UInt", threadId, "UInt")
    MsgBox("當前輸入法代碼：" Format("0x{:08X}", currentIME))
}
