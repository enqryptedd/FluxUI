local FluxUI = {}

local Styles = {
    Colors = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(255, 69, 0),
        Text = Color3.fromRGB(255, 255, 255),
        Secondary = Color3.fromRGB(50, 50, 50),
        Highlight = Color3.fromRGB(80, 80, 80)
    },
    Fonts = {
        Regular = Enum.Font.Gotham,
        Bold = Enum.Font.GothamBold
    }
}

local Utilities = {}

function Utilities:RandomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local str = ""
    for i = 1, length do
        str = str .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return str
end

function Utilities:MakeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local Animations = {}
local TweenService = game:GetService("TweenService")

function Animations:FadeIn(object)
    object.BackgroundTransparency = 1
    TweenService:Create(object, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
end

function Animations:Bounce(object)
    local originalSize = object.Size
    TweenService:Create(object, TweenInfo.new(0.1), {Size = UDim2.new(originalSize.X.Scale * 1.1, originalSize.X.Offset, originalSize.Y.Scale * 1.1, originalSize.Y.Offset)}):Play()
    wait(0.1)
    TweenService:Create(object, TweenInfo.new(0.1), {Size = originalSize}):Play()
end

local Components = {}
local UserInputService = game:GetService("UserInputService")

function Components:CreateTabButton(name, parent, index, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Position = UDim2.new(0, index * 110, 0, 0)
    button.BackgroundColor3 = Styles.Colors.Secondary
    button.Text = name
    button.TextColor3 = Styles.Colors.Text
    button.TextSize = 14
    button.Font = Styles.Fonts.Bold
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseButton1Click:Connect(function()
        callback()
        Animations:Bounce(button)
    end)
    return button
end

function Components:CreateButton(text, desc, parent, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -10, 0, 50)
    buttonFrame.BackgroundColor3 = Styles.Colors.Secondary
    buttonFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = buttonFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 5)
    button.BackgroundColor3 = Styles.Colors.Highlight
    button.Text = text
    button.TextColor3 = Styles.Colors.Text
    button.TextSize = 14
    button.Font = Styles.Fonts.Regular
    button.Parent = buttonFrame

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -10, 0, 15)
    descLabel.Position = UDim2.new(0, 5, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Styles.Colors.Text
    descLabel.TextSize = 12
    descLabel.Font = Styles.Fonts.Regular
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = buttonFrame

    button.MouseButton1Click:Connect(function()
        callback()
        Animations:Bounce(button)
    end)
    return button
end

function Components:CreateToggle(text, default, parent, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, 40)
    toggleFrame.BackgroundColor3 = Styles.Colors.Secondary
    toggleFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Styles.Colors.Text
    label.TextSize = 14
    label.Font = Styles.Fonts.Regular
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -45, 0.5, -10)
    toggle.BackgroundColor3 = default and Styles.Colors.Accent or Styles.Colors.Highlight
    toggle.Text = ""
    toggle.Parent = toggleFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggle

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = state and Styles.Colors.Accent or Styles.Colors.Highlight}):Play()
        callback(state)
    end)
    return toggle
end

function Components:CreateSlider(text, min, max, default, parent, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 60)
    sliderFrame.BackgroundColor3 = Styles.Colors.Secondary
    sliderFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = sliderFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Styles.Colors.Text
    label.TextSize = 14
    label.Font = Styles.Fonts.Regular
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 10)
    sliderBar.Position = UDim2.new(0, 10, 0, 30)
    sliderBar.BackgroundColor3 = Styles.Colors.Highlight
    sliderBar.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Styles.Colors.Accent
    fill.Parent = sliderBar

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new((default - min) / (max - min), -10, 0, -5)
    knob.BackgroundColor3 = Styles.Colors.Text
    knob.Parent = sliderBar

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 35)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Styles.Colors.Text
    valueLabel.TextSize = 12
    valueLabel.Parent = sliderFrame

    local dragging = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = (mousePos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
            relativePos = math.clamp(relativePos, 0, 1)
            local value = min + (max - min) * relativePos
            knob.Position = UDim2.new(relativePos, -10, 0, -5)
            fill.Size = UDim2.new(relativePos, 0, 1, 0)
            valueLabel.Text = tostring(math.floor(value))
            callback(value)
        end
    end)
    return sliderFrame
end

function Components:CreateDropdown(text, options, multi, default, parent, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, -10, 0, 40)
    dropdownFrame.BackgroundColor3 = Styles.Colors.Secondary
    dropdownFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = dropdownFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Styles.Colors.Text
    label.TextSize = 14
    label.Font = Styles.Fonts.Regular
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Position = UDim2.new(1, -105, 0, 5)
    button.BackgroundColor3 = Styles.Colors.Highlight
    button.Text = multi and table.concat(default or {}, ", ") or (default or options[1])
    button.TextColor3 = Styles.Colors.Text
    button.TextSize = 12
    button.Font = Styles.Fonts.Regular
    button.Parent = dropdownFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0, 100, 0, 0)
    listFrame.Position = UDim2.new(1, -105, 0, 40)
    listFrame.BackgroundColor3 = Styles.Colors.Secondary
    listFrame.ClipsDescendants = true
    listFrame.Visible = false
    listFrame.Parent = dropdownFrame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = listFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Parent = listFrame

    local selected = multi and {} or default or options[1]
    if multi then
        for _, v in pairs(default or {}) do
            table.insert(selected, v)
        end
    end

    local function updateText()
        button.Text = multi and table.concat(selected, ", ") or selected
    end

    local optionButtons = {}
    for i, option in pairs(options) do
        local optButton = Instance.new("TextButton")
        optButton.Size = UDim2.new(1, 0, 0, 25)
        optButton.BackgroundColor3 = Styles.Colors.Highlight
        optButton.Text = option
        optButton.TextColor3 = Styles.Colors.Text
        optButton.TextSize = 12
        optButton.Font = Styles.Fonts.Regular
        optButton.Parent = listFrame

        optButton.MouseButton1Click:Connect(function()
            if multi then
                if table.find(selected, option) then
                    table.remove(selected, table.find(selected, option))
                else
                    table.insert(selected, option)
                end
            else
                selected = option
                listFrame.Visible = false
                TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 0)}):Play()
            end
            updateText()
            callback(selected)
            Animations:Bounce(optButton)
        end)
        table.insert(optionButtons, optButton)
    end

    listFrame.Size = UDim2.new(0, 100, 0, #options * 25)
    local isOpen = false
    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listFrame.Visible = isOpen
        TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = isOpen and UDim2.new(0, 100, 0, #options * 25) or UDim2.new(0, 100, 0, 0)}):Play()
        Animations:Bounce(button)
    end)

    return dropdownFrame
end

function Components:CreateColorPicker(text, default, parent, callback)
    local pickerFrame = Instance.new("Frame")
    pickerFrame.Size = UDim2.new(1, -10, 0, 150)
    pickerFrame.BackgroundColor3 = Styles.Colors.Secondary
    pickerFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = pickerFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Styles.Colors.Text
    label.TextSize = 14
    label.Font = Styles.Fonts.Regular
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = pickerFrame

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 40, 0, 40)
    preview.Position = UDim2.new(1, -50, 0, 5)
    preview.BackgroundColor3 = default or Color3.fromRGB(255, 255, 255)
    preview.Parent = pickerFrame

    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 6)
    previewCorner.Parent = preview

    local svFrame = Instance.new("Frame")
    svFrame.Size = UDim2.new(0, 150, 0, 100)
    svFrame.Position = UDim2.new(0, 10, 0, 30)
    svFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svFrame.Parent = pickerFrame

    local svGradient = Instance.new("UIGradient")
    svGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    svGradient.Rotation = 90
    svGradient.Parent = svFrame

    local svOverlay = Instance.new("Frame")
    svOverlay.Size = UDim2.new(1, 0, 1, 0)
    svOverlay.BackgroundTransparency = 0
    svOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    local svOverlayGradient = Instance.new("UIGradient")
    svOverlayGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    svOverlayGradient.Rotation = 0
    svOverlayGradient.Parent = svOverlay
    svOverlay.Parent = svFrame

    local svKnob = Instance.new("Frame")
    svKnob.Size = UDim2.new(0, 10, 0, 10)
    svKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svKnob.BorderSizePixel = 2
    svKnob.BorderColor3 = Color3.fromRGB(0, 0, 0)
    svKnob.Parent = svFrame

    local hueBar = Instance.new("Frame")
    hueBar.Size = UDim2.new(0, 20, 0, 100)
    hueBar.Position = UDim2.new(0, 170, 0, 30)
    hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueBar.Parent = pickerFrame

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    })
    hueGradient.Rotation = 90
    hueGradient.Parent = hueBar

    local hueKnob = Instance.new("Frame")
    hueKnob.Size = UDim2.new(1, 0, 0, 5)
    hueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueKnob.BorderSizePixel = 2
    hueKnob.BorderColor3 = Color3.fromRGB(0, 0, 0)
    hueKnob.Parent = hueBar

    local function hsvToRgb(h, s, v)
        local r, g, b
        local i = math.floor(h * 6)
        local f = h * 6 - i
        local p = v * (1 - s)
        local q = v * (1 - f * s)
        local t = v * (1 - (1 - f) * s)
        if i % 6 == 0 then r, g, b = v, t, p
        elseif i % 6 == 1 then r, g, b = q, v, p
        elseif i % 6 == 2 then r, g, b = p, v, t
        elseif i % 6 == 3 then r, g, b = p, q, v
        elseif i % 6 == 4 then r, g, b = t, p, v
        elseif i % 6 == 5 then r, g, b = v, p, q
        end
        return Color3.fromRGB(r * 255, g * 255, b * 255)
    end

    local h, s, v = default:ToHSV()
    svKnob.Position = UDim2.new(s, -5, 1 - v, -5)
    hueKnob.Position = UDim2.new(0, 0, h, -2)
    svGradient.Color = ColorSequence.new(hsvToRgb(h, 1, 1))

    local function updateColor()
        local color = hsvToRgb(h, s, v)
        preview.BackgroundColor3 = color
        callback(color)
    end

    local svDragging = false
    svFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
        end
    end)

    local hueDragging = false
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = false
            hueDragging = false
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        if svDragging then
            s = math.clamp((mousePos.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1)
            v = math.clamp(1 - (mousePos.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1)
            svKnob.Position = UDim2.new(s, -5, 1 - v, -5)
            updateColor()
        end
        if hueDragging then
            h = math.clamp((mousePos.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
            hueKnob.Position = UDim2.new(0, 0, h, -2)
            svGradient.Color = ColorSequence.new(hsvToRgb(h, 1, 1))
            updateColor()
        end
    end)

    return pickerFrame
end

local Players = game:GetService("Players")

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
