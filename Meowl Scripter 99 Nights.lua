-- Meowl Scripter | 99 Nights ❄️🔥
-- Client-side | Delta | GitHub ready

if _G.MeowlScripterLoaded then return end
_G.MeowlScripterLoaded = true

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Meowl Scripter | 99 Nights ❄️🔥",
    SubTitle = "Forest Adventure ~ Delta Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 420),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Добавление инфо о авторе только один раз
if not _G.MeowlScripterInfoAdded then
    _G.MeowlScripterInfoAdded = true
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1,0,0,30)
    InfoLabel.Position = UDim2.new(0,0,0,0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "Meowl Scripter | 99 Nights in the Forest"
    InfoLabel.TextColor3 = Color3.fromRGB(255,255,255)
    InfoLabel.TextScaled = true
    InfoLabel.Parent = Window.Root
end

-- Drag
do
    local UIS = game:GetService("UserInputService")
    local frame = Window.Root
    local drag, start, pos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = i.Position
            pos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = i.Position - start
            frame.Position = UDim2.new(pos.X.Scale,pos.X.Offset+delta.X,pos.Y.Scale,pos.Y.Offset+delta.Y)
        end
    end)
end

-- Settings
local S = {AutoChop=false,ChopRadius=15,ChopDelay=0.25,AutoCampfire=false,CampfireRadius=12,AutoFeed=false,FeedRadius=12,AutoRescue=false,RescueRadius=20,Fly=false,FlySpeed=50,Noclip=false,ExploreSpeed=1,ESP=false}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
LP.CharacterAdded:Connect(function(c) Char=c HRP=c:WaitForChild("HumanoidRootPart") end)

local Tabs={Main=Window:AddTab({Title="Main"}),Move=Window:AddTab({Title="Movement"}),Visual=Window:AddTab({Title="Visual"})}

Tabs.Main:AddToggle("Auto Chop",S.AutoChop,function(v) S.AutoChop=v end)
Tabs.Main:AddSlider("Chop Radius",5,40,S.ChopRadius,1,function(v) S.ChopRadius=v end)
Tabs.Main:AddSlider("Chop Delay",0.1,1,S.ChopDelay,0.05,function(v) S.ChopDelay=v end)
Tabs.Main:AddToggle("Auto Campfire",S.AutoCampfire,function(v) S.AutoCampfire=v end)
Tabs.Main:AddSlider("Campfire Radius",5,30,S.CampfireRadius,1,function(v) S.CampfireRadius=v end)
Tabs.Main:AddToggle("Auto Feed",S.AutoFeed,function(v) S.AutoFeed=v end)
Tabs.Main:AddSlider("Feed Radius",5,30,S.FeedRadius,1,function(v) S.FeedRadius=v end)
Tabs.Main:AddToggle("Auto Rescue Children",S.AutoRescue,function(v) S.AutoRescue=v end)
Tabs.Main:AddSlider("Rescue Radius",5,50,S.RescueRadius,1,function(v) S.RescueRadius=v end)

Tabs.Move:AddToggle("Fly",S.Fly,function(v) S.Fly=v end)
Tabs.Move:AddSlider("Fly Speed",10,150,S.FlySpeed,5,function(v) S.FlySpeed=v end)
Tabs.Move:AddToggle("Noclip",S.Noclip,function(v) S.Noclip=v end)
Tabs.Move:AddSlider("Explore Speed",1,10,S.ExploreSpeed,0.1,function(v)
    if Char and Char:FindFirstChild("Humanoid") then
        Char.Humanoid.WalkSpeed=16*v
    end
end)

Tabs.Visual:AddToggle("ESP",S.ESP,function(v) S.ESP=v end)

local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")

RunService.Heartbeat:Connect(function()
    if S.Noclip and Char then
        for _,p in pairs(Char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

local FlyBV
RunService.Heartbeat:Connect(function()
    if S.Fly and Char then
        if not FlyBV then
            FlyBV=Instance.new("BodyVelocity")
            FlyBV.MaxForce=Vector3.new(1e5,1e5,1e5)
            FlyBV.Velocity=Vector3.new()
            FlyBV.Parent=HRP
        end
        local cam=workspace.CurrentCamera
        FlyBV.Velocity=cam.CFrame.LookVector*S.FlySpeed
    else
        if FlyBV then FlyBV:Destroy() FlyBV=nil end
    end
end)

-- Auto Chop
spawn(function()
    while task.wait(S.ChopDelay) do
        if S.AutoChop then
            for _,tree in pairs(Workspace:GetDescendants()) do
                if tree:IsA("Model") and tree:FindFirstChild("ProximityPrompt") then
                    local root=tree:FindFirstChild("HumanoidRootPart") or tree.PrimaryPart
                    if root and (HRP.Position-root.Position).Magnitude<=S.ChopRadius then
                        tree.ProximityPrompt:InputHoldBegin()
                        task.wait(0.1)
                        tree.ProximityPrompt:InputHoldEnd()
                    end
                end
            end
        end
    end
end)

-- Auto Rescue
spawn(function()
    while task.wait(0.3) do
        if S.AutoRescue then
            for _,child in pairs(Workspace:GetDescendants()) do
                if child:IsA("Model") and (child.Name=="Dino Kid" or child.Name=="Kraken Kid" or child.Name=="Squid Kid" or child.Name=="Koala Kid") then
                    local root=child:FindFirstChild("HumanoidRootPart") or child.PrimaryPart
                    local prompt=child:FindFirstChildWhichIsA("ProximityPrompt")
                    if root and prompt and (HRP.Position-root.Position).Magnitude<=S.RescueRadius then
                        prompt:InputHoldBegin()
                        task.wait(0.1)
                        prompt:InputHoldEnd()
                    end
                end
            end
        end
    end
end)

-- Auto Campfire & Auto Feed
spawn(function()
    while task.wait(0.3) do
        for _,obj in pairs(Workspace:GetDescendants()) do
            if S.AutoCampfire and obj:IsA("Model") and obj.Name:lower():find("campfire") then
                local prompt=obj:FindFirstChildWhichIsA("ProximityPrompt")
                if prompt and (HRP.Position-obj.PrimaryPart.Position).Magnitude<=S.CampfireRadius then
                    prompt:InputHoldBegin()
                    task.wait(0.1)
                    prompt:InputHoldEnd()
                end
            end
            if S.AutoFeed and obj:IsA("Model") and obj.Name:lower():find("playerfeed") then
                local prompt=obj:FindFirstChildWhichIsA("ProximityPrompt")
                if prompt and (HRP.Position-obj.PrimaryPart.Position).Magnitude<=S.FeedRadius then
                    prompt:InputHoldBegin()
                    task.wait(0.1)
                    prompt:InputHoldEnd()
                end
            end
        end
    end
end)

-- Player ESP
local ESP_Boxes={}
spawn(function()
    RunService.RenderStepped:Connect(function()
        if not S.ESP then
            for _,v in pairs(ESP_Boxes) do if v.Box then v.Box:Destroy() end end
            ESP_Boxes={}
            return
        end
        for _,player in pairs(Players:GetPlayers()) do
            if player~=LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not ESP_Boxes[player] then
                    local box=Instance.new("BoxHandleAdornment")
                    box.Adornee=player.Character.HumanoidRootPart
                    box.AlwaysOnTop=true
                    box.ZIndex=10
                    box.Size=Vector3.new(2,5,1)
                    box.Color3=Color3.fromRGB(255,0,0)
                    box.Parent=workspace.CurrentCamera
                    ESP_Boxes[player]={Box=box}
                else
                    ESP_Boxes[player].Box.Adornee=player.Character.HumanoidRootPart
                end
            end
        end
    end)
end)
