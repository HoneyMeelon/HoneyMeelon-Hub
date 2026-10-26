local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local GUI_NAME = "HoneyMeelonHub"
local WINDOW_SIZE = Vector2.new(760, 450)
local RAIL_WIDTH = 55
local LIST_WIDTH = 135
local SIDE_WIDTH = RAIL_WIDTH + LIST_WIDTH

local ACCENT = Color3.fromRGB(235, 60, 60)
local ACCENT_DIM = Color3.fromRGB(92, 38, 42)
local WHITE = Color3.fromRGB(255, 255, 255)
local TEXT_PRIMARY = Color3.fromRGB(240, 240, 245)
local TEXT_MUTED = Color3.fromRGB(142, 142, 152)
local TRACK_OFF = Color3.fromRGB(40, 40, 46)
local KNOB_OFF = Color3.fromRGB(68, 68, 75)
local FAST = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local ICONS = {
    Logo = "rbxassetid://6031075929",
    Lobby = "rbxassetid://6026568198",
    Match = "rbxassetid://6031280882",
    ["Auto Play"] = "rbxassetid://6023426915",
    Macros = "rbxassetid://6031097225",
    Webhook = "rbxassetid://6031094667",
    Misc = "rbxassetid://6031280883",
    Info = "rbxassetid://6026568227",
    Chevron = "rbxassetid://6031091004",
    Search = "rbxassetid://6031154871",
    Gear = "rbxassetid://6031280887",
}

local Flags = {}

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

local connections = {}

local function bind(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

screenGui.Destroying:Connect(function()
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
end)

local function font(weight)
    return Font.new("rbxasset://fonts/families/Inter.json", weight, Enum.FontStyle.Normal)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(parent, transparency)
    local s = Instance.new("UIStroke")
    s.Color = WHITE
    s.Thickness = 1
    s.Transparency = transparency
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function label(parent, text, size, color, weight, alignment)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.FontFace = font(weight or Enum.FontWeight.Regular)
    l.Text = text
    l.TextSize = size
    l.TextColor3 = color
    l.TextXAlignment = alignment or Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = parent
    return l
end

local function icon(parent, image, size, color)
    local i = Instance.new("ImageLabel")
    i.Size = UDim2.fromOffset(size, size)
    i.BackgroundTransparency = 1
    i.Image = image
    i.ImageColor3 = color
    i.Parent = parent
    return i
end

local function listLayout(parent, padding, direction)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, padding or 0)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.Parent = parent
    return layout
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(WINDOW_SIZE.X, WINDOW_SIZE.Y)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
main.BackgroundTransparency = 0.04
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 12)

local mainEdge = stroke(main, 0)
local mainEdgeGradient = Instance.new("UIGradient")
mainEdgeGradient.Rotation = 45
mainEdgeGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.5),
    NumberSequenceKeypoint.new(0.5, 0.93),
    NumberSequenceKeypoint.new(1, 0.72),
})
mainEdgeGradient.Parent = mainEdge

local catcher = Instance.new("TextButton")
catcher.Name = "Catcher"
catcher.Size = UDim2.fromScale(1, 1)
catcher.BackgroundTransparency = 1
catcher.Text = ""
catcher.AutoButtonColor = false
catcher.Visible = false
catcher.ZIndex = 49
catcher.Parent = main

local popup = Instance.new("Frame")
popup.Name = "Popup"
popup.Size = UDim2.fromOffset(120, 0)
popup.AutomaticSize = Enum.AutomaticSize.Y
popup.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
popup.BackgroundTransparency = 0.04
popup.BorderSizePixel = 0
popup.Visible = false
popup.ZIndex = 50
popup.Parent = main
corner(popup, 10)
stroke(popup, 0.88)
listLayout(popup, 2)

local popupPadding = Instance.new("UIPadding")
popupPadding.PaddingTop = UDim.new(0, 4)
popupPadding.PaddingBottom = UDim.new(0, 4)
popupPadding.PaddingLeft = UDim.new(0, 4)
popupPadding.PaddingRight = UDim.new(0, 4)
popupPadding.Parent = popup

local function closePopup()
    popup.Visible = false
    catcher.Visible = false
end

catcher.MouseButton1Click:Connect(closePopup)

local function openPopup(anchor, options, current, onPick)
    if #options == 0 then
        return
    end

    for _, child in ipairs(popup:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for index, name in ipairs(options) do
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, 0, 0, 26)
        option.BackgroundColor3 = WHITE
        option.BackgroundTransparency = name == current and 0.9 or 1
        option.BorderSizePixel = 0
        option.AutoButtonColor = false
        option.FontFace = font(Enum.FontWeight.Regular)
        option.Text = name
        option.TextSize = 12
        option.TextColor3 = name == current and ACCENT or TEXT_PRIMARY
        option.TextXAlignment = Enum.TextXAlignment.Left
        option.LayoutOrder = index
        option.Parent = popup
        corner(option, 7)

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.Parent = option

        option.MouseEnter:Connect(function()
            if name ~= current then
                option.BackgroundTransparency = 0.94
            end
        end)

        option.MouseLeave:Connect(function()
            if name ~= current then
                option.BackgroundTransparency = 1
            end
        end)

        option.MouseButton1Click:Connect(function()
            closePopup()
            onPick(name)
        end)
    end

    local width = math.max(anchor.AbsoluteSize.X, 110)
    local offset = anchor.AbsolutePosition - main.AbsolutePosition
    local height = #options * 28 + 8
    local y = offset.Y + anchor.AbsoluteSize.Y + 4
    if y + height > main.AbsoluteSize.Y - 6 then
        y = offset.Y - height - 4
    end

    popup.Size = UDim2.fromOffset(width, 0)
    popup.Position = UDim2.fromOffset(offset.X + anchor.AbsoluteSize.X - width, y)
    popup.Visible = true
    catcher.Visible = true
end

local rail = Instance.new("Frame")
rail.Name = "Rail"
rail.Size = UDim2.new(0, RAIL_WIDTH, 1, 0)
rail.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
rail.BackgroundTransparency = 0.25
rail.BorderSizePixel = 0
rail.Parent = main

local railEdge = Instance.new("Frame")
railEdge.Size = UDim2.new(0, 1, 1, 0)
railEdge.AnchorPoint = Vector2.new(1, 0)
railEdge.Position = UDim2.fromScale(1, 0)
railEdge.BackgroundColor3 = WHITE
railEdge.BackgroundTransparency = 0.94
railEdge.BorderSizePixel = 0
railEdge.Parent = rail

local logo = icon(rail, ICONS.Logo, 28, ACCENT)
logo.Name = "Logo"
logo.AnchorPoint = Vector2.new(0.5, 0)
logo.Position = UDim2.new(0.5, 0, 0, 16)
corner(logo, 14)

local railHolder = Instance.new("Frame")
railHolder.Name = "Icons"
railHolder.Size = UDim2.new(1, 0, 1, -72)
railHolder.Position = UDim2.fromOffset(0, 66)
railHolder.BackgroundTransparency = 1
railHolder.Parent = rail

local railLayout = listLayout(railHolder, 6)
railLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local list = Instance.new("Frame")
list.Name = "List"
list.Size = UDim2.new(0, LIST_WIDTH, 1, 0)
list.Position = UDim2.fromOffset(RAIL_WIDTH, 0)
list.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
list.BackgroundTransparency = 0.35
list.BorderSizePixel = 0
list.Parent = main

local listEdge = Instance.new("Frame")
listEdge.Size = UDim2.new(0, 1, 1, 0)
listEdge.AnchorPoint = Vector2.new(1, 0)
listEdge.Position = UDim2.fromScale(1, 0)
listEdge.BackgroundColor3 = WHITE
listEdge.BackgroundTransparency = 0.94
listEdge.BorderSizePixel = 0
listEdge.Parent = list

local listTitle = label(list, "HoneyMeelon Hub", 14, TEXT_MUTED, Enum.FontWeight.SemiBold)
listTitle.Name = "Title"
listTitle.Size = UDim2.new(1, -24, 0, 28)
listTitle.Position = UDim2.fromOffset(16, 16)

local listHolder = Instance.new("Frame")
listHolder.Name = "Tabs"
listHolder.Size = UDim2.new(1, 0, 1, -72)
listHolder.Position = UDim2.fromOffset(0, 58)
listHolder.BackgroundTransparency = 1
listHolder.Parent = list

local listHolderLayout = listLayout(listHolder, 4)
listHolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local workspaceFrame = Instance.new("Frame")
workspaceFrame.Name = "Workspace"
workspaceFrame.Size = UDim2.new(1, -SIDE_WIDTH, 1, 0)
workspaceFrame.Position = UDim2.fromOffset(SIDE_WIDTH, 0)
workspaceFrame.BackgroundTransparency = 1
workspaceFrame.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundTransparency = 1
header.Parent = workspaceFrame

local crumb = label(header, "", 15, TEXT_MUTED, Enum.FontWeight.SemiBold)
crumb.RichText = true
crumb.Size = UDim2.new(1, -190, 1, 0)
crumb.Position = UDim2.fromOffset(16, 0)

local searchPill = Instance.new("Frame")
searchPill.Name = "Search"
searchPill.Size = UDim2.fromOffset(140, 28)
searchPill.AnchorPoint = Vector2.new(1, 0.5)
searchPill.Position = UDim2.new(1, -16, 0.5, 0)
searchPill.BackgroundColor3 = WHITE
searchPill.BackgroundTransparency = 0.93
searchPill.BorderSizePixel = 0
searchPill.Parent = header
corner(searchPill, 14)

local searchIcon = icon(searchPill, ICONS.Search, 14, TEXT_MUTED)
searchIcon.AnchorPoint = Vector2.new(0, 0.5)
searchIcon.Position = UDim2.new(0, 10, 0.5, 0)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -36, 1, 0)
searchBox.Position = UDim2.fromOffset(30, 0)
searchBox.BackgroundTransparency = 1
searchBox.FontFace = font(Enum.FontWeight.Regular)
searchBox.Text = ""
searchBox.PlaceholderText = "Search"
searchBox.PlaceholderColor3 = TEXT_MUTED
searchBox.TextSize = 13
searchBox.TextColor3 = TEXT_PRIMARY
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.Parent = searchPill

local subBar = Instance.new("Frame")
subBar.Name = "SubBar"
subBar.Size = UDim2.new(1, -32, 0, 30)
subBar.Position = UDim2.fromOffset(16, 46)
subBar.BackgroundTransparency = 1
subBar.Parent = workspaceFrame

local subLayout = listLayout(subBar, 2, Enum.FillDirection.Horizontal)
subLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local pagesHolder = Instance.new("Frame")
pagesHolder.Name = "Pages"
pagesHolder.Size = UDim2.new(1, -32, 1, -92)
pagesHolder.Position = UDim2.fromOffset(16, 82)
pagesHolder.BackgroundTransparency = 1
pagesHolder.Parent = workspaceFrame

local tabs = { "Lobby", "Match", "Auto Play", "Macros", "Webhook", "Misc", "Info" }
local subs = { "Main", "Panels", "Auto Usage", "Binds", "Extra" }

local activeTab = "Macros"
local activeSub = "Main"

local railButtons = {}
local listButtons = {}
local subButtons = {}
local pageFrames = {}
local pageRecords = {}

local go

for index, name in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(38, 38)
    button.BackgroundColor3 = WHITE
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Text = ""
    button.LayoutOrder = index
    button.Parent = railHolder
    corner(button, 10)

    local glyph = icon(button, ICONS[name], 18, TEXT_MUTED)
    glyph.AnchorPoint = Vector2.new(0.5, 0.5)
    glyph.Position = UDim2.fromScale(0.5, 0.5)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.fromOffset(3, 16)
    bar.AnchorPoint = Vector2.new(0, 0.5)
    bar.Position = UDim2.new(0, -8, 0.5, 0)
    bar.BackgroundColor3 = ACCENT
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.Parent = button
    corner(bar, 2)

    railButtons[name] = { button = button, glyph = glyph, bar = bar }

    button.MouseButton1Click:Connect(function()
        go(name, "Main")
    end)
end

for index, name in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 30)
    button.BackgroundColor3 = WHITE
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.FontFace = font(Enum.FontWeight.Medium)
    button.Text = name
    button.TextSize = 13
    button.TextColor3 = TEXT_MUTED
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.LayoutOrder = index
    button.Parent = listHolder
    corner(button, 8)

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = button

    local bar = Instance.new("Frame")
    bar.Size = UDim2.fromOffset(3, 14)
    bar.AnchorPoint = Vector2.new(0, 0.5)
    bar.Position = UDim2.new(0, -20, 0.5, 0)
    bar.BackgroundColor3 = ACCENT
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.Parent = button
    corner(bar, 2)

    listButtons[name] = { button = button, bar = bar }

    button.MouseButton1Click:Connect(function()
        go(name, "Main")
    end)
end

for index, name in ipairs(subs) do
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(0, 28)
    button.AutomaticSize = Enum.AutomaticSize.X
    button.BackgroundColor3 = WHITE
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.FontFace = font(Enum.FontWeight.Medium)
    button.Text = name
    button.TextSize = 13
    button.TextColor3 = TEXT_MUTED
    button.LayoutOrder = index
    button.Parent = subBar
    corner(button, 8)

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = button

    subButtons[name] = button

    button.MouseButton1Click:Connect(function()
        go(activeTab, name)
    end)
end

local function newRow(record, height, searchText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundTransparency = 1
    row.LayoutOrder = #record.rows + 2
    row.Parent = record.frame

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -24, 0, 1)
    line.AnchorPoint = Vector2.new(0.5, 1)
    line.Position = UDim2.new(0.5, 0, 1, 0)
    line.BackgroundColor3 = WHITE
    line.BackgroundTransparency = 0.94
    line.BorderSizePixel = 0
    line.Parent = row

    table.insert(record.rows, { frame = row, line = line, text = string.lower(searchText) })
    return row
end

local function rowLabel(row, text, rightInset)
    local l = label(row, text, 13, TEXT_PRIMARY, Enum.FontWeight.Medium)
    l.Size = UDim2.new(1, -(rightInset + 12), 1, 0)
    l.Position = UDim2.fromOffset(12, 0)
    return l
end

local function pill(parent, width)
    local p = Instance.new("TextButton")
    p.Size = UDim2.fromOffset(width, 26)
    p.AnchorPoint = Vector2.new(1, 0.5)
    p.Position = UDim2.new(1, -12, 0.5, 0)
    p.BackgroundColor3 = WHITE
    p.BackgroundTransparency = 0.92
    p.BorderSizePixel = 0
    p.AutoButtonColor = false
    p.FontFace = font(Enum.FontWeight.Medium)
    p.Text = ""
    p.TextSize = 12
    p.TextColor3 = TEXT_PRIMARY
    p.Parent = parent
    corner(p, 8)

    p.MouseEnter:Connect(function()
        TweenService:Create(p, FAST, { BackgroundTransparency = 0.86 }):Play()
    end)

    p.MouseLeave:Connect(function()
        TweenService:Create(p, FAST, { BackgroundTransparency = 0.92 }):Play()
    end)

    return p
end

local function twoLine(record, searchText)
    local row = newRow(record, 46, searchText)

    local top = label(row, "", 13, TEXT_PRIMARY, Enum.FontWeight.SemiBold)
    top.Size = UDim2.new(1, -24, 0, 18)
    top.Position = UDim2.fromOffset(12, 7)

    local bottom = label(row, "", 12, TEXT_MUTED, Enum.FontWeight.Regular)
    bottom.Size = UDim2.new(1, -24, 0, 16)
    bottom.Position = UDim2.fromOffset(12, 25)

    return top, bottom
end

local function toggleRow(record, item)
    local key = item.flag or item.text
    local row = newRow(record, 36, item.text)
    rowLabel(row, item.text, item.gear and 80 or 60)

    local track = Instance.new("TextButton")
    track.Size = UDim2.fromOffset(34, 16)
    track.AnchorPoint = Vector2.new(1, 0.5)
    track.Position = UDim2.new(1, -16, 0.5, 0)
    track.BackgroundColor3 = TRACK_OFF
    track.BorderSizePixel = 0
    track.AutoButtonColor = false
    track.Text = ""
    track.Parent = row
    corner(track, 8)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = UDim2.new(0, -2, 0.5, 0)
    knob.BackgroundColor3 = KNOB_OFF
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 10)

    if item.gear then
        local gear = Instance.new("ImageButton")
        gear.Size = UDim2.fromOffset(15, 15)
        gear.AnchorPoint = Vector2.new(1, 0.5)
        gear.Position = UDim2.new(1, -62, 0.5, 0)
        gear.BackgroundTransparency = 1
        gear.Image = ICONS.Gear
        gear.ImageColor3 = TEXT_MUTED
        gear.AutoButtonColor = false
        gear.Parent = row

        gear.MouseEnter:Connect(function()
            gear.ImageColor3 = TEXT_PRIMARY
        end)

        gear.MouseLeave:Connect(function()
            gear.ImageColor3 = TEXT_MUTED
        end)
    end

    local state = item.default == true

    local function render(animate)
        local goal = state and ACCENT_DIM or TRACK_OFF
        local knobGoal = {
            Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, -2, 0.5, 0),
            BackgroundColor3 = state and ACCENT or KNOB_OFF,
        }
        if animate then
            TweenService:Create(track, FAST, { BackgroundColor3 = goal }):Play()
            TweenService:Create(knob, FAST, knobGoal):Play()
        else
            track.BackgroundColor3 = goal
            knob.Position = knobGoal.Position
            knob.BackgroundColor3 = knobGoal.BackgroundColor3
        end
    end

    Flags[key] = state
    render(false)

    track.MouseButton1Click:Connect(function()
        state = not state
        Flags[key] = state
        render(true)
        if item.callback then
            item.callback(state)
        end
    end)

    return row
end

local function dropdownRow(record, item)
    local key = item.flag or item.text
    local row = newRow(record, 38, item.text)
    rowLabel(row, item.text, 140)

    local button = pill(row, 120)

    local value = label(button, item.default or "", 12, TEXT_MUTED, Enum.FontWeight.Regular)
    value.Size = UDim2.new(1, -30, 1, 0)
    value.Position = UDim2.fromOffset(10, 0)

    local chevron = icon(button, ICONS.Chevron, 12, TEXT_MUTED)
    chevron.AnchorPoint = Vector2.new(1, 0.5)
    chevron.Position = UDim2.new(1, -8, 0.5, 0)

    local current = item.default
    Flags[key] = current

    local function getOptions()
        if type(item.options) == "function" then
            return item.options()
        end
        return item.options
    end

    button.MouseButton1Click:Connect(function()
        openPopup(button, getOptions(), current, function(choice)
            current = choice
            value.Text = choice
            Flags[key] = choice
            if item.callback then
                item.callback(choice)
            end
        end)
    end)

    return {
        setValue = function(text)
            current = text
            value.Text = text
        end,
    }
end

local function sliderRow(record, item)
    local key = item.flag or item.text
    local step = item.step or 1
    local value = item.default
    local row = newRow(record, 52, item.text)

    local title = rowLabel(row, item.text, 80)
    title.Size = UDim2.new(1, -92, 0, 28)
    title.Position = UDim2.fromOffset(12, 4)

    local valueLabel = label(row, "", 12, TEXT_MUTED, Enum.FontWeight.Regular, Enum.TextXAlignment.Right)
    valueLabel.Size = UDim2.fromOffset(70, 28)
    valueLabel.AnchorPoint = Vector2.new(1, 0)
    valueLabel.Position = UDim2.new(1, -12, 0, 4)

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.fromOffset(12, 38)
    track.BackgroundColor3 = TRACK_OFF
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(0, 1)
    fill.BackgroundColor3 = ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 2)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(12, 12)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.fromScale(0, 0.5)
    knob.BackgroundColor3 = WHITE
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 6)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, -24, 0, 24)
    hit.Position = UDim2.fromOffset(12, 28)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.Parent = row

    local function render()
        local ratio = (value - item.min) / (item.max - item.min)
        fill.Size = UDim2.fromScale(ratio, 1)
        knob.Position = UDim2.fromScale(ratio, 0.5)
        valueLabel.Text = tostring(value) .. (item.suffix or "")
    end

    local function setFromX(x)
        local ratio = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = item.min + (item.max - item.min) * ratio
        local snapped = item.min + math.floor((raw - item.min) / step + 0.5) * step
        snapped = math.clamp(snapped, item.min, item.max)
        if snapped ~= value then
            value = snapped
            Flags[key] = value
            render()
            if item.callback then
                item.callback(value)
            end
        end
    end

    local dragging = false

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            main.Draggable = false
            setFromX(input.Position.X)
        end
    end)

    bind(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)

    bind(UserInputService.InputEnded, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            main.Draggable = true
        end
    end)

    Flags[key] = value
    render()

    return row
end

local function buttonRow(record, item)
    local row = newRow(record, 38, item.text)
    rowLabel(row, item.text, 110)

    local button = pill(row, 84)
    button.Text = item.button
    button.TextColor3 = item.danger and ACCENT or TEXT_PRIMARY

    button.MouseButton1Click:Connect(function()
        if item.callback then
            item.callback()
        end
    end)

    return button
end

local function inputRow(record, item)
    local key = item.flag or item.text
    local row = newRow(record, 38, item.text)
    rowLabel(row, item.text, 170)

    local holder = pill(row, 150)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 1, 0)
    box.Position = UDim2.fromOffset(10, 0)
    box.BackgroundTransparency = 1
    box.FontFace = font(Enum.FontWeight.Regular)
    box.Text = item.default or ""
    box.PlaceholderText = item.placeholder or ""
    box.PlaceholderColor3 = TEXT_MUTED
    box.TextSize = 12
    box.TextColor3 = TEXT_PRIMARY
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.TextTruncate = Enum.TextTruncate.AtEnd
    box.Parent = holder

    Flags[key] = box.Text

    box.FocusLost:Connect(function()
        Flags[key] = box.Text
        if item.callback then
            item.callback(box.Text)
        end
    end)

    return box
end

local function infoRow(record, item)
    local top, bottom = twoLine(record, item.text .. " " .. (item.sub or ""))
    top.Text = item.text
    bottom.Text = item.sub or ""
end

local builders = {
    toggle = toggleRow,
    dropdown = dropdownRow,
    slider = sliderRow,
    button = buttonRow,
    input = inputRow,
    info = infoRow,
}

local function buildMacroState(record)
    local macroOrder = { "insanemod" }
    local macroActions = { insanemod = 49 }
    local selected = "insanemod"
    local dropdown

    local stateTop, stateSub = twoLine(record, "state idle loaded macro actions")
    local matchTop, matchSub = twoLine(record, "live match wave hybrid cash")
    local recordedTop, recordedSub = twoLine(record, "recorded actions selected macro")

    local nameBox = inputRow(record, { text = "Create Macro", default = "main", placeholder = "name" })

    local function update()
        local count = selected and macroActions[selected] or 0
        stateTop.Text = "State: Idle"
        stateSub.Text = selected and string.format("Loaded %s | %d actions", selected, count) or "No macro loaded"
        recordedTop.Text = "Recorded actions: " .. count
        recordedSub.Text = selected and string.format("Selected macro: %s | %d actions", selected, count) or "Selected macro: none"
        dropdown.setValue(selected or "None")
    end

    buttonRow(record, {
        text = "Create New Macro",
        button = "Create",
        callback = function()
            local name = nameBox.Text:match("^%s*(.-)%s*$")
            if name == "" or macroActions[name] ~= nil then
                return
            end
            table.insert(macroOrder, name)
            macroActions[name] = 0
            selected = name
            update()
        end,
    })

    dropdown = dropdownRow(record, {
        text = "Select Macro",
        default = selected,
        options = function()
            return macroOrder
        end,
        callback = function(choice)
            selected = choice
            update()
        end,
    })

    buttonRow(record, {
        text = "Delete Selected Macro",
        button = "Delete",
        danger = true,
        callback = function()
            if not selected then
                return
            end
            local position = table.find(macroOrder, selected)
            macroActions[selected] = nil
            table.remove(macroOrder, position)
            selected = macroOrder[math.min(position, #macroOrder)]
            update()
        end,
    })

    matchTop.Text = "Live match"
    matchSub.Text = "Wave 2 | Hybrid | Cash: 250"
    update()
end

local function T(text, default, gear)
    return { type = "toggle", text = text, default = default or false, gear = gear }
end

local function D(text, options, default)
    return { type = "dropdown", text = text, options = options, default = default or options[1] }
end

local function S(text, min, max, default, step, suffix, callback)
    return { type = "slider", text = text, min = min, max = max, default = default, step = step, suffix = suffix, callback = callback }
end

local function B(text, button, callback, danger)
    return { type = "button", text = text, button = button, callback = callback, danger = danger }
end

local function I(text, placeholder, default)
    return { type = "input", text = text, placeholder = placeholder, default = default }
end

local function N(text, sub)
    return { type = "info", text = text, sub = sub }
end

local layouts = {
    Macros = {
        Main = {
            left = {
                { title = "Macro State", build = buildMacroState },
            },
            right = {
                { title = "Recording", items = {
                    T("Auto Record Movement", true, true),
                    T("Use Fast Pathing"),
                    T("Loop Macro Path", true),
                    D("Record Mode", { "Hybrid", "Strict", "Relaxed" }),
                } },
                { title = "Playback", items = {
                    S("Playback Speed", 1, 5, 2, 1, "x"),
                    S("Action Delay", 0, 500, 120, 10, " ms"),
                    T("Pause On Death", true),
                } },
            },
        },
        Panels = {
            left = {
                { title = "Status Panel", items = {
                    T("Show Status Panel", true, true),
                    T("Show Action Counter", true),
                    T("Show Timeline"),
                } },
            },
            right = {
                { title = "Panel Layout", items = {
                    D("Position", { "Top Left", "Top Right", "Bottom Left", "Bottom Right" }),
                    S("Panel Opacity", 20, 100, 85, 5, "%"),
                } },
            },
        },
        ["Auto Usage"] = {
            left = {
                { title = "Auto Use Settings", items = {
                    T("Auto Use", true, true),
                    D("Trigger", { "If Lethal", "Always", "Never" }),
                    T("Use With Booster"),
                    T("Move Camera", true),
                    D("Returns Camera", { "Never", "Always", "After Cast" }),
                    T("Use On Running Target", true, true),
                } },
            },
            right = {
                { title = "Threshold Settings", items = {
                    T("Auto Use Threshold", true, true),
                    S("Minimum Targets", 1, 10, 2, 1, ""),
                    T("Use Refresher"),
                } },
                { title = "Interrupt Settings", items = {
                    T("Interrupt Teleports", true),
                    T("Interrupt Channels", true),
                } },
            },
        },
        Binds = {
            left = {
                { title = "Hotkeys", items = {
                    B("Start Recording", "F6"),
                    B("Stop Recording", "F7"),
                    B("Play Macro", "F8"),
                } },
            },
            right = {
                { title = "Input", items = {
                    T("Show Keybind List", true),
                    T("Block Game Input"),
                } },
            },
        },
        Extra = {
            left = {
                { title = "Import And Export", items = {
                    B("Copy Macro", "Copy"),
                    B("Import Macro", "Import"),
                } },
            },
            right = {
                { title = "Advanced", items = {
                    T("Verbose Logging"),
                    T("Auto Save Macros", true),
                } },
            },
        },
    },
    Lobby = {
        Main = {
            left = {
                { title = "Lobby Automation", items = {
                    T("Auto Join Lobby", true, true),
                    T("Auto Ready"),
                    D("Preferred Mode", { "Solo", "Duo", "Squad" }),
                    T("Rejoin After Kick", true),
                } },
            },
            right = {
                { title = "Matchmaking", items = {
                    S("Search Timeout", 5, 120, 30, 5, " s"),
                    T("Skip Cutscenes", true),
                    D("Region", { "Auto", "Europe", "North America", "Asia" }),
                } },
            },
        },
    },
    Match = {
        Main = {
            left = {
                { title = "Match Control", items = {
                    T("Auto Start Wave", true, true),
                    T("Auto Skip Wave"),
                    T("Auto Upgrade", true),
                    D("Upgrade Priority", { "Damage", "Range", "Economy" }),
                } },
            },
            right = {
                { title = "Limits", items = {
                    S("Max Wave", 1, 100, 30, 1, ""),
                    S("Cash Reserve", 0, 1000, 250, 50, ""),
                    T("Stop On Defeat"),
                } },
            },
        },
    },
    ["Auto Play"] = {
        Main = {
            left = {
                { title = "Auto Play", items = {
                    T("Enable Auto Play", false, true),
                    D("Strategy", { "Hybrid", "Aggressive", "Defensive" }),
                    T("Auto Replay", true),
                } },
            },
            right = {
                { title = "Behaviour", items = {
                    S("Reaction Delay", 0, 1000, 150, 10, " ms"),
                    T("Anti AFK", true),
                } },
            },
        },
    },
    Webhook = {
        Main = {
            left = {
                { title = "Discord Webhook", items = {
                    I("Webhook URL", "https://", ""),
                    T("Send On Match End", true),
                    T("Send On Error"),
                } },
            },
            right = {
                { title = "Message", items = {
                    I("Username", "name", "HoneyMeelon"),
                    T("Include Stats", true),
                    B("Send Test Message", "Send"),
                } },
            },
        },
    },
    Misc = {
        Main = {
            left = {
                { title = "Interface", items = {
                    T("Show FPS Counter"),
                    T("Compact Mode"),
                    S("Window Opacity", 50, 100, 96, 1, "%", function(v)
                        main.BackgroundTransparency = 1 - v / 100
                    end),
                } },
            },
            right = {
                { title = "Utility", items = {
                    T("Anti AFK", true),
                    B("Rejoin Server", "Rejoin"),
                    B("Unload Hub", "Unload", function()
                        screenGui:Destroy()
                    end, true),
                } },
            },
        },
    },
    Info = {
        Main = {
            left = {
                { title = "About", items = {
                    N("HoneyMeelon Hub", "Interface build 1.0"),
                    N("Status", "Ready"),
                } },
            },
            right = {},
        },
    },
}

local function createCard(column, title, order)
    local frame = Instance.new("Frame")
    frame.Name = title
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundColor3 = WHITE
    frame.BackgroundTransparency = 0.96
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order
    frame.Parent = column
    corner(frame, 10)
    stroke(frame, 0.95)
    listLayout(frame, 0)

    local head = Instance.new("Frame")
    head.Size = UDim2.new(1, 0, 0, 32)
    head.BackgroundTransparency = 1
    head.LayoutOrder = 1
    head.Parent = frame

    local headText = label(head, title, 13, TEXT_MUTED, Enum.FontWeight.Medium)
    headText.Size = UDim2.new(1, -24, 1, 0)
    headText.Position = UDim2.fromOffset(12, 0)

    return { frame = frame, rows = {} }
end

local function fillColumn(column, cards, records)
    for index, definition in ipairs(cards) do
        local record = createCard(column, definition.title, index)
        table.insert(records, record)
        if definition.build then
            definition.build(record)
        else
            for _, item in ipairs(definition.items) do
                builders[item.type](record, item)
            end
        end
        local last = record.rows[#record.rows]
        if last then
            last.line.Visible = false
        end
    end
end

local function buildPage(tabName, subName)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = tabName .. "_" .. subName
    scroll.Size = UDim2.fromScale(1, 1)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = WHITE
    scroll.ScrollBarImageTransparency = 0.75
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.Visible = false
    scroll.Parent = pagesHolder

    local scrollPadding = Instance.new("UIPadding")
    scrollPadding.PaddingRight = UDim.new(0, 8)
    scrollPadding.PaddingBottom = UDim.new(0, 8)
    scrollPadding.Parent = scroll

    local records = {}
    pageRecords[tabName][subName] = records
    pageFrames[tabName][subName] = scroll

    local definition = layouts[tabName] and layouts[tabName][subName]
    if not definition then
        local empty = label(scroll, "No settings on this page yet", 13, TEXT_MUTED, Enum.FontWeight.Regular, Enum.TextXAlignment.Center)
        empty.Size = UDim2.new(1, 0, 0, 40)
        empty.Position = UDim2.fromOffset(0, 24)
        return
    end

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 0)
    holder.AutomaticSize = Enum.AutomaticSize.Y
    holder.BackgroundTransparency = 1
    holder.Parent = scroll
    listLayout(holder, 10, Enum.FillDirection.Horizontal)

    for order, side in ipairs({ "left", "right" }) do
        local column = Instance.new("Frame")
        column.Name = side
        column.Size = UDim2.new(0.5, -5, 0, 0)
        column.AutomaticSize = Enum.AutomaticSize.Y
        column.BackgroundTransparency = 1
        column.LayoutOrder = order
        column.Parent = holder
        listLayout(column, 10)
        fillColumn(column, definition[side] or {}, records)
    end
end

for _, tabName in ipairs(tabs) do
    pageFrames[tabName] = {}
    pageRecords[tabName] = {}
    for _, subName in ipairs(subs) do
        buildPage(tabName, subName)
    end
end

local function applySearch()
    local query = string.lower(searchBox.Text)
    local records = pageRecords[activeTab][activeSub]
    for _, record in ipairs(records) do
        local any = false
        for _, entry in ipairs(record.rows) do
            local match = query == "" or string.find(entry.text, query, 1, true) ~= nil
            entry.frame.Visible = match
            if match then
                any = true
            end
        end
        record.frame.Visible = any or query == ""
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)

local function refresh()
    for _, name in ipairs(tabs) do
        local selected = name == activeTab
        local railEntry = railButtons[name]
        TweenService:Create(railEntry.button, FAST, { BackgroundTransparency = selected and 0.92 or 1 }):Play()
        railEntry.glyph.ImageColor3 = selected and ACCENT or TEXT_MUTED
        railEntry.bar.Visible = selected

        local listEntry = listButtons[name]
        TweenService:Create(listEntry.button, FAST, {
            BackgroundTransparency = selected and 0.94 or 1,
            TextColor3 = selected and ACCENT or TEXT_MUTED,
        }):Play()
        listEntry.bar.Visible = selected
    end

    for _, name in ipairs(subs) do
        local selected = name == activeSub
        TweenService:Create(subButtons[name], FAST, {
            BackgroundTransparency = selected and 0.94 or 1,
            TextColor3 = selected and ACCENT or TEXT_MUTED,
        }):Play()
    end

    crumb.Text = activeTab .. " / " .. '<font color="rgb(235,60,60)">' .. activeSub .. "</font>"

    for tabName, group in pairs(pageFrames) do
        for subName, frame in pairs(group) do
            frame.Visible = tabName == activeTab and subName == activeSub
        end
    end

    closePopup()
end

go = function(tabName, subName)
    searchBox.Text = ""
    activeTab = tabName
    activeSub = subName
    refresh()
end

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
    NumberSequenceKeypoint.new(0, 0.94),
    NumberSequenceKeypoint.new(0.4, 0.985),
    NumberSequenceKeypoint.new(1, 1),
})
sheenGradient.Parent = sheen

refresh()

print("HoneyMeelon Hub initialized.")
