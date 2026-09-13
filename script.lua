local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local DEFAULT_SPEED = 16

local existingGui = PlayerGui:FindFirstChild("SpeedMenuGui")
if existingGui then existingGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Главный фрейм (Меню) - Сделали чуть шире для удобства
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 260)
MainFrame.Position = UDim2.new(0.5, -155, 0.4, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "HeaderFrame"
HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.ZIndex = 2
HeaderFrame.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 180, 0, 40)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Настройка персонажа"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = HeaderFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.ZIndex = 4
MinimizeButton.Parent = HeaderFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.ArialBold
CloseButton.ZIndex = 4
CloseButton.Parent = HeaderFrame

-- ИСПРАВЛЕНО: Закрепленная зона для слайдера вне скролла (для 100% плавности)
local FixedSliderFrame = Instance.new("Frame")
FixedSliderFrame.Name = "FixedSliderFrame"
FixedSliderFrame.Size = UDim2.new(1, 0, 0, 55)
FixedSliderFrame.Position = UDim2.new(0, 0, 0, 40)
FixedSliderFrame.BackgroundTransparency = 1
FixedSliderFrame.ZIndex = 2
FixedSliderFrame.Parent = MainFrame

local SpeedValueLabel = Instance.new("TextLabel")
SpeedValueLabel.Name = "SpeedValueLabel"
SpeedValueLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedValueLabel.Position = UDim2.new(0, 0, 0, 2)
SpeedValueLabel.BackgroundTransparency = 1
SpeedValueLabel.Text = "Выбрано: 16"
SpeedValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedValueLabel.TextSize = 15
SpeedValueLabel.Font = Enum.Font.SourceSans
SpeedValueLabel.ZIndex = 3
SpeedValueLabel.Parent = FixedSliderFrame

local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(0, 240, 0, 6)
SliderTrack.Position = UDim2.new(0.5, -120, 0, 34)
SliderTrack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SliderTrack.BorderSizePixel = 0
SliderTrack.ZIndex = 3
SliderTrack.Parent = FixedSliderFrame

Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(1, 0)

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 16, 0, 16)
SliderButton.Position = UDim2.new(0.16, -8, 0.5, -8) 
SliderButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
SliderButton.BorderSizePixel = 0
SliderButton.Text = ""
SliderButton.ZIndex = 4
SliderButton.Parent = SliderTrack

Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(1, 0)
-- ИСПРАВЛЕНО: ScrollingFrame теперь начинается ниже слайдера и крутится без багов
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 0, 155)
ContentFrame.Position = UDim2.new(0, 0, 0, 95)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 2
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 140, 255)
ContentFrame.Parent = MainFrame

-- ИСПРАВЛЕНО: Автоматический менеджер отступов для идеально равного расстояния
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6) -- Одинаковое расстояние между кнопками в 6 пикселей
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createToggle(name, text)
	local frame = Instance.new("Frame")
	frame.Name = name .. "Frame"
	frame.Size = UDim2.new(0, 240, 0, 40)
	frame.BackgroundTransparency = 1
	frame.ZIndex = 3
	frame.Parent = ContentFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 180, 1, 0); label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 16; label.TextXAlignment = Enum.TextXAlignment.Left; label.Font = Enum.Font.SourceSans; label.ZIndex = 3; label.Parent = frame
	
	local button = Instance.new("TextButton")
	button.Name = name .. "Button"; button.Size = UDim2.new(0, 46, 0, 24); button.Position = UDim2.new(1, -46, 0.5, -12); button.BackgroundColor3 = Color3.fromRGB(120, 40, 40); button.Text = ""; button.ZIndex = 4; button.Parent = frame
	Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)
	
	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 18, 0, 18); circle.Position = UDim2.new(0, 3, 0.5, -9); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); circle.ZIndex = 5; circle.Parent = button
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
	return button, circle
end

local SpeedToggleButton, SpeedToggleCircle = createToggle("SpeedToggle", "Скорость:")
local JumpToggleButton, JumpToggleCircle = createToggle("JumpToggle", "Бесконечный прыжок:")
local NoFallToggleButton, NoFallToggleCircle = createToggle("NoFallToggle", "Без урона от падения:")
local FlyToggleButton, FlyToggleCircle = createToggle("FlyToggle", "Режим полета (Fly):")
local NoclipToggleButton, NoclipToggleCircle = createToggle("NoclipToggle", "Сквозь стены (Noclip):")
local TpToggleButton, TpToggleCircle = createToggle("TpToggle", "Телепорт по клику (TP):")
local EspToggleButton, EspToggleCircle = createToggle("EspToggle", "Подсветка игроков (ESP):")

local MIN_SPEED, MAX_SPEED, targetSpeed = 0, 100, DEFAULT_SPEED
local isSpeedEnabled, isJumpEnabled, isNoFallEnabled, isFlyEnabled, isNoclipEnabled, isTpEnabled, isEspEnabled = false, false, false, false, false, false, false
local isDragging, isMinimized = false, false

local dragToggle, dragStart, startPos
HeaderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
local TpZoneFrame = Instance.new("Frame")
TpZoneFrame.Name = "TpZoneFrame"; TpZoneFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255); TpZoneFrame.BackgroundTransparency = 1; TpZoneFrame.Visible = false; TpZoneFrame.Parent = ScreenGui
local ZoneStroke = Instance.new("UIStroke")
ZoneStroke.Color = Color3.fromRGB(255, 255, 255); ZoneStroke.Thickness = 2; ZoneStroke.Transparency = 0.3; ZoneStroke.Parent = TpZoneFrame

local function updateZonePosition()
	local camera = workspace.CurrentCamera; local screenSize = camera.ViewportSize
	local zoneSize = screenSize.Y * 0.38
	TpZoneFrame.Size = UDim2.new(0, zoneSize, 0, zoneSize)
	local crosshairX, crosshairY = screenSize.X / 2, screenSize.Y / 2
	TpZoneFrame.Position = UDim2.new(0, crosshairX - (zoneSize / 2), 0, crosshairY - (zoneSize / 2))
	return crosshairX, crosshairY, zoneSize
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateZonePosition)

local function applySpeed()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = isSpeedEnabled and targetSpeed or DEFAULT_SPEED
	end
end

UserInputService.JumpRequest:Connect(function()
	if isJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local function teleportToMouse(inputPosition)
	if not isTpEnabled then return end
	local character = LocalPlayer.Character; if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	local rootPart = character.HumanoidRootPart; local crosshairX, crosshairY, zoneSize = updateZonePosition()
	if math.abs(inputPosition.X - crosshairX) <= (zoneSize / 2) and math.abs(inputPosition.Y - crosshairY) <= (zoneSize / 2) then
		local unitRay = workspace.CurrentCamera:ViewportPointToRay(crosshairX, crosshairY)
		local raycastParams = RaycastParams.new(); raycastParams.FilterType = Enum.RaycastFilterType.Exclude; raycastParams.FilterDescendantsInstances = {character}
		local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 15000, raycastParams)
		local targetPos = raycastResult and (raycastResult.Position + Vector3.new(0, 3, 0)) or (unitRay.Origin + unitRay.Direction * 200)
		if not raycastResult then targetPos = Vector3.new(targetPos.X, rootPart.Position.Y, targetPos.Z) end
		rootPart.CFrame = CFrame.new(targetPos)
	end
end
UserInputService.InputBegan:Connect(function(input, gp) if not gp and isTpEnabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then teleportToMouse(input.Position) end end)

local function createEspElements(player)
	if player == LocalPlayer then return end
	local function drawEsp()
		task.spawn(function()
			local character = player.Character; if not character then return end
			local rootPart = character:WaitForChild("HumanoidRootPart", 5); local humanoid = character:WaitForChild("Humanoid", 5)
			if not rootPart or not humanoid then return end
			local highlight = rootPart:FindFirstChild("EspHighlight") or Instance.new("Highlight")
			highlight.Name = "EspHighlight"; highlight.FillColor = Color3.fromRGB(0, 140, 255); highlight.FillTransparency = 0.6; highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.OutlineTransparency = 0.2; highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; highlight.Enabled = isEspEnabled; highlight.Parent = rootPart
			local billboard = rootPart:FindFirstChild("EspBillboard") or Instance.new("BillboardGui")
			billboard.Name = "EspBillboard"; billboard.Size = UDim2.new(0, 200, 0, 50); billboard.AlwaysOnTop = true; billboard.ExtentsOffset = Vector3.new(0, 3, 0); billboard.Enabled = isEspEnabled; billboard.Parent = rootPart
			local label = billboard:FindFirstChild("EspLabel") or Instance.new("TextLabel")
			label.Name = "EspLabel"; label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextStrokeTransparency = 0; label.TextSize = 13; label.Font = Enum.Font.SourceSansBold; label.Text = player.Name .. " [" .. math.round(humanoid.Health) .. " HP]"; label.Parent = billboard
		end)
	end
	if player.Character then drawEsp() end
	player.CharacterAdded:Connect(drawEsp)
end
task.spawn(function() for _, p in pairs(Players:GetPlayers()) do createEspElements(p); task.wait(0.02) end end)
Players.PlayerAdded:Connect(createEspElements)

local function refreshEsp()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local root = p.Character.HumanoidRootPart
			if root:FindFirstChild("EspHighlight") then root.EspHighlight.Enabled = isEspEnabled end
			if root:FindFirstChild("EspBillboard") then root.EspBillboard.Enabled = isEspEnabled end
		end
	end
end
local function updateNoclipState()
	local character = LocalPlayer.Character; if not character or isNoclipEnabled then return end
	for _, part in pairs(character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
end

local flyBodyVelocity, flyBodyGyro = nil, nil
game:GetService("RunService").Heartbeat:Connect(function()
	local character = LocalPlayer.Character; if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart"); local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not rootPart or not humanoid then return end
	if isNoclipEnabled then for _, part in pairs(character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end
	if isNoFallEnabled and rootPart.Velocity.Y < -25 then humanoid:ChangeState(Enum.HumanoidStateType.Running); rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z) end
	if isFlyEnabled then
		if not flyBodyVelocity or not flyBodyVelocity.Parent then
			flyBodyVelocity = Instance.new("BodyVelocity"); flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5); flyBodyVelocity.Parent = rootPart
			flyBodyGyro = Instance.new("BodyGyro"); flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5); flyBodyGyro.Parent = rootPart
		end
		flyBodyGyro.CFrame = workspace.CurrentCamera.CFrame; local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then flyBodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * (moveDir.Magnitude * (isSpeedEnabled and targetSpeed or 30))
		else flyBodyVelocity.Velocity = Vector3.new(0, 0.1, 0) end
	else
		if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
		if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
	end
end)

local function updateSlider(inputPosition)
	local scale = math.clamp((inputPosition.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
	SliderButton.Position = UDim2.new(scale, -8, 0.5, -8)
	targetSpeed = math.round(MIN_SPEED + (scale * (MAX_SPEED - MIN_SPEED)))
	SpeedValueLabel.Text = "Выбрано: " .. targetSpeed
	if isSpeedEnabled then applySpeed() end
end
SliderButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end end)
UserInputService.InputChanged:Connect(function(input) if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input.Position) end end)

local function toggleVisual(state, button, circle)
	if state then button.BackgroundColor3 = Color3.fromRGB(46, 204, 113); circle.Position = UDim2.new(1, -21, 0.5, -9)
	else button.BackgroundColor3 = Color3.fromRGB(120, 40, 40); circle.Position = UDim2.new(0, 3, 0.5, -9) end
end

SpeedToggleButton.MouseButton1Click:Connect(function() isSpeedEnabled = not isSpeedEnabled; toggleVisual(isSpeedEnabled, SpeedToggleButton, SpeedToggleCircle); applySpeed() end)
JumpToggleButton.MouseButton1Click:Connect(function() isJumpEnabled = not isJumpEnabled; toggleVisual(isJumpEnabled, JumpToggleButton, JumpToggleCircle) end)
NoFallToggleButton.MouseButton1Click:Connect(function() isNoFallEnabled = not isNoFallEnabled; toggleVisual(isNoFallEnabled, NoFallToggleButton, NoFallToggleCircle) end)
FlyToggleButton.MouseButton1Click:Connect(function() isFlyEnabled = not isFlyEnabled; toggleVisual(isFlyEnabled, FlyToggleButton, FlyToggleCircle) end)
NoclipToggleButton.MouseButton1Click:Connect(function() isNoclipEnabled = not isNoclipEnabled; toggleVisual(isNoclipEnabled, NoclipToggleButton, NoclipToggleCircle); updateNoclipState() end)
TpToggleButton.MouseButton1Click:Connect(function() isTpEnabled = not isTpEnabled; toggleVisual(isTpEnabled, TpToggleButton, TpToggleCircle); updateZonePosition(); TpZoneFrame.Visible = isTpEnabled end)
EspToggleButton.MouseButton1Click:Connect(function() isEspEnabled = not isEspEnabled; toggleVisual(isEspEnabled, EspToggleButton, EspToggleCircle); refreshEsp() end)

MinimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	ContentFrame.Visible = not isMinimized; FixedSliderFrame.Visible = not isMinimized
	MainFrame.Size = isMinimized and UDim2.new(0, 310, 0, 40) or UDim2.new(0, 310, 0, 260)
	MinimizeButton.Text = isMinimized and "+" or "—"
end)

CloseButton.MouseButton1Click:Connect(function()
	isSpeedEnabled = false; isJumpEnabled = false; isNoFallEnabled = false; isFlyEnabled = false; isNoclipEnabled = false; isTpEnabled = false; isEspEnabled = false
	applySpeed(); updateNoclipState(); refreshEsp(); ScreenGui:Destroy()
end)

LocalPlayer.CharacterAdded:Connect(function(char) char:WaitForChild("Humanoid", 5); task.wait(0.2); applySpeed() end)

