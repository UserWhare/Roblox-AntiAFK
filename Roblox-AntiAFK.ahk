#Requires AutoHotkey v2.0
#SingleInstance Force

; =====================================
; ROBLOX ANTI-AFK
; =====================================

; Settings
robloxWindow := "ahk_exe RobloxPlayerBeta.exe"
intervalMs := 14 * 60 * 1000 ; 14 minutes

isEnabled := false
jumpCount := 0
lastCycle := "None"
nextCycleTick := 0
isRunning := false

; F8 - Enable / disable automatic mode
F8::{
    global isEnabled, intervalMs, nextCycleTick

    isEnabled := !isEnabled

    if isEnabled {
        SetTimer(RunAutomaticCycle, intervalMs)
        nextCycleTick := A_TickCount + intervalMs
        ShowNotification("ANTI-AFK ENABLED - 14 MIN")
        RunCycle()
    } else {
        SetTimer(RunAutomaticCycle, 0)
        nextCycleTick := 0
        ShowNotification("ANTI-AFK DISABLED")
    }
}

; F7 - Run a test cycle immediately
F7::RunCycle()

; F6 - Show statistics and status
F6::{
    global isEnabled, jumpCount, lastCycle, nextCycleTick, intervalMs

    status := isEnabled ? "ENABLED" : "DISABLED"
    nextCycle := "Disabled"

    if isEnabled {
        remainingMs := Max(0, nextCycleTick - A_TickCount)
        minutes := Floor(remainingMs / 60000)
        seconds := Mod(Floor(remainingMs / 1000), 60)
        nextCycle := Format("{:02}:{:02}", minutes, seconds)
    }

    MsgBox(
        "ROBLOX ANTI-AFK"
        . "`n"
        . "`nStatus: " status
        . "`nJump attempts: " jumpCount
        . "`nLast cycle: " lastCycle
        . "`nNext cycle in: " nextCycle
        . "`nInterval: " Round(intervalMs / 60000, 2) " minutes"
        . "`nActions: SPACE + R + E",
        "Anti-AFK | Information"
    )
}

; F9 - Exit the script
F9::ExitApp()

; Scheduled cycle
RunAutomaticCycle() {
    global nextCycleTick, intervalMs

    nextCycleTick := A_TickCount + intervalMs
    RunCycle()
}

; Focus Roblox, send the keys, then restore the previous window
RunCycle() {
    global robloxWindow, jumpCount, lastCycle, isRunning

    if isRunning
        return

    robloxHwnd := WinExist(robloxWindow)

    if !robloxHwnd {
        ShowNotification("Roblox was not found!")
        return
    }

    isRunning := true
    previousWindow := WinExist("A")

    try {
        ; Restore Roblox if minimized
        if WinGetMinMax("ahk_id " robloxHwnd) = -1
            WinRestore("ahk_id " robloxHwnd)

        ; Switch focus to Roblox
        WinActivate("ahk_id " robloxHwnd)

        if !WinWaitActive("ahk_id " robloxHwnd, , 2)
            return

        Sleep(200)

        ; 1. Jump (SPACE)
        SendEvent("{Space down}")
        Sleep(120)
        SendEvent("{Space up}")

        Sleep(400)

        ; 2. Repair the door (R)
        SendEvent("{r down}")
        Sleep(120)
        SendEvent("{r up}")

        Sleep(500)

        ; 3. Upgrade the door (E)
        SendEvent("{e down}")
        Sleep(120)
        SendEvent("{e up}")

        Sleep(150)

        ; Update statistics (attempted actions, not verified in-game)
        jumpCount++
        lastCycle := FormatTime(, "HH:mm:ss")

    } catch as error {
        ShowNotification("Error: " error.Message)

    } finally {
        ; Return focus to the previously active window
        if previousWindow
            && previousWindow != robloxHwnd
            && WinExist("ahk_id " previousWindow)
            && !WinActive("ahk_id " previousWindow) {
            WinActivate("ahk_id " previousWindow)
        }

        isRunning := false
    }
}

ShowNotification(message) {
    ToolTip(message)
    SetTimer(HideNotification, -1500)
}

HideNotification() {
    ToolTip()
}
