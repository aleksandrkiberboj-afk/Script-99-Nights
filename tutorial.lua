-- [[ MEOWL SCRIPTER v2.5 | 99 NIGHTS SURVIVAL ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Meowl Scripter", "Midnight")

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Safe Wait for Game Objects
local GameObjects = Workspace:WaitForChild("GameObjects", 10)
if not GameObjects then 
    warn("Meowl Scripter: GameObjects folder not found!") 
    return 
end

local EnemyFolder = GameObjects:WaitForChild("Enemies", 5)
local ResourceFolder = GameObjects:WaitForChild("Resources", 5)
local TreeFolder = ResourceFolder and ResourceFolder:WaitForChild("Trees", 5)

local Toggles = {
    KillAura = false,
    AutoChop = false,
    AutoLoot = false,
    Fly = false,
    Noclip = false,
    ESP = false
}

-- [[ TABS ]] --
local Main = Window:NewTab("Main")
local Combat = Window:NewTab("Combat")
local ItemsTab = Window:NewTab("Items")
local World = Window:NewTab("World")
local Visuals = Window:NewTab("Visuals")

-- [[ COMBAT ]] --
local CombatSec = Combat:NewSection("Combat Functions")
CombatSec:NewToggle("Kill Aura", "Kill enemies in 50 range", function(state)
    Toggles.KillAura = state
    task.spawn(function()
        while Toggles.KillAura do
            task.wait(0.1)
            pcall(function()
                local char = lp.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and EnemyFolder then
                    for _, enemy in ipairs(EnemyFolder:GetChildren()) do
                        local eRoot = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
                        local eHum = enemy:FindFirstChildOfClass("Humanoid")
                        if eRoot and eHum and eHum.Health > 0 then
                            if (root.Position - eRoot.Position).Magnitude < 50 then
                                eHum.Health = 0
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ ITEMS & BRING ]] --
local ItemSec = ItemsTab:NewSection("Item Management")
ItemSec:NewButton("Bring All Items", "Teleports items to you", function()
    pcall(function()
        local root = lp.Character.HumanoidRootPart
        for _, item in ipairs(Workspace:GetChildren()) do
            if item:IsA("BasePart") and (item:FindFirstChild("ClickDetector") or item.Name == "Loot") then
                item.CFrame = root.CFrame + Vector3.new(0, 2, 0)
            end
        end
    end)
end)

ItemSec:NewToggle("Auto Collect Loot", "Automatic pickup", function(state)
    Toggles.AutoLoot = state
    task.spawn(function()
        while Toggles.AutoLoot do
            task.wait(0.3)
            pcall(function()
                local root = lp.Character.HumanoidRootPart
                for _, item in ipairs(Workspace:GetChildren()) do
                    if item:IsA("BasePart") and item:FindFirstChild("ClickDetector") then
                        if (root.Position - item.Position).Magnitude < 30 then
                            fireclickdetector(item.ClickDetector)
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ WORLD & ADMIN BASE ]] --
local WorldSec = World:NewSection("Automation")
WorldSec:NewButton("Admin Tree Base", "1 Sapling -> Infinity", function()
    pcall(function()
        local base = Instance.new("Part", Workspace)
        base.Name = "AdminTreeBase"
        base.Size = Vector3.new(15, 1, 15)
        base.Anchored = true
        base.BrickColor = BrickColor.new("Bright green")
        base.Position = lp.Character.HumanoidRootPart.Position + Vector3.new(0, -3, 0)
        local cd = Instance.new("ClickDetector", base)
        cd.MouseClick:Connect(function()
            for i = 1, 5 do
                local s = Instance.new("Part", TreeFolder or Workspace)
                s.Name = "Tree"
                s.Position = base.Position + Vector3.new(math.random(-10, 10), 10, math.random(-10, 10))
                Instance.new("ClickDetector", s)
                local v = Instance.new("IntValue", s); v.Name = "Wood"; v.Value = 100
            end
        end)
    end)
end)

WorldSec:NewToggle("Auto Chop All", "Farms all trees", function(state)
    Toggles.AutoChop = state
    task.spawn(function()
        while Toggles.AutoChop do
            if TreeFolder then
                for _, v in ipairs(TreeFolder:GetChildren()) do
                    local cd = v:FindFirstChildOfClass("ClickDetector")
                    if cd then fireclickdetector(cd) end
                end
            end
            task.wait(0.3)
        end
    end)
end)

-- [[ PLAYER & MOVEMENT ]] --
local MainSec = Main:NewSection("Movement")
MainSec:NewSlider("Speed", "WalkSpeed", 250, 16, function(s)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = s
    end
end)

MainSec:NewToggle("Fly", "Flight Mode", function(state)
    Toggles.Fly = state
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local bv = root:FindFirstChild("MeowlFly") or Instance.new("BodyVelocity", root)
        bv.Name = "MeowlFly"
        bv.MaxForce = state and Vector3.new(9e9, 9e9, 9e9) or Vector3.new(0, 0, 0)
        task.spawn(function()
            while Toggles.Fly do
                bv.Velocity = lp.Character.Humanoid.MoveDirection * 100
                task.wait()
            end
        end)
    end
end)

MainSec:NewToggle("Noclip", "No Collision", function(state)
    Toggles.Noclip = state
    RunService.Stepped:Connect(function()
        if Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- [[ VISUALS ]] --
local VisSec = Visuals:NewSection("ESP & Brightness")
VisSec:NewToggle("Enemy ESP", "Box Highlight", function(state)
    Toggles.ESP = state
    task.spawn(function()
        while Toggles.ESP do
            if EnemyFolder then
                for _, e in ipairs(EnemyFolder:GetChildren()) do
                    if not e:FindFirstChild("Highlight") then
                        Instance.new("Highlight", e)
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end)

VisSec:NewButton("Full Bright", "Day Time", function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").ClockTime = 12
end)

print("Meowl Scripter v2.5 successfully loaded!")
