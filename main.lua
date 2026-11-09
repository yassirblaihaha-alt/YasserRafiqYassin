local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local Speed = 80
local MaxSpeed = 500

local RunSpeed = 16
local MaxRunSpeed = 200

local Flying = false
local Noclip = false
local Minimized = false

local Keys = {}
local OriginalCollision = {}

local Velocity, Attachment, Align
local Connection, NoclipConnection

local NormalSize = UDim2.fromOffset(230, 260)

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "YasserRafiqYassin"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = NormalSize
Frame.Position = UDim2.new(0, 30, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = Gui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(55, 55, 55)
Stroke.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 38)
Title.BackgroundTransparency = 1
Title.Text = "Yasser Rafiq Yassin"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = Frame

-- Create Button
local function CreateButton(Text, X, Y, Width, Height)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(Width or 40, Height or 30)
    Button.Position = UDim2.fromOffset(X, Y)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Text = Text
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 16
    Button.Parent = Frame

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    return Button
end

-- Minimize Button
local MinimizeButton = CreateButton("-", 5, 5, 28, 28)
MinimizeButton.ZIndex = 5
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local function SetMinimized(State)
    Minimized = State

    for _, Object in ipairs(Frame:GetChildren()) do
        if Object:IsA("GuiObject")
        and Object ~= MinimizeButton then
            Object.Visible = not Minimized
        end
    end

    if Minimized then
        Frame.Size = UDim2.fromOffset(40, 40)
        Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        MinimizeButton.Size = UDim2.fromOffset(30, 30)
        MinimizeButton.Position = UDim2.fromOffset(5, 5)
        MinimizeButton.Text = "+"
    else
        Frame.Size = NormalSize
        Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        MinimizeButton.Size = UDim2.fromOffset(28, 28)
        MinimizeButton.Position = UDim2.fromOffset(5, 5)
        MinimizeButton.Text = "-"
    end
end

MinimizeButton.MouseButton1Click:Connect(function()
    SetMinimized(not Minimized)
end)

-- Dragging
local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Frame.Position
    end
end)

UIS.InputChanged:Connect(function(Input)
    if Dragging and (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) then

        local Delta = Input.Position - DragStart

        Frame.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

-- Fly Button
local FlyButton = CreateButton("FLY: OFF", 10, 45, 210, 38)

-- Fly Speed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.fromOffset(125, 30)
SpeedLabel.Position = UDim2.fromOffset(10, 90)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "FLY SPEED: 80"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 12
SpeedLabel.Parent = Frame

local Minus = CreateButton("-", 145, 90, 35)
local Plus = CreateButton("+", 190, 90, 30)

Minus.MouseButton1Click:Connect(function()
    Speed = math.max(10, Speed - 10)
    SpeedLabel.Text = "FLY SPEED: " .. Speed
end)

Plus.MouseButton1Click:Connect(function()
    Speed = math.min(MaxSpeed, Speed + 10)
    SpeedLabel.Text = "FLY SPEED: " .. Speed
end)

-- Noclip Button
local NoclipButton = CreateButton("NOCLIP: OFF", 10, 130, 210)

-- Run Speed
local RunLabel = Instance.new("TextLabel")
RunLabel.Size = UDim2.fromOffset(125, 30)
RunLabel.Position = UDim2.fromOffset(10, 175)
RunLabel.BackgroundTransparency = 1
RunLabel.Text = "RUN SPEED: 16"
RunLabel.TextColor3 = Color3.new(1, 1, 1)
RunLabel.Font = Enum.Font.GothamBold
RunLabel.TextSize = 12
RunLabel.Parent = Frame

local RunMinus = CreateButton("-", 145, 175, 35)
local RunPlus = CreateButton("+", 190, 175, 30)

-- Apply Run Speed
local function ApplyRunSpeed()
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.WalkSpeed = RunSpeed
    end
end

RunMinus.MouseButton1Click:Connect(function()
    RunSpeed = math.max(16, RunSpeed - 5)
    RunLabel.Text = "RUN SPEED: " .. RunSpeed
    ApplyRunSpeed()
end)

RunPlus.MouseButton1Click:Connect(function()
    RunSpeed = math.min(MaxRunSpeed, RunSpeed + 5)
    RunLabel.Text = "RUN SPEED: " .. RunSpeed
    ApplyRunSpeed()
end)

-- Noclip
local function RestoreCollision()
    for Part, OriginalValue in pairs(OriginalCollision) do
        if Part and Part.Parent then
            Part.CanCollide = OriginalValue
        end
    end

    table.clear(OriginalCollision)
end

local function SetNoclip(State)
    Noclip = State

    NoclipButton.Text = Noclip and "NOCLIP: ON" or "NOCLIP: OFF"

    NoclipButton.BackgroundColor3 = Noclip
        and Color3.fromRGB(20, 140, 65)
        or Color3.fromRGB(40, 40, 40)

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    if Noclip then
        NoclipConnection = RunService.Stepped:Connect(function()
            local Character = Player.Character
            if not Character then return end

            for _, Part in ipairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    if OriginalCollision[Part] == nil then
                        OriginalCollision[Part] = Part.CanCollide
                    end

                    Part.CanCollide = false
                end
            end
        end)
    else
        RestoreCollision()
    end
end

NoclipButton.MouseButton1Click:Connect(function()
    SetNoclip(not Noclip)
end)

-- Keyboard
UIS.InputBegan:Connect(function(Input, Processed)
    if not Processed then
        Keys[Input.KeyCode] = true
    end
end)

UIS.InputEnded:Connect(function(Input)
    Keys[Input.KeyCode] = false
end)

-- Stop Flying
local function StopFlying()
    Flying = false

    if Connection then
        Connection:Disconnect()
        Connection = nil
    end

    if Velocity then
        Velocity:Destroy()
        Velocity = nil
    end

    if Align then
        Align:Destroy()
        Align = nil
    end

    if Attachment then
        Attachment:Destroy()
        Attachment = nil
    end

    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.PlatformStand = false
        Humanoid.AutoRotate = true
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    FlyButton.Text = "FLY: OFF"
    FlyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end

-- Start Flying
local function StartFlying()
    local Character = Player.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not Root or not Humanoid or Flying then
        return
    end

    Flying = true

    Humanoid.PlatformStand = true
    Humanoid.AutoRotate = false

    Attachment = Instance.new("Attachment")
    Attachment.Parent = Root

    Velocity = Instance.new("LinearVelocity")
    Velocity.Attachment0 = Attachment
    Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    Velocity.MaxForce = 1000000
    Velocity.VectorVelocity = Vector3.zero
    Velocity.Parent = Root

    Align = Instance.new("AlignOrientation")
    Align.Attachment0 = Attachment
    Align.Mode = Enum.OrientationAlignmentMode.OneAttachment
    Align.MaxTorque = 1000000
    Align.Responsiveness = 15
    Align.Parent = Root

    Connection = RunService.Heartbeat:Connect(function()
        if not Root.Parent or not Humanoid.Parent then
            StopFlying()
            return
        end

        local Camera = workspace.CurrentCamera
        if not Camera then return end

        local Direction = Vector3.zero

        if Keys[Enum.KeyCode.W] then
            Direction += Camera.CFrame.LookVector
        end

        if Keys[Enum.KeyCode.S] then
            Direction -= Camera.CFrame.LookVector
        end

        if Keys[Enum.KeyCode.A] then
            Direction -= Camera.CFrame.RightVector
        end

        if Keys[Enum.KeyCode.D] then
            Direction += Camera.CFrame.RightVector
        end

        if Keys[Enum.KeyCode.Space] then
            Direction += Vector3.yAxis
        end

        if Keys[Enum.KeyCode.LeftControl] then
            Direction -= Vector3.yAxis
        end

        if Direction.Magnitude > 0 then
            Velocity.VectorVelocity = Direction.Unit * Speed
        else
            Velocity.VectorVelocity = Vector3.zero
        end

        Align.CFrame = CFrame.lookAt(
            Root.Position,
            Root.Position + Camera.CFrame.LookVector
        )
    end)

    FlyButton.Text = "FLY: ON"
    FlyButton.BackgroundColor3 = Color3.fromRGB(20, 140, 65)
end

FlyButton.MouseButton1Click:Connect(function()
    if Flying then
        StopFlying()
    else
        StartFlying()
    end
end)

-- Character Respawn
Player.CharacterAdded:Connect(function()
    if Flying then
        StopFlying()
    end

    RestoreCollision()

    task.wait(0.5)
    ApplyRunSpeed()

    if Noclip then
        SetNoclip(true)
    end
end)
