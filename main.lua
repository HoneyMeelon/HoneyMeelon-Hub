-- HoneyMeelon Hub: Мгновенный интерфейс с выпадающими вкладками
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Защита от повторного запуска: удаляем старую панель, если она уже открыта
local oldUI = player:WaitForChild("PlayerGui"):FindFirstChild("HoneyMeelonPremiumUI") or game:GetService("CoreGui"):FindFirstChild("HoneyMeelonPremiumUI")
if oldUI then oldUI:Destroy() end

-- Создаем графическую оболочку
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoneyMeelonPremiumUI"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-----------------------------------------
-- 1. ГЛАВНОЕ ОКНО ИНТЕРФЕЙСА (MAIN FRAME)
-----------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.3, 0) -- Мгновенно появляется по центру
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Окно можно свободно перетаскивать мышкой
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

-- Кнопка-Заголовок (При наведении выпадает меню)
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
-- 2. ВЫДВИЖНОЕ МЕНЮ ВКЛАДОК (DROP-DOWN TABS)
-----------------------------------------
local DropdownMenu = Instance.new("Frame")
DropdownMenu.Size = UDim2.new(0, 160, 0, 0) -- Высота 0 (скрыто по умолчанию)
DropdownMenu.Position = UDim2.new(0, 15, 0, 40) -- Находится прямо под шапкой
DropdownMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownMenu.BorderSizePixel = 0
DropdownMenu.ClipsDescendants = true -- Скрывает вкладки, пока шторка свернута
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

-- Создание вкладок внутри шторки
for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.Text = "  " .. tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.BackgroundTransparency = 1
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.BorderSizePixel = 0
    TabButton.ZIndex = 5
    TabButton.Parent = DropdownMenu
    
    -- Плавное изменение цвета при наведении на саму вкладку
    TabButton.MouseEnter:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    TabButton.MouseLeave:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end)
end

-----------------------------------------
-- 3. ЛОГИКА АНИМАЦИИ ШТОРКИ (НАВЕДЕНИЕ)
-----------------------------------------
local isHovered = false

local function showDropdown()
    isHovered = true
    -- Плавно выдвигаем шторку вниз (высота 190 пикселей под все вкладки)
    TweenService:Create(DropdownMenu, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 160, 0, 190)}):Play()
end

local function hideDropdown()
    isHovered = false
    task.wait(0.2) -- Небольшая задержка, чтобы курсор не скрывал шторку при случайных рывках
    if not isHovered then
        TweenService:Create(DropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 160, 0, 0)}):Play()
    end
end

-- Привязываем события мыши к кнопке-заголовку и самому выпадающему меню
TitleButton.MouseEnter:Connect(showDropdown)
DropdownMenu.MouseEnter:Connect(function() isHovered = true end)

TitleButton.MouseLeave:Connect(hideDropdown)
DropdownMenu.MouseLeave:Connect(hideDropdown)

print("HoneyMeelon Hub мгновенно загружен!")
