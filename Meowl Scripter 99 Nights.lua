--[[
    MEOWL SCRIPTER v2.0
    Game: 99 Nights in the Forest
    Developer: Meowl_2705 (Display: Meowl_2026)
    Language: Auto-Detection (RU/EN)
    License: Open Source for GitHub
]]

local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

-- ПРОВЕРКА ЛОКАЛИЗАЦИИ
local isRussian = game:GetService("LocalizationService").RobloxLocaleId == "ru-ru"
local L = {
    Title = "Meowl Scripter | GitHub",
    BringTab = isRussian and "Транспорт" or "Bring Stuff",
    Settings = isRussian and "Настройки" or "Settings",
    ModeLabel = isRussian and "Режим скорости" or "Teleport Mode",
    TargetLabel = isRussian and "Точка доставки" or "Target Location",
    StartBtn = isRussian and "Запустить транспорт" or "Start Transport",
    NotifyTitle = "Meowl System"
}

local Window = WindUI:CreateWindow({
    Title = L.Title,
    Icon = "rbxassetid://10734950309",
    Author = "Meowl_2705",
    Theme = "Dark",
    Transparent = true
})

-- КОНФИГУРАЦИЯ ТРАНСПОРТА
local TargetLocation = "Player"
local TeleportMode = "Normal"
local ModeDelays = {
    ["Normal"] = 0.15,
    ["Fast"] = 0.07,
    ["Ultra Fast"] = 0.001
}

-- ВКЛАДКА: BRING STUFF
local BringTab = Window:CreateTab(L.BringTab, "package")

BringTab:Section(L.TargetLabel)
BringTab:Dropdown(L.TargetLabel, {"Player", "Workbench", "Campfire"}, "Player", function(v)
    TargetLocation = v
end)

BringTab:Section(L.ModeLabel)
BringTab:Dropdown(L.ModeLabel, {"Normal", "Fast", "Ultra Fast"}, "Normal", function(v)
    TeleportMode = v
end)

BringTab:Button(L.StartBtn, function()
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not root then return end
    
    -- Определение координат цели (Локальный поиск)
    local targetCFrame = root.CFrame
    if TargetLocation == "Workbench" then
        local wb = game.Workspace:FindFirstChild("Workbench", true) 
        if wb then targetCFrame = wb.CFrame else WindUI:Notify(L.NotifyTitle, "Workbench not found!", 3) return end
    elseif TargetLocation == "Campfire" then
        local cf = game.Workspace:FindFirstChild("Campfire", true)
        if cf then targetCFrame = cf.CFrame else WindUI:Notify(L.NotifyTitle, "Campfire not found!", 3) return end
    end

    -- ЛОГИКА ТЕЛЕПОРТАЦИИ (CLIENT-SIDE VISIBLE SYNC)
    task.spawn(function()
        local count = 0
        for _, obj in pairs(game.Workspace:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name:find("Log") or obj.Name:find("Wood")) then
                -- Плавная синхронизация для видимости игрокам
                obj.CFrame = targetCFrame + Vector3.new(0, 7, 0)
                obj.Velocity = Vector3.new(0, -20, 0) -- Эффект падения сверху
                count = count + 1
                task.wait(ModeDelays[TeleportMode])
            end
        end
        WindUI:Notify(L.NotifyTitle, isRussian and "Доставлено объектов: "..count or "Delivered objects: "..count, 3)
    end)
end)

-- ВКЛАДКА: ИГРОК
local PlayerTab = Window:CreateTab("Player", "user")
PlayerTab:Slider(isRussian and "Скорость" or "Speed", 16, 200, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

-- ИНФОРМАЦИЯ О РАЗРАБОТЧИКЕ (MEOWL_2026)
local InfoTab = Window:CreateTab("Credits", "info")
InfoTab:Section("Developer Info")
InfoTab:Button("User: Meowl_2705", function() setclipboard("Meowl_2705") end)
InfoTab:Button("Display: Meowl_2026", function() setclipboard("Meowl_2026") end)

-- КРАСИВЫЙ ВЫВОД В КОНСОЛЬ (ДЛЯ GITHUB)
warn("Meowl Scripter Loaded!")
print([[ 
    _  _   _   _  _ 
   | || | | | | || |
   | || |_| |_| || |
   |__   _|__   _| |
      |_|    |_| |_|
   Meowl_2705 (2026)
]])
