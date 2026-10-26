local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local GUI_NAME = "HoneyMeelonHub"
local ACCENT = Color3.fromRGB(235, 60, 60)
local TEXT_PRIMARY = Color3.fromRGB(240, 240, 245)
local TEXT_MUTED = Color3.fromRGB(140, 140, 150)
local TWEEN_INFO = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function removeOld(container)
    local old = container:FindFirstChild(GUI_NAME)
    if old then
        old:Destroy()
    end
end

pcall(function()
    removeOld(CoreGui)
end)

local localPlayer = Players.LocalPlayer
if localPlayer then
    local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        removeOld(playerGui)
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

local parented = pcall(function()
    screenGui.Parent = CoreGui
end)

if not parented or not screenGui.Parent then
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function newLabel(parent, text, size, color, alignment)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Inter
    label.Text = text
    label.TextSize = size
    label.TextColor3 = color
    label.TextXAlignment = alignment or Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(660, 410)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 8)

local rail = Instance.new("Frame")
rail.Name = "Rail"
rail.Size = UDim2.new(0, 55, 1, 0)
rail.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
rail.BorderSizePixel = 0
rail.Parent = main

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.fromOffset(28, 28)
logo.Position = UDim2.fromOffset(13, 14)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://6031075929"
logo.ImageColor3 = ACCENT
logo.Parent = rail
corner(logo, 14)

local iconHolder = Instance.new("Frame")
iconHolder.Name = "Icons"
iconHolder.Size = UDim2.new(1, 0, 1, -64)
iconHolder.Position = UDim2.fromOffset(0, 64)
iconHolder.BackgroundTransparency = 1
iconHolder.Parent = rail

local iconLayout = Instance.new("UIListLayout")
iconLayout.Padding = UDim.new(0, 4)
iconLayout.SortOrder = Enum.SortOrder.LayoutOrder
iconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
iconLayout.Parent = iconHolder

local nameColumn = Instance.new("Frame")
nameColumn.Name = "Names"
nameColumn.Size = UDim2.new(0, 135, 1, 0)
nameColumn.Position = UDim2.fromOffset(55, 0)
nameColumn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
nameColumn.BorderSizePixel = 0
nameColumn.Parent = main

local title = newLabel(nameColumn, "HoneyMeelon Hub", 14, TEXT_PRIMARY)
title.Name = "Title"
title.Font = Enum.Font.Inter
title.TextSize = 14
title.Size = UDim2.new(1, -24, 0, 28)
title.Position = UDim2.fromOffset(14, 14)

local tabHolder = Instance.new("Frame")
tabHolder.Name = "Tabs"
tabHolder.Size = UDim2.new(1, 0, 1, -64)
tabHolder.Position = UDim2.fromOffset(0, 64)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = nameColumn

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabHolder

local workspaceFrame = Instance.new("Frame")
workspaceFrame.Name = "Workspace"
workspaceFrame.Size = UDim2.new(1, -190, 1, 0)
workspaceFrame.Position = UDim2.fromOffset(190, 0)
workspaceFrame.BackgroundTransparency = 1
workspaceFrame.Parent = main

local subBar = Instance.new("Frame")
subBar.Name = "SubBar"
subBar.Size = UDim2.new(1, -32, 0, 36)
subBar.Position = UDim2.fromOffset(16, 12)
subBar.BackgroundTransparency = 1
subBar.Parent = workspaceFrame

local subLayout = Instance.new("UIListLayout")
subLayout.FillDirection = Enum.FillDirection.Horizontal
subLayout.Padding = UDim.new(0, 6)
subLayout.SortOrder = Enum.SortOrder.LayoutOrder
subLayout.Parent = subBar

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -32, 0, 1)
divider.Position = UDim2.fromOffset(16, 50)
divider.BackgroundColor3 = Color3.fromRGB(38, 38, 43)
divider.BorderSizePixel = 0
divider.Parent = workspaceFrame

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -32, 1, -68)
content.Position = UDim2.fromOffset(16, 60)
content.BackgroundTransparency = 1
content.Parent = workspaceFrame

local tabNames = { "Lobby", "Match", "Auto Play", "Macros", "Web Hook", "Misc" }
local tabIcons = {
    Lobby = "rbxassetid://6026568198",
    Match = "rbxassetid://6031280882",
    ["Auto Play"] = "rbxassetid://6023426915",
    Macros = "rbxassetid://6031097225",
    ["Web Hook"] = "rbxassetid://6031094667",
    Misc = "rbxassetid://6031280883",
}
local subNames = { "Main", "Panels", "Binds", "Extra" }

local activeTab = "Macros"
local activeSub = "Main"

local tabButtons = {}
local tabIconLabels = {}
local subButtons = {}
local pages = {}

local function refresh()
    for _, name in ipairs(tabNames) do
        local selected = name == activeTab
        local button = tabButtons[name]
        button.BackgroundTransparency = selected and 0 or 1
        button.TextColor3 = selected and TEXT_PRIMARY or TEXT_MUTED
        tabIconLabels[name].ImageColor3 = selected and ACCENT or TEXT_MUTED
    end
    for _, name in ipairs(subNames) do
        local selected = name == activeSub
        local entry = subButtons[name]
        entry.button.TextColor3 = selected and ACCENT or TEXT_MUTED
        entry.line.Visible = selected
    end
    for tabName, subPages in pairs(pages) do
        for subName, frame in pairs(subPages) do
            frame.Visible = tabName == activeTab and subName == activeSub
        end
    end
end

for index, name in ipairs(tabNames) do
    local iconRow = Instance.new("Frame")
    iconRow.Size = UDim2.new(1, 0, 0, 32)
    iconRow.BackgroundTransparency = 1
    iconRow.LayoutOrder = index
    iconRow.Parent = iconHolder

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(18, 18)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = tabIcons[name]
    icon.ImageColor3 = TEXT_MUTED
    icon.Parent = iconRow
    tabIconLabels[name] = icon

    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -16, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Font = Enum.Font.Inter
    button.Text = name
    button.TextSize = 13
    button.TextColor3 = TEXT_MUTED
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.LayoutOrder = index
    button.Parent = tabHolder
    corner(button, 6)

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = button

    tabButtons[name] = button

    button.MouseButton1Click:Connect(function()
        activeTab = name
        refresh()
    end)
end

for index, name in ipairs(subNames) do
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(58, 34)
    button.BackgroundTransparency = 1
    button.AutoButtonColor = false
    button.Font = Enum.Font.Inter
    button.Text = name
    button.TextSize = 12
    button.TextColor3 = TEXT_MUTED
    button.LayoutOrder = index
    button.Parent = subBar

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -16, 0, 2)
    line.AnchorPoint = Vector2.new(0.5, 1)
    line.Position = UDim2.new(0.5, 0, 1, 0)
    line.BackgroundColor3 = ACCENT
    line.BorderSizePixel = 0
    line.Visible = false
    line.Parent = button
    corner(line, 1)

    subButtons[name] = { button = button, line = line }

    button.MouseButton1Click:Connect(function()
        activeSub = name
        refresh()
    end)
end

for _, tabName in ipairs(tabNames) do
    pages[tabName] = {}
    for _, subName in ipairs(subNames) do
        local page = Instance.new("Frame")
        page.Name = tabName .. "_" .. subName
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = content
        pages[tabName][subName] = page

        if not (tabName == "Macros" and subName == "Main") then
            local placeholder = newLabel(page, tabName .. " / " .. subName, 12, TEXT_MUTED)
            placeholder.Size = UDim2.new(1, 0, 0, 20)
        end
    end
end

local function createToggle(parent, text, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 38)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = parent

    local label = newLabel(row, text, 13, TEXT_PRIMARY)
    label.Size = UDim2.new(1, -60, 1, 0)

    local track = Instance.new("TextButton")
    track.Size = UDim2.fromOffset(42, 24)
    track.AnchorPoint = Vector2.new(1, 0.5)
    track.Position = UDim2.new(1, 0, 0.5, 0)
    track.BackgroundColor3 = Color3.fromRGB(52, 52, 58)
    track.BorderSizePixel = 0
    track.AutoButtonColor = false
    track.Text = ""
    track.Parent = row
    corner(track, 12)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = UDim2.new(0, 2, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(150, 150, 158)
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 10)

    local state = false

    track.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(track, TWEEN_INFO, {
            BackgroundColor3 = state and ACCENT or Color3.fromRGB(52, 52, 58),
        }):Play()
        TweenService:Create(knob, TWEEN_INFO, {
            Position = state and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
            BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 158),
        }):Play()
    end)

    return row
end

local macroPage = pages["Macros"]["Main"]

local block = Instance.new("Frame")
block.Name = "MacroConfiguration"
block.Size = UDim2.new(1, 0, 0, 170)
block.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
block.BorderSizePixel = 0
block.Parent = macroPage
corner(block, 8)

local blockTitle = newLabel(block, "MACRO CONFIGURATION", 11, TEXT_MUTED)
blockTitle.Size = UDim2.new(1, -24, 0, 18)
blockTitle.Position = UDim2.fromOffset(12, 10)

local rows = Instance.new("Frame")
rows.Size = UDim2.new(1, 0, 1, -38)
rows.Position = UDim2.fromOffset(12, 34)
rows.BackgroundTransparency = 1
rows.Parent = block

local rowsLayout = Instance.new("UIListLayout")
rowsLayout.Padding = UDim.new(0, 4)
rowsLayout.SortOrder = Enum.SortOrder.LayoutOrder
rowsLayout.Parent = rows

createToggle(rows, "Auto Record Movement", 1)
createToggle(rows, "Use Fast Pathing", 2)
createToggle(rows, "Loop Macro Path", 3)

refresh()

print("HoneyMeelon Hub initialized.")
