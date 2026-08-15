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

local Moonwalk = {
Enabled = false,
SpamSpeed = 30,
Intensity = 35,
SlowSpeed = 13,
UseSlow = true
}

local MoonwalkSmoothYaw = 0

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

print("[zryx] Script loaded! Press Right Shift to open menu.")
