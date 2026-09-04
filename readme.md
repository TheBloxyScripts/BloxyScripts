<h1 align="center">📚 TheBloxyScripts UI Framework</h1>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/language-Lua-yellow" alt="Language">
  <img src="https://img.shields.io/badge/platform-Roblox-red" alt="Platform">
</p>

Welcome to the complete guide for using the **TheBloxyScripts UI Framework**. This framework is designed for building fast, beautiful, and custom user interfaces (cheats and hubs) in Roblox.

The framework supports both plain text and built-in multi-language translation (`EN` / `RU`), automatic configuration saving, and a complete set of controls.

---

## 1. Initialization (Setup & Window Creation)

Before creating any elements, load the library from GitHub and create your main window:

```lua
-- Load the framework from GitHub
local Library = loadstring(game:HttpGet("[https://raw.githubusercontent.com/TheBloxyScripts/BloxyScripts/main/main.lua](https://raw.githubusercontent.com/TheBloxyScripts/BloxyScripts/main/main.lua)"))()

-- Create the main window
local Window = Library:CreateWindow({
    Name = "BloxyScripts | Hub",
    LoadingTitle = "Loading modules...",
    LoadingSubtitle = "by TheBloxyScripts",
    FolderName = "BloxyConfigs" -- Folder for automatic config saving
})

-- Safe access for scripts
local Hub = Window or getgenv().CustomHub
if not Hub then
    warn("Error: Main framework not initialized!")
    return
end
