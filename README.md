# ⚡ Spot-Z CLI
> **Spotify Desktop Customization Engine**  
> **Developer: Zax**

Command-line tool to customize the official Spotify client with themes, CSS, and extensions.  
Supports Windows, macOS, and Linux.

---

## 🚀 Quick Install (PowerShell)

Run the following command in PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/mmtandico/spot-z/main/install.ps1 | iex
```

---

## ✨ Features

- **Custom Themes**: Change colors across the entire Spotify user interface
- **CSS Injection**: Inject custom CSS for advanced styling, glassmorphism, and layouts
- **Extensions**: Inject JavaScript extensions to extend functionalities, manipulate UI, and control playback
- **Custom Apps**: Load custom web apps inside Spotify
- **Full Control**: Backup, apply, and restore your client at any time

---

## 🛠️ Basic Usage

```powershell
# Backup and apply customization
spot-z backup apply

# Re-apply after editing styles or extensions
spot-z apply

# Revert Spotify to original stock state
spot-z restore

# Help & command list
spot-z -h
```

---

## 📄 License & Credits

- Maintained and customized by **Zax** ([@mmtandico](https://github.com/mmtandico))
- Based on the open-source [Spicetify CLI](https://github.com/spicetify/cli) project licensed under **LGPL-2.1**
