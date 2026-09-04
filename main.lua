local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local Library = {}

-- Надежное определение инжектора
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

-- Получение названия игры
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

    ---------------------------------------------------------
    -- КОНФИГУРАЦИЯ
    ---------------------------------------------------------
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

    local Theme = {
        Background = Color3.fromRGB(20, 20, 26),
        Header     = Color3.fromRGB(15, 15, 20),
        Sidebar    = Color3.fromRGB(18, 18, 24),
        Accent     = Color3.fromRGB(Config.AccentColorR, Config.AccentColorG, Config.AccentColorB),
        Text       = Color3.fromRGB(255, 255, 255),
        TextDark   = Color3.fromRGB(140, 140, 155),
        ElementBg  = Color3.fromRGB(28, 28, 36),
        ToggleOff  = Color3.fromRGB(45, 45, 55)
    }

    ---------------------------------------------------------
    -- UI CORE
    ---------------------------------------------------------
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = windowName .. "UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui

    -- СПЛЕШ-СКРИН
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
    SplashStroke.Color = Theme.Accent
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
    LoadingBarFill.BackgroundColor3 = Theme.Accent
    LoadingBarFill.BorderSizePixel = 0
    LoadingBarFill.Parent = LoadingBarBg
    table.insert(AccentElements, LoadingBarFill)

    local LoadingBarFillCorner = Instance.new("UICorner")
    LoadingBarFillCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarFillCorner.Parent = LoadingBarFill

    -- ОСНОВНОЕ ОКНО HUB
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
    MainStroke.Color = Theme.Accent
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

    -- ИСПРАВЛЕНИЕ: Сделали Sidebar прокручиваемым (ScrollingFrame), чтобы кнопки не обрезались снизу
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
    MobileIcon.BackgroundColor3 = Theme.Accent
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

    -- Перетаскивание
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

    local function UpdateLanguage()
        for _, item in ipairs(LocalizedElements) do
            if item.Label and item.Label.Parent then
                local textData = item.TextData
                local currentText = type(textData) == "table" and (textData[Config.Language] or textData["EN"]) or textData
                
                if item.Type == "Section" then
                    item.Label.Text = string.upper(currentText)
                elseif item.Type == "Slider" then
                    item.Label.Text = currentText .. ": " .. tostring(item.GetValue())
                elseif item.Type == "Dynamic" and item.GetValue then
                    item.Label.Text = currentText .. item.GetValue()
                else
                    item.Label.Text = currentText
                end
            end
        end
    end

    local function UpdateThemeColors(newColor)
        Theme.Accent = newColor
        for _, elem in ipairs(AccentElements) do
            if elem then
                if elem:IsA("TextButton") or elem:IsA("Frame") then
                    TweenService:Create(elem, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
                elseif elem:IsA("UIStroke") then
                    elem.Color = newColor
                end
            end
        end
    end

    ---------------------------------------------------------
    -- API ОКОН И ВКЛАДОК
    ---------------------------------------------------------
    local WindowAPI = {}
    local Tabs = {}
    local FirstTab = true

    function WindowAPI:SetLanguage(lang)
        if lang == "EN" or lang == "RU" then
            Config.Language = lang
            UpdateLanguage()
        end
    end

    function WindowAPI:CreateTab(tabName, customOrder)
        local initialText = type(tabName) == "table" and (tabName[Config.Language] or tabName["EN"]) or tabName
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Theme.ElementBg
        TabBtn.BackgroundTransparency = Config.Transparency / 100
        TabBtn.Text = initialText
        TabBtn.TextColor3 = Theme.TextDark
        TabBtn.TextSize = 11
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.LayoutOrder = customOrder or 50
        TabBtn.Parent = Sidebar
        table.insert(AllFrames, TabBtn)

        if type(tabName) == "table" then
            table.insert(LocalizedElements, {Type = "Tab", Label = TabBtn, TextData = tabName})
        end

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
            TabBtn.BackgroundColor3 = Theme.Accent
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
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
        end)

        table.insert(Tabs, {Page = Page, Btn = TabBtn})

        local Elements = {Page = Page}

        function Elements:AddSection(sectionTitle)
            local initText = type(sectionTitle) == "table" and (sectionTitle[Config.Language] or sectionTitle["EN"]) or sectionTitle
            local Label = Instance.new("TextLabel")
            Label.Text = string.upper(initText)
            Label.Size = UDim2.new(1, -5, 0, 20)
            Label.TextColor3 = Theme.TextDark
            Label.TextSize = 10
            Label.Font = Enum.Font.GothamBold
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Page

            if type(sectionTitle) == "table" then
                table.insert(LocalizedElements, {Type = "Section", Label = Label, TextData = sectionTitle})
            end
        end

        function Elements:AddLabel(labelText)
            local initText = type(labelText) == "table" and (labelText[Config.Language] or labelText["EN"]) or labelText
            local Label = Instance.new("TextLabel")
            Label.Text = initText
            Label.Size = UDim2.new(1, -5, 0, 25)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Page

            if type(labelText) == "table" then
                table.insert(LocalizedElements, {Type = "Static", Label = Label, TextData = labelText})
            end
            return Label
        end

        function Elements:AddDynamicLabel(labelText, valueGetter)
            local initText = type(labelText) == "table" and (labelText[Config.Language] or labelText["EN"]) or labelText
            local val = valueGetter() or "N/A"
            
            local Label = Instance.new("TextLabel")
            Label.Text = initText .. tostring(val)
            Label.Size = UDim2.new(1, -5, 0, 25)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Page

            table.insert(LocalizedElements, {
                Type = "Dynamic",
                Label = Label,
                TextData = labelText,
                GetValue = function() return tostring(valueGetter() or "N/A") end
            })
            return Label
        end

        function Elements:AddButton(btnText, onClick)
            local initText = type(btnText) == "table" and (btnText[Config.Language] or btnText["EN"]) or btnText
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 32)
            Btn.BackgroundColor3 = Theme.ElementBg
            Btn.BackgroundTransparency = Config.Transparency / 100
            Btn.Text = initText
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 11
            Btn.Font = Enum.Font.GothamMedium
            Btn.Parent = Page
            table.insert(AllFrames, Btn)

            if type(btnText) == "table" then
                table.insert(LocalizedElements, {Type = "Button", Label = Btn, TextData = btnText})
            end

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

            local initText = type(toggleText) == "table" and (toggleText[Config.Language] or toggleText["EN"]) or toggleText
            local Label = Instance.new("TextLabel")
            Label.Text = initText
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Position = UDim2.fromOffset(10, 0)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            if type(toggleText) == "table" then
                table.insert(LocalizedElements, {Type = "Static", Label = Label, TextData = toggleText})
            end

            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.fromOffset(36, 18)
            Switch.Position = UDim2.new(1, -44, 0.5, -9)
            Switch.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
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
                local targetColor = state and Theme.Accent or Theme.ToggleOff

                if state then
                    if not table.find(AccentElements, Switch) then table.insert(AccentElements, Switch) end
                else
                    local idx = table.find(AccentElements, Switch)
                    if idx then table.remove(AccentElements, idx) end
                end

                Circle:TweenPosition(targetPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                Switch:TweenSizeAndPosition(Switch.Size, Switch.Position, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()

                if callback then callback(state) end
            end

            Switch.MouseButton1Click:Connect(function() UpdateVisual(not state) end)
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

            local prefixText = type(sliderText) == "table" and (sliderText[Config.Language] or sliderText["EN"]) or sliderText
            local Label = Instance.new("TextLabel")
            Label.Text = prefixText .. ": " .. tostring(defaultVal)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.fromOffset(10, 2)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            if type(sliderText) == "table" then
                table.insert(LocalizedElements, {
                    Type = "Slider",
                    Label = Label,
                    TextData = sliderText,
                    GetValue = function() return Config[configKey] end
                })
            end

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
            Fill.BackgroundColor3 = Theme.Accent
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
                
                local pText = type(sliderText) == "table" and (sliderText[Config.Language] or sliderText["EN"]) or sliderText
                Label.Text = pText .. ": " .. tostring(val)
                if callback then callback(val) end
            end

            local sliding = false
            local function UpdateFromInput(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
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

            if callback then callback(defaultVal) end
        end

        return Elements
    end

    ---------------------------------------------------------
    -- 1. ВКЛАДКА "ИНФО" (Порядок 1)
    ---------------------------------------------------------
    local InfoTab = WindowAPI:CreateTab({EN = "Info", RU = "Инфо"}, 1)
    InfoTab:AddSection({EN = "Player Information", RU = "Информация об игроке"})
    
    InfoTab:AddDynamicLabel({EN = "Username: ", RU = "Ник: "}, function() return LocalPlayer.Name end)
    InfoTab:AddDynamicLabel({EN = "Executor: ", RU = "Инжектор: "}, function() return GetExecutorName() end)
    InfoTab:AddDynamicLabel({EN = "Game: ", RU = "Игра: "}, function() return GetGameName() end)
    InfoTab:AddDynamicLabel({EN = "Place ID: ", RU = "Place ID: "}, function() return tostring(game.PlaceId) end)

    ---------------------------------------------------------
    -- 2. ВКЛАДКА "НАСТРОЙКИ" (Порядок 99 - будет в самом низу с прокруткой)
    ---------------------------------------------------------
    local SettingsTab = WindowAPI:CreateTab({EN = "Settings", RU = "Настройки"}, 99)

    SettingsTab:AddSection({EN = "Language", RU = "Язык интерфейса"})
    SettingsTab:AddButton({EN = "Switch to Russian (RU)", RU = "Включить русский (RU)"}, function()
        WindowAPI:SetLanguage("RU")
    end)
    SettingsTab:AddButton({EN = "Switch to English (EN)", RU = "Switch to English (EN)"}, function()
        WindowAPI:SetLanguage("EN")
    end)

    SettingsTab:AddSection({EN = "Appearance", RU = "Внешний вид"})
    SettingsTab:AddSlider({EN = "UI Transparency", RU = "Прозрачность UI"}, "Transparency", 0, 80, 0, function(v)
        Config.Transparency = v
        for _, frame in ipairs(AllFrames) do
            if frame and frame.Parent then
                frame.BackgroundTransparency = v / 100
            end
        end
    end)

    SettingsTab:AddSection({EN = "Theme Accent", RU = "Акцентный цвет"})
    SettingsTab:AddButton({EN = "Purple Theme", RU = "Фиолетовая тема"}, function()
        UpdateThemeColors(Color3.fromRGB(115, 80, 255))
    end)
    SettingsTab:AddButton({EN = "Blue Theme", RU = "Синяя тема"}, function()
        UpdateThemeColors(Color3.fromRGB(50, 130, 255))
    end)
    SettingsTab:AddButton({EN = "Green Theme", RU = "Зеленая тема"}, function()
        UpdateThemeColors(Color3.fromRGB(50, 205, 90))
    end)
    SettingsTab:AddButton({EN = "Red Theme", RU = "Красная тема"}, function()
        UpdateThemeColors(Color3.fromRGB(255, 60, 60))
    end)

    -- Анимация появления главного окна
    task.spawn(function()
        TweenService:Create(LoadingBarFill, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(1.1)
        TweenService:Create(SplashFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        SplashFrame:Destroy()
        Main.Visible = true
    end)

    return WindowAPI
end

return Library
