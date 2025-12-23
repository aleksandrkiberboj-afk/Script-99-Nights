https://raw.githubusercontent.com/aleksandrkiberboj-afk/Script-99-Nights/main/Meowl%20Scripter%2099%20Nights.lua?v=
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Meowl Scripter | 99 Nights",
   LoadingTitle = "Meowl_2026 Edition",
   LoadingSubtitle = "by Meowl_2705",
   ConfigurationSaving = {Enabled = true, FolderName = "MeowlConfig", FileName = "99Nights"}
})

local Kids = {"Koala Kid", "Dino Kid", "Squid Kid", "Kraken Kid"}

-- [ MOVEMENT ]
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateSlider({
   Name = "Speed Multiplier (1X - 10X)",
   Range = {16, 160},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end,
})

MoveTab:CreateToggle({
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

-- [ EXPLORE ]
local WorldTab = Window:CreateTab("Explore", 4483362458)
WorldTab:CreateToggle({
   Name = "Explore Map (Full Bright)",
   CurrentValue = false,
   Callback = function(v)
      local L = game:GetService("Lighting")
      if v then
         L.Ambient = Color3.fromRGB(255, 255, 255)
         L.Brightness = 2
      else
         L.Ambient = Color3.fromRGB(127, 127, 127)
         L.Brightness = 1
      end
   end,
})

-- [ RESCUE & AUTO ]
local AutoTab = Window:CreateTab("Automation", 4483362458)
AutoTab:CreateButton({
   Name = "TP & Rescue Official Kids",
   Callback = function()
      local root = game.Players.LocalPlayer.Character.HumanoidRootPart
      for _, name in pairs(Kids) do
          local c = game.Workspace:FindFirstChild(name, true)
          if c and c:FindFirstChild("HumanoidRootPart") then
              root.CFrame = c.HumanoidRootPart.CFrame
              task.wait(0.5)
              local p = c:FindFirstChildOfClass("ProximityPrompt")
              if p then fireproximityprompt(p) end
              task.wait(0.5)
          end
      end
   end,
})

Rayfield:LoadConfiguration()

