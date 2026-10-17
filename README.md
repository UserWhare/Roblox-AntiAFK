# Roblox Anti-AFK — GUI Edition

A lightweight, open-source **AutoHotkey v2** control panel for Roblox on Windows. Use your PC normally while the Anti-AFK script briefly switches to Roblox, performs its actions, and returns to your previous window.

![Roblox Anti-AFK GUI preview](https://i.imgur.com/KP168Mx.png)

## Features

- **Anti-AFK:** Every **14 minutes** by default, switches to Roblox, presses **SPACE** (jump), **R** (repair door), and **E** (upgrade door), then switches back.
- **Unicorn Auto-Skill:** Independently presses **Q** every **50 seconds** by default.
- **GUI controls:** Start/stop each feature, customize both intervals, test actions, and see status, counters, and next-cycle countdowns.
- **Focus control for Unicorn:** Choose whether Q is only used while Roblox is focused or whether the script briefly switches to Roblox to send it.

## Requirements

- Windows 10 or 11
- [AutoHotkey v2](https://www.autohotkey.com/) (not v1)
- Desktop Roblox client (`RobloxPlayerBeta.exe`)

## How to use

1. Install **AutoHotkey v2**.
2. Download `Roblox-AntiAFK.ahk` from this repository.
3. **Recommended: Run the script as administrator**, especially if Roblox doesn't respond to the key presses. On Windows, right-click the `.ahk` file and choose **Run as administrator** (or use the AutoHotkey launcher option). Only grant administrator access to scripts you trust.
4. Open Roblox and join your game.
5. Use the panel to enable **Anti-AFK** and/or **Unicorn Auto-Skill**. Change either interval and click **Apply intervals**.

## Keyboard shortcuts

| Key | Action |
| --- | --- |
| **F6** | Show the control panel |
| **F7** | Test SPACE → R → E once |
| **F8** | Enable/disable Anti-AFK |
| **F9** | Exit the script |
| **F10** | Enable/disable Unicorn Auto-Skill |

Closing the panel with **X** only hides it. Press **F6** to show it again, or **F9** to fully exit.

## Using other apps while farming

Anti-AFK briefly activates Roblox, sends **SPACE → R → E**, then returns you to your previously active window. You can keep browsing, reading, using Discord, or watching videos, but you'll see a short focus change when each cycle runs.

**Unicorn Auto-Skill** has its own checkbox: `Switch to Roblox for Q`.

- **Unchecked (default):** Q is sent only if Roblox is already the active window. Checks are skipped while you use other apps.
- **Checked:** Briefly activates Roblox every 50 seconds (or your configured interval), sends Q, then returns focus to your previous window.

## Notes

- Counters track **attempted key sends**, not confirmed in-game actions.
- Some Roblox experiences may ignore simulated input. This script **does not guarantee** avoiding idle disconnections.
- The game may have rules regarding automation; check them before using the script.
- This is an independent community project and is not affiliated with Roblox.
