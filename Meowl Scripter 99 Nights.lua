local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDZHUB/RedzLibV2/main/Source.lua"))()

local Window = RedzLib:MakeWindow({
  Title = "Meowl Scripter | 99 Nights",
  SubTitle = "by Meowl_2705",
  SaveFolder = "MeowlConfig.json"
})

-- Переменные для работы функций
local TargetPos = "Player"
local Mode = "Normal"
local Delays = {["Normal"] = 0.15, ["Fast"] = 0.07, ["Ultra Fast"] = 0.001}

-- ВКЛАДКИ
local MainTab = Window:MakeTab("Auto", "rbxassetid://10734950309")
local BringTab = Window:MakeTab("Bring", "rbxassetid://10734950309")
local CombatTab = Window:MakeTab("Combat", "rbxassetid://10734950309")
local WorldTab = Window:MakeTab("World", "rbxassetid://10734950309")
local PlayerTab = Window:MakeTab("Player", "rbxassetid://10734950309")

--- [ ТУМБЛЕРЫ: AUTOMATION ] ---
MainTab:AddSection("Automation")

MainTab:AddToggle("Auto Chop", false, function(Value)
    _G.AutoChop = Value
    task.spawn(function()
        while _G.AutoChop do
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                tool:Activate()
            end
            task.wait(0.1) -- Скорость клика
        end
    end)
end)

MainTab:AddToggle("Auto Feed", false, function(Value)
    _G.AutoFeed = Value
    task.spawn(function()
        while _G.AutoFeed do
            -- Здесь должна быть проверка Hunger через Remote или UI
            -- Если голод низкий, скрипт ищет еду и использует её
            task.wait(5)
        end
    end)
end)

MainTab:AddToggle("Auto Campfire", false, function(Value)
    _G.AutoCampfire = Value
    task.spawn(function()
        while _G.AutoCampfire do
            -- Поиск ближайшего костра и отправка RemoteEvent на добавление топлива
            task.wait(2)
        end
    end)
end)

--- [ ТУМБЛЕРЫ: COMBAT ] ---
CombatTab:AddSection("Battle")

CombatTab:AddToggle("Kill Aura", false, function(Value)
    _G.KillAura = Value
    task.spawn(function()
        while _G.KillAura do
            local player = game.Players.LocalPlayer
            for _, monster in pairs(game.Workspace:GetChildren()) do
                -- Проверка: это моб, у него есть жизнь и он близко (15 метров)
                if monster:FindFirstChild("Humanoid") and monster:FindFirstChild("HumanoidRootPart") and monster.Name ~= player.Name then
                    local dist = (player.Character.HumanoidRootPart.Position - monster.HumanoidRootPart.Position).Magnitude
                    if dist < 18 then
                        -- Имитация удара (нужно подставить имя RemoteEvent игры)
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end)

CombatTab:AddToggle("Godmode (Anti-Damage)", false, function(Value)
    _G.GodMode = Value
    local char = game.Players.LocalPlayer.Character
    if Value and char:FindFirstChild("Health") then
        char.Health:Destroy() -- Простой обход для удаления скрипта урона
    end
end)

--- [ ТРАНСПОРТ ] ---
BringTab:AddSection("Visible Transport")
BringTab:AddDropdown("Target Location", {"Player", "Workbench", "Campfire"}, "Player", function(v) TargetPos = v end)
BringTab:AddDropdown("Teleport Speed", {"Normal", "Fast", "Ultra Fast"}, "Normal", function(v) Mode = v end)

BringTab:AddButton("Bring Logs", function()
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    local goal = root.CFrame
    if TargetPos == "Workbench" then
        local t = game.Workspace:FindFirstChild("Workbench", true)
        if t then goal = t.CFrame end
    elseif TargetPos == "Campfire" then
        local t = game.Workspace:FindFirstChild("Campfire", true)
        if t then goal = t.CFrame end
    end
    task.spawn(function()
        for _, obj in pairs(game.Workspace:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name:find("Log") or obj.Name:find("Wood")) then
                obj.CFrame = goal + Vector3.new(0, 5, 0)
                obj.Velocity = Vector3.new(0, -10, 0)
                task.wait(Delays[Mode])
            end
        end
    end)
end)

--- [ PLAYER & WORLD ] ---
PlayerTab:AddSection("Movement")
PlayerTab:AddSlider("WalkSpeed", 16, 250, 16, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)

PlayerTab:AddToggle("Noclip", false, function(v)
    _G.Noclip = v
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip then
            for _, p in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

WorldTab:AddSection("Exploits")
WorldTab:AddButton("Auto Stronghold", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0) -- Замени на реальные координаты
end)

MainTab:AddSection("Developer: Meowl_2026")
MainTab:AddButton("Copy Meowl_2705 Info", function() setclipboard("Meowl_2705") end)

RedzLib:SetTheme("Dark")

