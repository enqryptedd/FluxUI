local FluxUI = {}
local Styles = require(script.Parent.Styles)
local Components = require(script.Parent.Components)
local Animations = require(script.Parent.Animations)
local Utilities = require(script.Parent.Utilities)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function FluxUI:CreateWindow(title, accentColor)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "FluxUI_" .. Utilities:RandomString(8)

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Styles.Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    Utilities:MakeDraggable(mainFrame)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = accentColor
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 40)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -100)
    contentFrame.Position = UDim2.new(0, 10, 0, 90)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = mainFrame

    local window = {Tabs = {}, ActiveTab = nil}
    
    function window:AddTab(name)
        local tabButton = Components:CreateTabButton(name, tabContainer, #window.Tabs, function()
            if window.ActiveTab then
                window.ActiveTab.Content.Visible = false
            end
            window.ActiveTab = window.Tabs[name]
            window.ActiveTab.Content.Visible = true
            Animations:FadeIn(window.ActiveTab.Content)
        end)

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentFrame

        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.ScrollBarThickness = 4
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingFrame.Parent = tabContent

        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Padding = UDim.new(0, 10)
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Parent = scrollingFrame

        local tab = {
            Button = tabButton,
            Content = tabContent,
            ScrollingFrame = scrollingFrame,
            AddButton = function(self, text, desc, callback)
                return Components:CreateButton(text, desc, self.ScrollingFrame, callback)
            end,
            AddToggle = function(self, text, default, callback)
                return Components:CreateToggle(text, default, self.ScrollingFrame, callback)
            end,
            AddSlider = function(self, text, min, max, default, callback)
                return Components:CreateSlider(text, min, max, default, self.ScrollingFrame, callback)
            end,
            AddDropdown = function(self, text, options, multi, default, callback)
                return Components:CreateDropdown(text, options, multi, default, self.ScrollingFrame, callback)
            end,
            AddColorPicker = function(self, text, default, callback)
                return Components:CreateColorPicker(text, default, self.ScrollingFrame, callback)
            end
        }
        window.Tabs[name] = tab
        if not window.ActiveTab then
            window.ActiveTab = tab
            tab.Content.Visible = true
        end
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
        uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
        end)
        return tab
    end

    return window
end

return FluxUI