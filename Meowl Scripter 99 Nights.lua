 local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Meowl Scripter | 99 Nights",
   LoadingTitle = "Meowl_2026 Edition",
   LoadingSubtitle = "by Meowl_2705",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MeowlConfig",
      FileName = "99Nights"
   }
})

local TargetPos = "Player"
local ModeDelay = 0.15

-- [ АВТОМАТИЗАЦИЯ ]
local MainTab = Window:CreateTab("Automation", 4483362458)
MainTab:CreateSection("Farming & Combat")

MainTab:CreateToggle({
   Name = "Auto Chop",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoChop = Value
      task.spawn(function()
         while _G.AutoChop do
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(0.1)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Callback = function(Value)
      _G.KillAura = Value
      task.spawn(function()
         while _G.KillAura do
            pcall(function()
               for _, m in pairs(game.Workspace:GetChildren()) do
                  if m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") then
                     local d = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - m.HumanoidRootPart.Position).Magnitude
                     if d < 20 then
                        local t = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if t then t:Activate() end
                     end
                  end
               end
            end)
            task.wait(0.2)
         end
      end)
   end,
})

-- [ ТРАНСПОРТ ]
local BringTab = Window:CreateTab("Bring Stuff", 4483362458)
BringTab:CreateSection("Visible Transport")

BringTab:CreateDropdown({
   Name = "Target Location",
   Options = {"Player", "Workbench", "Campfire"},
   CurrentOption = {"Player"},
   Callback = function(Option)
      TargetPos = Option[1]
   end,
})

BringTab:CreateButton({
   Name = "Bring All Logs",
   Callback = function()
      local root = game.Players.LocalPlayer.Character.HumanoidRootPart
      task.spawn(function()
         for _, obj in pairs(game.Workspace:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name:find("Log") or obj.Name:find("Wood")) then
               obj.CFrame = root.CFrame + Vector3.new(0, 5, 0)
               task.wait(0.1)
            end
         end
      end)
   end,
})

-- [ ИГРОК И МИР ]
local WorldTab = Window:CreateTab("World & ESP", 4483362458)

WorldTab:CreateToggle({
   Name = "Godmode (Bypass)",
   CurrentValue = false,
   Callback = function(v)
      if v then
         local h = game.Players.LocalPlayer.Character:FindFirstChild("Health")
         if h then h:Destroy() end
      end
   end,
})

WorldTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(v)
      _G.Noclip = v
      game:GetService("RunService").Stepped:Connect(function()
         if _G.Noclip then
            for _, p in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
               if p:IsA("BasePart") then p.CanCollide = false end
            end
         end
      end)
   end,
})

WorldTab:CreateButton({
   Name = "Teleport Stronghold",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
   end,
})

-- [ ИНФОРМАЦИЯ ]
local CreditsTab = Window:CreateTab("Info", 4483362458)
CreditsTab:CreateSection("Developer Information")
CreditsTab:CreateLabel("Main Dev: Meowl_2705")
CreditsTab:CreateLabel("Nickname: Meowl_2026")
CreditsTab:CreateButton({
   Name = "Copy Info",
   Callback = function() 
      setclipboard("Meowl_2705") 
      Rayfield:Notify({Title="Meowl System", Content="Скопировано!", Duration=2})
   end,
})

Rayfield:LoadConfiguration()

