-- HoneyMeelon Hub: Профессиональный интерфейс с анимацией и вкладками
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Защита от дубликатов: удаляем старое меню при перезапуске
local oldUI = player:WaitForChild("PlayerGui"):FindFirstChild("HoneyMeelonPremiumUI") or game:GetService("CoreGui"):FindFirstChild("HoneyMeelonPremiumUI")
if oldUI then oldUI:Destroy() end

-- Создаем графическую оболочку
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoneyMeelonPremiumUI"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-----------------------------------------
-- 1. ЭКРАН ЗАГРУЗКИ (LOADING SCREEN)
-----------------------------------------
local LoadingScreen = Instance.new("Frame")
LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
LoadingScreen.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LoadingScreen.ZIndex = 10
LoadingScreen.Parent = ScreenGui

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(0, 300, 0, 40)
LoadingText.Position = UDim2.new(0.5, -150, 0.45, 0)
LoadingText.Text = "HoneyMeelon Hub"
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.Font = Enum.Font.SourceSansBold
LoadingText.TextSize = 32
LoadingText.BackgroundTransparency = 1
LoadingText.ZIndex = 10
LoadingText.Parent = LoadingScreen

-- Индикатор загрузки (полоса прогресса)
local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0, 200, 0, 4)
BarBackground.Position = UDim2.new(0.5, -100, 0.55, 0)
BarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BarBackground.BorderSizePixel = 0
BarBackground.ZIndex = 10
BarBackground.Parent = LoadingScreen

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(40, 180, 100) -- Зеленый цвет загрузки
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 10
BarFill.Parent = BarBackground

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 2)
FillCorner.Parent = BarFill

-----------------------------------------
-- 2. ГЛАВНОЕ ОКНО ИНТЕРФЕЙСА (MAIN FRAME)
-----------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, -0.5, 0) -- Начинает за пределами экрана сверху (для шторки)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Шапка (Верхняя панель)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Кнопка-Заголовок (Реагирует на наведение)
local TitleButton = Instance.new("TextButton")
TitleButton.Size = UDim2.new(0, 180, 1, 0)
TitleButton.Position = UDim2.new(0, 15, 0, 0)
TitleButton.Text = "HoneyMeelon Hub ▾"
TitleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleButton.Font = Enum.Font.SourceSansBold
TitleButton.TextSize = 18
TitleButton.BackgroundTransparency = 1
TitleButton.TextXAlignment = Enum.TextXAlignment.Left
TitleButton.Parent = TitleBar

-----------------------------------------
-- 3. ВЫДВИЖНОЕ МЕНЮ ВКЛАДОК (DROP-DOWN TABS)
-----------------------------------------
local DropdownMenu = Instance.new("Frame")
DropdownMenu.Size = UDim2.new(0, 160, 0, 0) -- Высота изначально 0
DropdownMenu.Position = UDim2.new(0, 15, 0, 40) -- Сразу под шапкой
DropdownMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownMenu.BorderSizePixel = 0
DropdownMenu.ClipsDescendants = true -- Прячет вкладки, когда меню свернуто
DropdownMenu.ZIndex = 5
DropdownMenu.Parent = MainFrame

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 6)
DropdownCorner.Parent = DropdownMenu

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.Parent = DropdownMenu

-- Массив ваших вкладок
local tabs = {"Lobby", "Match", "Auto Play", "Macros", "Web Hook", "Misc"}

-- Функция создания вкладок внутри шторки
for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.Text = "  " .. tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.BackgroundTransparency = i == 1 and 0.5 or 1 -- Подсветка первой вкладки
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.BorderSizePixel = 0
    TabButton.ZIndex = 5
    TabButton.Parent = DropdownMenu
    
    -- Анимация наведения мышки на саму вкладку
    TabButton.MouseEnter:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    TabButton.MouseLeave:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end)
end

-----------------------------------------
-- 4. АНИМАЦИЯ НАВЕДЕНИЯ НА НАДПИСЬ
-----------------------------------------
local isHovered = false

local function showDropdown()
    isHovered = true
    -- Плавно раскрываем шторку вниз (высота 190 пикселей под 6 вкладок)
    TweenService:Create(DropdownMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 160, 0, 190)}):Play()
end

local function hideDropdown()
    isHovered = false
    task.wait(0.3) -- Небольшая задержка, чтобы пользователь успел перевести мышку
    if not isHovered then
        TweenService:Create(DropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 160, 0, 0)}):Play()
    end
end

-- Привязываем события мыши к шапке меню
TitleButton.MouseEnter:Connect(showDropdown)
DropdownMenu.MouseEnter:Connect(function() isHovered = true end)

TitleButton.MouseLeave:Connect(hideDropdown)
DropdownMenu.MouseLeave:Connect(hideDropdown)

-----------------------------------------
-- 5. ЛОГИКА АНИМАЦИИ ЗАГРУЗКИ (ЗАПУСК)
-----------------------------------------
task.spawn(function()
    -- 1. Анимируем полосу загрузки (заполнение за 2 секунды)
    local barTween = TweenService:Create(BarFill, TweenInfo.new(2, Enum.EasingStyle.Poly, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    barTween:Play()
    barTween.Completed:Wait()
    
    -- 2. Плавно убираем экран загрузки (Fade Out)
    TweenService:Create(LoadingText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    local screenTween = TweenService:Create(LoadingScreen, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    screenTween:Play()
    
    -- Прячем индикаторы, чтобы они не мешали кликать
    BarBackground:Destroy()
    task.wait(0.3)
    LoadingScreen:Destroy()
    
    -- 3. Выдвигаем главное меню сверху как красивую шторку
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.3, 0)}):Play()
end)
