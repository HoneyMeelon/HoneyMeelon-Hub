-- HoneyMeelon Hub: В стилистике чита Umbrella (Dota 2)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Удаляем старые UI, чтобы не накладывались
local oldUI = player:WaitForChild("PlayerGui"):FindFirstChild("HoneyMeelonUmbrellaUI") or game:GetService("CoreGui"):FindFirstChild("HoneyMeelonUmbrellaUI")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoneyMeelonUmbrellaUI"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-----------------------------------------
-- 1. ОСНОВНОЕ ОКНО (СТИЛЬ UMBRELLA)
-----------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 350) -- Увеличенный размер для полноценного меню
MainFrame.Position = UDim2.new(0.5, -275, 0.3, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Угольно-черный основной фон
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

-----------------------------------------
-- 2. ЛЕВАЯ ПАНЕЛЬ НАВИГАЦИИ (SIDEBAR)
-----------------------------------------
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22) -- Чуть светлее для контраста
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 6)
SideCorner.Parent = Sidebar

-- Логотип / Название чита в левом верхнем углу
local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size = UDim2.new(1, 0, 0, 45)
LogoLabel.Text = "UMBRELLA HUB"
LogoLabel.TextColor3 = Color3.fromRGB(255, 60, 60) -- Ярко-красный фирменный акцент
LogoLabel.Font = Enum.Font.SourceSansBold
LogoLabel.TextSize = 18
LogoLabel.BackgroundTransparency = 1
LogoLabel.Parent = Sidebar

-- Контейнер для кнопок вкладок
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -50)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 2)
UIList.Parent = TabContainer

-----------------------------------------
-- 3. ПРАВАЯ ЗОНА ДЛЯ КОНТЕНТА (CONTAINER)
-----------------------------------------
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -160, 1, -20)
ContentContainer.Position = UDim2.new(0, 155, 0, 10)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Хранилище страниц
local pages = {}
local activePage = nil

-- Массив вкладок, которые вы заказывали
local tabsList = {"Lobby", "Match", "Auto Play", "Macros", "Web Hook", "Misc"}

-- Функция переключения вкладок
local function switchTab(tabName)
    if activePage then
        activePage.Visible = false
    end
    if pages[tabName] then
        pages[tabName].Visible = true
        activePage = pages[tabName]
    end
end

-- Создаем страницы и кнопки навигации
for i, tabName in ipairs(tabsList) do
    -- 1. Создаем саму скрытую страницу контента для этой вкладки
    local PageFrame = Instance.new("Frame")
    PageFrame.Size = UDim2.new(1, 0, 1, 0)
    PageFrame.BackgroundTransparency = 1
    PageFrame.Visible = false
    PageFrame.Parent = ContentContainer
    pages[tabName] = PageFrame
    
    -- Тестовая надпись на странице, чтобы видеть переключение
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, 0, 0, 30)
    infoText.Text = "Настройки модуля: " .. tabName
    infoText.TextColor3 = Color3.fromRGB(150, 150, 150)
    infoText.Font = Enum.Font.SourceSansItalic
    infoText.TextSize = 16
    infoText.BackgroundTransparency = 1
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.Parent = PageFrame
    
    -- 2. Создаем кнопку в левом меню
    local MenuButton = Instance.new("TextButton")
    MenuButton.Size = UDim2.new(1, -10, 0, 32)
    MenuButton.Position = UDim2.new(0, 5, 0, 0)
    MenuButton.Text = "  " .. tabName
    MenuButton.TextColor3 = Color3.fromRGB(160, 160, 160)
    MenuButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    MenuButton.BackgroundTransparency = 1
    MenuButton.Font = Enum.Font.SourceSansSemibold
    MenuButton.TextSize = 14
    MenuButton.TextXAlignment = Enum.TextXAlignment.Left
    MenuButton.BorderSizePixel = 0
    MenuButton.Parent = TabContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = MenuButton
    
    -- Индикатор нажатия / Анимации
    MenuButton.MouseEnter:Connect(function()
        TweenService:Create(MenuButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    MenuButton.MouseLeave:Connect(function()
        if activePage ~= PageFrame then
            TweenService:Create(MenuButton, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
        end
    end)
    
    MenuButton.MouseButton1Click:Connect(function()
        -- Сбрасываем визуальный стиль со всех кнопок меню
        for _, child in ipairs(TabContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = 1
                child.TextColor3 = Color3.fromRGB(160, 160, 160)
            end
        end
        -- Подсвечиваем выбранную
        MenuButton.BackgroundTransparency = 0.2
        MenuButton.TextColor3 = Color3.fromRGB(255, 60, 60) -- Красный текст при активации
        switchTab(tabName)
    end)
    
    -- Делаем первую вкладку активной по умолчанию
    if i == 1 then
        MenuButton.BackgroundTransparency = 0.2
        MenuButton.TextColor3 = Color3.fromRGB(255, 60, 60)
        switchTab(tabName)
    end
end

-----------------------------------------
-- 4. НАПОЛНЕНИЕ ВКЛАДКИ MACROS (ПРИМЕР)
-----------------------------------------
-- Добавим функционал макроса прямо на страницу "Macros" в стиле Umbrella
local macrosPage = pages["Macros"]

local function createCheatToggle(text, yPos, parent)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 15
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Box = Instance.new("TextButton")
    Box.Size = UDim2.new(0, 45, 0, 20)
    Box.Position = UDim2.new(1, -50, 0.5, -10)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Box.Text = ""
    Box.BorderSizePixel = 0
    Box.Parent = ToggleFrame
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 10)
    BoxCorner.Parent = Box
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Circle.BorderSizePixel = 0
    Circle.Parent = Box
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(0, 8)
    CircleCorner.Parent = Circle
    
    return Box, Circle
end

-- Создаем красивые круглые переключатели (как в оригинальном Umbrella)
local recBox, recCircle = createCheatToggle("Запись траектории движения", 50, macrosPage)
local playBox, playCircle = createCheatToggle("Воспроизведение макроса", 90, macrosPage)

-- Пример логики анимации тумблера для Записи
local recActive = false
recBox.MouseButton1Click:Connect(function()
    recActive = not recActive
    if recActive then
        TweenService:Create(recBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
        TweenService:Create(recCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 27, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        TweenService:Create(recBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        TweenService:Create(recCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end
end)

print("Интерфейс Umbrella запущен успешно!")
