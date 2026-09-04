local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Library = {}

local ConfigFolder = "BloxyHubConfigs"
local DefaultConfigName = "settings.json"

if makefolder and not isfolder(ConfigFolder) then
    pcall(function() makefolder(ConfigFolder) end)
end

local function GetExecutorName()
    local success, name = pcall(function()
        if identifyexecutor then
            local execName, execVer = identifyexecutor()
            return execName .. (execVer and (" " .. tostring(execVer)) or "")
        elseif getexecutorname then
            return getexecutorname()
        elseif syn then
            return "Synapse X"
        elseif KRNL_LOADED then
            return "Krnl"
        elseif FLUXUS_LOADED then
            return "Fluxus"
        elseif Delta then
            return "Delta"
        elseif Celery then
            return "Celery"
        elseif Solara then
            return "Solara"
        else
            return "Unknown"
        end
    end)
    return success and name or "Unknown"
end

local function GetGameName()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success and info and info.Name then
        return info.Name
    end
    return "Roblox Game"
end

function Library:CreateWindow(settings)
    settings = settings or {}
    local windowName = settings.Name or "Universal Hub"
    local loadingTitle = settings.LoadingTitle or windowName
    local loadingSubtitle = settings.LoadingSubtitle or "by Developer"

    local Config = {
        AccentColorR = 115,
        AccentColorG = 80,
        AccentColorB = 255,
        Transparency = 0,
        CornerRadius = 12,
        Language = "RU"
    }

    local LocalizedElements = {}
    local AccentElements = {}
    local AllCorners = {}
    local AllFrames = {}
    local UIElementUpdaters = {}

    local function GetAccentColor()
        return Color3.fromRGB(Config.AccentColorR, Config.AccentColorG, Config.AccentColorB)
    end

    local Theme = {
        Background = Color3.fromRGB(20, 20, 26),
        Header     = Color3.fromRGB(15, 15, 20),
        Sidebar    = Color3.fromRGB(18, 18, 24),
        Text       = Color3.fromRGB(255, 255, 255),
        TextDark   = Color3.fromRGB(140, 140, 155),
        ElementBg  = Color3.fromRGB(28, 28, 36),
        ToggleOff  = Color3.fromRGB(45, 45, 55)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = windowName .. "UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui

    local SplashFrame = Instance.new("Frame")
    SplashFrame.Size = UDim2.fromOffset(220, 150)
    SplashFrame.Position = UDim2.fromScale(0.5, 0.5)
    SplashFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SplashFrame.BackgroundColor3 = Theme.Background
    SplashFrame.BorderSizePixel = 0
    SplashFrame.ClipsDescendants = true
    SplashFrame.Parent = ScreenGui

    local SplashCorner = Instance.new("UICorner")
    SplashCorner.CornerRadius = UDim.new(0, 12)
    SplashCorner.Parent = SplashFrame

    local SplashStroke = Instance.new("UIStroke")
    SplashStroke.Thickness = 1.5
    SplashStroke.Color = GetAccentColor()
    SplashStroke.Parent = SplashFrame
    table.insert(AccentElements, SplashStroke)

    local SplashLogo = Instance.new("TextLabel")
    SplashLogo.Text = "⚡"
    SplashLogo.Size = UDim2.fromOffset(40, 40)
    SplashLogo.Position = UDim2.new(0.5, -20, 0.2, -20)
    SplashLogo.BackgroundTransparency = 1
    SplashLogo.TextSize = 28
    SplashLogo.Parent = SplashFrame

    local SplashTitle = Instance.new("TextLabel")
    SplashTitle.Text = loadingTitle
    SplashTitle.Size = UDim2.new(1, 0, 0, 20)
    SplashTitle.Position = UDim2.new(0, 0, 0.5, 0)
    SplashTitle.TextColor3 = Theme.Text
    SplashTitle.Font = Enum.Font.GothamBold
    SplashTitle.TextSize = 13
    SplashTitle.BackgroundTransparency = 1
    SplashTitle.Parent = SplashFrame

    local SplashSub = Instance.new("TextLabel")
    SplashSub.Text = loadingSubtitle
    SplashSub.Size = UDim2.new(1, 0, 0, 15)
    SplashSub.Position = UDim2.new(0, 0, 0.65, 0)
    SplashSub.TextColor3 = Theme.TextDark
    SplashSub.Font = Enum.Font.Gotham
    SplashSub.TextSize = 10
    SplashSub.BackgroundTransparency = 1
    SplashSub.Parent = SplashFrame

    local LoadingBarBg = Instance.new("Frame")
    LoadingBarBg.Size = UDim2.new(0.7, 0, 0, 4)
    LoadingBarBg.Position = UDim2.new(0.15, 0, 0.82, 0)
    LoadingBarBg.BackgroundColor3 = Theme.ElementBg
    LoadingBarBg.BorderSizePixel = 0
    LoadingBarBg.Parent = SplashFrame

    local LoadingBarBgCorner = Instance.new("UICorner")
    LoadingBarBgCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarBgCorner.Parent = LoadingBarBg

    local LoadingBarFill = Instance.new("Frame")
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    LoadingBarFill.BackgroundColor3 = GetAccentColor()
    LoadingBarFill.BorderSizePixel = 0
    LoadingBarFill.Parent = LoadingBarBg
    table.insert(AccentElements, LoadingBarFill)

    local LoadingBarFillCorner = Instance.new("UICorner")
    LoadingBarFillCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarFillCorner.Parent = LoadingBarFill

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.fromOffset(540, 370)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = Config.Transparency / 100
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = false
    Main.Parent = ScreenGui
    table.insert(AllFrames, Main)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, Config.CornerRadius)
    MainCorner.Parent = Main
    table.insert(AllCorners, MainCorner)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.5
    MainStroke.Color = GetAccentColor()
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = Main
    table.insert(AccentElements, MainStroke)

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Theme.Header
    Header.BackgroundTransparency = Config.Transparency / 100
    Header.BorderSizePixel = 0
    Header.Parent = Main
    table.insert(AllFrames, Header)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, Config.CornerRadius)
    HeaderCorner.Parent = Header
    table.insert(AllCorners, HeaderCorner)

    local Title = Instance.new("TextLabel")
    Title.Text = windowName
    Title.Size = UDim2.new(1, -85, 1, 0)
    Title.Position = UDim2.fromOffset(15, 0)
    Title.TextColor3 = Theme.Text
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = Header

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.fromOffset(30, 30)
    MinimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
    MinimizeBtn.BackgroundColor3 = Theme.ElementBg
    MinimizeBtn.BackgroundTransparency = Config.Transparency / 100
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Theme.Text
    MinimizeBtn.TextSize = 18
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = Header
    table.insert(AllFrames, MinimizeBtn)

    local MinBtnCorner = Instance.new("UICorner")
    MinBtnCorner.CornerRadius = UDim.new(0, 6)
    MinBtnCorner.Parent = MinimizeBtn
    table.insert(AllCorners, MinBtnCorner)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(30, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    CloseBtn.BackgroundTransparency = Config.Transparency / 100
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.Text
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.fromOffset(0, 40)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.Parent = Main

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 8)
    SidebarPadding.PaddingLeft = UDim.new(0, 6)
    SidebarPadding.PaddingRight = UDim.new(0, 6)
    SidebarPadding.PaddingBottom = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarList.AbsoluteContentSize.Y + 20)
    end)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -150, 1, -50)
    Container.Position = UDim2.fromOffset(145, 45)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local MobileIcon = Instance.new("TextButton")
    MobileIcon.Size = UDim2.fromOffset(42, 42)
    MobileIcon.Position = UDim2.new(0, 15, 0.4, 0)
    MobileIcon.BackgroundColor3 = GetAccentColor()
    MobileIcon.Text = "⚡"
    MobileIcon.TextSize = 20
    MobileIcon.Visible = false
    MobileIcon.Parent = ScreenGui
    table.insert(AccentElements, MobileIcon)

    local MobileCorner = Instance.new("UICorner")
    MobileCorner.CornerRadius = UDim.new(1, 0)
    MobileCorner.Parent = MobileIcon

    local MobileStroke = Instance.new("UIStroke")
    MobileStroke.Thickness = 1.5
    MobileStroke.Color = Theme.Text
    MobileStroke.Parent = MobileIcon

    local function ToggleUI()
        Main.Visible = not Main.Visible
        MobileIcon.Visible = not Main.Visible
    end

    MinimizeBtn.MouseButton1Click:Connect(ToggleUI)
    MobileIcon.MouseButton1Click:Connect(ToggleUI)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end
    end)

    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local function ApplyConfig()
        local newAccent = GetAccentColor()
        for _, elem in ipairs(AccentElements) do
            if elem then
                if elem:IsA("TextButton") or elem:IsA("Frame") then
                    TweenService:Create(elem, TweenInfo.new(0.2), {BackgroundColor3 = newAccent}):Play()
                elseif elem:IsA("UIStroke") then
                    elem.Color = newAccent
                end
            end
        end
        for _, frame in ipairs(AllFrames) do
            if frame and frame.Parent then
                frame.BackgroundTransparency = Config.Transparency / 100
            end
        end
        for _, corner in ipairs(AllCorners) do
            if corner and corner.Parent then
                corner.CornerRadius = UDim.new(0, Config.CornerRadius)
            end
        end
    end

    local WindowAPI = {}
    local Tabs = {}
    local FirstTab = true

    function WindowAPI:CreateTab(tabName, customOrder)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Theme.ElementBg
        TabBtn.BackgroundTransparency = Config.Transparency / 100
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TextDark
        TabBtn.TextSize = 11
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.LayoutOrder = customOrder or 50
        TabBtn.Parent = Sidebar
        table.insert(AllFrames, TabBtn)

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, Config.CornerRadius)
        BtnCorner.Parent = TabBtn
        table.insert(AllCorners, BtnCorner)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.Parent = Container

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 6)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingBottom = UDim.new(0, 15)
        PagePadding.Parent = Page

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
        end)

        if FirstTab then
            FirstTab = false
            Page.Visible = true
            TabBtn.TextColor3 = Theme.Text
            TabBtn.BackgroundColor3 = GetAccentColor()
            table.insert(AccentElements, TabBtn)
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Btn.TextColor3 = Theme.TextDark
                t.Btn.BackgroundColor3 = Theme.ElementBg
                local idx = table.find(AccentElements, t.Btn)
                if idx then table.remove(AccentElements, idx) end
            end
            Page.Visible = true
            TabBtn.TextColor3 = Theme.Text
            table.insert(AccentElements, TabBtn)
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = GetAccentColor()}):Play()
        end)

        table.insert(Tabs, {Page = Page, Btn = TabBtn})

        local Elements = {Page = Page}

        function Elements:AddSection(sectionTitle)
            local Label = Instance.new("TextLabel")
            Label.Text = string.upper(sectionTitle)
            Label.Size = UDim2.new(1, -5, 0, 20)
            Label.TextColor3 = Theme.TextDark
            Label.TextSize = 10
            Label.Font = Enum.Font.GothamBold
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Page
        end

        function Elements:AddButton(btnText, onClick)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 32)
            Btn.BackgroundColor3 = Theme.ElementBg
            Btn.BackgroundTransparency = Config.Transparency / 100
            Btn.Text = btnText
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 11
            Btn.Font = Enum.Font.GothamMedium
            Btn.Parent = Page
            table.insert(AllFrames, Btn)

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, Config.CornerRadius)
            BCorner.Parent = Btn
            table.insert(AllCorners, BCorner)

            Btn.MouseButton1Click:Connect(function() if onClick then onClick() end end)
        end

        function Elements:AddToggle(toggleText, configKey, default, callback)
            local state = Config[configKey] ~= nil and Config[configKey] or (default or false)
            Config[configKey] = state

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -5, 0, 36)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Config.Transparency / 100
            Frame.Parent = Page
            table.insert(AllFrames, Frame)

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(0, Config.CornerRadius)
            FCorner.Parent = Frame
            table.insert(AllCorners, FCorner)

            local Label = Instance.new("TextLabel")
            Label.Text = toggleText
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Position = UDim2.fromOffset(10, 0)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.fromOffset(36, 18)
            Switch.Position = UDim2.new(1, -44, 0.5, -9)
            Switch.BackgroundColor3 = state and GetAccentColor() or Theme.ToggleOff
            Switch.Text = ""
            Switch.Parent = Frame

            if state then table.insert(AccentElements, Switch) end

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = Switch

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.fromOffset(14, 14)
            Circle.Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
            Circle.BackgroundColor3 = Theme.Text
            Circle.Parent = Switch

            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(1, 0)
            CCorner.Parent = Circle

            local function UpdateVisual(newState)
                state = newState
                Config[configKey] = state
                local targetPos = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
                local targetColor = state and GetAccentColor() or Theme.ToggleOff

                if state then
                    if not table.find(AccentElements, Switch) then table.insert(AccentElements, Switch) end
                else
                    local idx = table.find(AccentElements, Switch)
                    if idx then table.remove(AccentElements, idx) end
                end

                Circle:TweenPosition(targetPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()

                if callback then callback(state) end
            end

            Switch.MouseButton1Click:Connect(function() UpdateVisual(not state) end)
            
            table.insert(UIElementUpdaters, {
                Key = configKey,
                Update = function(val) UpdateVisual(val) end
            })

            if callback then callback(state) end
        end

        function Elements:AddSlider(sliderText, configKey, min, max, default, callback)
            local defaultVal = Config[configKey] ~= nil and Config[configKey] or (default or min)
            Config[configKey] = defaultVal

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -5, 0, 45)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Config.Transparency / 100
            Frame.Parent = Page
            table.insert(AllFrames, Frame)

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(0, Config.CornerRadius)
            FCorner.Parent = Frame
            table.insert(AllCorners, FCorner)

            local Label = Instance.new("TextLabel")
            Label.Text = sliderText .. ": " .. tostring(defaultVal)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.fromOffset(10, 2)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -20, 0, 6)
            Track.Position = UDim2.fromOffset(10, 28)
            Track.BackgroundColor3 = Theme.ToggleOff
            Track.Parent = Frame

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(1, 0)
            TCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((defaultVal - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = GetAccentColor()
            Fill.Parent = Track
            table.insert(AccentElements, Fill)

            local FCorner2 = Instance.new("UICorner")
            FCorner2.CornerRadius = UDim.new(1, 0)
            FCorner2.Parent = Fill

            local function SetSliderValue(val)
                val = math.clamp(val, min, max)
                Config[configKey] = val
                local pos = math.clamp((val - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Label.Text = sliderText .. ": " .. tostring(val)
                if callback then callback(val) end
            end

            local sliding = false
            local function UpdateFromInput(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos + 0.5)
                SetSliderValue(value)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    UpdateFromInput(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateFromInput(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            table.insert(UIElementUpdaters, {
                Key = configKey,
                Update = function(val) SetSliderValue(val) end
            })

            if callback then callback(defaultVal) end
        end

        function Elements:AddColorPicker(pickerText, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -5, 0, 36)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Config.Transparency / 100
            Frame.Parent = Page
            table.insert(AllFrames, Frame)

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(0, Config.CornerRadius)
            FCorner.Parent = Frame
            table.insert(AllCorners, FCorner)

            local Label = Instance.new("TextLabel")
            Label.Text = pickerText
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Position = UDim2.fromOffset(10, 0)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            local Preview = Instance.new("TextButton")
            Preview.Size = UDim2.fromOffset(36, 18)
            Preview.Position = UDim2.new(1, -44, 0.5, -9)
            Preview.BackgroundColor3 = GetAccentColor()
            Preview.Text = ""
            Preview.Parent = Frame
            table.insert(AccentElements, Preview)

            local PCorner = Instance.new("UICorner")
            PCorner.CornerRadius = UDim.new(0, 4)
            PCorner.Parent = Preview

            local colors = {
                Color3.fromRGB(115, 80, 255),
                Color3.fromRGB(50, 130, 255),
                Color3.fromRGB(50, 205, 90),
                Color3.fromRGB(255, 60, 60),
                Color3.fromRGB(255, 165, 0)
            }
            local colorIdx = 1

            Preview.MouseButton1Click:Connect(function()
                colorIdx = colorIdx % #colors + 1
                local chosenColor = colors[colorIdx]
                if callback then callback(chosenColor) end
            end)
        end

        function Elements:AddDropdown(dropdownText, configKey, options, defaultOption, callback)
            options = options or {"Нет элементов"}
            local selected = defaultOption or options[1]
            Config[configKey] = selected

            local opened = false
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -5, 0, 36)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Config.Transparency / 100
            Frame.ClipsDescendants = true
            Frame.Parent = Page
            table.insert(AllFrames, Frame)

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(0, Config.CornerRadius)
            FCorner.Parent = Frame
            table.insert(AllCorners, FCorner)

            local Label = Instance.new("TextLabel")
            Label.Text = dropdownText .. ": " .. tostring(selected)
            Label.Size = UDim2.new(1, -20, 0, 36)
            Label.Position = UDim2.fromOffset(10, 0)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            local Arrow = Instance.new("TextLabel")
            Arrow.Text = "▼"
            Arrow.Size = UDim2.fromOffset(20, 36)
            Arrow.Position = UDim2.new(1, -25, 0, 0)
            Arrow.TextColor3 = Theme.TextDark
            Arrow.TextSize = 10
            Arrow.BackgroundTransparency = 1
            Arrow.Parent = Frame

            local DropList = Instance.new("ScrollingFrame")
            DropList.Size = UDim2.new(1, 0, 0, 0)
            DropList.Position = UDim2.fromOffset(0, 36)
            DropList.BackgroundTransparency = 1
            DropList.BorderSizePixel = 0
            DropList.ScrollBarThickness = 2
            DropList.Parent = Frame

            local DropLayout = Instance.new("UIListLayout")
            DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropLayout.Parent = DropList

            local function RebuildList(newOpts)
                options = newOpts or options
                for _, child in ipairs(DropList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end

                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptBtn.BackgroundColor3 = Theme.ElementBg
                    OptBtn.BackgroundTransparency = 1
                    OptBtn.Text = "   " .. tostring(opt)
                    OptBtn.TextColor3 = Theme.TextDark
                    OptBtn.TextSize = 11
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.Parent = DropList

                    OptBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        Config[configKey] = selected
                        Label.Text = dropdownText .. ": " .. tostring(selected)
                        opened = false
                        Arrow.Text = "▼"
                        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, 36)}):Play()
                        TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                        if callback then callback(selected) end
                    end)
                end
                DropList.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
            end

            RebuildList(options)

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    opened = not opened
                    Arrow.Text = opened ? "▲" : "▼"
                    local targetH = opened and math.clamp(#options * 30 + 5, 30, 130) + 36 or 36
                    local listH = opened and math.clamp(#options * 30, 0, 130) or 0
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, targetH)}):Play()
                    TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, listH)}):Play()
                end
            end)

            local controller = {}
            function controller.Refresh(newOpts)
                RebuildList(newOpts)
                if not table.find(newOpts, selected) then
                    selected = newOpts[1] or "Нет элементов"
                    Config[configKey] = selected
                    Label.Text = dropdownText .. ": " .. tostring(selected)
                end
            end
            function controller.GetSelected()
                return selected
            end

            return controller
        end

        return Elements
    end

    return WindowAPI
end

return Library
