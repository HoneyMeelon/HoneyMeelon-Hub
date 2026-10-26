local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Создаем графическую оболочку
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoneyMeelonHubUI"
ScreenGui.ResetOnSpawn = false -- Меню не пропадет после перезагрузки персонажа

-- Безопасное подключение интерфейса (работает и в читах, и в Roblox Studio)
local success, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- 2. Главное окно меню (Панель)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300) -- Размер окна (Ширина 250, Высота 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0) -- Начальная позиция на экране
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Темная тема (цвет фона)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Позволяет зажать окно мышкой и двигать его
MainFrame.Parent = ScreenGui

-- Скругление углов для главного окна
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- 3. Верхняя шапка (Заголовок)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35) -- Высота шапки 35 пикселей
TitleLabel.Text = "HoneyMeelon Hub v1.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Чуть светлее основного фона
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.Parent = MainFrame

-- Скругление углов для шапки
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel
