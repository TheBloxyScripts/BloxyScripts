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
```
## 2. Text Formats: Plain String or Multi-language (EN / RU)

Across all framework methods (tabs, sections, buttons, toggles, etc.), text can be passed in two ways:

    Plain string (if language switching is not needed): "Main" or "Главная".

    Language table (if you want text to update dynamically when the hub's language changes): {EN = "Main", RU = "Главная"}.

All examples below demonstrate both options.
## 3. Creating Tabs

Tabs divide your hub's functionality into separate categories.
Lua
```lua
-- Multi-language variant:
local Tab = Window:CreateTab({EN = "Main", RU = "Главная"})

-- Plain string variant:
-- local Tab = Window:CreateTab("Главная")
```
## 4. UI Elements
Section

A visual title-divider inside a tab.
Lua
```lua
-- With multi-language:
Tab:AddSection({EN = "Player Settings", RU = "Настройки игрока"})

-- String variant:
-- Tab:AddSection("Настройки игрока")
```
Button

Executes code when clicked by the user.
Lua
```lua
Tab:AddButton({EN = "Teleport to Spawn", RU = "Телепорт на спавн"}, function()
    print("Button clicked!")
end)

-- Or string variant:
-- Tab:AddButton("Телепорт на спавн", function() ... end)
```
Toggle
```lua
An on/off switch with state persistence saved to the configuration.
Lua

Tab:AddToggle({EN = "GodMode", RU = "Бессмертие"}, "GodModeKey", false, function(state)
    if state then
        print("Enabled")
    else
        print("Disabled")
    end
end)
```
    Arguments: Text (or language table), Configuration Key (string), Default Value (true/false), Callback function.

Slider

Selects a numeric value within a specified range.
Lua
```lua
Tab:AddSlider({EN = "WalkSpeed", RU = "Скорость бега"}, "SpeedKey", 16, 250, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```
    Arguments: Text, Configuration Key, Minimum, Maximum, Default Value, Callback function.

Dropdown

Selects a single option from a list.
Lua
```lua
Tab:AddDropdown({EN = "Target Part", RU = "Часть тела"}, "TargetPartKey", {"Head", "HumanoidRootPart"}, "Head", function(selected)
    print("Selected: " .. selected)
end)
```
    Arguments: Text, Configuration Key, Options Table, Default Value, Callback function.

Textbox

A field for user input.
Lua
```lua
Tab:AddTextbox({EN = "Custom Message", RU = "Сообщение"}, "MsgKey", "Hello!", function(text)
    print("Entered: " .. text)
end)
```
    Arguments: Text, Configuration Key, Default Placeholder, Callback function.

Static Label

A simple text hint or label.
Lua
```lua
Tab:AddLabel({EN = "Status: Active", RU = "Статус: Активен"})
```
Dynamic Label

A label that automatically updates its text based on a return value function.
Lua
```lua
Tab:AddDynamicLabel({EN = "FPS: ", RU = "FPS: "}, function()
    return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Receive Kbps"]:GetValue())
end)
```
## 5. Themes & Color Customization

You can programmatically control the interface accent colors (for instance, via settings menu buttons):
Lua
```lua
SettingsTab:AddButton({EN = "Custom Neon Theme", RU = "Неоновая тема"}, function()
    -- Pass a custom Color3 to modify framework accent colors
    UpdateThemeColors(Color3.fromRGB(0, 255, 200))
end)
```
## 6. Full Script Example
```Lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheBloxyScripts/BloxyScripts/main/main.lua"))()

local Window = Library:CreateWindow({
    Name = "BloxyScripts | Hub",
    LoadingTitle = "Loading modules...",
    LoadingSubtitle = "by TheBloxyScripts",
    FolderName = "BloxyConfigs"
})

local Hub = Window or getgenv().CustomHub
if not Hub then
    warn("Error: Main framework not initialized!")
    return
end

local plrs = game:GetService("Players")
local r_service = game:GetService("RunService")
local u_input = game:GetService("UserInputService")
local l_plr = plrs.LocalPlayer
local cam = workspace.CurrentCamera

if _G.ext_loaded then
    if _G.unload_esp then _G.unload_esp() end
end
_G.ext_loaded = true

local state = {
    aim = false,
    esp_box = false,
    esp_hp = false,
    esp_dist = false,
    tracers = false,
    fov = 180,
    max_dist = 1000,
    active = true,
    fov_visible = false,
    wall_check = false
}

local cache = {}
local fov_ring = Drawing.new("Circle")
local current_target_player = nil

_G.unload_esp = function()
    state.active = false
    for _, item in pairs(cache) do
        if item.line then item.line:Remove() end
        if item.box then item.box:Remove() end
        if item.hpText then item.hpText:Remove() end
        if item.distText then item.distText:Remove() end
    end
    table.clear(cache)
    if fov_ring then fov_ring:Remove() end
end

fov_ring.Visible = false
fov_ring.Thickness = 1.5
fov_ring.Color = Color3.fromRGB(255, 0, 0)
fov_ring.Filled = false

local function init_draw(p)
    if cache[p] then return end
    cache[p] = {
        line = Drawing.new("Line"), 
        box = Drawing.new("Square"),
        hpText = Drawing.new("Text"),
        distText = Drawing.new("Text")
    }
    cache[p].line.Thickness = 1.5
    cache[p].box.Thickness = 1.5
    cache[p].box.Filled = false
    
    for _, textObj in ipairs({cache[p].hpText, cache[p].distText}) do
        textObj.Size = 13
        textObj.Center = true
        textObj.Outline = true
        textObj.Color = Color3.fromRGB(255, 255, 255)
    end
    cache[p].hpText.Color = Color3.fromRGB(0, 255, 100)
end

local function get_screen_data(pos)
    local screen, visible = cam:WorldToViewportPoint(pos)
    if visible then return Vector2.new(screen.X, screen.Y), true end
    local mid = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local diff = (Vector2.new(screen.X, screen.Y) - mid)
    if diff.Magnitude == 0 then return mid, false end
    local scale = math.min((mid.X - 20) / math.abs(diff.X), (mid.Y - 20) / math.abs(diff.Y))
    return (screen.Z < 0) and (mid - (diff * scale)) or (mid + (diff * scale)), false
end

local function get_best_part(character)
    local parts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
    local bestPart = nil
    local shortestDist = math.huge
    local mid = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    for _, partName in ipairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then
            local screen, visible = cam:WorldToViewportPoint(part.Position)
            if visible then
                local dist = (Vector2.new(screen.X, screen.Y) - mid).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    bestPart = part
                end
            end
        end
    end
    return bestPart
end

local function find_best_target()
    local target_hit = nil
    local near = state.fov
    local mid = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local best_player = nil

    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= l_plr and p.Character then
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local hitPart = get_best_part(p.Character)
                if hitPart then
                    if state.wall_check then
                        local obscuring = cam:GetPartsObscuringTarget({hitPart.Position}, p.Character:GetDescendants())
                        if #obscuring > 0 then continue end
                    end

                    local screen = cam:WorldToViewportPoint(hitPart.Position)
                    local dist = (Vector2.new(screen.X, screen.Y) - mid).Magnitude
                    if dist < near then
                        near = dist
                        target_hit = hitPart
                        best_player = p
                    end
                end
            end
        end
    end
    current_target_player = best_player
    return target_hit
end

local function is_valid_target(player)
    if not player or not player.Character then return false end
    local char = player.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end

    local hitPart = get_best_part(char)
    if not hitPart then return false end

    if state.wall_check then
        local obscuring = cam:GetPartsObscuringTarget({hitPart.Position}, char:GetDescendants())
        if #obscuring > 0 then return false end
    end

    local screen = cam:WorldToViewportPoint(hitPart.Position)
    local mid = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local dist = (Vector2.new(screen.X, screen.Y) - mid).Magnitude

    return dist <= state.fov, hitPart
end

local loop
loop = r_service.RenderStepped:Connect(function()
    if not state.active then 
        loop:Disconnect()
        return 
    end

    local mid = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    fov_ring.Position = mid
    fov_ring.Radius = state.fov
    fov_ring.Visible = state.aim and state.fov_visible

    if state.aim then
        local lock = nil
        local valid, hit_part = is_valid_target(current_target_player)
        if valid then
            lock = hit_part
            fov_ring.Color = Color3.fromRGB(255, 70, 70)
        else
            current_target_player = nil
            lock = find_best_target()
            fov_ring.Color = Color3.fromRGB(255, 255, 255)
        end

        if lock then 
            cam.CFrame = CFrame.new(cam.CFrame.Position, lock.Position)
        end
    else
        current_target_player = nil
        fov_ring.Color = Color3.fromRGB(255, 255, 255)
    end

    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= l_plr then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                init_draw(p)
                local data = cache[p]
                local root = char.HumanoidRootPart
                local head = char:FindFirstChild("Head") or root
                local s_pos, is_on_screen = get_screen_data(root.Position)
                local distance = (cam.CFrame.Position - root.Position).Magnitude
                local color = Color3.fromHSV(math.clamp(distance / state.max_dist, 0, 0.33), 1, 1)

                data.line.From = mid
                data.line.To = s_pos
                data.line.Color = color
                data.line.Visible = state.tracers

                if is_on_screen then
                    local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    local boxPos = Vector2.new(s_pos.X - width / 2, headPos.Y)

                    if state.esp_box then
                        data.box.Size = Vector2.new(width, height)
                        data.box.Position = boxPos
                        data.box.Color = color
                        data.box.Visible = true
                    else
                        data.box.Visible = false
                    end

                    if state.esp_hp then
                        data.hpText.Text = "HP: " .. math.floor(char.Humanoid.Health)
                        data.hpText.Position = Vector2.new(s_pos.X, boxPos.Y - 15)
                        data.hpText.Visible = true
                    else
                        data.hpText.Visible = false
                    end

                    if state.esp_dist then
                        data.distText.Text = math.floor(distance) .. "m"
                        data.distText.Position = Vector2.new(s_pos.X, boxPos.Y + height + 2)
                        data.distText.Visible = true
                    else
                        data.distText.Visible = false
                    end
                else 
                    data.box.Visible = false 
                    data.hpText.Visible = false
                    data.distText.Visible = false
                end
            elseif cache[p] then
                cache[p].line.Visible = false
                cache[p].box.Visible = false
                cache[p].hpText.Visible = false
                cache[p].distText.Visible = false
            end
        end
    end
end)

plrs.PlayerRemoving:Connect(function(p)
    if cache[p] then
        cache[p].line:Remove()
        cache[p].box:Remove()
        cache[p].hpText:Remove()
        cache[p].distText:Remove()
        cache[p] = nil
    end
    if current_target_player == p then
        current_target_player = nil
    end
end)

-- =========================================================
-- FRAMEWORK INTERFACE
-- =========================================================

-- Create "ESP" tab in the hub interface
local EspTab = Hub:CreateTab("ESP")

-- Add a visual section header inside the ESP tab
EspTab:AddSection("Visual Features")

-- Toggle for displaying boxes (Box ESP)
-- Arguments: title text, config key, default value, callback function
EspTab:AddToggle("Box ESP", "EspBox", false, function(s) 
    state.esp_box = s 
end)

-- Toggle for displaying player health (HP)
EspTab:AddToggle("Health (HP)", "EspHp", false, function(s) 
    state.esp_hp = s 
end)

-- Toggle for displaying distance to players
EspTab:AddToggle("Distance", "EspDist", false, function(s) 
    state.esp_dist = s 
end)

-- Toggle for displaying tracer lines to players
EspTab:AddToggle("Tracers (Lines)", "EspTracers", false, function(s) 
    state.tracers = s 
end)

-- Create "Aimbot" tab in the hub interface
local AimTab = Hub:CreateTab("Aimbot")

-- Add section header for aimbot settings
AimTab:AddSection("Auto-Lock Settings")

-- Toggle to enable/disable aimbot function
AimTab:AddToggle("Enable Aimbot", "AimActive", false, function(s) 
    state.aim = s 
end)

-- Toggle for wall check before locking onto target
AimTab:AddToggle("Wall Check", "AimWallCheck", false, function(s) 
    state.wall_check = s 
end)

-- Toggle to display the FOV radius circle on screen
AimTab:AddToggle("Show FOV", "AimFovVis", false, function(s) 
    state.fov_visible = s 
end)

-- Slider to configure the target acquisition FOV radius
-- Arguments: text, config key, minimum, maximum, default value, callback
AimTab:AddSlider("FOV Radius", "AimFovRad", 50, 400, 180, function(val) 
    state.fov = val 
end)


```
