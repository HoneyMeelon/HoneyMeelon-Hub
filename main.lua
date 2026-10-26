local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local GUI_NAME = "HoneyMeelonHub"
local ACCENT = Color3.fromRGB(235, 60, 60)
local WHITE = Color3.fromRGB(255, 255, 255)
local TEXT_PRIMARY = Color3.fromRGB(242, 242, 247)
local TEXT_MUTED = Color3.fromRGB(150, 150, 160)
local TWEEN_INFO = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

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

local function interFont(weight)
    return Font.new("rbxasset://fonts/families/Inter.json", weight, Enum.FontStyle.Normal)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function glass(frame, backgroundTransparency, edgeStrength)
    frame.BackgroundTransparency = backgroundTransparency

    local fill = Instance.new("UIGradient")
    fill.Rotation = 45
    fill.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.12),
        NumberSequenceKeypoint.new(1, 0.3),
    })
    fill.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = WHITE
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Transparency = 0
    stroke.Parent = frame

    local edge = Instance.new("UIGradient")
    edge.Rotation = 45
    edge.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1 - edgeStrength),
        NumberSequenceKeypoint.new(0.45, 0.94),
        NumberSequenceKeypoint.new(0.55, 0.94),
        NumberSequenceKeypoint.new(1, 1 - edgeStrength * 0.6),
    })
    edge.Parent = stroke

    return frame
end

local function newLabel(parent, text, size, color, weight)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.FontFace = interFont(weight or Enum.FontWeight.Regular)
    label.Text = text
    label.TextSize = size
    label.TextColor3 = color
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = parent
    return label
end

local function newIcon(parent, image, size, color)
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(size, size)
    icon.BackgroundTransparency = 1
    icon.Image = image
    icon.ImageColor3 = color
    icon.Parent = parent
    return icon
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
corner(main, 12)
glass(main, 0.12, 0.55)

local sheen = Instance.new("Frame")
sheen.Name = "Sheen"
sheen.Size = UDim2.fromScale(1, 1)
sheen.BackgroundColor3 = WHITE
sheen.BorderSizePixel = 0
sheen.Active = false
sheen.Parent = main
corner(sheen, 12)

local sheenGradient = Instance.new("UIGradient")
sheenGradient.Rotation = 60
sheenGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.93),
    NumberSequenceKeypoint.new(0.35, 0.98),
    NumberSequenceKeypoint.new(0.5, 1),
    NumberSequenceKeypoint.new(1, 1),
})
sheenGradient.Parent = sheen

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 190, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
sidebar.BackgroundTransparency = 0.55
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sidebarEdge = Instance.new("Frame")
sidebarEdge.Size = UDim2.new(0, 1, 1, 0)
sidebarEdge.AnchorPoint = Vector2.new(1, 0)
sidebarEdge.Position = UDim2.fromScale(1, 0)
sidebarEdge.BackgroundColor3 = WHITE
sidebarEdge.BackgroundTransparency = 0.9
sidebarEdge.BorderSizePixel = 0
sidebarEdge.Parent = sidebar

local logo = newIcon(sidebar, "rbxassetid://6031075929", 24, ACCENT)
logo.Name = "Logo"
logo.Position = UDim2.fromOffset(16, 16)
corner(logo, 12)

local title = newLabel(sidebar, "HoneyMeelon Hub", 14, TEXT_PRIMARY, Enum.FontWeight.SemiBold)
title.Name = "Title"
title.Size = UDim2.new(1, -56, 0, 24)
title.Position = UDim2.fromOffset(48, 16)

local tabHolder = Instance.new("Frame")
tabHolder.Name = "Tabs"
tabHolder.Size = UDim2.new(1, 0, 1, -64)
tabHolder.Position = UDim2.fromOffset(0, 60)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = sidebar

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

local tabNames = { "Lobby", "Match", "Auto Play", "Macros", "Webhook", "Misc", "Info" }
local tabIcons = {
    Lobby = "rbxassetid://6026568198",
    Match = "rbxassetid://6031280882",
    ["Auto Play"] = "rbxassetid://6023426915",
    Macros = "rbxassetid://6031097225",
    Webhook = "rbxassetid://6031094667",
    Misc = "rbxassetid://6031280883",
    Info = "rbxassetid://6026568227",
}
local ICON_CHEVRON = "rbxassetid://6031091004"
local ICON_NEW_FILE = "rbxassetid://6035067857"
local ICON_TRASH = "rbxassetid://6022668898"

local activeTab = "Macros"
local tabButtons = {}
local tabIconLabels = {}
local pages = {}

local function refreshTabs()
    for _, name in ipairs(tabNames) do
        local selected = name == activeTab
        TweenService:Create(tabButtons[name], TWEEN_INFO, {
            BackgroundTransparency = selected and 0.86 or 1,
            TextColor3 = selected and TEXT_PRIMARY or TEXT_MUTED,
        }):Play()
        tabIconLabels[name].ImageColor3 = selected and ACCENT or TEXT_MUTED
        pages[name].Visible = selected
    end
end

for index, name in ipairs(tabNames) do
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 34)
    button.BackgroundColor3 = WHITE
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.FontFace = interFont(Enum.FontWeight.Medium)
    button.Text = name
    button.TextSize = 13
    button.TextColor3 = TEXT_MUTED
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.LayoutOrder = index
    button.Parent = tabHolder
    corner(button, 8)

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 38)
    padding.Parent = button

    local icon = newIcon(button, tabIcons[name], 16, TEXT_MUTED)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.Position = UDim2.new(0, -26, 0.5, 0)
    tabIconLabels[name] = icon

    tabButtons[name] = button

    button.MouseButton1Click:Connect(function()
        activeTab = name
        refreshTabs()
    end)
end

for _, name in ipairs(tabNames) do
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, -32, 1, -24)
    page.Position = UDim2.fromOffset(16, 12)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = workspaceFrame
    pages[name] = page

    if name ~= "Macros" then
        local header = newLabel(page, name, 15, TEXT_PRIMARY, Enum.FontWeight.SemiBold)
        header.Size = UDim2.new(1, 0, 0, 24)
    end
end

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "MacroScroll"
scroll.Size = UDim2.fromScale(1, 1)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = WHITE
scroll.ScrollBarImageTransparency = 0.7
scroll.CanvasSize = UDim2.new()
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Parent = pages["Macros"]

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 8)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Parent = scroll

local scrollPadding = Instance.new("UIPadding")
scrollPadding.PaddingRight = UDim.new(0, 8)
scrollPadding.PaddingBottom = UDim.new(0, 8)
scrollPadding.Parent = scroll

local macroHeader = newLabel(scroll, "Macro State", 15, TEXT_PRIMARY, Enum.FontWeight.SemiBold)
macroHeader.Size = UDim2.new(1, 0, 0, 24)
macroHeader.LayoutOrder = 1

local card = Instance.new("Frame")
card.Name = "StateCard"
card.Size = UDim2.new(1, 0, 0, 0)
card.AutomaticSize = Enum.AutomaticSize.Y
card.BackgroundColor3 = WHITE
card.BorderSizePixel = 0
card.LayoutOrder = 2
card.Parent = scroll
corner(card, 12)
glass(card, 0.93, 0.5)

local cardLayout = Instance.new("UIListLayout")
cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
cardLayout.Parent = card

local function newRow(order, height, last)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = card

    if not last then
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -32, 0, 1)
        line.AnchorPoint = Vector2.new(0.5, 1)
        line.Position = UDim2.new(0.5, 0, 1, 0)
        line.BackgroundColor3 = WHITE
        line.BackgroundTransparency = 0.92
        line.BorderSizePixel = 0
        line.Parent = row
    end

    return row
end

local function infoRow(order, titleText, subText)
    local row = newRow(order, 56, false)

    local top = newLabel(row, titleText, 14, TEXT_PRIMARY, Enum.FontWeight.SemiBold)
    top.Size = UDim2.new(1, -32, 0, 18)
    top.Position = UDim2.fromOffset(16, 10)

    local bottom = newLabel(row, subText, 12, TEXT_MUTED, Enum.FontWeight.Regular)
    bottom.Size = UDim2.new(1, -32, 0, 16)
    bottom.Position = UDim2.fromOffset(16, 30)

    return top, bottom
end

local function controlRow(order, labelText, last)
    local row = newRow(order, 50, last)

    local label = newLabel(row, labelText, 14, TEXT_PRIMARY, Enum.FontWeight.SemiBold)
    label.Size = UDim2.new(0.5, -16, 1, 0)
    label.Position = UDim2.fromOffset(16, 0)

    return row
end

local stateTitle, loadedSub = infoRow(1, "State: Idle", "")
local matchTitle, matchSub = infoRow(2, "Live match", "Wave 2 | Hybrid | Cash: 250")
local recordedTitle, recordedSub = infoRow(3, "", "")

local createRow = controlRow(4, "Create Macro", false)

local inputPill = Instance.new("Frame")
inputPill.Size = UDim2.fromOffset(150, 30)
inputPill.AnchorPoint = Vector2.new(1, 0.5)
inputPill.Position = UDim2.new(1, -16, 0.5, 0)
inputPill.BackgroundColor3 = WHITE
inputPill.BackgroundTransparency = 0.9
inputPill.BorderSizePixel = 0
inputPill.Parent = createRow
corner(inputPill, 15)

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -24, 1, 0)
input.Position = UDim2.fromOffset(12, 0)
input.BackgroundTransparency = 1
input.FontFace = interFont(Enum.FontWeight.Regular)
input.Text = "main"
input.PlaceholderText = "name"
input.PlaceholderColor3 = TEXT_MUTED
input.TextSize = 13
input.TextColor3 = TEXT_PRIMARY
input.TextXAlignment = Enum.TextXAlignment.Left
input.ClearTextOnFocus = false
input.Parent = inputPill

local newRowFrame = controlRow(5, "Create New Macro", false)

local newButton = Instance.new("TextButton")
newButton.Size = UDim2.fromOffset(30, 30)
newButton.AnchorPoint = Vector2.new(1, 0.5)
newButton.Position = UDim2.new(1, -16, 0.5, 0)
newButton.BackgroundTransparency = 1
newButton.Text = ""
newButton.AutoButtonColor = false
newButton.Parent = newRowFrame

local newIconLabel = newIcon(newButton, ICON_NEW_FILE, 18, TEXT_PRIMARY)
newIconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
newIconLabel.Position = UDim2.fromScale(0.5, 0.5)

local selectRow = controlRow(6, "Select Macro", false)

local dropdownButton = Instance.new("TextButton")
dropdownButton.Size = UDim2.fromOffset(150, 30)
dropdownButton.AnchorPoint = Vector2.new(1, 0.5)
dropdownButton.Position = UDim2.new(1, -16, 0.5, 0)
dropdownButton.BackgroundColor3 = WHITE
dropdownButton.BackgroundTransparency = 0.9
dropdownButton.BorderSizePixel = 0
dropdownButton.AutoButtonColor = false
dropdownButton.Text = ""
dropdownButton.Parent = selectRow
corner(dropdownButton, 15)

local dropdownLabel = newLabel(dropdownButton, "", 13, TEXT_PRIMARY, Enum.FontWeight.Regular)
dropdownLabel.Size = UDim2.new(1, -44, 1, 0)
dropdownLabel.Position = UDim2.fromOffset(12, 0)

local chevron = newIcon(dropdownButton, ICON_CHEVRON, 14, TEXT_MUTED)
chevron.AnchorPoint = Vector2.new(1, 0.5)
chevron.Position = UDim2.new(1, -10, 0.5, 0)

local deleteRow = controlRow(7, "Delete Selected Macro", true)

local deleteButton = Instance.new("TextButton")
deleteButton.Size = UDim2.fromOffset(30, 30)
deleteButton.AnchorPoint = Vector2.new(1, 0.5)
deleteButton.Position = UDim2.new(1, -16, 0.5, 0)
deleteButton.BackgroundTransparency = 1
deleteButton.Text = ""
deleteButton.AutoButtonColor = false
deleteButton.Parent = deleteRow

local deleteIcon = newIcon(deleteButton, ICON_TRASH, 18, ACCENT)
deleteIcon.AnchorPoint = Vector2.new(0.5, 0.5)
deleteIcon.Position = UDim2.fromScale(0.5, 0.5)

local macroOrder = { "insanemod" }
local macroActions = { insanemod = 49 }
local selectedMacro = "insanemod"

local popup = Instance.new("Frame")
popup.Name = "Popup"
popup.Size = UDim2.fromOffset(150, 0)
popup.AutomaticSize = Enum.AutomaticSize.Y
popup.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
popup.BorderSizePixel = 0
popup.Visible = false
popup.ZIndex = 50
popup.Parent = main
corner(popup, 12)
glass(popup, 0.15, 0.6)

local popupLayout = Instance.new("UIListLayout")
popupLayout.Padding = UDim.new(0, 2)
popupLayout.SortOrder = Enum.SortOrder.LayoutOrder
popupLayout.Parent = popup

local popupPadding = Instance.new("UIPadding")
popupPadding.PaddingTop = UDim.new(0, 4)
popupPadding.PaddingBottom = UDim.new(0, 4)
popupPadding.PaddingLeft = UDim.new(0, 4)
popupPadding.PaddingRight = UDim.new(0, 4)
popupPadding.Parent = popup

local function updateState()
    local count = selectedMacro and macroActions[selectedMacro] or 0
    stateTitle.Text = "State: Idle"
    loadedSub.Text = selectedMacro and ("Loaded " .. selectedMacro .. " | " .. count .. " actions") or "No macro loaded"
    recordedTitle.Text = "Recorded actions: " .. count
    recordedSub.Text = selectedMacro and ("Selected macro: " .. selectedMacro .. " | " .. count .. " actions") or "Selected macro: none"
    dropdownLabel.Text = selectedMacro or "None"
end

local function closePopup()
    popup.Visible = false
end

local function openPopup()
    for _, child in ipairs(popup:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for index, name in ipairs(macroOrder) do
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, 0, 0, 28)
        option.BackgroundColor3 = WHITE
        option.BackgroundTransparency = name == selectedMacro and 0.88 or 1
        option.BorderSizePixel = 0
        option.AutoButtonColor = false
        option.FontFace = interFont(Enum.FontWeight.Regular)
        option.Text = name
        option.TextSize = 13
        option.TextColor3 = TEXT_PRIMARY
        option.TextXAlignment = Enum.TextXAlignment.Left
        option.LayoutOrder = index
        option.ZIndex = 51
        option.Parent = popup
        corner(option, 8)

        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 10)
        optionPadding.Parent = option

        option.MouseButton1Click:Connect(function()
            selectedMacro = name
            updateState()
            closePopup()
        end)
    end

    local offset = dropdownButton.AbsolutePosition - main.AbsolutePosition
    popup.Position = UDim2.fromOffset(offset.X, offset.Y + dropdownButton.AbsoluteSize.Y + 4)
    popup.Visible = #macroOrder > 0
end

dropdownButton.MouseButton1Click:Connect(function()
    if popup.Visible then
        closePopup()
    else
        openPopup()
    end
end)

scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(closePopup)

newButton.MouseButton1Click:Connect(function()
    local name = input.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" or macroActions[name] ~= nil then
        return
    end
    table.insert(macroOrder, name)
    macroActions[name] = 0
    selectedMacro = name
    updateState()
end)

deleteButton.MouseButton1Click:Connect(function()
    if not selectedMacro then
        return
    end
    local position = table.find(macroOrder, selectedMacro)
    macroActions[selectedMacro] = nil
    if position then
        table.remove(macroOrder, position)
    end
    selectedMacro = macroOrder[math.min(position or 1, #macroOrder)]
    updateState()
    closePopup()
end)

updateState()
refreshTabs()

print("HoneyMeelon Hub initialized.")
