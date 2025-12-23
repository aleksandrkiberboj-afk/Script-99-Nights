local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Meowl Scripter | 99 Nights",
   LoadingTitle = "Meowl_2026 Edition",
   LoadingSubtitle = "by Meowl_2705",
   ConfigurationSaving = {Enabled = true, FolderName = "MeowlConfig", FileName = "99Nights"}
})

-- Variables
local Kids = {"Koala Kid", "Dino Kid", "Squid Kid", "Kraken Kid"}
local NormalSpeed = 16

-- [ MOVEMENT & SPEED ]
local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateSlider({
   Name = "WalkSpeed Multiplier (Up to 10X)",
   Range = {16, 160}, -- 160 это как раз 10X от стандартных 16
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
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

-- [ EXPLORE & VISUALS ]
local WorldTab = Window:CreateTab("World", 4483362458)

WorldTab:CreateToggle({
   Name = "Explore Map (Full Bright)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
         game:GetService("Lighting").Brightness = 2
         game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255, 255, 255)
      else
         game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
         game:GetService("Lighting").Brightness = 1
         game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(127, 127, 127)
      end
   end,
})

-- [ RESCUE MISSIONS ]
local AutoTab = Window:CreateTab("Automation", 4483362458)
AutoTab:CreateSection("Official Kids Rescue")

AutoTab:CreateButton({
   Name = "TP & Rescue All 4 Kids",
   Callback = function()
      local root = game.Players.LocalPlayer.Character.HumanoidRootPart
      for _, name in pairs(Kids) do
          local child = game.Workspace:FindFirstChild(name, true)
          if child and child:FindFirstChild("HumanoidRootPart") then
              root.CFrame = child.HumanoidRootPart.CFrame
              task.wait(0.5)
              local prompt = child:FindFirstChildOfClass("ProximityPrompt")
              if prompt then fireproximityprompt(prompt) end
              task.wait(0.5)
          end
      end
      Rayfield:Notify({Title="Meowl System", Content="All official kids rescued!", Duration=3})
   end,
})

-- [ INFO ]
local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateLabel("Main Dev: Meowl_2705")
InfoTab:CreateLabel("Display: Meowl_2026")

Rayfield:LoadConfiguration()


