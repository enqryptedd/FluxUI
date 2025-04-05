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

return Animations