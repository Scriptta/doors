-- im doors 🤓
-- cv is two cool loking letters no real meaning
-- 435345242533452325423454235gfdsdfgdsgfgsdf

--[[
    todo:
    fly
    anti eyes
    anti seek
    anti screech
    ignore this
]]
warn'hello'
repeat task.wait() until game:IsLoaded()
warn'hola'

local notificationSound = Instance.new'Sound'
notificationSound.SoundId = 'rbxassetid://4590657391'
notificationSound.Volume = 2
notificationSound.Parent = game.Players.LocalPlayer.PlayerGui

local players = game:GetService'Players'
local replicatedStorage = game:GetService'ReplicatedStorage'
local camera = workspace.CurrentCamera
local runService = game:GetService'RunService'
local gameData = replicatedStorage.GameData
local remoteFolder = replicatedStorage.RemotesFolder
local latestRoom = gameData.LatestRoom
local player = players.LocalPlayer
local character
character = player.Character

local rep = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local lib =   loadstring(game:HttpGet(rep.. 'Library.lua'))()
local save =  loadstring(game:HttpGet(rep.. 'addons/SaveManager.lua'))()
local theme = loadstring(game:HttpGet(rep.. 'addons/ThemeManager.lua'))()

local Options = getgenv().Options

local window = lib:CreateWindow({
    Title = 'door script beta v1!!!1',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- settings up stuff

lib.KeybindFrame.Visible = true

local flags = {
    speed = false,
    noclip = false,
    ncpbypass = false,
    clipPrompts = false,
    auraPrompts = false,
    fly = false,
    esp = false,
    tracers = false,
    fov = false
}

local values = {
    speedV = 5,
    fieldOfView = 120
}

local speedMethod

local espColors = {
    [1] = Color3.fromRGB(255, 255, 0),
    [2] = Color3.fromRGB(0, 255, 255),
    [3] = Color3.fromRGB(255, 0, 0),
    [4] = Color3.fromRGB(124, 124, 124)
}

function notify(text, title)
    lib:Notify(text, title)
    notificationSound:Play()
end

function firep(prompt)
    if prompt:IsA'ProximityPrompt' then
        fireproximityprompt(prompt, 1)
    end
end

function espAttempt(object, typea, text)
    if not flags.esp then return end
    assert(typea == ('item') or typea == ('roomAsset') or typea == ('entity'), 'type was not provided: '..text)

    local room = latestRoom.Value
    local part; do
        local p, e = pcall(function()
            return object.PrimaryPart
        end)
        if p then
            part = object.PrimaryPart
        else
            part = object
        end
    end

    local color; do
        if typea == 'item' then
            notify(text..' spawned')
            color = espColors[1]
        elseif typea == 'roomAsset' then
            color = espColors[2]
        elseif typea == 'entity' then
            notify(text .. ' has spawned')
            color = espColors[3]
        else
            color = Color3.fromRGB(124, 124, 124)
        end
    end
    local highlight = Instance.new'Highlight'; do
        highlight.Parent = part
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = color
        highlight.OutlineColor = color
    end

    local billboard = Instance.new'BillboardGui'; do
        billboard.Adornee = part
        billboard.Parent = part
        billboard.Name = 'zzzzz :yawn:'
        if typea == 'roomAsset' or typea == 'entity' then
            billboard.Size = UDim2.new(8, 0, 2, 0)
        else
            billboard.Size = UDim2.new(6, 0, 1, 0)
        end
    end
    

    local label = Instance.new'TextLabel'; do
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = text or part.Name
        label.Font = Enum.Font.Oswald
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.TextColor3 = color
        label.TextStrokeColor3 = Color3.new()
        label.TextStrokeTransparency = 0
        label.Parent = billboard
    end


    billboard.AlwaysOnTop = true

    latestRoom:GetPropertyChangedSignal('Value'):Connect(function()
        highlight:Destroy()
        billboard:Destroy()
        label:Destroy()
    end)
end

notify('creating tabs..', 'hi')

local general, exploits = window:AddTab'general', window:AddTab'exploits'
local group = {
    left = general:AddLeftGroupbox'speed',
    right = general:AddRightGroupbox'fov',
    esp = general:AddRightGroupbox'esp',
    left2 = exploits:AddLeftGroupbox'noclip',
    right2 = exploits:AddRightGroupbox'bypasses',
    prompts = exploits:AddLeftGroupbox'prompts'
}
-- speeeeedd
notify('speed', 'hi')
group.left:AddToggle('cv1', {
    Text = 'speedhax',
    Default = flags.speed,
    Tooltip = 'makes u fast',
    Callback = function(v)
        flags.speed = v
    end
})

group.left:AddSlider('cv2', {
    Text = 'Speed',
    Default = 7,
    Min = 0,
    Max = 7,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        values.speedV = v
    end
})

group.left:AddDropdown('cv3', {
    Values = {'boost', 'walkspeed'},
    Text = 'speed method',
    Default = 'boost',
    Multi = false,
    Tooltip = 'what method to use for speed',
    Callback = function(v)
        speedMethod = v
    end
})
-- field of view
notify('fov', 'a')
group.right:AddToggle('cv4', {
    Text = 'FOV',
    Default = false,
    Tooltip = 'changes fov',
    Callback = function(v)
        flags.fov = v
    end
})

group.right:AddSlider('cv5', {
    Text = 'FOV',
    Default = 120,
    Min = 70,
    Max = 120,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        warn(v)
        values.fieldOfView = v
    end
})

-- noclip
notify('noclip', 'b')
local oldValues = {}
for i, cv1 in character:GetDescendants() do
    pcall(function()
        oldValues[cv1.Name] = cv1.CanCollide
    end)
end

group.left2:AddLabel('noclip - N'):AddKeyPicker('cv6', {
    Default = 'N',
    NoUI = false,
    Text = 'noclip',
    Callback = function(v)
        flags.noclip = v
        if flags.noclip then
            task.spawn(function()
                while flags.noclip do task.wait()
                    for i, cv1 in character:GetDescendants() do
                        pcall(function()
                            cv1.CanCollide = false
                        end)
                    end
                end
            end)
        else
            for i, cv1 in character:GetDescendants() do
                pcall(function()
                    cv1.CanCollide = oldValues[cv1.Name] or true
                end)
            end
        end
    end
})
group.right2:AddLabel('noclip bypassed - B'):AddKeyPicker('cv7', {
    Default = 'B',
    NoUI = false,
    Text = 'bypasses noclip',
    Callback = function(v)
        if v then
            character:WaitForChild'Collision'.Weld.C0 = CFrame.new(-8, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
            character:WaitForChild'Collision'.CanCollide = false
            character:TranslateBy(Vector3.new(0, 8, 0))
        else
            character:WaitForChild'Collision'.Weld.C0 = CFrame.new() * CFrame.Angles(0, 0, math.rad(90))
            character:WaitForChild'Collision'.CanCollide = true
            character:TranslateBy(Vector3.new(0, 8, 0))
        end
    end
})
-- prompts
notify('prompts')
group.prompts:AddLabel('toggle aura prompts - R' ):AddKeyPicker('cv12', {
    Default = 'R',
    NoUI = false,
    Text = 'auras prompts',

    Callback = function(v)
        flags.auraPrompts = v
    end
})

group.prompts:AddToggle('cv13', {
    Text = 'prompt clip',
    Tooltip = 'allows prompts to be used through objects',
    Default = false,
    Callback = function(v)
        flags.clipPrompts = v
    end
})

-- esp
notify('esp', 'dd')

local promptsToAura = {}

local auraPrompts = {
    'ActivateEventPrompt',
    'HerbPrompt',
    'LootPrompt',
    'ModulePrompt'
}

local clipPrompts = {
    'HerbPrompt',
    'HidePrompt',
    'LootPrompt',
    'ModulePrompt',
    'SkullPrompt',
    'UnlockPrompt',
    'Prompt'
}

function roomAdded(newRoom)
    local room = workspace.CurrentRooms[latestRoom.Value]
    local assets = room:WaitForChild'Assets'

    local function descendants(v)
        if v:IsA'ProximityPrompt' then
            v.MaxActivationDistance = 100
            print('prompt: ' .. v.Name)
            if table.find(clipPrompts, v.Name) then
                warn('Found clip prompt' .. v.Name)
                v.RequiresLineOfSight = false
            elseif table.find(auraPrompts, v.Name) then
                warn('Found aura prompt' .. v.Name)
                task.spawn(function()
                    if flags.auraPrompts then
                        repeat
                            if v:IsA'ProximityPrompt' then
                                local interaction = 'Interactions'..player.Name
                                if v:GetAttribute(interaction) then return end
                                firep(v)
                            end
                            task.wait()
                        until v.Parent == nil
                    end
                end)
                table.insert(promptsToAura, v)
            end
        end

        task.spawn(function()
            if v.Name == 'Key' then
                espAttempt(v:FindFirstAncestor'KeyObtain', 'item', 'Key')
            elseif v.Name == 'LiveHintBook' then
                espAttempt(v, 'item', 'Book')
            elseif v.Name == 'FigureRagdoll' then
                notify('figure spawned')
                espAttempt(v, 'entity', 'Figure')
            elseif v.Name == 'Snare' then
                espAttempt(v, 'entity', 'Snare')
            elseif v.Name == 'LiveBreakerPolePickup' then
                espAttempt(v, 'item', 'Breaker')
            elseif v.Name == 'GoldPile' then
                espAttempt(v, 'item', 'Gold')
            end
        end)
    end

    for i,v in room:GetDescendants() do
        descendants(v)
    end

    room.DescendantAdded:Connect(descendants)

    if flags.esp then
        for i,v in assets:GetChildren() do
            if v.Name == 'Wardrobe' then
                espAttempt(v, 'roomAsset', 'wardrobe')
            end
        end
        espAttempt(room.Door.Door, 'roomAsset', 'Door')
    end
end

roomAdded()

workspace.CurrentRooms.ChildAdded:Connect(roomAdded)

group.esp:AddToggle('cv8', {
    Text = 'esp',
    Default = false,
    Tooltip = 'see through walls kinda stuff',
    Callback = function(v)
        flags.esp = v
        if v then
            roomAdded()
        end
    end
})

group.esp:AddLabel('Item color'):AddColorPicker('cv9', {
    Title = 'item color',
    Default = espColors[1],
    Callback = function(v)
        espColors[1] = v
    end
})

group.esp:AddLabel('Asset color'):AddColorPicker('cv10', {
    Title = 'door and wardrobe color',
    Default = espColors[2],
    Callback = function(v)
        espColors[2] = v
    end
})

group.esp:AddLabel('Entity color'):AddColorPicker('cv11', {
    Title = 'entity color',
    Default = espColors[3],
    Callback = function(v)
        espColors[3] = v
    end
})

-- connections
local frame = {
    Counter = 0,
    Timer = tick()
}
local fps = 0

local watermarkConnection = runService.RenderStepped:Connect(function(deltaTime)
    frame.Counter += 1
    
    if (tick() - frame.Timer) >= 1 then
        frame.Timer = tick()
        fps = frame.Counter
        frame.Counter = 0
    end
    local watermark = ('door scriptbeta!!1 | %s fps'):format(math.floor(fps))

    lib:SetWatermark(watermark)
end)

-- mainscript

runService.RenderStepped:Connect(function()
    character = player.Character
    task.spawn(function()
        if flags.speed then -- speed
            if speedMethod == 'walkspeed' then
                character.Humanoid.WalkSpeed = 15 + values.speedV
            elseif speedMethod == 'boost' then
                character.Humanoid:SetAttribute('SpeedBoostBehind', values.speedV)
            end
        end
    end)

    task.spawn(function()
        if flags.fov then
            camera.FieldOfView = values.fieldOfView
        else
            camera.FieldOfView = 70
        end
    end)
end)

-- finishing up

lib.ToggleKeybind = Options.MenuKeybind

local configuration = window:AddTab'config'
local extra = configuration:AddLeftGroupbox'extra'

extra:AddLabel('menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'RightShift',
    NoUI = false,
    Text = 'key to open menu'
})

notify('finished loading!!!', 'dddd')

do
    theme:SetLibrary(lib)
    save:SetLibrary(lib)
    save:IgnoreThemeSettings()
    save:SetIgnoreIndexes({ 'MenuKeybind' })
    theme:SetFolder('baa')
    save:SetFolder('baa/doors')
    save:BuildConfigSection(configuration)
    theme:ApplyToTab(configuration)
    theme:LoadAutoloadConfig()
end
