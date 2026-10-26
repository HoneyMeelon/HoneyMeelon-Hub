local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local oldUI = player:WaitForChild("PlayerGui"):FindFirstChild("HoneyMeelonPremiumUI") or game:GetService("CoreGui"):FindFirstChild("HoneyMeelonPremiumUI")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoneyMeelonPremiumUI"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

local FONT_REGULAR = Enum.Font.Inter
local FONT_BOLD = Enum.Font.Inter
local COLOR_BG = Color3.fromRGB(20, 20, 23)
local COLOR_SIDEBAR = Color3.fromRGB(28, 28, 32)
local COLOR_ACCENT = Color3.fromRGB(235, 60, 60)
local COLOR_TEXT = Color3.fromRGB(240, 240, 245)
local COLOR_TEXT_MUTED = Color3.fromRGB(140, 145, 155)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 660, 0, 410)
MainFrame.Position = UDim2.new(0.5, -330, 0.5, -205)
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local IconSidebar = Instance.new("Frame")
IconSidebar.Size = UDim2.new(0, 55, 1, 0)
IconSidebar.BackgroundColor3 = COLOR_SIDEBAR
IconSidebar.BorderSizePixel = 0
IconSidebar.Parent = MainFrame

local IconSideCorner = Instance.new("UICorner")
IconSideCorner.CornerRadius = UDim.new(0, 8)
IconSideCorner.Parent = IconSidebar

local SideHideFrame = Instance.new("Frame")
SideHideFrame.Size = UDim2.new(0, 10, 1, 0)
SideHideFrame.Position = UDim2.new(1, -10, 0, 0)
SideHideFrame.BackgroundColor3 = COLOR_SIDEBAR
SideHideFrame.BorderSizePixel = 0
SideHideFrame.Parent = IconSidebar

local LogoIcon = Instance.new("ImageLabel")
LogoIcon.Size = UDim2.new(0, 24, 0, 24)
LogoIcon.Position = UDim2.new(0.5, -12, 0, 15)
LogoIcon.Image = "rbxassetid://6031075929"
LogoIcon.ImageColor3 = COLOR_ACCENT
LogoIcon.BackgroundTransparency = 1
LogoIcon.Parent = IconSidebar

local function createSideIcon(assetId, yPos)
    local Img = Instance.new("ImageLabel")
    Img.Size = UDim2.new(0, 20, 0, 20)
    Img.Position = UDim2.new(0.5, -10, 0, yPos)
    Img.Image = "rbxassetid://" .. assetId
    Img.ImageColor3 = COLOR_TEXT_MUTED
    Img.BackgroundTransparency = 1
    Img.Parent = IconSidebar
    return Img
end
createSideIcon("6034287515", 65)
createSideIcon("6034502922", 110)
createSideIcon("6031235942", 155)

local TextSidebar = Instance.new("Frame")
TextSidebar.Size = UDim2.new(0, 135, 1, 0)
TextSidebar.Position = UDim2.new(0, 55, 0, 0)
TextSidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
TextSidebar.BorderSizePixel = 0
TextSidebar.Parent = MainFrame

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, 0, 0, 40)
HubTitle.Position = UDim2.new(0, 15, 0, 12)
HubTitle.Text = "HoneyMeelon Hub"
HubTitle.TextColor3 = COLOR_TEXT
HubTitle.Font = FONT_BOLD
HubTitle.TextSize = 14
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.BackgroundTransparency = 1
HubTitle.Parent = TextSidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.Parent = TextSidebar

local PaddingFrame = Instance.new("Frame")
PaddingFrame.Size = UDim2.new(1, 0, 0, 50)
PaddingFrame.BackgroundTransparency = 1
PaddingFrame.LayoutOrder = 0
PaddingFrame.Parent = TextSidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -210, 1, 0)
ContentArea.Position = UDim2.new(0, 200, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local TopNavbar = Instance.new("Frame")
TopNavbar.Size = UDim2.new(1, 0, 0, 45)
TopNavbar.Position = UDim2.new(0, 0, 0, 5)
TopNavbar.BackgroundTransparency = 1
TopNavbar.Parent = ContentArea

local NavList = Instance.new("UIListLayout")
NavList.FillDirection = Enum.FillDirection.Horizontal
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Padding = UDim.new(0, 25)
NavList.Parent = TopNavbar

local function createSubTab(text, order)
    local SubBtn = Instance.new("TextButton")
    SubBtn.Size = UDim2.new(0, 50, 1, 0)
    SubBtn.Text = text
    SubBtn.TextColor3 = order == 1 and COLOR_ACCENT or COLOR_TEXT_MUTED
    SubBtn.Font = FONT_BOLD
    SubBtn.TextSize = 13
    SubBtn.BackgroundTransparency = 1
    SubBtn.LayoutOrder = order
    SubBtn.Parent = TopNavbar
    return SubBtn
end
createSubTab("Main", 1)
createSubTab("Panels", 2)
createSubTab("Binds", 3)
createSubTab("Extra", 4)

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -10, 1, -65)
PageContainer.Position = UDim2.new(0, 0, 0, 50)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = ContentArea

local activePage = nil
local pages = {}
local mainTabs = {"Lobby", "Match", "Auto Play", "Macros", "Web Hook", "Misc"}

for i, tabName in ipairs(mainTabs) do
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = PageContainer
    pages[tabName] = Page

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -10, 0, 32)
    TabBtn.Position = UDim2.new(0, 5, 0, 0)
    TabBtn.Text = "   " .. tabName
    TabBtn.TextColor3 = COLOR_TEXT_MUTED
    TabBtn.Font = FONT_REGULAR
    TabBtn.TextSize = 13
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.BackgroundTransparency = 1
    TabBtn.LayoutOrder = i
    TabBtn.Parent = TextSidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(TextSidebar:GetChildren()) do
            if child:IsA("TextButton") then 
                child.TextColor3 = COLOR_TEXT_MUTED 
                child.BackgroundTransparency = 1
            end
        end
        TabBtn.TextColor3 = COLOR_TEXT
        TabBtn.BackgroundTransparency = 0.95
        if activePage then activePage.Visible = false end
        Page.Visible = true
        activePage = Page
    end)

    if i == 4 then
        TabBtn.TextColor3 = COLOR_TEXT
        TabBtn.BackgroundTransparency = 0.95
        Page.Visible = true
        activePage = Page
    end
end

local macrosPage = pages["Macros"]

local SettingsBlock = Instance.new("Frame")
SettingsBlock.Size = UDim2.new(0.5, 0, 1, -10)
SettingsBlock.BackgroundColor3 = COLOR_SIDEBAR
SettingsBlock.BorderSizePixel = 0
SettingsBlock.Parent = macrosPage

local BlockCorner = Instance.new("UICorner")
BlockCorner.CornerRadius = UDim.new(0, 6)
BlockCorner.Parent = SettingsBlock

local BlockTitle = Instance.new("TextLabel")
BlockTitle.Size = UDim2.new(1, -20, 0, 35)
BlockTitle.Position = UDim2.new(0, 12, 0, 2)
BlockTitle.Text = "MACRO CONFIGURATION"
BlockTitle.TextColor3 = COLOR_TEXT_MUTED
BlockTitle.Font = FONT_BOLD
BlockTitle.TextSize = 11
BlockTitle.TextXAlignment = Enum.TextXAlignment.Left
BlockTitle.BackgroundTransparency = 1
BlockTitle.Parent = SettingsBlock

local function createModernToggle(text, yPos, parent)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -24, 0, 35)
    Frame.Position = UDim2.new(0, 12, 0, yPos)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 150, 1, 0)
    Label.Text = text
    Label.TextColor3 = COLOR_TEXT
    Label.Font = FONT_REGULAR
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local SwitchBg = Instance.new("TextButton")
    SwitchBg.Size = UDim2.new(0, 34, 0, 18)
    SwitchBg.Position = UDim2.new(1, -34, 0.5, -9)
    SwitchBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SwitchBg.Text = ""
    SwitchBg.BorderSizePixel = 0
    SwitchBg.Parent = Frame
    
    local SwCorner = Instance.new("UICorner")
    SwCorner.CornerRadius = UDim.new(0, 9)
    SwCorner.Parent = SwitchBg
    
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(0, 14, 0, 14)
    Slider.Position = UDim2.new(0, 2, 0.5, -7)
    Slider.BackgroundColor3 = Color3.fromRGB(200, 200, 205)
    Slider.BorderSizePixel = 0
    Slider.Parent = SwitchBg
    
    local SlCorner = Instance.new("UICorner")
    SlCorner.CornerRadius = UDim.new(0, 7)
    SlCorner.Parent = Slider
    
    local active = false
    SwitchBg.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(SwitchBg, TweenInfo.new(0.12), {BackgroundColor3 = COLOR_ACCENT}):Play()
            TweenService:Create(Slider, TweenInfo.new(0.12), {Position = UDim2.new(0, 18, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(SwitchBg, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
            TweenService:Create(Slider, TweenInfo.new(0.12), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 205)}):Play()
        end
    end)
end

createModernToggle("Auto Record Movement", 40, SettingsBlock)
createModernToggle("Use Fast Pathing", 75, SettingsBlock)
createModernToggle("Loop Macro Path", 110, SettingsBlock)

print("HoneyMeelon Hub initialized.")
