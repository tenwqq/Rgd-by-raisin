local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RGD Menu | TWKS",
   LoadingTitle = "TWKS Automation",
   LoadingSubtitle = "by Raisin",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", nil)

local flags = {
    KillAura = false,
    Fullbright = false,
    InfJump = false
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local defaultAmbient = Lighting.Ambient
local defaultOutdoor = Lighting.OutdoorAmbient
local defaultBrightness = Lighting.Brightness

MainTab:CreateToggle({
   Name = "KillAura",
   CurrentValue = false,
   Callback = function(Value)
      flags.KillAura = Value
   end,
})

MainTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Callback = function(Value)
      flags.Fullbright = Value
      if Value then
          Lighting.Ambient = Color3.fromRGB(255, 255, 255)
          Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
          Lighting.Brightness = 2
      else
          Lighting.Ambient = defaultAmbient
          Lighting.OutdoorAmbient = defaultOutdoor
          Lighting.Brightness = defaultBrightness
      end
   end,
})

MainTab:CreateToggle({
   Name = "InfJump",
   CurrentValue = false,
   Callback = function(Value)
      flags.InfJump = Value
   end,
})

task.spawn(function()
    while task.wait(0.1) do
        if flags.KillAura and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("RemoteClick") then
                for _, folder in ipairs(Workspace:GetChildren()) do
                    if folder:IsA("Folder") and (folder.Name:find("Room") or folder.Name:find("generated")) then
                        for _, enemy in ipairs(folder:GetDescendants()) do
                            if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                                local distance = LocalPlayer:DistanceFromCharacter(enemy.HumanoidRootPart.Position)
                                if distance <= 18 and enemy:FindFirstChildOfClass("Humanoid").Health > 0 then
                                    tool.RemoteClick:FireServer(enemy.HumanoidRootPart.Position, enemy)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if flags.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
   
        end
end)
