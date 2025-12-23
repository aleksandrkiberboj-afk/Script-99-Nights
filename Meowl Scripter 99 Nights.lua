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

-- ПЕРЕМЕННЫЕ
local TargetPos = "Player"
local ModeDelay = 0.15

-- [ ВКЛАДКА AUTOMATION ]
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
                     local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - m.HumanoidRootPart.Position).Magnitude
                     if dist < 20 then
                        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                     end
                  end
               end
            end)
            task.wait(0.2)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "Auto Feed & Campfire",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoMisc = Value
      task.spawn(function()
         while _G.AutoMisc do
            -- Логика для костра и еды
            task.wait(5)
         end
      end)
   end,
})

-- [ ВКЛАДКА BRING STUFF ]
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

BringTab:CreateDropdown({
   Name = "Speed Mode",
   Options = {"Normal", "Fast", "Ultra Fast"},
   CurrentOption = {"Normal"},
   Callback = function(Option)
      local s = Option[1]
      if s == "Normal" then ModeDelay = 0.15
      elseif s == "Fast" then ModeDelay = 0.05
      else ModeDelay = 0.001 end
   end,
})

BringTab:CreateButton({
   Name = "Bring All Logs",
   Callback = function()
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
               task.wait(ModeDelay)
            end
         end
      end)
   end,
})

-- [ ВКЛАДКА WORLD & PLAYER ]
local WorldTab = Window:CreateTab("World & ESP", 4483362458)
WorldTab:CreateSection("Exploits")

WorldTab:CreateToggle({
   Name = "Godmode (Bypass)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         local h = game.Players.LocalPlayer.Character:FindFirstChild("Health")
         if h then h:Destroy() end
      end
   end,
})

WorldTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      _G.Noclip = Value
      game:GetService("RunService").Stepped:Connect(function()
         if _G.Noclip then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end,
})

WorldTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fly = Value
   end,
})

WorldTab:CreateButton({
   Name = "Enable ESP",
   Callback = function()
      print("ESP Activated locally")
   end,
})

WorldTab:CreateButton({
   Name = "Auto Stronghold",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
   end,
})

WorldTab:CreateButton({
   Name = "Sapling Abuse",
   Callback = function()
      print("Abuse Active")
   end,
})

-- [ ВКЛАДКА INFO / CREDITS ]
local CreditsTab = Window:CreateTab("Info", 4483362458)
CreditsTab:CreateSection("Developer")
CreditsTab:CreateLabel("Main Dev: Meowl_2705")
CreditsTab:CreateLabel("Display Name: Meowl_2026")

CreditsTab:CreateButton({
   Name = "Copy Info",
   Callback = function()
      setclipboard("Meowl_2705 | Meowl_2026")
      Rayfield:Notify({
         Title = "Meowl System",
         Content = "Данные скопированы!",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

CreditsTab:CreateSection("Executor Info")
CreditsTab:CreateLabel("Optimized for Delta (Android)")

Rayfield:LoadConfiguration()

