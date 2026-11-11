
-- FIRE AIM + ESP
-- Roblox Studio | Seu próprio jogo

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local espEnabled = false
local aimEnabled = false
local minimized = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FireAimESP"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(230, 250)
frame.Position = UDim2.fromOffset(30, 150)
frame.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔥 FIRE AIM + ESP"
title.TextColor3 = Color3.fromRGB(255, 65, 20)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = frame

local function createButton(name, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.85, 0, 0, 35)
    button.Position = UDim2.new(0.075, 0, position, 0)
    button.BackgroundColor3 = Color3.fromRGB(120, 25, 15)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.Text = name
    button.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    return button
end

local aimButton = createButton("AIM: OFF [Q]", 0.20)
local espButton = createButton("ESP: OFF", 0.38)
local nameButton = createButton("NOMES: ON", 0.56)
local healthButton = createButton("VIDA: ON", 0.74)
local minimizeButton = createButton("MINIMIZAR", 0.90)

local showNames = true
local showHealth = true

-- AIM
local function toggleAim()
    aimEnabled = not aimEnabled
    aimButton.Text = aimEnabled and "AIM: ON [Q]" or "AIM: OFF [Q]"
end

aimButton.MouseButton1Click:Connect(toggleAim)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.Q then
        toggleAim()
    end
end)

-- ESP
local function removeESP(character)
    local highlight = character:FindFirstChild("FireESP")
    if highlight then
        highlight:Destroy()
    end

    local info = character:FindFirstChild("FireESPInfo")
    if info then
        info:Destroy()
    end
end

local function createESP(target)
    local character = target.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local head = character:FindFirstChild("Head")

    if not humanoid or not head then return end

    local highlight = character:FindFirstChild("FireESP")

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "FireESP"
        highlight.FillColor = Color3.fromRGB(255, 45, 15)
        highlight.OutlineColor = Color3.fromRGB(255, 170, 20)
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        highlight.Parent = character
    end

    local billboard = character:FindFirstChild("FireESPInfo")

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "FireESPInfo"
        billboard.Size = UDim2.fromOffset(150, 45)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = false
        billboard.Adornee = head
        billboard.Parent = character

        local label = Instance.new("TextLabel")
        label.Name = "Info"
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 80, 30)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.Parent = billboard
    end

    local label = billboard:FindFirstChild("Info")

    if label then
        local text = ""

        if showNames then
            text = target.Name
        end

        if showHealth then
            text ..= string.format(
                "\nVida: %d/%d",
                humanoid.Health,
                humanoid.MaxHealth
            )
        end

        label.Text = text
    end
end

local function updateESP()
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player then
            if espEnabled then
                createESP(target)
            elseif target.Character then
                removeESP(target.Character)
            end
        end
    end
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    updateESP()
end)

nameButton.MouseButton1Click:Connect(function()
    showNames = not showNames
    nameButton.Text = showNames and "NOMES: ON" or "NOMES: OFF"
    updateESP()
end)

healthButton.MouseButton1Click:Connect(function()
    showHealth = not showHealth
    healthButton.Text = showHealth and "VIDA: ON" or "VIDA: OFF"
    updateESP()
end)

-- Minimizar
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized

    for _, object in ipairs(frame:GetChildren()) do
        if object ~= title and object ~= minimizeButton
            and object:IsA("GuiObject") then
            object.Visible = not minimized
        end
    end

    frame.Size = minimized
        and UDim2.fromOffset(230, 45)
        or UDim2.fromOffset(230, 250)

    minimizeButton.Text = minimized and "ABRIR MENU" or "MINIMIZAR"
end)

-- Atualização
RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

Players.PlayerRemoving:Connect(function(target)
    if target.Character then
        removeESP(target.Character)
    end
end)

print("Fire Aim + ESP carregado!")
