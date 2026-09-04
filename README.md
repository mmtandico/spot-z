<h1 align="center">⚡ spot-Z</h1>
<p align="center">
  <strong>Spotify Desktop Customization Engine</strong><br>
  Developed by <strong>Zax</strong> (<a href="https://github.com/mmtandico">@mmtandico</a>)
</p>

<p align="center">
  <a href="https://github.com/mmtandico/spot-z"><img src="https://img.shields.io/badge/Project-spot--Z-purple?style=for-the-badge&logo=spotify" alt="Project spot-Z"></a>
  <a href="https://github.com/mmtandico/spot-z"><img src="https://img.shields.io/badge/Developer-Zax-blue?style=for-the-badge" alt="Developer Zax"></a>
  <a href="https://github.com/mmtandico/spot-z/releases"><img src="https://img.shields.io/badge/Version-v1.0.0-green?style=for-the-badge" alt="Version 1.0.0"></a>
</p>

---

## 📖 About spot-Z

**spot-Z** is a powerful command-line tool designed to customize, theme, and extend the official Spotify desktop client. Supports Windows, macOS, and Linux.

```
   ____  ____   ___ _____       _____ 
  / ___||  _ \ / _ \_   _|     |__  / 
  \___ \| |_) | | | || | _____   / /  
   ___) |  __/| |_| || ||_____| / /_  
  |____/|_|    \___/ |_|       /____| 
        SPOTIFY UI THEME & EXTENSION ENGINE
              DEVELOPER: ZAX
```

---

## 🚀 Quick Install (Windows PowerShell)

Install and configure **spot-Z** with a single command:

```powershell
iwr -useb https://raw.githubusercontent.com/mmtandico/spot-z/main/install.ps1 | iex
```

---

## ✨ Features

- **🎨 Theme Customization**: Change color schemes, accents, and styling across the entire Spotify interface.
- **💎 Glassmorphism & Modern CSS**: Inject custom CSS rules for frosted glass, smooth hover cards, and glowing playback bars.
- **🧩 Extensions & Plugins**: Inject client-side scripts to expand Spotify functionality and UI controls.
- **🛍️ In-App Theme Store**: Built-in interactive HUD & Theme Marketplace inside Spotify by **Zax**.
- **🛡️ Safe & Non-Destructive**: Includes automatic backup and 1-click restore functionality to return to stock Spotify at any time.

---

## 🛠️ CLI Usage

```powershell
# Initial setup: create backup and apply styling
spot-z backup apply

# Re-apply after making changes to themes or extensions
spot-z apply

# Restore Spotify back to factory default
spot-z restore

# Enable Spotify Developer Tools (Inspect Elements)
spot-z enable-devtools

# Display help and all available commands
spot-z -h
```

---

## 📁 Repository & Contributing

- **Repository**: [https://github.com/mmtandico/spot-z](https://github.com/mmtandico/spot-z)
- **Issues & Feedback**: [https://github.com/mmtandico/spot-z/issues](https://github.com/mmtandico/spot-z/issues)

---

## 📄 License & Credits

- Developed and maintained by **Zax** ([@mmtandico](https://github.com/mmtandico))
- Based on the open-source [Spicetify CLI](https://github.com/spicetify/cli) project licensed under **LGPL-2.1**
