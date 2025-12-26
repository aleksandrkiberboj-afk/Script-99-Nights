local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local Settings = {
    WindRedz = {
        AntiDuplicateLoad = false,
        DragGUI = true,
        Tabs = {},
        Toggles = {},
        Sliders = {},
        AutoChop = false,
        ChopRadius = 20,
        ChopDelay = 1,
        AutoInteract = false,
        TeleportNearestTree = false,
        BringTrees = false,
        TreeHighlight = false,
        AutoCampfire = false,
        CampRadius = 30,
        AutoMaintainCamp = false,
        TeleportToCamp = false,
        AutoRescue = false,
        RescueRadius = 25,
        TeleportNearestChild = false,
        BringChildren = false,
        AutoProximityPrompt = false,
        Fly = false,
        FlySpeed = 50,
        WASDFlyControl = true,
        Noclip = false,
        WalkSpeedControl = true,
        ExploreSpeedMin = 1,
        ExploreSpeedMax = 10,
        JumpPowerControl = true,
        InstantFlyStop = false,
        PlayerESP = false,
        BoxESP = false,
        NameESP = false,
        DistanceESP = false,
        LocalHighlight = false,
        SafeZoneRadius = 20,
        AutoReturnToCamp = false,
        AntiFallDamage = false,
        PositionLock = false,
        CentralSettingsTable = {},
        SingleScriptClient = true,
        NoKeySystem = true,
        GitHubReady = true
    }
}

local function createGUI()
    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    if Settings.WindRedz.DragGUI then
        ScreenGui.DragToggle = Instance.new("TextButton", ScreenGui)
        ScreenGui.DragToggle.Text = "Drag GUI"
        ScreenGui.DragToggle.Position = UDim2.new(0,10,0,10)
        ScreenGui.DragToggle.Size = UDim2.new(0,100,0,30)
        local dragging = false
        local dragInput, dragStart, startPos
        ScreenGui.DragToggle.MouseButton1Down:Connect(function()
            dragging = true
            dragStart = UserInputService:GetMouseLocation()
            startPos = ScreenGui.AbsolutePosition
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = UserInputService:GetMouseLocation() - dragStart
                    ScreenGui.DragToggle.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end)
    end
end

createGUI()

local function loadLibrary()
    local lib = {}
    lib.autoChop = Settings.WindRedz.AutoChop
    lib.chopRadius = Settings.WindRedz.ChopRadius
    lib.chopDelay = Settings.WindRedz.ChopDelay
    lib.autoInteract = Settings.WindRedz.AutoInteract
    lib.teleportNearestTree = Settings.WindRedz.TeleportNearestTree
    lib.bringTrees = Settings.WindRedz.BringTrees
    lib.treeHighlight = Settings.WindRedz.TreeHighlight
    lib.autoCampfire = Settings.WindRedz.AutoCampfire
    lib.campRadius = Settings.WindRedz.CampRadius
    lib.autoMaintainCamp = Settings.WindRedz.AutoMaintainCamp
    lib.teleportToCamp = Settings.WindRedz.TeleportToCamp
    lib.autoRescue = Settings.WindRedz.AutoRescue
    lib.rescueRadius = Settings.WindRedz.RescueRadius
    lib.teleportNearestChild = Settings.WindRedz.TeleportNearestChild
    lib.bringChildren = Settings.WindRedz.BringChildren
    lib.autoProximityPrompt = Settings.WindRedz.AutoProximityPrompt
    lib.fly = Settings.WindRedz.Fly
    lib.flySpeed = Settings.WindRedz.FlySpeed
    lib.wasdFlyControl = Settings.WindRedz.WASDFlyControl
    lib.noclip = Settings.WindRedz.Noclip
    lib.walkSpeedControl = Settings.WindRedz.WalkSpeedControl
    lib.exploreSpeedMin = Settings.WindRedz.ExploreSpeedMin
    lib.exploreSpeedMax = Settings.WindRedz.ExploreSpeedMax
    lib.jumpPowerControl = Settings.WindRedz.JumpPowerControl
    lib.instantFlyStop = Settings.WindRedz.InstantFlyStop
    lib.playerESP = Settings.WindRedz.PlayerESP
    lib.boxESP = Settings.WindRedz.BoxESP
    lib.nameESP = Settings.WindRedz.NameESP
    lib.distanceESP = Settings.WindRedz.DistanceESP
    lib.localHighlight = Settings.WindRedz.LocalHighlight
    lib.safeZoneRadius = Settings.WindRedz.SafeZoneRadius
    lib.autoReturnToCamp = Settings.WindRedz.AutoReturnToCamp
    lib.antiFallDamage = Settings.WindRedz.AntiFallDamage
    lib.positionLock = Settings.WindRedz.PositionLock
    lib.centralSettingsTable = Settings.WindRedz.CentralSettingsTable
    lib.singleScriptClient = Settings.WindRedz.SingleScriptClient
    lib.noKeySystem = Settings.WindRedz.NoKeySystem
    lib.gitHubReady = Settings.WindRedz.GitHubReady
    return lib
end

local library = loadLibrary()

local function autoChopTrees()
    while library.autoChop do
        local trees = workspace:GetChildren()
        for _, obj in pairs(trees) do
            if obj.Name == "Tree" and (obj.Position - Player.Character.HumanoidRootPart.Position).magnitude <= library.chopRadius then
                if obj:FindFirstChild("Chop") then
                    fireclickdetector(obj.Chop.ClickDetector)
                    wait(library.chopDelay)
                end
            end
        end
        wait(0.5)
    end
end

local function autoRescueChildren()
    while library.autoRescue do
        local chars = workspace:GetChildren()
        for _, c in pairs(chars) do
            if c:FindFirstChild("Children") then
                for _, child in pairs(c.Children:GetChildren()) do
                    if (child.Position - Player.Character.HumanoidRootPart.Position).magnitude <= library.rescueRadius then
                        if child:FindFirstChildOfClass("ProximityPrompt") then
                            fireproximityprompt(child:FindFirstChildOfClass("ProximityPrompt"))
                            wait(0.5)
                        end
                    end
                end
            end
        end
        wait(1)
    end
end

local function autoCampfireFeed()
    while library.autoCampfire do
        local campfires = workspace:GetChildren()
        for _, obj in pairs(campfires) do
            if obj.Name == "Campfire" and (obj.Position - Player.Character.HumanoidRootPart.Position).magnitude <= library.campRadius then
                if obj:FindFirstChildOfClass("ProximityPrompt") then
                    fireproximityprompt(obj:FindFirstChildOfClass("ProximityPrompt"))
                    wait(1)
                end
            end
        end
        wait(0.5)
    end
end

local function teleportToNearest(targets)
    local nearest = nil
    local minDist = math.huge
    for _, target in pairs(targets) do
        local dist = (target.Position - Player.Character.HumanoidRootPart.Position).magnitude
        if dist < minDist then
            minDist = dist
            nearest = target
        end
    end
    if nearest then
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
    end
end

local function bringToPlayer(objects)
    for _, obj in pairs(objects) do
        if obj and obj:FindFirstChild("HumanoidRootPart") then
            obj.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
        end
    end
end

local function toggleFly()
    library.fly = not library.fly
    if library.fly then
        local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local flyConn
            flyConn = RunService.Stepped:Connect(function()
                if library.fly then
                    hrp.Velocity = Vector3.new(0,0,0)
                    local moveDirection = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += Camera.CFrame.RightVector end
                    hrp.CFrame = hrp.CFrame + moveDirection * library.flySpeed * RunService.RenderStepped:Wait()
                else
                    flyConn:Disconnect()
                end
            end)
        end
    end
end

local function applyESP()
    if library.playerESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local character = p.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    if not character:FindFirstChild("ESPBox") then
                        local box = Instance.new("BoxHandleAdornment", character.HumanoidRootPart)
                        box.Name = "ESPBox"
                        box.Adornee = character.HumanoidRootPart
                        box.Size = Vector3.new(2,2,2)
                        box.Color3 = Color3.new(1,0,0)
                        box.AlwaysOnTop = true
                        box.Visible = library.boxESP
                    else
                        character:FindFirstChild("ESPBox").Visible = library.boxESP
                    end
                end
                if not character:FindFirstChild("ESPName") then
                    local nameLabel = Instance.new("BillboardGui", character:WaitForChild("HumanoidRootPart"))
                    nameLabel.Name = "ESPName"
                    nameLabel.Size = UDim2.new(0,100,0,50)
                    nameLabel.Adornee = character.HumanoidRootPart
                    local textLabel = Instance.new("TextLabel", nameLabel)
                    textLabel.Size = UDim2.new(1,0,1,0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = p.Name
                    textLabel.TextColor3 = Color3.new(1,1,1)
                    textLabel.TextStrokeTransparency = 0
                    textLabel.Visible = library.nameESP
                else
                    local label = character:FindFirstChild("ESPName")
                    label.Visible = library.nameESP
                    label:FindFirstChild("TextLabel").Text = p.Name
                end
            end
        end
    end
end

local function mainLoop()
    while true do
        if library.autoChop then autoChopTrees() end
        if library.autoRescue then autoRescueChildren() end
        if library.autoCampfire then autoCampfireFeed() end
        applyESP()
        wait(0.1)
    end
end

coroutine.wrap(mainLoop)()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)
