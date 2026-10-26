-- HoneyMeelon Hub: Точная стилистика Umbrella UI
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Очистка старого интерфейса
local oldUI = player:WaitForChild("PlayerGui"):FindFirstChild("HoneyMeelonUmbrellaUI") or game:GetService("CoreGui"):FindFirstChild("HoneyMeelonUmbrellaUI")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoneyMeelonUmbrellaUI"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-----------------------------------------
-- 1. ОСНОВНОЕ ОКНО
-----------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 680, 0, 420) -- Пропорции как в оригинале
MainFrame.Position = UDim2.new(0.5, -340, 0.3, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(17, 18, 22) -- Фирменный глубокий темно-серый тон
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

-----------------------------------------
-- 2. САМЫЙ ЛЕВЫЙ УЗКИЙ САДБАР (ИКОНКИ + ЛОГО)
-----------------------------------------
local IconSidebar = Instance.new("Frame")
IconSidebar.Size = UDim2.new(0, 50, 1, 0)
IconSidebar.BackgroundColor3 = Color3.fromRGB(12, 13, 15) -- Угольный фон для иконок
IconSidebar.BorderSizePixel = 0
IconSidebar.Parent = MainFrame

local IconSideCorner = Instance.new("UICorner")
IconSideCorner.CornerRadius = UDim.new(0, 6)
IconSideCorner.Parent = IconSidebar

-- Логотип-Зонтик (Umbrella Logo)
local UmbrellaLogo = Instance.new("TextLabel")
UmbrellaLogo.Size = UDim2.new(1, 0, 0, 50)
UmbrellaLogo.Text = "☂" -- Символ зонтика
UmbrellaLogo.TextColor3 = Color3.fromRGB(235, 60, 60) -- Красный бренд
UmbrellaLogo.Font = Enum.Font.SourceSansBold
UmbrellaLogo.TextSize = 28
UmbrellaLogo.BackgroundTransparency = 1
UmbrellaLogo.Parent = IconSidebar

-- Фейковые иконки снизу для копирования стиля
local function createSideIcon(text, yPos)
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(1, 0, 0, 40)
    Icon.Position = UDim2.new(0, 0, 0, yPos)
    Icon.Text = text
    Icon.TextColor3 = Color3.fromRGB(100, 105, 115)
    Icon.Font = Enum.Font.SourceSans
    Icon.TextSize = 18
    Icon.BackgroundTransparency = 1
    Icon.Parent = IconSidebar
end
createSideIcon("⚛", 60)
createSideIcon("🛡", 100)
createSideIcon("⚙", 140)

-----------------------------------------
-- 3. ВТОРОЙ СЛОЙ САЙДБАРА (СПИСОК НАЗВАНИЙ ВКЛАДОК)
-----------------------------------------
local TextSidebar = Instance.new("Frame")
TextSidebar.Size = UDim2.new(0, 140, 1, 0)
TextSidebar.Position = UDim2.new(0, 50, 0, 0)
TextSidebar.BackgroundColor3 = Color3.fromRGB(15, 16, 19) -- Промежуточный цвет
TextSidebar.BorderSizePixel = 0
TextSidebar.Parent = MainFrame

-- Название Хаба сверху списка
local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, 0, 0, 40)
HubTitle.Position = UDim2.new(0, 12, 0, 10)
HubTitle.Text = "HoneyMeelon Hub"
HubTitle.TextColor3 = Color3.fromRGB(150, 155, 165)
HubTitle.Font = Enum.Font.SourceSansBold
HubTitle.TextSize = 14
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.BackgroundTransparency = 1
HubTitle.Parent = TextSidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 2)
TabListLayout.Parent = TextSidebar

-- Сдвигаем список чуть ниже заголовка
local PaddingFrame = Instance.new("Frame")
PaddingFrame.Size = UDim2.new(1, 0, 0, 45)
PaddingFrame.BackgroundTransparency = 1
PaddingFrame.LayoutOrder = 0
PaddingFrame.Parent = TextSidebar

-----------------------------------------
-- 4. ПРАВАЯ РАБОЧАЯ ОБЛАСТЬ (КОНТЕНТ)
-----------------------------------------
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -200, 1, 0)
ContentArea.Position = UDim2.new(0, 200, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Верхний блок для горизонтального подменю (Main, Binds, Extra)
local TopNavbar = Instance.new("Frame")
TopNavbar.Size = UDim2.new(1, 0, 0, 45)
TopNavbar.BackgroundTransparency = 1
TopNavbar.Parent = ContentArea

local NavList = Instance.new("UIListLayout")
NavList.FillDirection = Enum.FillDirection.Horizontal
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Padding = UDim.new(0, 20)
NavList.Parent = TopNavbar

local function createSubTab(text, order)
    local SubBtn = Instance.new("TextButton")
    SubBtn.Size = UDim2.new(0, 60, 1, 0)
    SubBtn.Text = text
    SubBtn.TextColor3 = order == 1 and Color3.fromRGB(235, 60, 60) or Color3.fromRGB(130, 135, 145)
    SubBtn.Font = Enum.Font.SourceSansBold
    SubBtn.TextSize = 14
    SubBtn.BackgroundTransparency = 1
    SubBtn.LayoutOrder = order
    SubBtn.Parent = TopNavbar
    return SubBtn
end
createSubTab("Main", 1)
createSubTab("Panels", 2)
createSubTab("Binds", 3)
createSubTab("Extra", 4)

-- Основной контейнер страниц под вкладками
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -20, 1, -60)
PageContainer.Position = UDim2.new(0, 0, 0, 50)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = ContentArea

local activePage = nil
local pages = {}
local mainTabs = {"Lobby", "Match", "Auto Play", "Macros", "Web Hook", "Misc"}

-- Создание основных вертикальных вкладок
for i, tabName in ipairs(mainTabs) do
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = PageContainer
    pages[tabName] = Page

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -15, 0, 30)
    TabBtn.Text = "   " .. tabName
    TabBtn.TextColor3 = Color3.fromRGB(120, 125, 135)
    TabBtn.Font = Enum.Font.SourceSansSemibold
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.BackgroundTransparency = 1
    TabBtn.LayoutOrder = i
    TabBtn.Parent = TextSidebar
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(TextSidebar:GetChildren()) do
            if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(120, 125, 135) end
        end
        TabBtn.TextColor3 = Color3.fromRGB(235, 60, 60)
        if activePage then activePage.Visible = false end
        Page.Visible = true
        activePage = Page
    end)

    if i == 4 then -- Активируем Macros по умолчанию
        TabBtn.TextColor3 = Color3.fromRGB(235, 60, 60)
        Page.Visible = true
        activePage = Page
    end
end

-----------------------------------------
-- 5. СОЗДАНИЕ СПИСКОВ НАСТРОЕК (ПРИМЕР ДЛЯ MACROS)
-----------------------------------------
local macrosPage = pages["Macros"]

-- Сетка для двух блоков настроек (как левый и правый столбец в Umbrella)
local LeftBlock = Instance.new("Frame")
LeftBlock.Size = UDim2.new(0.48, 0, 1, 0)
LeftBlock.BackgroundColor3 = Color3.fromRGB(22, 23, 27)
LeftBlock.BorderSizePixel = 0
LeftBlock.Parent = macrosPage

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 4)
LeftCorner.Parent = LeftBlock

local LeftTitle = Instance.new("TextLabel")
LeftTitle.Size = UDim2.new(1, -20, 0, 35)
LeftTitle.Position = UDim2.new(0, 10, 0, 0)
LeftTitle.Text = "Macro Recorder Settings"
LeftTitle.TextColor3 = Color3.fromRGB(140, 145, 155)
LeftTitle.Font = Enum.Font.SourceSansBold
LeftTitle.TextSize = 13
LeftTitle.TextXAlignment = Enum.TextXAlignment.Left
LeftTitle.BackgroundTransparency = 1
LeftTitle.Parent = LeftBlock

-- Красивый переключатель в стиле Umbrella (Красный круглый слайдер)
local function createUmbrellaToggle(text, yPos, parent)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 35)
    Frame.Position = UDim2.new(0, 10, 0, yPos)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 140, 1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(190, 195, 205)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local SwitchBg = Instance.new("TextButton")
    SwitchBg.Size = UDim2.new(0, 36, 0, 18)
    SwitchBg.Position = UDim2.new(1, -36, 0.5, -9)
    SwitchBg.BackgroundColor3 = Color3.fromRGB(35, 36, 42)
    SwitchBg.Text = ""
    SwitchBg.BorderSizePixel = 0
    SwitchBg.Parent = Frame
    
    local SwCorner = Instance.new("UICorner")
    SwCorner.CornerRadius = UDim.new(0, 9)
    SwCorner.Parent = SwitchBg
    
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(0, 14, 0, 14)
    Slider.Position = UDim2.new(0, 2, 0.5, -7)
    Slider.BackgroundColor3 = Color3.fromRGB(110, 115, 125)
    Slider.BorderSizePixel = 0
    Slider.Parent = SwitchBg
    
    local SlCorner = Instance.new("UICorner")
    SlCorner.CornerRadius = UDim.new(0, 7)
    SlCorner.Parent = Slider
    
    local active = false
    SwitchBg.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(SwitchBg, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(235, 60, 60)}):Play()
            TweenService:Create(Slider, TweenInfo.new(0.15), {Position = UDim2.new(0, 20, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(SwitchBg, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 36, 42)}):Play()
            TweenService:Create(Slider, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(110, 115, 125)}):Play()
        end
    end)
end
createUmbrellaToggle("Auto Record", 40, LeftBlock)
createUmbrellaToggle("Use Fast Pathing", 75, LeftBlock)
createUmbrellaToggle("Loop Playback", 110, LeftBlock)
