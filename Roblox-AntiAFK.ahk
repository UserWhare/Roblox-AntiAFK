#Requires AutoHotkey v2.0
#SingleInstance Force

; Roblox Anti-AFK - GUI Edition (AutoHotkey v2)
; Uses the working focus-and-return method for Roblox.
; Tip: Run as administrator if Roblox does not receive key presses.

robloxWindow := "ahk_exe RobloxPlayerBeta.exe"
antiIntervalMs := 14 * 60 * 1000   ; 14 minutes
skillIntervalMs := 50 * 1000      ; 50 seconds

antiEnabled := false
skillEnabled := false
antiAttempts := 0
skillAttempts := 0
antiNextTick := 0
skillNextTick := 0
isRunning := false
lastAction := "Ready."

; ------------------------- GUI -------------------------
panel := Gui(, "Roblox Anti-AFK | Control Panel")
panel.BackColor := "F5F5F9"
panel.SetFont("s16 bold c512D82", "Segoe UI")
panel.AddText("x20 y12 w435 h32", "ROBLOX ANTI-AFK")
panel.SetFont("s9 c626275", "Segoe UI")
panel.AddText("x20 y46 w435 h19", "One panel for anti-AFK and Unicorn auto-skill")

panel.SetFont("s10 c24242B", "Segoe UI")
panel.AddGroupBox("x18 y76 w444 h145", "Anti-AFK  |  SPACE > R > E")
antiStatusLabel := panel.AddText("x34 y105 w405 h22", "Status: OFF")
antiTimerLabel := panel.AddText("x34 y131 w405 h21", "Next cycle: --:--   |   Attempts: 0")
antiButton := panel.AddButton("x34 y163 w140 h30", "Start Anti-AFK")
antiTestButton := panel.AddButton("x182 y163 w122 h30", "Test (F7)")
panel.AddText("x317 y170 w64 h20", "Minutes:")
antiMinutesInput := panel.AddEdit("x385 y163 w58 h26 Number", "14")

panel.AddGroupBox("x18 y237 w444 h185", "Unicorn Auto-Skill  |  Q")
skillStatusLabel := panel.AddText("x34 y267 w405 h22", "Status: OFF")
skillTimerLabel := panel.AddText("x34 y291 w405 h21", "Next check: --:--   |   Attempts: 0")
skillButton := panel.AddButton("x34 y319 w140 h30", "Start Unicorn")
skillTestButton := panel.AddButton("x182 y319 w122 h30", "Test Q")
panel.AddText("x310 y325 w70 h20", "Seconds:")
skillSecondsInput := panel.AddEdit("x385 y319 w58 h26 Number", "50")
focusCheckbox := panel.AddCheckBox("x34 y360 w409 h23", "Switch to Roblox for Q (interrupts other apps)")
panel.SetFont("s9 c626275", "Segoe UI")
panel.AddText("x34 y389 w406 h19", "Unchecked: Q only works while Roblox is already focused.")

panel.SetFont("s10 c24242B", "Segoe UI")
applyButton := panel.AddButton("x319 y439 w142 h30", "Apply intervals")
panel.SetFont("s9 c626275", "Segoe UI")
panel.AddText("x20 y445 w286 h19", "Change times above, then click Apply.")
robloxStatusLabel := panel.AddText("x20 y488 w441 h22", "Roblox: Checking...")
lastActionLabel := panel.AddText("x20 y512 w441 h38", "Last event: Ready.")
panel.AddText("x20 y552 w444 h34", "F6 = Show panel   F7 = AFK test   F8 = Anti-AFK ON/OFF" . Chr(10) . "F10 = Unicorn ON/OFF   F9 = Exit script")

antiButton.OnEvent("Click", ToggleAntiAFK)
antiTestButton.OnEvent("Click", RunAntiAFK)
skillButton.OnEvent("Click", ToggleUnicorn)
skillTestButton.OnEvent("Click", RunUnicorn)
applyButton.OnEvent("Click", ApplyIntervals)
panel.OnEvent("Close", HidePanel)
panel.OnEvent("Escape", HidePanel)

; Closing the panel hides it. Press F6 to bring it back; F9 exits.
F6::{
    global panel
    panel.Show()
}
F7::RunAntiAFK()
F8::ToggleAntiAFK()
F9::ExitApp()
F10::ToggleUnicorn()

SetTimer(UpdateUI, 1000)
UpdateUI()
panel.Show("w480 h598")

; ------------------------- TIMERS -------------------------
ToggleAntiAFK(*) {
    global antiEnabled, antiIntervalMs, antiNextTick, lastAction

    antiEnabled := !antiEnabled
    if antiEnabled {
        SetTimer(AntiTimer, antiIntervalMs)
        antiNextTick := A_TickCount + antiIntervalMs
        lastAction := "Anti-AFK enabled."
        RunAntiAFK() ; Run one cycle immediately upon activation.
    } else {
        SetTimer(AntiTimer, 0)
        antiNextTick := 0
        lastAction := "Anti-AFK disabled."
    }
    UpdateUI()
}

ToggleUnicorn(*) {
    global skillEnabled, skillIntervalMs, skillNextTick, lastAction

    skillEnabled := !skillEnabled
    if skillEnabled {
        SetTimer(UnicornTimer, skillIntervalMs)
        skillNextTick := A_TickCount + skillIntervalMs
        lastAction := "Unicorn enabled."
        RunUnicorn() ; Try Q immediately upon activation.
    } else {
        SetTimer(UnicornTimer, 0)
        skillNextTick := 0
        lastAction := "Unicorn disabled."
    }
    UpdateUI()
}

AntiTimer(*) {
    global antiNextTick, antiIntervalMs
    antiNextTick := A_TickCount + antiIntervalMs
    RunAntiAFK()
}

UnicornTimer(*) {
    global skillNextTick, skillIntervalMs
    skillNextTick := A_TickCount + skillIntervalMs
    RunUnicorn()
}

ApplyIntervals(*) {
    global antiMinutesInput, skillSecondsInput
    global antiIntervalMs, skillIntervalMs, antiEnabled, skillEnabled
    global antiNextTick, skillNextTick, lastAction

    minutesText := Trim(antiMinutesInput.Value)
    secondsText := Trim(skillSecondsInput.Value)

    if !RegExMatch(minutesText, "^\d+$") || !RegExMatch(secondsText, "^\d+$") {
        MsgBox("Please enter whole numbers for both intervals.", "Invalid intervals", "Icon!")
        return
    }

    minutes := Number(minutesText)
    seconds := Number(secondsText)

    if minutes < 1 || minutes > 120 || seconds < 5 || seconds > 3600 {
        MsgBox("Anti-AFK: 1-120 minutes." . Chr(10) . "Unicorn: 5-3600 seconds.", "Invalid intervals", "Icon!")
        return
    }

    antiIntervalMs := minutes * 60 * 1000
    skillIntervalMs := seconds * 1000

    if antiEnabled {
        SetTimer(AntiTimer, antiIntervalMs)
        antiNextTick := A_TickCount + antiIntervalMs
    }
    if skillEnabled {
        SetTimer(UnicornTimer, skillIntervalMs)
        skillNextTick := A_TickCount + skillIntervalMs
    }

    lastAction := "Intervals updated."
    UpdateUI()
}

; ------------------------- IN-GAME ACTIONS -------------------------
RunAntiAFK(*) {
    global robloxWindow, antiAttempts, isRunning, lastAction

    if isRunning
        return

    hwnd := WinExist(robloxWindow)
    if !hwnd {
        lastAction := "Roblox not found; AFK cycle skipped."
        UpdateUI()
        return
    }

    isRunning := true
    previousWindow := WinExist("A")

    try {
        if WinGetMinMax("ahk_id " hwnd) = -1
            WinRestore("ahk_id " hwnd)

        WinActivate("ahk_id " hwnd)
        if !WinWaitActive("ahk_id " hwnd, , 2) {
            lastAction := "Could not focus Roblox."
            return
        }

        Sleep(200)
        SendEvent("{Space down}")
        Sleep(120)
        SendEvent("{Space up}")

        Sleep(400)
        SendEvent("{r down}")
        Sleep(120)
        SendEvent("{r up}")

        Sleep(500)
        SendEvent("{e down}")
        Sleep(120)
        SendEvent("{e up}")
        Sleep(150)

        antiAttempts++
        lastAction := "AFK cycle sent (SPACE, R, E) at " FormatTime(, "HH:mm:ss")
    } catch as err {
        lastAction := "AFK error: " err.Message
    } finally {
        if previousWindow && WinExist("ahk_id " previousWindow)
            && !WinActive("ahk_id " previousWindow) {
            WinActivate("ahk_id " previousWindow)
        }
        isRunning := false
        UpdateUI()
    }
}

RunUnicorn(*) {
    global robloxWindow, skillAttempts, isRunning, lastAction, focusCheckbox

    if isRunning
        return

    hwnd := WinExist(robloxWindow)
    if !hwnd {
        lastAction := "Roblox not found; Unicorn check skipped."
        UpdateUI()
        return
    }

    allowFocusSwitch := focusCheckbox.Value = 1
    if !allowFocusSwitch && !WinActive("ahk_id " hwnd) {
        lastAction := "Unicorn skipped: Roblox is not focused."
        UpdateUI()
        return
    }

    isRunning := true
    previousWindow := WinExist("A")

    try {
        if allowFocusSwitch {
            if WinGetMinMax("ahk_id " hwnd) = -1
                WinRestore("ahk_id " hwnd)
            WinActivate("ahk_id " hwnd)
            if !WinWaitActive("ahk_id " hwnd, , 2) {
                lastAction := "Could not focus Roblox for Unicorn."
                return
            }
            Sleep(200)
        }

        SendEvent("{q down}")
        Sleep(120)
        SendEvent("{q up}")
        Sleep(150)

        skillAttempts++
        lastAction := "Unicorn Q sent at " FormatTime(, "HH:mm:ss")
    } catch as err {
        lastAction := "Unicorn error: " err.Message
    } finally {
        if allowFocusSwitch && previousWindow
            && WinExist("ahk_id " previousWindow)
            && !WinActive("ahk_id " previousWindow) {
            WinActivate("ahk_id " previousWindow)
        }
        isRunning := false
        UpdateUI()
    }
}

; ------------------------- UI HELPERS -------------------------
HidePanel(*) {
    global panel
    panel.Hide()
}

Countdown(nextTick) {
    if nextTick = 0
        return "--:--"

    remaining := Max(0, nextTick - A_TickCount)
    minutes := Floor(remaining / 60000)
    seconds := Mod(Floor(remaining / 1000), 60)
    return Format("{:02}:{:02}", minutes, seconds)
}

UpdateUI(*) {
    global robloxWindow, antiEnabled, skillEnabled, antiAttempts, skillAttempts
    global antiNextTick, skillNextTick, antiButton, skillButton
    global antiStatusLabel, skillStatusLabel, antiTimerLabel, skillTimerLabel
    global robloxStatusLabel, lastActionLabel, lastAction

    antiStatusLabel.Text := "Status: " (antiEnabled ? "ON" : "OFF")
    skillStatusLabel.Text := "Status: " (skillEnabled ? "ON" : "OFF")
    antiButton.Text := antiEnabled ? "Stop Anti-AFK" : "Start Anti-AFK"
    skillButton.Text := skillEnabled ? "Stop Unicorn" : "Start Unicorn"

    antiTimerLabel.Text := "Next cycle: " Countdown(antiNextTick)
        . "   |   Attempts: " antiAttempts
    skillTimerLabel.Text := "Next check: " Countdown(skillNextTick)
        . "   |   Q attempts: " skillAttempts

    robloxStatusLabel.Text := "Roblox: " (WinExist(robloxWindow) ? "Detected" : "Not running")
    lastActionLabel.Text := "Last event: " lastAction
}
