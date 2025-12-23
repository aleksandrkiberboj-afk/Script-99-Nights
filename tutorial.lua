                local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Meowl Scripter | Premium v3.6", "Midnight")

local lp = game.Players.LocalPlayer
local ResourceFolder = workspace:WaitForChild("GameObjects"):WaitForChild("Resources")
local TreeFolder = ResourceFolder:WaitForChild("Trees")

_G.Building = false

-- [[ TABS ]]
local Main = Window:NewTab("Main")
local Build = Window:NewTab("Advanced Builder")
local PlayerTab = Window:NewTab("Player")

local BuildSec = Build:NewSection("Tree Shape Generator")

-- Функция для спавна одного "админского" дерева
local function spawnTree(pos)
    if not _G.Building then return end
    local t = Instance.new("Part", TreeFolder)
    t.Name = "AdminTree"
    t.Size = Vector3.new(4, 15, 4)
    t.Position = pos
    t.Anchored = true
    t.BrickColor = BrickColor.new("Slime green")
    t.Material = Enum.Material.Neon
    local cd = Instance.new("ClickDetector", t)
    local v = Instance.new("IntValue", t); v.Name = "Wood"; v.Value = 999
end

-- КНОПКИ ФОРМ
BuildSec:NewButton("Circle Shape", "Spawn trees in circle", function()
    _G.Building = true
    local center = lp.Character.HumanoidRootPart.Position
    for i = 1, 360, 20 do
        if not _G.Building then break end
        local angle = math.rad(i)
        local pos = center + Vector3.new(math.cos(angle) * 30, 0, math.sin(angle) * 30)
        spawnTree(pos)
        task.wait(0.1)
    end
end)

BuildSec:NewButton("Square Shape", "Spawn trees in square", function()
    _G.Building = true
    local center = lp.Character.HumanoidRootPart.Position
    local size = 40
    for x = -size, size, 10 do
        if not _G.Building then break end
        spawnTree(center + Vector3.new(x, 0, size))
        spawnTree(center + Vector3.new(x, 0, -size))
        spawnTree(center + Vector3.new(size, 0, x))
        spawnTree(center + Vector3.new(-size, 0, x))
        task.wait(0.1)
    end
end)

BuildSec:NewButton("Heart Shape ❤️", "Spawn trees in heart form", function()
    _G.Building = true
    local center = lp.Character.HumanoidRootPart.Position
    for i = 0, 360, 10 do
        if not _G.Building then break end
        local t = math.rad(i)
        local x = 16 * math.sin(t)^3
        local z = -(13 * math.cos(t) - 5 * math.cos(2*t) - 2 * math.cos(3*t) - math.cos(4*t))
        spawnTree(center + Vector3.new(x * 2, 0, z * 2))
        task.wait(0.05)
    end
end)

BuildSec:NewButton("Spiral Shape", "Spawn trees in spiral", function()
    _G.Building = true
    local center = lp.Character.HumanoidRootPart.Position
    for i = 1, 500, 10 do
        if not _G.Building then break end
        local angle = 0.1 * i
        local x = (1 + angle) * math.cos(angle)
        local z = (1 + angle) * math.sin(angle)
        spawnTree(center + Vector3.new(x * 2, 0, z * 2))
        task.wait(0.05)
    end
end)

BuildSec:NewButton("Triangle Shape", "Spawn trees in triangle", function()
    _G.Building = true
    local center = lp.Character.HumanoidRootPart.Position
    local size = 40
    for i = -size, size, 10 do
        if not _G.Building then break end
        spawnTree(center + Vector3.new(i, 0, i))
        spawnTree(center + Vector3.new(i, 0, -size))
        spawnTree(center + Vector3.new(-i, 0, i))
        task.wait(0.1)
    end
end)

BuildSec:NewButton("Single Point (Infinite)", "Stack trees in one spot", function()
    _G.Building = true
    local pos = lp.Character.HumanoidRootPart.Position + lp.Character.HumanoidRootPart.CFrame.LookVector * 10
    task.spawn(function()
        while _G.Building do
            spawnTree(pos)
            task.wait(0.5)
        end
    end)
end)

local ControlSec = Build:NewSection("Controls")
ControlSec:NewButton("STOP ALL PROCESSES", "Instantly stops building", function()
    _G.Building = false
    print("Building Stopped.")
end)

-- [[ PLAYER ]]
local MoveSec = PlayerTab:NewSection("Movement")
MoveSec:NewSlider("Speed", "WalkSpeed", 300, 16, function(s)
    lp.Character.Humanoid.WalkSpeed = s
end)

-- [[ MAIN AUTO ]]
local MainSec = Main:NewSection("Automation")
MainSec:NewToggle("Auto Chop", "Collect Wood", function(state)
    _G.Chop = state
    while _G.Chop do
        for _, v in pairs(TreeFolder:GetChildren()) do
            local cd = v:FindFirstChildOfClass("ClickDetector")
            if cd then fireclickdetector(cd) end
        end
        task.wait(0.2)
    end
end)

