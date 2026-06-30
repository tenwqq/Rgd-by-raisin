local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TWKS_RGD"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 220)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "RGD Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, 0, 1, -40)
Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = Frame

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 8)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Container

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.Parent = Container

local flags = {
    KillAura = false,
    Fullbright = false,
    InfJump = false
}

local defaultAmbient = Lighting.Ambient
local defaultOutdoor = Lighting.OutdoorAmbient
local defaultBrightness = Lighting.Brightness

local function createToggle(name, layoutOrder, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 180, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 90, 90)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 16
    Button.LayoutOrder = layoutOrder
    Button.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        flags[name] = state
        if state then
            Button.Text = name .. ": ON"
            Button.TextColor3 = Color3.fromRGB(90, 255, 90)
            Button.BackgroundColor3 = Color3.fromRGB(55, 75, 55)
        else
            Button.Text = name .. ": OFF"
            Button.TextColor3 = Color3.fromRGB(255, 90, 90)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
        callback(state)
    end)
end

createToggle("KillAura", 1, function(state) end)

createToggle("Fullbright", 2, function(state)
    if state then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = defaultAmbient
        Lighting.OutdoorAmbient = defaultOutdoor
        Lighting.Brightness = defaultBrightness
    end
end)

createToggle("InfJump", 3, function(state) end)

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
