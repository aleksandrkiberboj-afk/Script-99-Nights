local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    AntiDuplicateLoad = false,
    HubUI = true,
    DragUI = true,
    Tabs = {"Auto", "Tools", "Misc"},
    ToggleStates = {},
    SliderValues = {AutoChop = 1, ChopRadius = 10, ChopDelay = 1, CampRadius = 15, AutoMaintainCamp = false, TeleportToCamp = false, RescueRadius = 20, AutoRescueChildren = false, AutoProximityPrompt = false, FlySpeed = 10, WalkSpeed = 16, ExploreSpeed = 1, JumpPower = 50, SafeZoneRadius = 30},
    AutoChop = false,
    AutoInteracts = false,
    AutoCamp = false,
    AutoRescue = false,
    AutoPrompt = false,
    Fly = false,
    Noclip = false,
    PositionLock = false,
    ExploreSpeedMultiplier = 1,
    InstantFlyStop = false,
    PlayerESPEnabled = false,
    BoxESP = false,
    NameESP = false,
    DistanceESP = false,
    LocalHighlight = false,
    AutoReturnToCamp = false,
    AntiFallDamage = false,
    IsFlying = false,
    IsNoclip = false,
    IsDragging = false,
    DragStartPosition = nil,
    CurrentTab = "Auto"
}

local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HubUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.Parent = screenGui

    local tabHolder = Instance.new("Frame")
    tabHolder.Name = "TabHolder"
    tabHolder.Size = UDim2.new(1, 0, 0, 50)
    tabHolder.BackgroundTransparency = 1
    tabHolder.Parent = mainFrame

    local contentHolder = Instance.new("Frame")
    contentHolder.Name = "ContentHolder"
    contentHolder.Size = UDim2.new(1, 0, 1, -50)
    contentHolder.Position = UDim2.new(0, 0, 0, 50)
    contentHolder.BackgroundTransparency = 1
    contentHolder.Parent = mainFrame

    for i, tabName in ipairs(Settings.Tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName.."Tab"
        tabButton.Text = tabName
        tabButton.Size = UDim2.new(0, 200, 0, 50)
        tabButton.Position = UDim2.new(0, (i-1)*200, 0, 0)
        tabButton.Parent = tabHolder
        tabButton.MouseButton1Click:Connect(function()
            for _, btn in ipairs(tabHolder:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
                end
            end
            tabButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
            switchTab(tabName)
        end)
    end

    local function createTabContent(tabName)
        local frame = Instance.new("Frame")
        frame.Name = tabName.."Content"
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = contentHolder
        return frame
    end

    local tabContents = {}
    for _, tabName in ipairs(Settings.Tabs) do
        tabContents[tabName] = createTabContent(tabName)
    end

    local function switchTab(tabName)
        for name, frame in pairs(tabContents) do
            frame.Visible = (name == tabName)
        end
        Settings.CurrentTab = tabName
    end

    switchTab(Settings.CurrentTab)

    -- Helper functions to create UI elements
    local function createToggle(parent, label, default)
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 180, 0, 30)
        toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
        toggle.TextColor3 = Color3.new(1,1,1)
        toggle.Text = label..": "..(default and "On" or "Off")
        toggle.Parent = parent
        toggle.MouseButton1Click:Connect(function()
            default = not default
            toggle.Text = label..": "..(default and "On" or "Off")
            Settings[TABLE_FIND(Settings, label)] = default
        end)
        return toggle
    end

    local function createSlider(parent, label, min, max, start, callback)
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0, 180, 0, 15)
        labelText.Text = label..": "..start
        labelText.BackgroundTransparency = 1
        labelText.TextColor3 = Color3.new(1,1,1)
        labelText.Parent = parent

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(0, 180, 0, 15)
        slider.BackgroundColor3 = Color3.fromRGB(70,70,70)
        slider.Parent = parent

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((start - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        fill.Parent = slider

        local function updateSlider(inputX)
            local percent = math.clamp((inputX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            local value = math.floor(min + percent * (max - min))
            labelText.Text = label..": "..value
            callback(value)
        end

        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateSlider(input.Position.X)
                local moveConn
                moveConn = UserInputService.InputChanged:Connect(function(moveInput)
                    if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(moveInput.Position.X)
                    end
                end)
                moveConn = moveConn
                UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                        if moveConn then moveConn:Disconnect() end
                    end
                end)
            end
        end)
    end

    -- Creating Auto tab controls
    local autoTab = tabContents["Auto"]
    local autoChopToggle = createToggle(autoTab, "Auto Chop", Settings.AutoChop)
    local autoInteractsToggle = createToggle(autoTab, "Auto Interact", Settings.AutoInteracts)
    local autoCampToggle = createToggle(autoTab, "Auto Camp", Settings.AutoCamp)
    local autoRescueToggle = createToggle(autoTab, "Auto Rescue", Settings.AutoRescue)
    local autoPromptToggle = createToggle(autoTab, "Auto Prompt", Settings.AutoPrompt)

    createSlider(autoTab, "Chop Radius", 1, 50, Settings.SliderValues.ChopRadius, function(val) Settings.SliderValues.ChopRadius = val end)
    createSlider(autoTab, "Chop Delay", 0.1, 5, Settings.SliderValues.ChopDelay, function(val) Settings.SliderValues.ChopDelay = val end)
    createSlider(autoTab, "Camp Radius", 5, 50, Settings.SliderValues.CampRadius, function(val) Settings.SliderValues.CampRadius = val end)
    createSlider(autoTab, "Rescue Radius", 5, 50, Settings.SliderValues.RescueRadius, function(val) Settings.SliderValues.RescueRadius = val end)
    createSlider(autoTab, "Fly Speed", 1, 50, Settings.SliderValues.FlySpeed, function(val) Settings.SliderValues.FlySpeed = val end)
    createSlider(autoTab, "Walk Speed", 1, 50, Settings.SliderValues.WalkSpeed, function(val) Settings.SliderValues.WalkSpeed = val end)
    createSlider(autoTab, "Explore Speed", 1, 10, Settings.SliderValues.ExploreSpeed, function(val) Settings.SliderValues.ExploreSpeed = val end)
    createSlider(autoTab, "Jump Power", 10, 100, Settings.SliderValues.JumpPower, function(val) Settings.SliderValues.JumpPower = val end)

    -- Creating Tools tab controls
    local toolsTab = tabContents["Tools"]
    local flyToggle = createToggle(toolsTab, "Fly", Settings.Fly)
    local noclipToggle = createToggle(toolsTab, "Noclip", Settings.Noclip)
    local autoReturnToggle = createToggle(toolsTab, "Auto Return To Camp", Settings.AutoReturnToCamp)
    local autoMaintainCampToggle = createToggle(toolsTab, "Auto Maintain Camp", Settings.SliderValues.AutoMaintainCamp)
    local autoRescueChildrenToggle = createToggle(toolsTab, "Auto Rescue Children", Settings.AutoRescueChildren)

    -- Creating Misc tab controls
    local miscTab = tabContents["Misc"]
    local playerESP = createToggle(miscTab, "Player ESP", Settings.PlayerESPEnabled)
    local boxESP = createToggle(miscTab, "Box ESP", Settings.BoxESP)
    local nameESP = createToggle(miscTab, "Name ESP", Settings.NameESP)
    local distanceESP = createToggle(miscTab, "Distance ESP", Settings.DistanceESP)
    local localHighlightToggle = createToggle(miscTab, "Local Highlight", Settings.LocalHighlight)
    local antiFallToggle = createToggle(miscTab, "Anti Fall Damage", Settings.AntiFallDamage)
end

createUI()

function TABLE_FIND(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
end

local function getClosestObjectInRange(parent, name, radius)
    local closest = nil
    local distance = math.huge
    for _, obj in ipairs(parent:GetChildren()) do
        if obj.Name == name and obj:IsA("BasePart") then
            local dist = (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if dist < distance and dist <= radius then
                distance = dist
                closest = obj
            end
        end
    end
    return closest
end

local function teleportToObject(obj)
    if obj and obj:IsA("BasePart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
    end
end

local function bringObjectsToPlayer(objects)
    for _, obj in ipairs(objects) do
        if obj and obj:IsA("BasePart") then
            obj.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

local function autoChop()
    while Settings.AutoChop do
        local tree = getClosestObjectInRange(workspace, "Tree", Settings.SliderValues.ChopRadius)
        if tree then
            teleportToObject(tree)
            -- Simulate chopping
            wait(Settings.SliderValues.ChopDelay)
        else
            wait(1)
        end
    end
end

local function autoInteract()
    while Settings.AutoInteracts do
        local interactObject = getClosestObjectInRange(workspace, "Interactable", 10)
        if interactObject then
            -- Simulate interaction
            fireproximityprompt(interactObject:FindFirstChildOfClass("ProximityPrompt"))
            wait(0.5)
        else
            wait(1)
        end
    end
end

local function autoCamp()
    while Settings.AutoCamp do
        local campSpot = getClosestObjectInRange(workspace, "Campfire", Settings.SliderValues.CampRadius)
        if campSpot then
            teleportToObject(campSpot)
        end
        wait(5)
    end
end

local function autoRescue()
    while Settings.AutoRescue do
        local children = workspace:GetChildren()
        for _, child in ipairs(children) do
            if child.Name == "Child" then
                local dist = (child.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if dist <= Settings.SliderValues.RescueRadius then
                    teleportToObject(child.HumanoidRootPart)
                end
            end
        end
        wait(3)
    end
end

local function autoPrompt()
    while Settings.AutoPrompt do
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                fireproximityprompt(prompt)
                wait(0.5)
            end
        end
        wait(1)
    end
end

local function fly()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    Settings.IsFlying = true
    local direction = Vector3.new(0,0,0)
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = hrp

    local function updateFly()
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + hrp.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - hrp.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - hrp.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + hrp.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + moveDir.Normalized * Settings.SliderValues.FlySpeed * 0.1
        end
    end

    RunService.Heartbeat:Connect(updateFly)
end

local function stopFly()
    Settings.IsFlying = false
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in ipairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

local function toggleNoclip()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not Settings.IsNoclip then
        Settings.IsNoclip = true
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.N then
                Settings.IsNoclip = not Settings.IsNoclip
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = not Settings.IsNoclip
                    end
                end
            end
        end)
    else
        Settings.IsNoclip = false
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function setWalkSpeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

local function setJumpPower(jump)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jump
    end
end

local function teleportToNearest(targetName, radius)
    local nearest = getClosestObjectInRange(workspace, targetName, radius)
    if nearest then
        teleportToObject(nearest)
    end
end

local function bringObjects(targetName)
    local objects = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == targetName then
            table.insert(objects, obj)
        end
    end
    bringObjectsToPlayer(objects)
end

local function togglePlayerESP()
    -- Placeholder for ESP toggle implementation
end

local function toggleBoxESP()
    -- Placeholder for box ESP toggle implementation
end

local function toggleNameESP()
    -- Placeholder for Name ESP toggle implementation
end

local function toggleDistanceESP()
    -- Placeholder for Distance ESP toggle implementation
end

local function toggleLocalHighlight()
    -- Placeholder for Local highlight toggle
end

local function autoReturnToCamp()
    if Settings.AutoReturnToCamp then
        local camp = getClosestObjectInRange(workspace, "Campfire", 1000)
        if camp then
            teleportToObject(camp)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if Settings.Fly then
            stopFly()
        else
            fly()
        end
    elseif input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
    elseif input.KeyCode == Enum.KeyCode.Escape then
        Settings.IsFlying = false
        Settings.IsNoclip = false
        -- Additional cleanup if needed
    end
end)

if Settings.AutoChop then coroutine.wrap(autoChop)() end
if Settings.AutoInteracts then coroutine.wrap(autoInteract)() end
if Settings.AutoCamp then coroutine.wrap(autoCamp)() end
if Settings.AutoRescue then coroutine.wrap(autoRescue)() end
if Settings.AutoPrompt then coroutine.wrap(autoPrompt)() end

RunService.Heartbeat:Connect(function()
    if Settings.AutoReturnToCamp then autoReturnToCamp() end
    if Settings.AntiFallDamage then
        -- Assuming fall damage protection logic here
    end
    if Settings.PositionLock then
        -- Lock player position logic
    end
    if Settings.Noclip then toggleNoclip() end
    if Settings.Fly and Settings.IsFlying then
        -- Fly movement handled in fly()
    end
    -- Additional ESP and highlight logic placeholders
end)
