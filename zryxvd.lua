-- LOAD LIB
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
-- =======================================
WindUI:AddTheme({
    Name = "Dark",

    Accent = Color3.fromHex("#0091FF"),
    Dialog = Color3.fromHex("#1a1a1a"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#a1a1a1"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
    Toggle = Color3.fromHex("#33C759"),
    Slider = Color3.fromHex("#0091FF"),
    Checkbox = Color3.fromHex("#0091FF"),

    PanelBackground = Color3.fromHex("#FFFFFF"),
    PanelBackgroundTransparency = 0.95,

    SliderIcon = Color3.fromHex("#908F95"),
    Primary = Color3.fromHex("#0091FF"),

    LabelBackground = Color3.fromHex("#000000"),
    LabelBackgroundTransparency = 0.83,

    ElementBackground = Color3.fromHex("#2A2A2C"),
    ElementBackgroundTransparency = 0,

    TabBackground = Color3.fromHex("#101010"),
    TabBackgroundHover = Color3.fromHex("#26262A"),
    TabBackgroundHoverTransparency = 0,
    TabBackgroundActive = Color3.fromHex("#26262A"),
    TabBackgroundActiveTransparency = 0,
    TabText = Color3.fromHex("#FFFFFF"),
    TabTextTransparency = 0,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#FFFFFF"),
    TabIcon = Color3.fromHex("#a1a1aa"),
    TabIconTransparency = 0,
    TabIconTransparencyActive = 0,
    TabBorderTransparency = 1,

    DropdownTabBackground = Color3.fromHex("#232327"),
    DropdownBackground = Color3.fromHex("#1B1B1F"),
})
-- =======================================
-- WINDOW
local UserInputService = game:GetService("UserInputService")
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local ok, err = pcall(function()
    WindUI.Creator:AddIcons("zryx", { Logo = "rbxassetid://126755028963880" })
end)
if not ok then
    warn("[zryx] failed to register logo icon: " .. tostring(err))
end

local Window = WindUI:CreateWindow({
    Title   = "zryx",
    Author  = "Violence District - Freemium",
    Folder  = "zryx",
    Icon    = "zap",
    Theme   = "Dark",
    Acrylic = true,
    Transparent = true,
    Background = "rbxassetid://84152360484913",
    Size    = IsMobile and UDim2.fromOffset(600, 440) or UDim2.fromOffset(680, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    ToggleKey  = Enum.KeyCode.RightShift,
    Resizable  = true,
    AutoScale  = true,
    NewElements = true,
    BackgroundImageTransparency = 0.65,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    SideBarWidth = 200,
    Topbar = {
        Height      = 44,
        ButtonsType = "Default",
    },
    OpenButton = {
        Title = "zryx",
        Icon = "zryx:Logo",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = IsMobile and 1.35 or 1,
        Color = ColorSequence.new(
            Color3.fromHex("#000000"),
            Color3.fromHex("#000000")
        ),
    },
    User = {
        Enabled  = true,
        Anonymous = false,
        Callback = function()
            print("user panel clicked")
        end,
    },
})

local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

Window:SetUIScale(IsMobile and 1 or 0.85)

-- Custom watermark (WindUI has no draggable label)
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "ZryxWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WatermarkGui.Parent = game:GetService("CoreGui")

local WatermarkLabel = Instance.new("TextLabel")
WatermarkLabel.Size = UDim2.fromOffset(240, 26)
WatermarkLabel.Position = UDim2.new(0.5, -120, 0, 12)
WatermarkLabel.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
WatermarkLabel.BackgroundTransparency = 0.2
WatermarkLabel.Text = "zryx"
WatermarkLabel.TextColor3 = Color3.fromRGB(200, 215, 255)
WatermarkLabel.TextSize = 14
WatermarkLabel.Font = Enum.Font.GothamBold
local WmCorner = Instance.new("UICorner")
WmCorner.CornerRadius = UDim.new(1, 0)
WmCorner.Parent = WatermarkLabel
WatermarkLabel.Parent = WatermarkGui

local Watermark = {
    Visible = true,
    SetText = function(self, text)
        WatermarkLabel.Text = text
    end,
}
setmetatable(Watermark, {
    __newindex = function(self, key, value)
        rawset(self, key, value)
        if key == "Visible" then
            WatermarkLabel.Visible = value
        end
    end,
})

local FPS = 0
local Frames = 0
local LastTick = tick()

RunService.RenderStepped:Connect(function()
    Frames += 1

    if tick() - LastTick >= 1 then
        FPS = Frames
        Frames = 0
        LastTick = tick()

        local Ping = math.floor(
            Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        )

        Watermark:SetText(
            string.format(
                "zryx | FPS: %d | PING: %d ms",
                FPS,
                Ping
            )
        )
    end
end)

-- TABS
local Tabs = {}
Tabs.Info = Window:Tab({ Title = "Info" })
Tabs.ESP = Window:Tab({ Title = "ESP" })

local PlayerSection = Window:Section({ Title = "Player", Opened = true })
Tabs.Survivor = PlayerSection:Tab({ Title = "Survivor" })
Tabs.Killer = PlayerSection:Tab({ Title = "Killer" })
Tabs.AimBot = PlayerSection:Tab({ Title = "AimBot" })
Tabs.Parry = PlayerSection:Tab({ Title = "Parry" })
Tabs.Crosshair = PlayerSection:Tab({ Title = "Crosshair" })

local MiscSection = Window:Section({ Title = "Misc", Opened = true })
Tabs.Movement = MiscSection:Tab({ Title = "Movement" })

Tabs.Visual = Window:Tab({ Title = "Visual" })
Tabs.UISettings = Window:Tab({ Title = "UI Settings" })

-- SECTIONS (in-tab collapsible boxes)
local InfoBox = Tabs.Info:Section({ Title = "Script Info", Opened = true })
local CreditsBox = Tabs.Info:Section({ Title = "Credits", Opened = true })
local ESPBox = Tabs.ESP:Section({ Title = "ESP Cham", Opened = true })
local ESPStatusBox = Tabs.ESP:Section({ Title = "ESP Status", Opened = true })
local AbilityTab = Tabs.Survivor
local KillerTab = Tabs.Killer
local AimlockBox = Tabs.AimBot:Section({ Title = "AimBot", Opened = true })
local ParryBox = Tabs.Parry:Section({ Title = "Parry", Opened = true })
local CrosshairBox = Tabs.Crosshair:Section({ Title = "Crosshair", Opened = true })
local MovementBox = Tabs.Movement:Section({ Title = "Movement", Opened = true })
local VisualBox = Tabs.Visual:Section({ Title = "Graphics", Opened = true })
local MorphAvaBox = Tabs.Visual:Section({ Title = "Morph Avatar", Opened = true })
local TimeBox = Tabs.Visual:Section({ Title = "Clock & Ambient", Opened = true })
local ZoomBox = Tabs.Visual:Section({ Title = "Zoom Out", Opened = true })
local SettingBox = Tabs.UISettings:Section({ Title = "Menu", Opened = true })

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local CarryEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("CarrySurvivorEvent")
local HookEvent  = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("HookEvent")
local AttackEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")
local SkillCheckRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("Generator")
    :WaitForChild("SkillCheckResultEvent")

-- ============== CONFIG =================

local ESP = {
Survivor = false,
Killer = false,
Generator = false,
Pallet = false,
Window = false,
SCP = false
}

local ESPStatus = {
Enabled = false,
ShowName = true,
ShowDistance = true,
ShowHealth = false
}

local TeamColors = {
Killer = Color3.fromRGB(255, 60, 60),      -- merah
Survivor = Color3.fromRGB(60, 255, 120)    -- hijau
}

local Auto = {
    SkillCheck = false,
    Parry = false,
    ParryDelay = 0,
    ParryCooldown = 1,
    ParryDistance = 15,
    FaceSensitivity = 0.7,
    RequireFacing = true
}

local GunAim = {
    Enabled = false,
    Holding = false,
    TargetMode = "All",
    Strength = 1,
    Predict = true,
    PredictStrength = 0.12,
    FOV = 250,
    VisibilityCheck = true,
    Target = nil,
    AimPart = "HumanoidRootPart",
    ShowFOVCircle = false
}

local Killer = {
    AutoCarry = false,
    KillRange = 500,
    AttackDelay = 0.45
}

local KillerBusy = false
local ParryActive = false

local Masked = {
    Enabled = false,
    CurrentPower = "Cobra"
}

local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

-- ========== IMPROVED MOONWALK CONFIG ==========
local Moonwalk = {
    Enabled = false,
    Style = "Sway",              -- "Sway", "Slide", "HipShake"
    Speed = 15,                  -- Rotation speed (lower = slower, smoother)
    Intensity = 25,              -- Rotation amplitude in degrees
    Smoothness = 0.25,           -- Interpolation smoothness (lower = smoother)
    MovementSpeed = 12,          -- Walk speed when moving
    UseSlow = true,
    
    -- Style configs
    Styles = {
        Sway = {
            Speed = 15,
            Intensity = 25,
            Smoothness = 0.25,
            Description = "Smooth side-to-side sway"
        },
        Slide = {
            Speed = 12,
            Intensity = 20,
            Smoothness = 0.2,
            Description = "Subtle sliding motion"
        },
        HipShake = {
            Speed = 20,
            Intensity = 30,
            Smoothness = 0.3,
            Description = "Exaggerated hip shake"
        }
    }
}

local MoonwalkPhase = 0          -- Smooth phase tracker
local MoonwalkSmoothYaw = 0      -- Camera-relative yaw

-- ============== CONFIG =================

local CameraZoom = {
    UnlimitedZoom = false,
    MaxDistance = 1000,
    MinDistance = 0,

    FOVEnabled = false,
    FOV = 70,
    DefaultFOV = workspace.CurrentCamera.FieldOfView
}

local AutoStalk = {
    Enabled = false,
    StalkRange = 150,
    Target = nil
}

local KillerAnims = {
["rbxassetid://105374834496520"] = true,
["rbxassetid://113255068724446"] = true,
["rbxassetid://118907603246885"] = true,
["rbxassetid://129784271201071"] = true,
["rbxassetid://117042998468241"] = true,
["rbxassetid://122812055447896"] = true,
["rbxassetid://78935059863801"] = true,
["rbxassetid://74968262036854"] = true,
["rbxassetid://78432063483146"] = true,
["rbxassetid://132817836308238"] = true,
["rbxassetid://133963973694098"] = true,
["rbxassetid://111920872708571"] = true,
["rbxassetid://80411309607666"] = true,
["rbxassetid://98163597193511"] = true,
["rbxassetid://82666958311998"] = true,
["rbxassetid://110355011987939"] = true,
["rbxassetid://139369275981139"] = true,
["rbxassetid://135002183282873"] = true,
["rbxassetid://121216847022485"] = true,
["rbxassetid://130593238885843"] = true,
["rbxassetid://117070354890871"] = true,
["rbxassetid://106871536134254"] = true,
["rbxassetid://138720291317243"] = true
}

local ParryRangeVisual = {
Enabled = false,
Color = Color3.fromRGB(255, 80, 80),
Transparency = 0.9
}

local ParryCircle = nil

local PlayerMods = {    
    GodMode = false
}

local Movement = {
    WalkSpeedEnabled = false,
    WalkSpeedValue = 17.6,
    OriginalWalkSpeed = 16,
    NoClip = false
}

local AvatarStealer = {
    Enabled = true,
    TargetUsername = "",
    OriginalDescription = nil,
    CurrentStealedUserId = nil,
    BlockyBody = true
}

-- ============== HELPER =================
local function GetNil(Name, DebugId)
    if not getnilinstances then return nil end

    for _, Object in pairs(getnilinstances()) do
        if Object.Name == Name then
            if not DebugId or Object:GetDebugId() == DebugId then
                return Object
            end
        end
    end
end

local function getRoot()
return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function getAnimId(id)
return tostring(id):match("%d+")
end

local function GetDowned()
local root = getRoot()
if not root then return nil end

local best, dist = nil, math.huge

for _,p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
local hum = p.Character:FindFirstChildOfClass("Humanoid")
local hrp = p.Character:FindFirstChild("HumanoidRootPart")

if hum and hrp and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then    
        local d = (hrp.Position - root.Position).Magnitude    
        if d < dist then    
            dist = d    
            best = p.Character    
        end    
    end    
end

end

return best

end

local function GetHook()
local root = getRoot()
if not root then return nil end

local bestHook = nil
local shortestDistance = math.huge

for _, obj in pairs(workspace:GetDescendants()) do
if obj.Name == "HookPoint" and obj:IsA("BasePart") then
local dist = (obj.Position - root.Position).Magnitude
if dist < shortestDistance and dist < 400 then
shortestDistance = dist
bestHook = obj
end
end
end

return bestHook

end

local function shouldDisableWalkSpeed()

    local char = LocalPlayer.Character
    if not char then
        return false
    end

    -- DETEKSI ANIMASI PARRY
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then

    local animator = hum:FindFirstChildOfClass("Animator")

    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do

            local anim = track.Animation

            if anim and anim.AnimationId then

                -- PARRY ANIM
                if anim.AnimationId == "rbxassetid://127096285501517" then
                    return true
                end
                
                -- BREAK PALLET
                if anim.AnimationId == "rbxassetid://112166042383605" then
                    return true
                end
                
                -- WALKCROUCH
                if anim.AnimationId == "http://www.roblox.com/asset/?id=126965695851149" then
                    return true
                end
                
                -- WALKCROUCHINJURED
                if anim.AnimationId == "http://www.roblox.com/asset/?id=135084204086504" then
                    return true
                end
                
                -- STUN
                if anim.AnimationId == "rbxassetid://123047897844134" then
                    return true
                end

                -- KILLER ATTACK ANIM
                local id = anim.AnimationId:match("%d+")

                if id then
                    local fullId = "rbxassetid://" .. id

                    if KillerAnims[fullId] then
                        return true
                    end
                end

            end
        end
    end
end

    -- DOWNED CHECK
    if hum and (
        hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
    ) then
        return true
    end

    return false
end

local WalkSpeedConnection = nil

local function applyWalkSpeed()

    if WalkSpeedConnection then
        WalkSpeedConnection:Disconnect()
        WalkSpeedConnection = nil
    end

    WalkSpeedConnection =
        RunService.Heartbeat:Connect(function()

            if not Movement.WalkSpeedEnabled then
                return
            end

            local char = LocalPlayer.Character
            if not char then
                return
            end

            local hum =
                char:FindFirstChildOfClass("Humanoid")

            if not hum then
                return
            end

            if shouldDisableWalkSpeed() then
                return
            end

            if hum.WalkSpeed ~= Movement.WalkSpeedValue then
                hum.WalkSpeed = Movement.WalkSpeedValue
            end

        end)
end

-- Auto apply saat respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.8)
    applyWalkSpeed()
end)

local NoClipConnection = nil

local function applyNoClip()
    local char = LocalPlayer.Character
    if not char then return end

    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then
            if Movement.NoClip then
                v.CanCollide = false
            else
                v.CanCollide = true
            end
        end
    end
end

-- Toggle NoClip
local function toggleNoClip(state)
    Movement.NoClip = state

    if state then
        if NoClipConnection then NoClipConnection:Disconnect() end
        
        NoClipConnection = RunService.RenderStepped:Connect(function()
            if Movement.NoClip then
                applyNoClip()
            end
        end)
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end
        -- Restore collision
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end

-- Auto apply saat respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.8)
    if Movement.NoClip then
        task.wait(0.3)
        toggleNoClip(true)
    end
end)

local function applyGodMode()
    if not PlayerMods.GodMode then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Heal terus
    if hum.Health < hum.MaxHealth then
        pcall(function()
            hum.Health = hum.MaxHealth
        end)
    end

    -- Anti mati / ragdoll
    local state = hum:GetState()

    if state == Enum.HumanoidStateType.Dead 
    or state == Enum.HumanoidStateType.FallingDown 
    or state == Enum.HumanoidStateType.Ragdoll then
        
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
local hum = char:WaitForChild("Humanoid")
task.wait(0.5)

-- RESET PARRY CIRCLE
if ParryCircle then
    ParryCircle:Destroy()
    ParryCircle = nil
end

-- RESET MOONWALK PHASE
MoonwalkPhase = 0
MoonwalkSmoothYaw = 0
end)

-- jika karakter sudah ada
if LocalPlayer.Character then
local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if hum then
end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)

    -- RESET AIM
    GunAim.Target = nil
    GunAim.Holding = false
    applyCameraFOV()
end)

-- ============= ESP SYSTEM ==============
local ESPObjects = {}

local CachedSCP = {}

-- cache SCP sekali saja
for _, obj in ipairs(workspace:GetDescendants()) do
    local name = string.lower(obj.Name)

    if string.find(name, "scp") then
        CachedSCP[obj] = true
    end
end

workspace.DescendantAdded:Connect(function(obj)
    local name = string.lower(obj.Name)

    if string.find(name, "scp") then
        CachedSCP[obj] = true
    end
end)

local function removeESP(obj)
if ESPObjects[obj] then
ESPObjects[obj]:Destroy()
ESPObjects[obj] = nil
end
end

workspace.DescendantRemoving:Connect(function(obj)
    CachedSCP[obj] = nil
    removeESP(obj)
end)

local function createESP(obj, color)
if not obj then return end

if ESPObjects[obj] then
-- update warna saja (tidak recreate)
ESPObjects[obj].FillColor = color
ESPObjects[obj].OutlineColor = color
return
end

local h = Instance.new("Highlight")
h.FillColor = color
h.OutlineColor = color
h.FillTransparency = 0.9
h.OutlineTransparency = 0.3
h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
h.Parent = obj

ESPObjects[obj] = h

-- auto remove jika character hilang
obj.AncestryChanged:Connect(function(_, parent)
if not parent then
removeESP(obj)
end
end)

end

-- ======= ESP GENERATOR =================

local GeneratorColor = Color3.fromRGB(255, 170, 0)
local PalletColor = Color3.fromRGB(74, 255, 181)
local WindowColor = Color3.fromRGB(74, 255, 181)
local SCPColor = Color3.fromRGB(255, 0, 0)

local function GetGameValue(obj, name)
if not obj then return nil end

local attr = obj:GetAttribute(name)
if attr ~= nil then return attr end

local child = obj:FindFirstChild(name)
if child then
local success, val = pcall(function() return child.Value end)
if success then return val end
end

return nil

end

local function ApplyGenHighlight(object, color)
local h = object:FindFirstChild("GenHighlight") or Instance.new("Highlight")
h.Name = "GenHighlight"
h.Adornee = object
h.FillColor = color
h.OutlineColor = color
h.FillTransparency = 0.9
h.OutlineTransparency = 0.3
h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
h.Parent = object
end

local function CreateBillboard(text, color)
local billboard = Instance.new("BillboardGui")
billboard.Name = "GenESP"
billboard.Size = UDim2.new(0, 100, 0, 30)
billboard.AlwaysOnTop = true

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = color
label.TextStrokeTransparency = 0
label.Font = Enum.Font.GothamBold
label.TextSize = 12
label.Parent = billboard

return billboard

end

local function UpdateGenerator(generator)
if not generator or not generator.Parent then return end

-- kalau ESP mati → hapus
if not ESP.Generator then
local old = generator:FindFirstChild("GenESP")
if old then old:Destroy() end

local h = generator:FindFirstChild("GenHighlight")
if h then h:Destroy() end
return

end

local percent =
GetGameValue(generator, "RepairProgress") or
GetGameValue(generator, "Progress") or 0

local billboard = generator:FindFirstChild("GenESP")

if percent >= 100 then
if billboard then billboard:Destroy() end
return
end

local cp = math.clamp(percent, 0, 100)

local color = GeneratorColor:Lerp(
    Color3.fromRGB(0,255,120),
    cp / 100
)

local text = string.format("[%.0f%%]", percent)

if not billboard then
billboard = CreateBillboard(text, color)
billboard.Adornee = generator
billboard.Parent = generator
else
local lbl = billboard:FindFirstChildOfClass("TextLabel")
if lbl then
lbl.Text = text
lbl.TextColor3 = color
end
end

ApplyGenHighlight(generator, color)

end

local function UpdateMapESP(obj, root)
if not obj or not root then return end

local pos
if obj:IsA("Model") then
pos = obj:GetPivot().Position
elseif obj:IsA("BasePart") then
pos = obj.Position
end

if not pos then return end

-- WINDOW
if obj.Name == "Window" then
if ESP.Window then
createESP(obj, WindowColor)
else
removeESP(obj)
end
end

-- PALLET
if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
if ESP.Pallet then
createESP(obj, PalletColor)
else
removeESP(obj)
end
end

end

local StatusESP = {}

local function removeStatusESP(char)
if StatusESP[char] then
StatusESP[char]:Destroy()
StatusESP[char] = nil
end
end

local function createStatusESP(player, char, root)
if not ESPStatus.Enabled then
removeStatusESP(char)
return
end

if not root then return end

local head = char:FindFirstChild("Head")
local hum = char:FindFirstChildOfClass("Humanoid")

if not head or not hum then return end

local isDown =
hum.Health <= 0
or hum.Health < 2
or char:GetAttribute("Downed") == true
or char:GetAttribute("IsDown") == true
or char:GetAttribute("Knocked") == true

local dist = (head.Position - root.Position).Magnitude

local text = ""

if isDown then
text = "💀 DOWN\n"
end

if ESPStatus.ShowName then
text = text .. player.Name .. "\n"
end

if ESPStatus.ShowDistance then
text = text .. string.format("Dist: %.0f\n", dist)
end

if ESPStatus.ShowHealth then
text = text .. string.format("HP: %.0f\n", hum.Health)
end

if text == "" then
removeStatusESP(char)
return
end

local billboard = StatusESP[char]

if not billboard then
billboard = Instance.new("BillboardGui")
billboard.Size = UDim2.new(0, 120, 0, 50)
billboard.AlwaysOnTop = true

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
local teamColor = Color3.new(1,1,1)

if player.Team then
if player.Team.Name == "Killer" then
teamColor = TeamColors.Killer
elseif player.Team.Name == "Survivors" then
teamColor = TeamColors.Survivor
end
end

if isDown then
teamColor = Color3.fromRGB(255, 0, 0)
end

label.TextColor3 = teamColor
label.TextStrokeTransparency = 0
label.Font = Enum.Font.GothamBold
label.TextSize = 12
label.Text = text
label.Parent = billboard

billboard.Adornee = head
billboard.StudsOffset = Vector3.new(0, 2.5, 0)
billboard.Parent = char

StatusESP[char] = billboard

else
local label = billboard:FindFirstChildOfClass("TextLabel")
if label then
label.Text = text

local teamColor = Color3.new(1,1,1)

if player.Team then
if player.Team.Name == "Killer" then
teamColor = TeamColors.Killer
elseif player.Team.Name == "Survivors" then
teamColor = TeamColors.Survivor
end
end

if isDown then
teamColor = Color3.fromRGB(255, 0, 0)
end

label.TextColor3 = teamColor

end
end
end

local function UpdateSCPEsp(root)

    if not ESP.SCP then
        for obj in pairs(CachedSCP) do
            removeESP(obj)
        end
        return
    end

    for obj in pairs(CachedSCP) do

        if obj and obj.Parent then
            createESP(obj, SCPColor)
        else
            removeESP(obj)
        end

    end

end

-- ========== MOONWALK IMPROVED ==========

-- Helper: Sanitize Moonwalk Settings
local function applyMoonwalkStyle(styleName)
    local styleConfig = Moonwalk.Styles[styleName]
    if styleConfig then
        Moonwalk.Speed = styleConfig.Speed
        Moonwalk.Intensity = styleConfig.Intensity
        Moonwalk.Smoothness = styleConfig.Smoothness
        Moonwalk.Style = styleName
    end
end

-- Improved Moonwalk Renderer
local function updateMoonwalk()
    if not Moonwalk.Enabled or ParryActive or isDowned() then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = true
            end
        end
        return
    end

    local char = LocalPlayer.Character
    if not char or not char.Parent then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local cam = workspace.CurrentCamera

    if not hum or not hrp or not cam then return end

    hum.AutoRotate = false

    -- Apply walk speed
    if Moonwalk.UseSlow then
        if hum.WalkSpeed ~= Moonwalk.MovementSpeed then
            hum.WalkSpeed = Moonwalk.MovementSpeed
        end
    end

    -- Get camera direction
    local look = cam.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    if flatLook.Magnitude > 0 then
        flatLook = flatLook.Unit
    else
        flatLook = hrp.CFrame.LookVector
    end

    -- Determine movement direction based on keys
    local moveDir = nil
    local targetFace = flatLook

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDir = flatLook
        targetFace = -flatLook  -- Face backwards when moving forward
    elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDir = -flatLook
        targetFace = flatLook   -- Face forward when moving backward
    end

    -- Smooth yaw interpolation
    local targetYaw = math.atan2(targetFace.X, -targetFace.Z)
    local delta = (targetYaw - MoonwalkSmoothYaw + math.pi) % (2 * math.pi) - math.pi
    MoonwalkSmoothYaw = MoonwalkSmoothYaw + delta * Moonwalk.Smoothness

    -- Update position if moving
    local newPos = hrp.Position
    if moveDir then
        newPos = hrp.Position + moveDir * (Moonwalk.MovementSpeed * (1 / 60))
    end

    -- Update phase for rotation
    MoonwalkPhase = MoonwalkPhase + (Moonwalk.Speed / 60)
    if MoonwalkPhase >= 2 * math.pi then
        MoonwalkPhase = MoonwalkPhase - 2 * math.pi
    end

    -- Apply rotation based on style
    local baseCF = CFrame.new(newPos) * CFrame.Angles(0, MoonwalkSmoothYaw, 0)
    local rotationAngle = 0

    if moveDir then
        if Moonwalk.Style == "Sway" then
            -- Smooth sine wave
            rotationAngle = math.sin(MoonwalkPhase) * Moonwalk.Intensity
        elseif Moonwalk.Style == "Slide" then
            -- Subtle sliding
            rotationAngle = math.sin(MoonwalkPhase * 0.8) * Moonwalk.Intensity
        elseif Moonwalk.Style == "HipShake" then
            -- Exaggerated hip shake
            rotationAngle = math.sin(MoonwalkPhase * 1.2) * Moonwalk.Intensity
        end

        hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(rotationAngle), 0)
    else
        hrp.CFrame = baseCF
    end
end

-- ============= MOVEMENT UI =================

local function isDowned()
    local char = LocalPlayer.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    return hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
end

MovementBox:Toggle({
    Flag = "WalkSpeedToggle",
    Title = "Walk Speed",
    Value = false,
    Callback = function(v)
        Movement.WalkSpeedEnabled = v
        if v then
            applyWalkSpeed()
        else
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Movement.OriginalWalkSpeed
            end
        end
    end
})

MovementBox:Slider({
    Flag = "WalkSpeedSlider",
    Title = "Walk Speed Value",
    Value = { Min = 16, Max = 32, Default = 17.6 },
    Step = 0.1,
    Callback = function(v)
        Movement.WalkSpeedValue = v
        if Movement.WalkSpeedEnabled then
            applyWalkSpeed()
        end
    end
})

MovementBox:Toggle({
    Flag = "NoClipToggle",
    Title = "No Clip",
    Value = false,
    Callback = function(v)
        toggleNoClip(v)
    end
})

-- =============== IMPROVED MOONWALK UI ===============

MovementBox:Toggle({
    Flag = "MoonwalkToggle",
    Title = "Moonwalk Enabled",
    Value = false,
    Callback = function(v)
        Moonwalk.Enabled = v
    end
})

MovementBox:Dropdown({
    Flag = "MoonwalkStyle",
    Title = "Moonwalk Style",
    Values = {
        "Sway",
        "Slide",
        "HipShake"
    },
    Value = 1,
    Callback = function(Value)
        local styles = {"Sway", "Slide", "HipShake"}
        applyMoonwalkStyle(styles[Value])
    end
})

MovementBox:Slider({
    Flag = "MoonwalkSpeed",
    Title = "Rotation Speed",
    Value = { Min = 5, Max = 40, Default = 15 },
    Step = 1,
    Callback = function(v)
        Moonwalk.Speed = v
    end
})

MovementBox:Slider({
    Flag = "MoonwalkIntensity",
    Title = "Rotation Intensity",
    Value = { Min = 5, Max = 50, Default = 25 },
    Step = 1,
    Callback = function(v)
        Moonwalk.Intensity = v
    end
})

MovementBox:Slider({
    Flag = "MoonwalkSmoothness",
    Title = "Smoothness",
    Value = { Min = 0.05, Max = 0.5, Default = 0.25 },
    Step = 0.05,
    Callback = function(v)
        Moonwalk.Smoothness = v
    end
})

MovementBox:Slider({
    Flag = "MoonwalkMovementSpeed",
    Title = "Movement Speed",
    Value = { Min = 5, Max = 20, Default = 12 },
    Step = 0.5,
    Callback = function(v)
        Moonwalk.MovementSpeed = v
    end
})

MovementBox:Keybind({
    Flag = "MoonwalkKey",
    Title = "Moonwalk Toggle Key",
    Value = Enum.KeyCode.V,
    Callback = function()
        Moonwalk.Enabled = not Moonwalk.Enabled
    end
})

MovementBox:Toggle({
    Flag = "MoonwalkAutoSlow",
    Title = "Auto Slow Walk",
    Value = true,
    Callback = function(v)
        Moonwalk.UseSlow = v
    end
})

-- =============== RENDER LOOP ===============

RunService.RenderStepped:Connect(function(dt)
    -- Update moonwalk
    updateMoonwalk()
end)

print("[zryx] Script loaded successfully! Press Right Shift to open menu.")
print("[zryx] Moonwalk improved with 3 styles: Sway, Slide, HipShake")
