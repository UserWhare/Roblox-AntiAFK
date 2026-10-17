# Roblox Anti-AFK

A simple **AutoHotkey v2** script for Roblox on Windows. Every **14 minutes** (by default), it briefly switches to Roblox, sends **Space → R → E**, and returns focus to the window you were using.

In the game this was made for, those keys are used to **jump, repair a door, and upgrade a door**. Change the keys if your game uses different controls.

## Requirements

- Windows 10 or 11
- [AutoHotkey v2](https://www.autohotkey.com/) (**v2**, not v1)
- The desktop Roblox client (`RobloxPlayerBeta.exe`)

## Setup

1. Install AutoHotkey v2.
2. Download `Roblox-AntiAFK.ahk` from this repository.
3. Open Roblox and join your game.
4. Double-click `Roblox-AntiAFK.ahk` to run it.
5. Press **F8** to start automatic mode. The first cycle runs immediately.

## Hotkeys

| Key | Action |
| --- | --- |
| **F6** | Show status, jump attempts, last cycle, and next cycle countdown |
| **F7** | Run one cycle immediately, even if automatic mode is off |
| **F8** | Enable or disable automatic mode |
| **F9** | Exit the script |

## Change the interval

Edit this line near the top of `Roblox-AntiAFK.ahk`:

```ahk
intervalMs := 14 * 60 * 1000 ; 14 minutes
```

For example, use `5 * 60 * 1000` for 5 minutes or `10 * 60 * 1000` for 10 minutes. **AutoHotkey timers use milliseconds**, not seconds. Save and reload the script after editing.

## How it works

The script activates the Roblox window, presses **Space** to jump, **R** to repair, and **E** to upgrade, then switches back to your previous window. Roblox needs to come to the foreground briefly, so you may notice a short interruption while using other apps.

The status counter reports **attempted cycles**, not confirmed jumps or upgrades. It resets when the script restarts.

> **Note:** Simulated inputs may not work in every Roblox experience, and this script cannot guarantee that you will avoid idle disconnections. Check the rules of the game you play before using automation.
