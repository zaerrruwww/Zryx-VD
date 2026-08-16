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

-- === KURSOR ===
--   menu buka  -> dipaksa bebas (Default)
--   menu tutup + hidup (round/game) -> kunci (LockCenter) biar FPS
--   menu tutup + mati/spec atau di lobby -> bebas (biarin game atur sendiri)
-- Deteksi menu pakai callback OnOpen/OnClose WindUI (paling akurat),
-- BUKAN polling Window.Closed / Visible (terbukti nggak konsisten).
if not IsMobile then
    local menuOpen = false

    local function isInGame()
        local char = LocalPlayer.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        return hum.Health > 0
    end

    local function applyMouse()
        if menuOpen then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        elseif isInGame() then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            UserInputService.MouseIconEnabled = false
        end
    end

    pcall(function()
        if Window.OnOpen then Window:OnOpen(function() menuOpen = true applyMouse() end) end
        if Window.OnClose then Window:OnClose(function() menuOpen = false applyMouse() end) end
    end)

    -- inisialisasi status awal dari callback window (menu start terbuka)
    task.spawn(function()
        task.wait(0.5)
        menuOpen = (Window.Closed == false)
        applyMouse()
    end)

    -- dipaksa tiap frame (RenderStep + Heartbeat biar ngalahin game)
    RunService:BindToRenderStep("ZryxMouseFree", Enum.RenderPriority.Last.Value, applyMouse)
    RunService.Heartbeat:Connect(applyMouse)
end

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
    ShowFOVCircle = false,
    MobileButton = false
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

-- kalau ESP mati â†’ hapus
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
text = "ðŸ”» DOWN\n"
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

            local pos

            if obj:IsA("Model") then
                pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            end

            if pos then
                if ESP.SCP then
                    createESP(obj, SCPColor)
                else
                    removeESP(obj)
                end
            end
        end
    end
end

-- ==========AUTO SYSTEM=================

local function GetNearestKiller()
    local root = getRoot()
    if not root then return nil end

    local closest = nil
    local shortest = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and plr.Team
        and plr.Team.Name == "Killer"
        and plr.Character then

            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude

                if dist < shortest then
                    shortest = dist
                    closest = hrp
                end
            end
        end
    end

    return closest, shortest
end

local lastParry = 0
local PARRY_DEBOUNCE = 0.2

local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local AttackPaths = {
    "Slasher-mob.Controls.attack",
    "Masked-mob.Controls.attack",
    "Killer-mob.Controls.attack"
}

local function GetParryButton()
local current = PlayerGui
for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
current = current and current:FindFirstChild(segment)
end
return current
end

local function GetAttackButtonForParry()

    for _, path in ipairs(AttackPaths) do

        local current = PlayerGui

        for segment in string.gmatch(path, "[^%.]+") do
            current =
                current and current:FindFirstChild(segment)
        end

        if current and current:IsA("GuiObject") then
            return current
        end
    end

    return nil
end

local function GetGunAimButton()

    local current = PlayerGui

    for segment in string.gmatch(
        "Survivor-mob.Controls.Gui-mob",
        "[^%.]+"
    ) do

        current =
            current and current:FindFirstChild(segment)
    end

    return current
end

-- ====== PC RIGHT CLICK HOLD DETECT ======
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false
    end
end)

local function pressParryButton()
    if UserInputService.TouchEnabled then
        -- MOBILE (biarin seperti sekarang)
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = game:GetService("GuiService"):GetGuiInset()

            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y

            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
        end
    else
        -- PC â†’ klik kanan
        pressRightClick()
    end
end

local function doParry()
local now = tick()
if now - lastParry < PARRY_DEBOUNCE then return end
lastParry = now

ParryActive = true  

pressParryButton()  

-- ðŸ”¥ tunggu lebih lama (biar anim selesai)  
task.delay(0.3, function()  
    ParryActive = false  
end)

end

local function isInParryRange(killerChar)
local myRoot = getRoot()
if not myRoot or not killerChar then return false end

local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
if not enemyRoot then return false end

local dist = (enemyRoot.Position - myRoot.Position).Magnitude
return dist <= Auto.ParryDistance

end

local function isFacingTarget(targetChar)
if not Auto.RequireFacing then return true end

local myChar = LocalPlayer.Character  
if not myChar then return false end  

local myRoot = myChar:FindFirstChild("HumanoidRootPart")  
local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")  

if not myRoot or not enemyRoot then return false end  

-- ðŸ”¥ arah depan killer  
local enemyForward = enemyRoot.CFrame.LookVector  

-- arah dari killer ke kita  
local directionToMe = (myRoot.Position - enemyRoot.Position).Unit  

local dot = enemyForward:Dot(directionToMe)  

-- disable check  
if Auto.FaceSensitivity <= -1 then  
    return true  
end  

return dot >= Auto.FaceSensitivity

end

local hookedKillers = {}

local function hookKiller(char)
if hookedKillers[char] then return end
hookedKillers[char] = true

local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return end

local animator = hum:FindFirstChildOfClass("Animator")
if not animator then return end

animator.AnimationPlayed:Connect(function(track)
if not Auto.Parry then return end

local anim = track.Animation
if not anim then return end

local id = anim.AnimationId:match("%d+")
if not id then return end

local fullId = "rbxassetid://" .. id

if KillerAnims[fullId] then
if not isInParryRange(char) then return end
if not isFacingTarget(char) then return end

doParry()

end
end)

end

local function scanKillers()
for _, p in pairs(game:GetService("Players"):GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
hookKiller(p.Character)
end
end
end

local RayParams = RaycastParams.new()

RayParams.FilterType =
    Enum.RaycastFilterType.Blacklist

local function isVisible(part)

    local cam = workspace.CurrentCamera

    RayParams.FilterDescendantsInstances = {
        LocalPlayer.Character
    }

    local origin = cam.CFrame.Position

    local direction =
        (part.Position - origin)

    local result =
        workspace:Raycast(
            origin,
            direction,
            RayParams
        )

    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(
        part.Parent
    )
end

local function getClosestGunTarget()

    local cam = workspace.CurrentCamera

    local center = Vector2.new(
        cam.ViewportSize.X / 2,
        cam.ViewportSize.Y / 2
    )

    local closest = nil
    local shortest = GunAim.FOV

    -- ==================================

    for _, p in pairs(Players:GetPlayers()) do

        if p ~= LocalPlayer
        and p.Character
        and p.Team then

            local valid = false

            if GunAim.TargetMode == "All" then

                valid = true

            elseif GunAim.TargetMode == "Killer"
            and p.Team.Name == "Killer" then

                valid = true

            elseif GunAim.TargetMode == "Survivor"
            and p.Team.Name == "Survivors" then

                valid = true
            end

            if valid then

                local hrp =
                    p.Character:FindFirstChild(
                        GunAim.AimPart
                    )

                local hum =
                    p.Character:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if hrp and hum and hum.Health > 0 then

                    local pos, visible =
                        cam:WorldToViewportPoint(
                            hrp.Position
                        )

                    if visible then

                        local dist =
                            (
                                Vector2.new(pos.X, pos.Y)
                                - center
                            ).Magnitude

                        if dist < shortest then

                            if GunAim.VisibilityCheck then
                                if not isVisible(hrp) then
                                    continue
                                end
                            end

                            shortest = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
    end
    -- ================= SCP =================

    if GunAim.TargetMode == "SCP" then

        for obj in pairs(CachedSCP) do

            if obj and obj.Parent then

                local part

                if obj:IsA("Model") then
                    part =
                        obj.PrimaryPart
                        or obj:FindFirstChildWhichIsA(
                            "BasePart"
                        )
                elseif obj:IsA("BasePart") then
                    part = obj
                end

                if part then

                    local pos, visible =
                        cam:WorldToViewportPoint(
                            part.Position
                        )

                    if visible then

                        local dist =
                            (
                                Vector2.new(pos.X, pos.Y)
                                - center
                            ).Magnitude

                        if dist < shortest then

                            shortest = dist
                            closest = part
                        end
                    end
                end
            end
        end
    end

    return closest
end


local GunAimConnection = nil
local function startGunAim()

    if GunAimConnection then
        return
    end

    GunAimConnection =
        RunService.RenderStepped:Connect(function()

            if not GunAim.Enabled then
                GunAim.Target = nil
                return
            end

            if not GunAim.Holding then
                GunAim.Target = nil
                return
            end

            local cam =
                workspace.CurrentCamera

            local target =
                getClosestGunTarget()

            if not target then
                return
            end

            local pos = target.Position

            if GunAim.Predict then

                pos =
                    pos +
                    (
                        target.AssemblyLinearVelocity
                        * GunAim.PredictStrength
                    )
            end

            local cf =
                CFrame.new(
                    cam.CFrame.Position,
                    pos
                )

            cam.CFrame =
                cam.CFrame:Lerp(
                    cf,
                    GunAim.Strength
                )
        end)
end

local GunAimButtonConnection = nil
local CurrentGunButton = nil

task.spawn(function()

    while true do
        task.wait(1)

        local btn = GetGunAimButton()

        -- GUI belum ada
        if not btn then
            CurrentGunButton = nil
            continue
        end

        -- tombol baru detected
        if btn ~= CurrentGunButton then

            CurrentGunButton = btn

            -- disconnect lama
            if GunAimButtonConnection then
                GunAimButtonConnection:Disconnect()
                GunAimButtonConnection = nil
            end

            btn.InputBegan:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseButton2 then

                    GunAim.Holding = true
                end
            end)

            btn.InputEnded:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseButton2 then

                    GunAim.Holding = false
                end
            end)
        end
    end
end)

-- ====== MOBILE AIMLOCK FLOATING BUTTON ======
local MobileAimButtonGui = nil
local MobileAimButtonConnections = {}

local function createMobileAimButton()
    removeMobileAimButton()

    local gui = Instance.new("ScreenGui")
    gui.Name = "ZryxMobileAimButton"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999
    gui.Parent = PlayerGui

    local holder = Instance.new("Frame")
    holder.Name = "Holder"
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Size = UDim2.fromOffset(90, 90)
    holder.Position = UDim2.new(0.85, 0, 0.5, 0)
    holder.BackgroundTransparency = 1
    holder.Parent = gui

    local btn = Instance.new("TextButton")
    btn.Name = "AimButton"
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.Text = "AIM"
    btn.TextColor3 = Color3.fromRGB(255, 120, 60)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = holder

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 120, 60)
    stroke.Thickness = 2
    stroke.Parent = btn

    local radius = Instance.new("UICorner")
    radius.CornerRadius = UDim.new(1, 0)
    radius.Parent = btn

    local dragConn = nil
    local dragStart, dragHold = nil, nil

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            GunAim.Holding = true
            btn.BackgroundColor3 = Color3.fromRGB(255, 120, 60)
            btn.TextColor3 = Color3.fromRGB(30, 30, 35)
            dragStart = input.Position
            dragHold = holder.Position
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            GunAim.Holding = false
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            btn.TextColor3 = Color3.fromRGB(255, 120, 60)
            dragStart, dragHold = nil, nil
        end
    end)

    dragConn = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not dragStart or not dragHold then return end
        local delta = input.Position - dragStart
        holder.Position = UDim2.new(
            dragHold.X.Scale, dragHold.X.Offset + delta.X,
            dragHold.Y.Scale, dragHold.Y.Offset + delta.Y
        )
    end)

    MobileAimButtonConnections = { dragConn }
    MobileAimButtonGui = gui
end

local function removeMobileAimButton()
    for _, c in ipairs(MobileAimButtonConnections) do
        pcall(function() c:Disconnect() end)
    end
    MobileAimButtonConnections = {}
    if MobileAimButtonGui then
        pcall(function() MobileAimButtonGui:Destroy() end)
        MobileAimButtonGui = nil
    end
end

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

-- ================= AUTO SKILL CHECK =================

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

local SkillHeartbeat = nil
local SkillVisibility = nil

local function GetActionTarget()
local current = PlayerGui
for segment in string.gmatch(ActionPath, "[^%.]+") do
current = current and current:FindFirstChild(segment)
end
return current
end

local function TriggerMobileButton()
local b = GetActionTarget()
if b and b:IsA("GuiObject") then
local p, s, i = b.AbsolutePosition, b.AbsoluteSize, game:GetService("GuiService"):GetGuiInset()
local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
pcall(function()
VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
task.wait(0.01)
VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
end)
end
end

local busy = false

local function startSkillCheck()
if SkillHeartbeat then SkillHeartbeat:Disconnect() end

SkillHeartbeat = RunService.RenderStepped:Connect(function()
if not Auto.SkillCheck or busy then return end

local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
if not prompt then return end

local check = prompt:FindFirstChild("Check")
if not check or not check.Visible then return end

local line = check:FindFirstChild("Line")
local goal = check:FindFirstChild("Goal")
if not line or not goal then return end

local lr = line.Rotation % 360
local gr = goal.Rotation % 360

local startRange = (gr + 102) % 360
local endRange   = (gr + 116) % 360

local success =
(startRange > endRange and (lr >= startRange or lr <= endRange))
or (lr >= startRange and lr <= endRange)

if success then
busy = true

task.spawn(function()
if UserInputService.TouchEnabled then
    TriggerMobileButton()
else
    pressSpace()
end
task.wait(0.05)
busy = false
end)

end

end)

end

-- === AUTO STALK =============
local StalkConnection = nil

local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end

    local closest, shortest = nil, math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then 
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= AutoStalk.StalkRange and dist < shortest then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end


local function startAutoStalk()
    if StalkConnection then return end

    StalkConnection = RunService.Heartbeat:Connect(function()
        if not AutoStalk.Enabled then return end

        local target = getClosestSurvivorForStalk()
        if not target or not target.Character then return end

        local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
                          and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
                          and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true)
                          and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")

        if stalkEvent then
            pcall(function()
                stalkEvent:FireServer(target)
            end)
        end
    end)
end

local function stopAutoStalk()
    if StalkConnection then
        StalkConnection:Disconnect()
        StalkConnection = nil
    end
end

local function applyUnlimitedZoom()
    if CameraZoom.UnlimitedZoom then
        LocalPlayer.CameraMaxZoomDistance = CameraZoom.MaxDistance
        LocalPlayer.CameraMinZoomDistance = CameraZoom.MinDistance
    else
        -- Kembalikan ke default (biasanya 128 atau 40 tergantung game)
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end

local function applyCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end

    if CameraZoom.FOVEnabled then
        cam.FieldOfView = CameraZoom.FOV
    else
        cam.FieldOfView = CameraZoom.DefaultFOV
    end
end

-- ================= AVATAR STEALER FUNCTIONS =================
local function saveOriginalAppearance()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        AvatarStealer.OriginalDescription = hum:GetAppliedDescription()
    end
end

local function applyBlockyBody(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local desc = Instance.new("HumanoidDescription")
    desc.BodyTypeScale = 1
    desc.DepthScale = 1
    desc.HeadScale = 1
    desc.HeightScale = 1
    desc.ProportionScale = 0
    desc.WidthScale = 1

    hum:ApplyDescriptionClientServer(desc)
end

local function removeAllClothingAndAccessories(character)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            v:Destroy()
        end
    end
end

local function copyAvatar(username)
    if not username or username == "" then
        return 
    end

    saveOriginalAppearance()

    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)

    if not success then
        return
    end

    AvatarStealer.CurrentStealedUserId = userId

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    task.spawn(function()
        local desc = Players:GetHumanoidDescriptionFromUserId(userId)

        if AvatarStealer.BlockyBody then
            applyBlockyBody(char)
            task.wait(0.3)
        end

        removeAllClothingAndAccessories(char)
        task.wait(0.2)

        hum:ApplyDescriptionClientServer(desc)
    end)
end

local function resetAvatar()
    if not AvatarStealer.OriginalDescription then
        return
    end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        removeAllClothingAndAccessories(char)
        hum:ApplyDescriptionClientServer(AvatarStealer.OriginalDescription)
        AvatarStealer.CurrentStealedUserId = nil
    end
end

-- Auto restore setelah respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if AvatarStealer.CurrentStealedUserId then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local desc = Players:GetHumanoidDescriptionFromUserId(AvatarStealer.CurrentStealedUserId)
            if AvatarStealer.BlockyBody then
                applyBlockyBody(char)
            end
            removeAllClothingAndAccessories(char)
            hum:ApplyDescriptionClientServer(desc)
        end
    end
end)

local function teleportToFinishLine()

    local root = getRoot()

    if not root then
        return
    end

    local found = nil

    for _, obj in ipairs(workspace:GetDescendants()) do

        if string.lower(obj.Name) == "fininshline"
        and obj:IsA("BasePart") then

            found = obj
            break
        end
    end

    if not found then
        warn("fininshline not found")
        return
    end

    root.CFrame =
        found.CFrame + Vector3.new(0, 5, 0)

end

-- ================= AMBIENT / VISUAL =================

local Visual = {
Fullbright = false,
NoShadow = false,
Ambient = false,
AmbientColor = Color3.fromRGB(255,255,255),
ClockTimeEnabled = true,
Brightness = 2,
ClockTime = 14,
LowGraphics = false,
LowRender = false,
NoFog = false,
CleanSky = false,
NoScreenEffects = false
}

local original = {
Brightness = Lighting.Brightness,
ClockTime = Lighting.ClockTime,
Ambient = Lighting.Ambient,
OutdoorAmbient = Lighting.OutdoorAmbient,
GlobalShadows = Lighting.GlobalShadows
}

local LastVisualState = {
    Fullbright = nil,
    NoShadow = nil,
    Ambient = nil,
    AmbientColor = nil,
    Brightness = nil,
    ClockTime = nil
}

local function applyVisual(force)

    -- ================= FULLBRIGHT =================
    if force
    or LastVisualState.Fullbright ~= Visual.Fullbright then

        LastVisualState.Fullbright = Visual.Fullbright

        if Visual.Fullbright then

            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(1,1,1)
            Lighting.OutdoorAmbient = Color3.new(1,1,1)

        else

            Lighting.Brightness = original.Brightness
            Lighting.ClockTime = original.ClockTime
            Lighting.Ambient = original.Ambient
            Lighting.OutdoorAmbient = original.OutdoorAmbient

        end
    end

    -- ================= NO SHADOW =================
    if force
    or LastVisualState.NoShadow ~= Visual.NoShadow then

        LastVisualState.NoShadow = Visual.NoShadow

        Lighting.GlobalShadows = not Visual.NoShadow
    end

    -- ================= CUSTOM AMBIENT =================
    local ambientChanged =
        LastVisualState.Ambient ~= Visual.Ambient
        or LastVisualState.AmbientColor ~= Visual.AmbientColor
        or LastVisualState.Brightness ~= Visual.Brightness
        or LastVisualState.ClockTime ~= Visual.ClockTime

    if force or ambientChanged then

        LastVisualState.Ambient = Visual.Ambient
        LastVisualState.AmbientColor = Visual.AmbientColor
        LastVisualState.Brightness = Visual.Brightness
        LastVisualState.ClockTime = Visual.ClockTime

        if Visual.Ambient then

            Lighting.Ambient = Visual.AmbientColor
            Lighting.OutdoorAmbient = Visual.AmbientColor
            Lighting.Brightness = Visual.Brightness
            Lighting.ClockTime = Visual.ClockTime

        elseif not Visual.Fullbright then

            -- restore default jika ambient dimatikan
            Lighting.Brightness = original.Brightness
            Lighting.ClockTime = original.ClockTime
            Lighting.Ambient = original.Ambient
            Lighting.OutdoorAmbient = original.OutdoorAmbient

        end
    end
end

-- ================= CROSSHAIR =================
local Crosshair = {
    Enabled = false,
    Size = 8,
    Thickness = 2,
    Color = Color3.fromRGB(255,255,255),
    Style = "Plus",
    OffsetX = 0,
    OffsetY = 6
}

local CrosshairDrawings = {}

local function clearCrosshair()
for _,v in pairs(CrosshairDrawings) do
if v.Remove then v:Remove() end
end
CrosshairDrawings = {}
end

local FOVCircle = nil

local function drawFOVCircle()

    if not GunAim.ShowFOVCircle then
        if FOVCircle then
            FOVCircle.Visible = false
        end
        return
    end

    if not FOVCircle then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Filled = false
        FOVCircle.Thickness = 1
        FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        FOVCircle.Visible = true
    end

    local cam = workspace.CurrentCamera
    FOVCircle.Position = Vector2.new(
        cam.ViewportSize.X / 2,
        cam.ViewportSize.Y / 2
    )
    FOVCircle.Radius = GunAim.FOV
    FOVCircle.Visible = true
end

local created = false
local LastCrosshairStyle = nil

local function drawCrosshair()

    if not Crosshair.Enabled then
        for _,v in pairs(CrosshairDrawings) do
            if v then
                v.Visible = false
            end
        end
        return
    end

    -- ðŸ”¥ DETECT STYLE CHANGE
    if LastCrosshairStyle ~= Crosshair.Style then
        clearCrosshair()
        created = false
        LastCrosshairStyle = Crosshair.Style
    end

    local cam = workspace.CurrentCamera

    local center = Vector2.new(
        cam.ViewportSize.X / 2 + Crosshair.OffsetX,
        cam.ViewportSize.Y / 2 + Crosshair.OffsetY
    )

    -- CREATE DRAWING
    if not created then
        created = true

        if Crosshair.Style == "Plus" then

            for i = 1,4 do
                local line = Drawing.new("Line")
                line.Visible = true
                table.insert(CrosshairDrawings, line)
            end

        elseif Crosshair.Style == "Dot" then

            local dot = Drawing.new("Circle")
            dot.Filled = true
            dot.Visible = true
            table.insert(CrosshairDrawings, dot)

        elseif Crosshair.Style == "Circle" then

            local circle = Drawing.new("Circle")
            circle.Filled = false
            circle.Visible = true
            table.insert(CrosshairDrawings, circle)

        end
    end

    -- UPDATE STYLE
    if Crosshair.Style == "Plus" then

        for _,line in pairs(CrosshairDrawings) do
            line.Color = Crosshair.Color
            line.Thickness = Crosshair.Thickness
        end

        CrosshairDrawings[1].From = center + Vector2.new(-Crosshair.Size,0)
        CrosshairDrawings[1].To   = center + Vector2.new(-2,0)

        CrosshairDrawings[2].From = center + Vector2.new(Crosshair.Size,0)
        CrosshairDrawings[2].To   = center + Vector2.new(2,0)

        CrosshairDrawings[3].From = center + Vector2.new(0,-Crosshair.Size)
        CrosshairDrawings[3].To   = center + Vector2.new(0,-2)

        CrosshairDrawings[4].From = center + Vector2.new(0,Crosshair.Size)
        CrosshairDrawings[4].To   = center + Vector2.new(0,2)

    elseif Crosshair.Style == "Dot" then

        local dot = CrosshairDrawings[1]

        dot.Position = center
        dot.Radius = Crosshair.Size / 2
        dot.Color = Crosshair.Color

    elseif Crosshair.Style == "Circle" then

        local circle = CrosshairDrawings[1]

        circle.Position = center
        circle.Radius = Crosshair.Size
        circle.Color = Crosshair.Color
        circle.Thickness = Crosshair.Thickness

    end
end

local function updateParryCircle()
local root = getRoot()

if not ParryRangeVisual.Enabled or not root then  
    if ParryCircle then  
        ParryCircle:Destroy()  
        ParryCircle = nil  
    end  
    return  
end  

if not ParryCircle then  
    ParryCircle = Instance.new("Part")  
    ParryCircle.Shape = Enum.PartType.Cylinder  
    ParryCircle.Anchored = true  
    ParryCircle.CanCollide = false  
    ParryCircle.Material = Enum.Material.Neon  
    ParryCircle.Name = "ParryRangeCircle"  
    ParryCircle.Parent = workspace  
end  

-- ukuran = diameter (radius * 2)  
local size = Auto.ParryDistance * 2  

ParryCircle.Size = Vector3.new(0.2, size, size)  
local yOffset = root.Size.Y / 2 + 1.5  

ParryCircle.CFrame =  
    CFrame.new(root.Position - Vector3.new(0, yOffset, 0))  
    * CFrame.Angles(0, 0, math.rad(90))  

ParryCircle.Color = ParryRangeVisual.Color  
ParryCircle.Transparency = ParryRangeVisual.Transparency

end

local LastOptimizationState = {
    LowGraphics = nil,
    LowRender = nil,
    CleanSky = nil
}

local function applyOptimization(force)

    -- ================= LOW GRAPHICS =================
    if force
    or LastOptimizationState.LowGraphics ~= Visual.LowGraphics then

        LastOptimizationState.LowGraphics = Visual.LowGraphics

        pcall(function()

            if Visual.LowGraphics then
                settings().Rendering.QualityLevel =
                    Enum.QualityLevel.Level01
            else
                settings().Rendering.QualityLevel =
                    Enum.QualityLevel.Automatic
            end

        end)
    end

    -- ================= CLEAN SKY =================
    if force
    or LastOptimizationState.CleanSky ~= Visual.CleanSky then

        LastOptimizationState.CleanSky = Visual.CleanSky

        if Visual.CleanSky then

        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then
                v:Destroy()
                 end
             end

        end
    end
end

local ScreenEffectTypes = {
    "ColorCorrectionEffect",
    "DepthOfFieldEffect",
    "BlurEffect",
    "SunRaysEffect",
    "BloomEffect"
}

local DisabledEffects = {}

local function applyNoScreenEffects()
    if Visual.NoScreenEffects then
        for _, v in pairs(Lighting:GetChildren()) do
            for _, t in pairs(ScreenEffectTypes) do
                if v:IsA(t) then
                    DisabledEffects[v] = v.Enabled
                    v.Enabled = false
                end
            end
        end
    else
        -- restore
        for obj, state in pairs(DisabledEffects) do
            if obj and obj.Parent then
                obj.Enabled = state
            end
        end
        DisabledEffects = {}
    end
end

Lighting.ChildAdded:Connect(function(v)
    if not Visual.NoScreenEffects then return end
    task.wait()
    for _, t in pairs(ScreenEffectTypes) do
        if v:IsA(t) then
            DisabledEffects[v] = v.Enabled
            v.Enabled = false
        end
    end
end)

-- ================= OBJECT CACHE =================
local Cached = {
Generators = {},
Windows = {},
Pallets = {}
}

local function cacheObject(obj)
if obj.Name == "Generator" then
Cached.Generators[obj] = true
elseif obj.Name == "Window" then
Cached.Windows[obj] = true
elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then
Cached.Pallets[obj] = true
end
end

local function removeCache(obj)
Cached.Generators[obj] = nil
Cached.Windows[obj] = nil
Cached.Pallets[obj] = nil
end

-- INIT CACHE (sekali saja)
for _, obj in ipairs(workspace:GetDescendants()) do
cacheObject(obj)
end

workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(removeCache)

local currentTarget = nil
local carryBusy = false

-- ================ MAIN LOOP (OPTIMIZED) =================

local lastESPUpdate = 0
local lastKillerUpdate = 0
local lastGodMode = 0

-- âœ… HEARTBEAT: logika non-visual (tidak perlu sync frame)
RunService.Heartbeat:Connect(function()
    local now = tick()

    -- GOD MODE (cukup 10x/detik)
    if now - lastGodMode >= 0.1 then
        lastGodMode = now
        applyGodMode()
    end

    -- KILLER SYSTEM (cukup 20x/detik)
    if now - lastKillerUpdate >= 0.05 then
        lastKillerUpdate = now

        -- AUTO CARRY + HOOK
        if Killer.AutoCarry and not KillerBusy then
            KillerBusy = true
            local target = GetDowned()
            local root = getRoot()

            if target and root then
                local tRoot = target:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                    task.wait(0.4)
                    for i = 1, 4 do
                        CarryEvent:FireServer(target)
                        task.wait(0.2)
                    end
                    task.wait(0.6)
                    local hook = GetHook()
                    if hook then
                        root.CFrame = hook.CFrame * CFrame.new(0, 4, -3)
                        task.wait(0.7)
                        for i = 1, 6 do
                            HookEvent:FireServer(hook)
                            task.wait(0.15)
                        end
                    end
                end
            end

            task.delay(2, function() KillerBusy = false end)
        end

        -- WALK SPEED
        if Movement.WalkSpeedEnabled then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if shouldDisableWalkSpeed() then
                    if hum.WalkSpeed == Movement.WalkSpeedValue then
                        hum.WalkSpeed = Movement.OriginalWalkSpeed
                    end
                else
                    if hum.WalkSpeed ~= Movement.WalkSpeedValue then
                        hum.WalkSpeed = Movement.WalkSpeedValue
                    end
                end
            end
        end
    end
end)

-- âœ… RENDERSTEP: hanya visual & camera (perlu sync frame)
RunService.RenderStepped:Connect(function(dt)
    local root = getRoot()
    if not root then return end

    local now = tick()

    -- ESP (cukup 20x/detik, bukan 60x)
    if now - lastESPUpdate >= 0.05 then
        lastESPUpdate = now

        -- PLAYER ESP + STATUS
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")

                if hum and hum.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                            createESP(char, TeamColors.Survivor)
                        elseif ESP.Killer and p.Team and p.Team.Name == "Killer" then
                            createESP(char, TeamColors.Killer)
                        else
                            removeESP(char)
                        end
                    end
                    createStatusESP(p, char, root)
                else
                    removeESP(char)
                end
            end
        end

        -- GENERATOR ESP
        if ESP.Generator then
            for gen in pairs(Cached.Generators) do
                UpdateGenerator(gen)
            end
        end

        -- MAP ESP
        for obj in pairs(Cached.Windows) do UpdateMapESP(obj, root) end
        for obj in pairs(Cached.Pallets) do UpdateMapESP(obj, root) end

        UpdateSCPEsp(root)
        applyVisual()
        applyNoScreenEffects()
        updateParryCircle()
    end

    -- CROSSHAIR & FOV CIRCLE: tetap setiap frame (butuh smooth)
    drawFOVCircle()
    drawCrosshair()
end)

RunService.RenderStepped:Connect(function()

    if CameraZoom.FOVEnabled then
        local cam = workspace.CurrentCamera

        if cam and cam.FieldOfView ~= CameraZoom.FOV then
            cam.FieldOfView = CameraZoom.FOV
        end
    end

end)

-- ================ MAIN LOOP (RenderStepped) =================
local FastVault = {
Enabled = false,
Speed = 1.2,

ReplaceMap = {
["rbxassetid://83873880822918"]  = "rbxassetid://136962284480779"  -- Running â†’ Finesse
}

}

local VaultTracks = {}

local function normalizeId(id)
local num = tostring(id):match("%d+")
return num and ("rbxassetid://" .. num)
end

local function hookVault(char)
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return end

local animator = hum:FindFirstChildOfClass("Animator")
if not animator then return end

animator.AnimationPlayed:Connect(function(track)
if not FastVault.Enabled then return end

local anim = track.Animation
if not anim or not anim.AnimationId then return end

local id = normalizeId(anim.AnimationId)
if not id then return end

local replaceId = FastVault.ReplaceMap[id]
if not replaceId then return end

if VaultTracks[track] then return end
VaultTracks[track] = true

-- STOP anim lama
track:Stop()

-- PLAY anim baru (Finesse)
local newAnim = Instance.new("Animation")
newAnim.AnimationId = replaceId

local newTrack = animator:LoadAnimation(newAnim)

newTrack.Priority = Enum.AnimationPriority.Action

newTrack:Play()
newTrack:AdjustSpeed(FastVault.Speed)

newTrack.Stopped:Connect(function()
VaultTracks[track] = nil
end)

end)

end

-- APPLY KE CHARACTER
LocalPlayer.CharacterAdded:Connect(function(char)
task.wait(0.5)
applyUnlimitedZoom()
hookVault(char)
end)


if LocalPlayer.Character then
hookVault(LocalPlayer.Character)
startGunAim()
end

task.spawn(function()
while true do
task.wait(0.8)

if Auto.Parry then
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
hookKiller(p.Character)
end
end
end
end

end)

-- ================= UI ================
-- INFO
InfoBox:Paragraph({ Title = "Script: zryx" })
InfoBox:Paragraph({ Title = "Version: 2.0.0" })
InfoBox:Paragraph({ Title = "Game: Violence District" })

-- CREDITS
CreditsBox:Paragraph({ Title = "Developer:" })
CreditsBox:Paragraph({ Title = "- zryx" })
CreditsBox:Divider()
CreditsBox:Paragraph({ Title = "Library:" })
CreditsBox:Paragraph({ Title = "- WindUI" })

-- ================= ESP =================
ESPBox:Toggle({
    Flag = "SurvivorESP",
    Title = "ESP Survivor",
    Value = false,
    Callback = function(v)
        ESP.Survivor = v
    end
})

ESPBox:Colorpicker({
    Flag = "SurvivorESPColor",
    Title = "Survivor Color",
    Default = TeamColors.Survivor,
    Callback = function(color)
        TeamColors.Survivor = color
    end
})

ESPBox:Toggle({
    Flag = "KillerESP",
    Title = "ESP Killer",
    Value = false,
    Callback = function(v)
        ESP.Killer = v
    end
})

ESPBox:Colorpicker({
    Flag = "KillerESPColor",
    Title = "Killer Color",
    Default = TeamColors.Killer,
    Callback = function(color)
        TeamColors.Killer = color
    end
})

ESPBox:Toggle({
    Flag = "ESPGenerator",
    Title = "Generator",
    Value = false,
    Callback = function(v)
        ESP.Generator = v
    end
})

ESPBox:Colorpicker({
    Flag = "GeneratorColor",
    Title = "Generator Color",
    Default = GeneratorColor,
    Callback = function(v)
        GeneratorColor = v
    end
})

ESPBox:Toggle({
    Flag = "ESPSCP",
    Title = "SCP",
    Value = false,
    Callback = function(v)
        ESP.SCP = v
    end
})

ESPBox:Colorpicker({
    Flag = "SCPColor",
    Title = "SCP Color",
    Default = SCPColor,
    Callback = function(v)
        SCPColor = v
    end
})

ESPBox:Toggle({
    Flag = "ESPPallet",
    Title = "Pallet",
    Value = false,
    Callback = function(v)
        ESP.Pallet = v
    end
})

ESPBox:Colorpicker({
    Flag = "PalletColor",
    Title = "Pallet Color",
    Default = PalletColor,
    Callback = function(v)
        PalletColor = v
    end
})

ESPBox:Toggle({
    Flag = "ESPWindow",
    Title = "Window",
    Value = false,
    Callback = function(v)
        ESP.Window = v
    end
})

ESPBox:Colorpicker({
    Flag = "WindowColor",
    Title = "Window Color",
    Default = WindowColor,
    Callback = function(v)
        WindowColor = v
    end
})

ESPStatusBox:Toggle({
    Flag = "EnableStatus",
    Title = "Enable Status ESP",
    Value = false,
    Callback = function(v)
        ESPStatus.Enabled = v
    end
})

ESPStatusBox:Toggle({
    Flag = "ShowName",
    Title = "Show Name",
    Value = true,
    Callback = function(v)
        ESPStatus.ShowName = v
    end
})

ESPStatusBox:Toggle({
    Flag = "ShowDistance",
    Title = "Show Distance",
    Value = true,
    Callback = function(v)
        ESPStatus.ShowDistance = v
    end
})

ESPStatusBox:Toggle({
    Flag = "ShowHealth",
    Title = "Show Health",
    Value = false,
    Callback = function(v)
        ESPStatus.ShowHealth = v
    end
})



-- ================= CROSSHAIR =================
CrosshairBox:Toggle({
    Flag = "CrosshairEnabled",
    Title = "Enable Crosshair",
    Value = false,
    Callback = function(v)
        Crosshair.Enabled = v
    end
})

CrosshairBox:Colorpicker({
    Flag = "CrosshairColor",
    Title = "Crosshair Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(color)
        Crosshair.Color = color
    end
})

CrosshairBox:Dropdown({
    Flag = "Style",
    Title = "Style",
    Values = {"Plus","Dot","Circle"},
    Value = 1,
    Callback = function(v) Crosshair.Style = v end
})

CrosshairBox:Slider({
    Flag = "CrosshairPosX",
    Title = "Position X",
    Value = { Min = -100, Max = 100, Default = 0 },
    Step = 1,
    Callback = function(v)
        Crosshair.OffsetX = v
    end
})

CrosshairBox:Slider({
    Flag = "CrosshairPosY",
    Title = "Position Y",
    Value = { Min = -100, Max = 100, Default = 6 },
    Step = 1,
    Callback = function(v)
        Crosshair.OffsetY = v
    end
})



-- =============== PLAYER =================

AbilityTab:Toggle({
    Flag = "Skill",
    Title = "Auto Skill Check",
    Value = false,
    Callback = function(v)
        Auto.SkillCheck = v
        if v then startSkillCheck() end
    end
})

AbilityTab:Toggle({
    Flag = "GodMode",
    Title = "Anti KnockDown",
    Value = false,
    Callback = function(v)
        PlayerMods.GodMode = v
    end
})

AbilityTab:Toggle({
    Flag = "FastVault",
    Title = "Fast Vault",
    Value = false,
    Callback = function(v)
        FastVault.Enabled = v
    end
})

AbilityTab:Slider({
    Flag = "VaultSpeed",
    Title = "Animation Speed",
    Value = { Min = 1, Max = 5, Default = 1.2 },
    Step = 0.1,
    Callback = function(v)
        FastVault.Speed = v
    end
})

AbilityTab:Button({
    Title = "instan escape",
    Callback = function()
        teleportToFinishLine()
    end
})

KillerTab:Toggle({
    Flag = "AutoStalk",
    Title = "Auto Stalk",
    Value = false,
    Callback = function(v)
        AutoStalk.Enabled = v
        if v then
            startAutoStalk()
        else
            stopAutoStalk()
        end
    end
})

KillerTab:Slider({
    Flag = "AttackDelay",
    Title = "Attack Delay",
    Value = { Min = 0.1, Max = 1, Default = 0.45 },
    Step = 0.01,
    Callback = function(v)
        Killer.AttackDelay = v
    end
})

-- ================= MASKED POWER =================

KillerTab:Divider()
KillerTab:Dropdown({
    Flag = "MaskedPowerSelect",
    Title = "Select Power",
    Values = MaskedPowers,
    Value = 1,
    Callback = function(val)
        Masked.CurrentPower = val
    end
})

KillerTab:Button({
    Title = "Activate Power",
    Callback = function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
            and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
        
        if Event then
            Event:FireServer(Masked.CurrentPower)
        else
        end
    end
})

KillerTab:Button({
    Title = "Deactivate Power",
    Callback = function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
            and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
        
        if Event then
            Event:FireServer()
        else
        end
    end
})

ParryBox:Toggle({
    Flag = "AutoParry",
    Title = "Auto Parry",
    Value = false,
    Callback = function(v)
        Auto.Parry = v
        ParryRangeVisual.Enabled = v
    end
})

ParryBox:Colorpicker({
    Flag = "ParryRangeColor",
    Title = "Parry Range Color",
    Default = Color3.fromRGB(255, 80, 80),
    Callback = function(color)
        ParryRangeVisual.Color = color

        if ParryCircle then
            ParryCircle.Color = color
        end
    end
})

ParryBox:Toggle({
    Flag = "ShowParryRange",
    Title = "Show Parry Range",
    Value = true,
    Callback = function(Value)
        ParryRangeVisual.Enabled = Value
        
        if not Value and ParryCircle then
            ParryCircle:Destroy()
            ParryCircle = nil
        end
    end
})

ParryBox:Slider({
    Flag = "ParryDistance",
    Title = "Distance",
    Value = { Min = 5, Max = 20, Default = 15 },
    Step = 1,
    Callback = function(v)
        Auto.ParryDistance = v
    end
})

ParryBox:Slider({
    Flag = "FaceSensitivity",
    Title = "Face Sensitivity Killer",
    Value = { Min = -1, Max = 1, Default = 0.7 },
    Step = 0.01,
    Callback = function(v)
        Auto.FaceSensitivity = v
    end
})

AimlockBox:Toggle({
    Flag = "GunAimEnabled",
    Title = "Aim Lock",
    Value = false,
    Callback = function(v)
        GunAim.Enabled = v
    end
})

AimlockBox:Toggle({
    Flag = "GunAimMobileButton",
    Title = "Mobile Aim Button",
    Value = false,
    Callback = function(v)
        GunAim.MobileButton = v
        if v then
            createMobileAimButton()
        else
            removeMobileAimButton()
        end
    end
})

AimlockBox:Dropdown({
    Flag = "GunAimTarget",
    Title = "Target",
    Values = {
        "All",
        "Killer",
        "Survivor",
        "SCP"
    },
    Value = 1,
    Callback = function(v)
        GunAim.TargetMode = v
    end
})

AimlockBox:Toggle({
    Flag = "GunAimFOVCircle",
    Title = "FOV Circle",
    Value = false,
    Callback = function(v)
        GunAim.ShowFOVCircle = v
    end
})

AimlockBox:Dropdown({
    Flag = "GunAimPart",
    Title = "Aim Part",
    Values = {
        "Head",
        "HumanoidRootPart",
        "Torso"
    },
    Value = 2,
    Callback = function(Value)
        GunAim.AimPart = Value
    end
})
AimlockBox:Slider({
    Flag = "GunAimFOV",
    Title = "FOV",
    Value = { Min = 50, Max = 1000, Default = 250 },
    Step = 1,
    Callback = function(v)
        GunAim.FOV = v
    end
})

AimlockBox:Slider({
    Flag = "GunAimPredict",
    Title = "Prediction",
    Value = { Min = 0, Max = 1, Default = 0.12 },
    Step = 0.01,
    Callback = function(v)
        GunAim.PredictStrength = v
    end
})

-- ================= MOVEMENT =================

MovementBox:Toggle({
    Flag = "WalkSpeedToggle",
    Title = "Walk Speed",
    Value = false,
    Callback = function(v)
        Movement.WalkSpeedEnabled = v
        if v then
            applyWalkSpeed()
        else
            -- Kembalikan ke default
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

-- == AVATAR STEALER UI =================
MorphAvaBox:Input({
    Flag = "StealUsername",
    Title = "Target Username",
    Value = "",
    Placeholder = "Ketik username target...",
    Callback = function(val)
        AvatarStealer.TargetUsername = val
    end
})
MorphAvaBox:Button({
    Title = "Copy Avatar",
    Callback = function()
        copyAvatar(AvatarStealer.TargetUsername)
    end
})

MorphAvaBox:Button({
    Title = "Reset to Original Skin",
    Callback = function()
        resetAvatar()
    end
})

MorphAvaBox:Button({
    Title = "Save Current as Original",
    Callback = function()
        saveOriginalAppearance()
    end
})
-- ================= VISUAL =================
VisualBox:Toggle({
Flag = "Fullbright",
Title = "Fullbright",
Value = false,
Callback = function(v) 
Visual.Fullbright = v
applyVisual()
end
})

VisualBox:Toggle({
Flag = "NoShadow",
Title = "No Shadow",
Value = false,
Callback = function(v) Visual.NoShadow = v end
})

VisualBox:Toggle({
Flag = "LowGraphics",
Title = "Low Graphics",
Value = false,
Callback = function(v)
Visual.LowGraphics = v 
applyOptimization()
end
})

VisualBox:Toggle({
    Flag = "NoScreenEffects",
    Title = "No Screen Effects",
    Value = false,
    Callback = function(v)
        Visual.NoScreenEffects = v
        applyNoScreenEffects()
    end
})

VisualBox:Toggle({
Flag = "CleanSky",
Title = "Clean Sky",
Value = false,
Callback = function(v)
Visual.CleanSky = v 
applyOptimization()
end
})

ZoomBox:Toggle({
    Flag = "UnlimitedZoom",
    Title = "Unlimited Zoom Out",
    Value = false,
    Callback = function(v)
        CameraZoom.UnlimitedZoom = v
        applyUnlimitedZoom()
    end
})

ZoomBox:Slider({
    Flag = "MaxZoomDistance",
    Title = "Max Zoom Distance",
    Value = { Min = 100, Max = 5000, Default = 1000 },
    Step = 1,
    Callback = function(v)
        CameraZoom.MaxDistance = v
        if CameraZoom.UnlimitedZoom then
            applyUnlimitedZoom()
        end
    end
})

ZoomBox:Toggle({
    Flag = "CustomFOV",
    Title = "Custom FOV",
    Value = false,
    Callback = function(Value)
        CameraZoom.FOVEnabled = Value
        applyCameraFOV()
    end
})

ZoomBox:Slider({
    Flag = "CameraFOV",
    Title = "Camera FOV",
    Value = { Min = 40, Max = 120, Default = 70 },
    Step = 1,
    Callback = function(Value)
        CameraZoom.FOV = Value

        if CameraZoom.FOVEnabled then
            applyCameraFOV()
        end
    end
})


-- ================= CLOCK TIME & AMBIENT =================
TimeBox:Slider({
    Flag = "ClockTime",
    Title = "Clock Time",
    Value = { Min = 0, Max = 24, Default = 14 },
    Step = 1,
    Callback = function(v)
        Visual.ClockTime = v
        Visual.Ambient = true
        applyVisual()
    end
})

TimeBox:Slider({
    Flag = "Brightness",
    Title = "Brightness",
    Value = { Min = 0, Max = 5, Default = 2 },
    Step = 0.1,
    Callback = function(v)
        Visual.Brightness = v
        Visual.Ambient = true
        applyVisual()
    end
})

-- ============ UI SETTINGS ================
SettingBox:Dropdown({
    Flag = "NotificationSide",
    Values = { "Left", "Right" },
    Value = "Right",
    Title = "Notification Side",
    Callback = function(Value)
        WindUI:SetNotificationLower(Value == "Left")
    end,
})

SettingBox:Dropdown({
    Flag = "DPIDropdown",
    Values = { "50%", "75%", "85%", "100%", "125%", "150%" },
    Value = IsMobile and "100%" or "85%",
    Title = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        if DPI then
            Window:SetUIScale(DPI / 100)
        end
    end,
})

SettingBox:Toggle({
    Flag = "WatermarkToggle",
    Title = "Watermark",
    Value = true,
    Callback = function(Value)
        Watermark.Visible = Value
    end
})

SettingBox:Divider()

SettingBox:Button({
    Title = "Unload script",
    Callback = function()
        Window:Destroy()
    end
})

-- ====== THEME =================
local ThemeBox = Tabs.UISettings:Section({ Title = "Theme", Opened = true })

ThemeBox:Dropdown({
    Flag = "ThemeDropdown",
    Title = "Theme",
    Values = (function()
        local names = {}
        for name in pairs(WindUI:GetThemes()) do
            table.insert(names, name)
        end
        table.sort(names)
        return names
    end)(),
    Value = WindUI:GetCurrentTheme(),
    Callback = function(selected)
        WindUI:SetTheme(selected)
    end,
})

ThemeBox:Toggle({
    Flag = "Acrylic",
    Title = "Acrylic",
    Value = WindUI.Window and WindUI.Window.Acrylic or false,
    Callback = function()
        local isOn = WindUI.Window and WindUI.Window.Acrylic
        WindUI:ToggleAcrylic(not isOn)
    end,
})

ThemeBox:Toggle({
    Flag = "Transparent",
    Title = "Transparent",
    Value = WindUI:GetTransparency(),
    Callback = function(state)
        Window:ToggleTransparency(state)
    end,
})

ThemeBox:Keybind({
    Flag = "ToggleUIKey",
    Title = "Toggle UI Key",
    Value = Enum.KeyCode.RightShift,
    Callback = function(v)
        local key = typeof(v) == "EnumItem" and v or Enum.KeyCode[v]
        if key then
            Window:SetToggleKey(key)
        end
    end,
})

-- ====== CONFIG =================
local ConfigBox = Tabs.UISettings:Section({ Title = "Config", Opened = true })

do
    local ConfigManager = Window.ConfigManager
    local ConfigName = "default"

    if ConfigManager then
        local AllConfigs = ConfigManager:AllConfigs()

        local ConfigNameInput = ConfigBox:Input({
            Flag = "ConfigName",
            Title = "Config Name",
            Value = ConfigName,
            Callback = function(value)
                ConfigName = value ~= "" and value or ConfigName
            end,
        })

        local AllConfigsDropdown = ConfigBox:Dropdown({
            Flag = "AllConfigs",
            Title = "All Configs",
            Values = AllConfigs,
            Value = AllConfigs[1],
            AllowNone = true,
            Callback = function(value)
                if value and value ~= "" then
                    ConfigName = value
                    ConfigNameInput:Set(value)
                end
            end,
        })

        ConfigBox:Button({
            Title = "Save Config",
            Callback = function()
                Window.CurrentConfig = ConfigManager:Config(ConfigName)
                if Window.CurrentConfig:Save() then
                    WindUI:Notify({
                        Title = "Config Saved",
                        Content = ConfigName,
                        Duration = 3,
                    })
                end
                AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
            end,
        })

        ConfigBox:Button({
            Title = "Load Config",
            Callback = function()
                Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
                if Window.CurrentConfig:Load() then
                    WindUI:Notify({
                        Title = "Config Loaded",
                        Content = ConfigName,
                        Duration = 3,
                    })
                end
            end,
        })

        ConfigBox:Button({
            Title = "Delete Config",
            Callback = function()
                if not Window.CurrentConfig then
                    Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
                end
                local ok, err = Window.CurrentConfig:Delete()
                if ok then
                    WindUI:Notify({
                        Title = "Config Deleted",
                        Content = ConfigName,
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Failed to delete config",
                        Content = tostring(err),
                        Duration = 3,
                    })
                end
                AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
            end,
        })
    end
end
