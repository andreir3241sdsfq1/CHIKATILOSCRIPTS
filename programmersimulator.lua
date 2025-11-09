-- Чит-скрипт для автофарма в Roblox
-- By @neked10 & @sglauncher
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Настройки интервалов
local FARM_INTERVAL = 0.01
local CLICK_BURST_COUNT = 5

-- Поиск удаленных событий
local remotes = {}
local remoteNames = {"Clicker", "Rebirth"}

for _, name in pairs(remoteNames) do
    spawn(function()
        while not remotes[name] do
            wait(0.1)
            local remote = ReplicatedStorage.Remotes:FindFirstChild(name)
            if remote and remote:IsA("RemoteEvent") then
                remotes[name] = remote
                print(name .. " найден!")
            end
        end
    end)
end

print("Поиск удаленных событий запущен!")

-- Основная функция
local function startAutoFarm()
    local connections = {}
    local farmEnabled = false
    local rebirthEnabled = false
    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    local minimized = false

    -- Функции для вызова ремотов
    local function fireClicker()
        if remotes.Clicker then
            for i = 1, CLICK_BURST_COUNT do
                pcall(function()
                    remotes.Clicker:FireServer()
                end)
            end
        end
    end

    local function doRebirth()
        if remotes.Rebirth then
            pcall(function()
                remotes.Rebirth:FireServer()
            end)
        end
    end

    -- Создание интерфейса
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoFarmGUI"
    screenGui.Parent = player.PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 220, 0, 120)
    mainFrame.Position = UDim2.new(1, -230, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    -- Тень
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Parent = mainFrame

    -- Заголовок для перетаскивания
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 25)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 5, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Text = "By @neked10 & @sglauncher"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 12
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    -- Линия для сворачивания
    local minimizeLine = Instance.new("TextButton")
    minimizeLine.Size = UDim2.new(0, 15, 0, 15)
    minimizeLine.Position = UDim2.new(1, -40, 0, 5)
    minimizeLine.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    minimizeLine.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeLine.Text = "_"
    minimizeLine.Font = Enum.Font.GothamBold
    minimizeLine.TextSize = 14
    minimizeLine.Parent = titleBar

    -- Крест для выгрузки
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 15, 0, 15)
    closeButton.Position = UDim2.new(1, -20, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 12
    closeButton.Parent = titleBar

    -- Контент фрейм с функциями
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 90)
    contentFrame.Position = UDim2.new(0, 0, 0, 25)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Кнопка автофарма
    local farmButton = Instance.new("TextButton")
    farmButton.Size = UDim2.new(0.9, 0, 0, 40)
    farmButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    farmButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    farmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmButton.Text = "ВКЛЮЧИТЬ АВТОФАРМ"
    farmButton.Font = Enum.Font.GothamBold
    farmButton.TextSize = 12
    farmButton.Parent = contentFrame

    -- Кнопка авто-реберта
    local rebirthButton = Instance.new("TextButton")
    rebirthButton.Size = UDim2.new(0.9, 0, 0, 40)
    rebirthButton.Position = UDim2.new(0.05, 0, 0.55, 0)
    rebirthButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    rebirthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    rebirthButton.Text = "АВТО-REBIRTH: ВЫКЛ"
    rebirthButton.Font = Enum.Font.GothamBold
    rebirthButton.TextSize = 12
    rebirthButton.Parent = contentFrame

    -- Функция перетаскивания
    local function updateInput(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)

    -- Функция сворачивания/разворачивания
    local function toggleMinimize()
        minimized = not minimized
        
        if minimized then
            -- Анимация сворачивания
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(mainFrame, tweenInfo, {
                Size = UDim2.new(0, 220, 0, 25)
            })
            tween:Play()
            minimizeLine.Text = "+"
        else
            -- Анимация разворачивания
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(mainFrame, tweenInfo, {
                Size = UDim2.new(0, 220, 0, 120)
            })
            tween:Play()
            minimizeLine.Text = "_"
        end
    end

    -- Анимация появления
    local function playAppearAnimation()
        mainFrame.Position = UDim2.new(1, -230, 0, -120)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(1, -230, 0, 10)})
        tween:Play()
    end

    -- Обработчики функций
    farmButton.MouseButton1Click:Connect(function()
        farmEnabled = not farmEnabled
        
        if farmEnabled then
            farmButton.Text = "ВЫКЛЮЧИТЬ АВТОФАРМ"
            farmButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            connections.farm = RunService.Heartbeat:Connect(fireClicker)
            print("Автофарм включен")
        else
            farmButton.Text = "ВКЛЮЧИТЬ АВТОФАРМ"
            farmButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            if connections.farm then
                connections.farm:Disconnect()
                connections.farm = nil
            end
            print("Автофарм выключен")
        end
    end)

    rebirthButton.MouseButton1Click:Connect(function()
        rebirthEnabled = not rebirthEnabled
        
        if rebirthEnabled then
            rebirthButton.Text = "АВТО-REBIRTH: ВКЛ"
            rebirthButton.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
            connections.rebirth = RunService.Heartbeat:Connect(function()
                doRebirth()
            end)
            print("Авто-реберт включен")
        else
            rebirthButton.Text = "АВТО-REBIRTH: ВЫКЛ"
            rebirthButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            if connections.rebirth then
                connections.rebirth:Disconnect()
                connections.rebirth = nil
            end
            print("Авто-реберт выключен")
        end
    end)

    -- Обработчики кнопок управления
    minimizeLine.MouseButton1Click:Connect(toggleMinimize)
    
    closeButton.MouseButton1Click:Connect(function()
        for _, connection in pairs(connections) do
            connection:Disconnect()
        end
        screenGui:Destroy()
        print("Чит-скрипт выгружен")
    end)

    -- Анимации кнопок
    local function setupButtonHover(button)
        button.MouseEnter:Connect(function()
            if button.BackgroundColor3 ~= Color3.fromRGB(200, 30, 30) and 
               button.BackgroundColor3 ~= Color3.fromRGB(30, 100, 200) then
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end)
        
        button.MouseLeave:Connect(function()
            if button == farmButton and not farmEnabled then
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            elseif button == rebirthButton and not rebirthEnabled then
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            elseif button == minimizeLine or button == closeButton then
                button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end
        end)
    end

    setupButtonHover(farmButton)
    setupButtonHover(rebirthButton)
    setupButtonHover(minimizeLine)
    setupButtonHover(closeButton)

    -- Запуск анимации появления
    playAppearAnimation()

    -- Защита при перезагрузке персонажа
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        print("Персонаж перезагружен, скрипт продолжает работу")
    end)
end

-- Запуск скрипта
local success, err = pcall(function()
    startAutoFarm()
end)

if not success then
    warn("Ошибка при запуске скрипта:", err)
end

print("Чит-скрипт от @neked10 & @sglauncher успешно загружен!")
