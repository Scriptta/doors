local CustomTexture

if not isfile('BobPlush.jfif') then
    writefile(
        'BobPlush.jfif',
        game:HttpGetAsync('https://github.com/Scriptta/images/blob/main/thebobplush.jfif?raw=true')
    )
end

CustomTexture = getcustomasset('BobPlush.jfif')

local player = game.Players.LocalPlayer
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local FOVConnection

local Plushie = Instance.new('Tool')
Plushie.Parent = player.Backpack
Plushie.Name = 'Bobby'
Plushie.TextureId = CustomTexture
Plushie.GripPos = Vector3.new(-.75, -1, 0)
Plushie.Grip *= CFrame.Angles(0, math.rad(190), 0)

local PlushModel = game:GetObjects('rbxassetid://16628629918')[1]
PlushModel.Parent = Plushie
PlushModel.Name = 'Handle'
PlushModel.Massless = true
PlushModel.Size *= 1.5

local OldPlushSize = PlushModel.Size

local Squeak = Instance.new('Sound')
Squeak.SoundId = 'rbxassetid://6737208080'
Squeak.Volume = 0.75
Squeak.Parent = PlushModel


local AnimationFolder = Instance.new('Folder')
AnimationFolder.Name = 'Animations'
AnimationFolder.Parent = Plushie

local idle = Instance.new('Animation')
idle.Name = 'idle'
idle.Parent = AnimationFolder
idle.AnimationId = 'rbxassetid://6516424098'

local oldBoost = 30
local targetBoost = oldBoost

Plushie.Activated:Connect(function()
    Squeak:Play()
    TweenService:Create(PlushModel, TweenInfo.new(
        .2,
        Enum.EasingStyle.Quart
    ), {Size = PlushModel.Size * 1.25}):Play()
    targetBoost = 50
end)

Plushie.Deactivated:Connect(function()
    targetBoost = oldBoost

    TweenService:Create(PlushModel, TweenInfo.new(
        .2,
        Enum.EasingStyle.Quart
    ), {Size = OldPlushSize}):Play()
end)

Plushie.Equipped:Connect(function()
    local FOV = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(.5, Enum.EasingStyle.Quart), {FieldOfView = 120})
    FOV:Play()
    FOV.Completed:Connect(function()
        FOVConnection = RunService.RenderStepped:Connect(function()
            workspace.CurrentCamera.FieldOfView = 120
        end)
    end)
end)

Plushie.Unequipped:Connect(function()
    TweenService:Create(workspace.CurrentCamera, TweenInfo.new(.5, Enum.EasingStyle.Quart), {FieldOfView = 70}):Play()
    FOVConnection:Disconnect()
end)

local CollisionCrouch; do
    CollisionCrouch = player.Character.Collision.CollisionCrouch
end

local Collision; do
    Collision = player.Character.Collision or CollisionCrouch.Parent
end

local Humanoid; do
    Humanoid = player.Character.Humanoid
end

local RootPart; do
    RootPart = Humanoid.RootPart
end

local OldCAccel, OldCCAccel, OldRAccel =
    Collision.CustomPhysicalProperties,
    CollisionCrouch.CustomPhysicalProperties,
    RootPart.CustomPhysicalProperties

function setPhysicalProperties(Properties : PhysicalProperties)
    do
        Collision.CustomPhysicalProperties = Properties
        CollisionCrouch.CustomPhysicalProperties = Properties
        RootPart.CustomPhysicalProperties = Properties
    end
end

local Timer = tick()

game:GetService('RunService'):BindToRenderStep('BobEffects', 999, function()
    Humanoid = player.Character.Humanoid
    CollisionCrouch = player.Character.Collision.CollisionCrouch
    Collision = player.Character.Collision or CollisionCrouch.Parent
    RootPart = Humanoid.RootPart

    if Plushie.Parent == player.Character then
        if (tick() - Timer) >= .2 then

            setPhysicalProperties(
                PhysicalProperties.new(100, 0, 0, 0, 0)
            )
            Humanoid:SetAttribute('SpeedBoostBehind', targetBoost)

            CollisionCrouch.Massless = true
            Collision.Massless = not Collision.Massless
            Timer = tick()
        end
    else
        CollisionCrouch.CustomPhysicalProperties = OldCCAccel
        Collision.CustomPhysicalProperties = OldCAccel
        RootPart.CustomPhysicalProperties = OldRAccel
        Collision.Massless = false
        CollisionCrouch.Massless = false
        Humanoid:SetAttribute('SpeedBoostBehind', 0)
        Timer = tick()
    end
end)
