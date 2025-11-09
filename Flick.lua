-- @neked10 & @sglauncher |V5| — ЧИТ v5 (WALLHACK + TRIGGERBOT ЛУЧАМИ + BHOP + SPIN)

repeat task.wait() until game:IsLoaded()

-- === АНТИ-КИК (БЕЗОПАСНЫЙ) ===
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Блокируем кик через AncestryChanged
local kickConnection
kickConnection = LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer.Parent then
        task.spawn(function()
            task.wait(1)
            if not LocalPlayer.Parent then
                LocalPlayer:LoadCharacter()
            end
        end)
    end
end)

-- Anti-ClientMover
task.spawn(function()
    task.wait(5)
    pcall(function()
        local cm = ReplicatedStorage:FindFirstChild("ClientMover")
        if cm then
            cm:FireServer("ping")
        end
    end)
end)

-- === ЗАПУСК ЧИТА ===
task.wait(5)

local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- === ПЕРЕМЕННЫЕ ===
local bhopEnabled = false
local antiAimEnabled = false
local aimbotEnabled = false
local triggerbotEnabled = false
local wallhackEnabled = false
local glowEnabled = false
local espEnabled = false
local skeletonEnabled = false
local minimized = false

-- ESP Drawing
local espDrawings = {}

-- === ПЕРЕДЕЛАННЫЙ GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "NekedCheat_v5"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- Главный фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 80)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Заголовок
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 40)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleFrame

local title = Instance.new("TextLabel")
title.Text = "@neked10 & @sglauncher |V5|"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleFrame

-- Кнопка сворачивания
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = titleFrame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = titleFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Контент фрейм
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Функция создания переключателей
local function createToggle(parent, name, callback, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPosition)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
    toggleBtn.Position = UDim2.new(0.72, 0, 0.2, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.Parent = toggleFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local state = false
    
    local function updateToggle()
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        callback(state)
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
    end)
    
    updateToggle()
    
    return toggleFrame
end

-- Создаем все функции
local toggles = {
    -- MOVEMENT
    {name = "Bhop", callback = function(s) bhopEnabled = s end},
    {name = "Anti Aim (Spin)", callback = function(s) antiAimEnabled = s end},
    
    -- AIM
    {name = "Aimbot (No Wall)", callback = function(s) aimbotEnabled = s end},
    {name = "Triggerbot", callback = function(s) triggerbotEnabled = s end},
    
    -- VISUAL
    {name = "Box ESP", callback = function(s) espEnabled = s end},
    {name = "Glow ESP", callback = function(s) glowEnabled = s end},
    {name = "Skeleton ESP", callback = function(s) skeletonEnabled = s end}
}

-- Добавляем все переключатели
for i, toggle in ipairs(toggles) do
    createToggle(contentFrame, toggle.name, toggle.callback, (i-1) * 40)
end

-- Функция сворачивания/разворачивания
local function toggleMinimize()
    minimized = not minimized
    
    if minimized then
        -- Сворачиваем
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 350, 0, 40)
        }):Play()
        minimizeBtn.Text = "+"
    else
        -- Разворачиваем
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 350, 0, 400)
        }):Play()
        minimizeBtn.Text = "-"
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- Кнопка закрытия
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- === УЛУЧШЕННЫЙ BHOP (МЕНЬШАЯ СКОРОСТЬ) ===
RunService.Heartbeat:Connect(function()
    if bhopEnabled and player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        
        if hum and root then
            -- Небольшое увеличение скорости при движении
            if UserInputService:IsKeyDown(Enum.KeyCode.W) or 
               UserInputService:IsKeyDown(Enum.KeyCode.A) or 
               UserInputService:IsKeyDown(Enum.KeyCode.S) or 
               UserInputService:IsKeyDown(Enum.KeyCode.D) then
                hum.WalkSpeed = 20 -- Умеренная скорость
            else
                hum.WalkSpeed = 16 -- Нормальная скорость
            end
            
            -- Авто-прыжки в воздухе с меньшим ускорением
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    -- Меньшее увеличение горизонтальной скорости
                    root.Velocity = Vector3.new(
                        root.Velocity.X * 1.02, 
                        50, 
                        root.Velocity.Z * 1.02
                    )
                end
            end
        end
    elseif player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16 -- Возвращаем нормальную скорость
        end
    end
end)

-- Anti Aim: просто крутит игрока
RunService.Heartbeat:Connect(function()
    if antiAimEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(25), 0)
    end
end)

-- === УЛУЧШЕННЫЙ AIMBOT (ТОЛЬКО НА ВИДИМЫХ ИГРОКОВ) ===
local function canSeeTarget(targetPart)
    if not targetPart then return false end
    
    local origin = camera.CFrame.Position
    local targetPos = targetPart.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    local ray = Ray.new(origin, direction * distance)
    local hit, hitPos = Workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, camera})
    
    if hit then
        local hitPlayer = Players:GetPlayerFromCharacter(hit.Parent)
        return hitPlayer and hitPlayer == Players:GetPlayerFromCharacter(targetPart.Parent)
    end
    
    return false
end

local function getVisibleTarget()
    local bestTarget = nil
    local closestDist = math.huge
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            
            if head and hum and hum.Health > 0 then
                -- Проверяем видимость через луч
                if canSeeTarget(head) then
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < closestDist and dist < 250 then
                            closestDist = dist
                            bestTarget = head
                        end
                    end
                end
            end
        end
    end
    
    return bestTarget
end

-- Aimbot
RunService.Heartbeat:Connect(function()
    if aimbotEnabled then
        local target = getVisibleTarget()
        if target then
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, target.Position)
        end
    end
end)

-- === TRIGGERBOT С ЛУЧАМИ ===
RunService.Heartbeat:Connect(function()
    if not triggerbotEnabled or not player.Character or not player.Character:FindFirstChild("Head") then return end
    
    local origin = player.Character.Head.Position
    local direction = camera.CFrame.LookVector * 1000
    local ray = Ray.new(origin, direction)
    local hit, pos = Workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})

    if hit and hit.Parent then
        local enemyPlayer = Players:GetPlayerFromCharacter(hit.Parent)
        if enemyPlayer and enemyPlayer ~= player then
            local hum = hit.Parent:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                mouse1press()
                task.wait(0.01)
                mouse1release()
            end
        end
    end
end)

-- === ESP СИСТЕМА ===
local function clearESP()
    for _, drawing in pairs(espDrawings) do
        if drawing then 
            pcall(function() drawing:Remove() end)
        end
    end
    espDrawings = {}
end

local function drawLine(from, to, color)
    local line = Drawing.new("Line")
    line.From = from
    line.To = to
    line.Color = color
    line.Thickness = 1
    line.Visible = true
    table.insert(espDrawings, line)
    return line
end

local function drawSquare(pos, size, color)
    local square = Drawing.new("Square")
    square.Position = pos
    square.Size = size
    square.Color = color
    square.Thickness = 2
    square.Filled = false
    square.Visible = true
    table.insert(espDrawings, square)
    return square
end

RunService.RenderStepped:Connect(function()
    clearESP()

    if not (espEnabled or glowEnabled or skeletonEnabled) then return end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            
            if root and head and hum and hum.Health > 0 then
                local rootScreen, rootVisible = camera:WorldToViewportPoint(root.Position)
                local headScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                
                if rootVisible then
                    local height = (headScreen.Y - rootScreen.Y) * 2
                    local width = height * 0.6
                    
                    -- Box ESP
                    if espEnabled then
                        drawSquare(
                            Vector2.new(rootScreen.X - width/2, rootScreen.Y - height/2),
                            Vector2.new(width, height),
                            Color3.fromRGB(0, 255, 0)
                        )
                    end
                    
                    -- Skeleton ESP
                    if skeletonEnabled then
                        local bodyParts = {
                            "Head", "UpperTorso", "LowerTorso", 
                            "LeftUpperArm", "LeftLowerArm", "LeftHand",
                            "RightUpperArm", "RightLowerArm", "RightHand",
                            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                            "RightUpperLeg", "RightLowerLeg", "RightFoot"
                        }
                        
                        local points = {}
                        for _, partName in ipairs(bodyParts) do
                            local part = p.Character:FindFirstChild(partName)
                            if part then
                                local screenPos = camera:WorldToViewportPoint(part.Position)
                                if screenPos.Z > 0 then
                                    points[partName] = Vector2.new(screenPos.X, screenPos.Y)
                                end
                            end
                        end
                        
                        -- Рисуем линии скелета
                        local connections = {
                            {"Head", "UpperTorso"},
                            {"UpperTorso", "LowerTorso"},
                            {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
                            {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
                            {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
                            {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
                        }
                        
                        for _, connection in ipairs(connections) do
                            local fromPart, toPart = connection[1], connection[2]
                            if points[fromPart] and points[toPart] then
                                drawLine(points[fromPart], points[toPart], Color3.fromRGB(255, 255, 0))
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Glow ESP
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if glowEnabled then
                local highlight = p.Character:FindFirstChildOfClass("Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "GlowESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.3
                    highlight.OutlineTransparency = 0
                    highlight.Parent = p.Character
                end
                highlight.Enabled = true
            else
                local highlight = p.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight.Enabled = false
                end
            end
        end
    end
end)

-- Анимация появления
mainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 350, 0, 400)
}):Play()

print("🎯 ЧИТ v5 ЗАГРУЖЕН!")
print("✅ Bhop - улучшенные прыжки с умеренной скоростью")
print("✅ Aimbot No Wall - целение только на видимых игроков")
print("✅ Box ESP - рамки вокруг игроков")
print("✅ Glow ESP - свечение игроков")
print("✅ Skeleton ESP - скелет игроков")
print("👤 By @neked10 & @sglauncher |V5|")
