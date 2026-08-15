<div align="center">
<a href="https://www.roblox.com/games/93978595733734/Violence-District">
  <img src="https://static.wikia.nocookie.net/roblox/images/7/78/VDIcon.webp/revision/latest?cb=20260713154719" width="240">
</a>

# zryx — Aimbot & Utility

Advanced Lua script for **Roblox Violence District** featuring Aimbot, Aimlock, ESP, auto-parry, movement hacks, and a fully customizable UI.

![Lua](https://img.shields.io/badge/Language-Lua-2C2D72?style=for-the-badge&logo=lua)
![Roblox](https://img.shields.io/badge/Platform-Roblox-E2231A?style=for-the-badge&logo=roblox)
![Status](https://img.shields.io/badge/Status-Active-22C55E?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-v1.0-blue?style=for-the-badge)
![Executors](https://img.shields.io/badge/Executors-Keyless-6B21A8?style=for-the-badge)

</div>

---

## ✨ Features

- **Combat**  
  - Aimbot & Aimlock with adjustable strength, prediction and target selection (All / Killer / Survivor / SCP)  
  - Selectable aim part (Head / HumanoidRootPart), custom FOV and FOV circle  
  - Auto-parry that reacts to killer attack animations in real time  
  - Auto carry & hook for killers  
  - Masked powers (Cobra, Richter, Brandon, Rabbit, Alex) with activate/deactivate

- **ESP System**  
  - Highlights Survivors, Killers, Generators, Pallets, Windows and SCPs  
  - Generator repair percentage shown directly above the machine  
  - Optional status ESP displaying name, distance and health  
  - Configurable radius for every ESP type  

- **Survivor Utilities**  
  - God Mode, Auto Skill Check, Fast Vault and instant escape  
  - Morph avatar support  
  - Auto Stalk (killer) to auto-track nearby survivors

- **Movement**  
  - WalkSpeed override with smart disabling during animations  
  - No Clip toggle  
  - Moonwalk sway (no forward/backward movement) with keybind, spam speed and intensity

- **Visuals & QoL**  
  - Ambient/clock controls, camera zoom and FOV  
  - Custom theme with save/load system

---

## 🛠️ Installation & Usage

1. **Get the script**  
   - Copy the raw content of `zryxvd.lua` from this repository.

2. **Inject with a Roblox executor**  
   - Use any modern keyless executor (Xeno, Delta, Solara, Velocity, etc.).

3. **Paste and execute**  
   - Paste the script into your executor and run it.

4. **Configure the GUI**  
   - Open the menu with **Right Shift** (or the toggle button on screen).  
   - Enable Aimbot, ESP or whatever you need from the tabs.  
   - All settings are saved automatically per account.

5. **Let it run**  
   - The script handles the rest — aim, parry, ESP and movement.

---

### 📥 One-Liner Execution
Copy and paste this line into your executor and run it:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/zaerrruwww/zryx-vd/main/zryxvd.lua"))()
```

## ⚙️ Configuration Options

| Option | Description |
|--------|-------------|
| **Aimbot / Aimlock** | Auto-aim at enemies while holding right click. |
| **FOV Circle** | Shows the aimbot FOV radius on screen. |
| **ESP** | Highlight players, generators, pallets, windows and SCPs. |
| **Auto Parry** | Perfect parry against killer attacks automatically. |
| **Auto Skill Check** | Hits perfect skill checks on generators. |
| **God Mode** | Prevents death/down state. |
| **No Clip** | Walk through walls. |
| **Moonwalk** | In-place sway with custom keybind and intensity. |
| **WalkSpeed** | Movement speed override. |
| **Menu Keybind** | Custom key to open/close the UI (default: `Right Shift`). |
| **Theme & Save** | UI appearance tweaks with persistent config. |

---

## ⌨️ Default Keybinds

| Action | Key |
|--------|-----|
| **Open/Close GUI** | `Right Shift` |
| **Aimbot / Aimlock** | Hold `Right Click` |
| **Moonwalk** | *Via UI toggle* |

> *All other options are controlled through the graphical interface.*

---

## 📦 File Structure

- `zryxvd.lua` – Main script, loads the WindUI library and runs all features.  
- *External dependencies*:  
  - [WindUI Library](https://github.com/Footagesus/WindUI) (loaded remotely)  
  - Built-in config system for UI theming and config persistence.

---

## ⚠️ Disclaimer

> **This script is intended for educational purposes only.**  
> Using automation tools in Roblox violates Roblox's Terms of Service.  
> **Use at your own risk.** The developers are not responsible for any account bans, warnings, or data loss.

---

## 🙏 Credits

- **WindUI** – by [Footagesus](https://github.com/Footagesus)

---

## 📝 Changelog

- **v1.0.0** – Initial release  
  - Aimbot, Aimlock & FOV with prediction  
  - Full ESP system with status & radius  
  - Auto-parry, auto skill check, god mode  
  - No Clip, Moonwalk, walk speed override, masked powers  
  - Custom theme with save/load

---

*Happy gaming… but remember – play fair!* 😉