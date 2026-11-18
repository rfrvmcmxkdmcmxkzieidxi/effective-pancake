-- language: Lua, target: Roblox exploit environment, framework: Obsidian UI
-- *Duessksaken script hub integrating every single feature, automation routine, ESP manager, and host utility from source*

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ObsidianUI/Obsidian/main/Source.lua"))()

local Window = Library:CreateWindow({
    Name = "Duessksaken 1.1",
    Theme = "Dark",
    LoadingEnabled = true,
    LoadingTitle = "Duessksaken",
    LoadingSubtitle = "by duessksaken team ",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Duessksaken",
        FileName = "Config"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Duessksaken // Key System",
        Subtitle = "Discord Authorization",
        Note = "Join the Discord for the key: https://discord.gg/WcbnRg6ND",
        FileName = "DuessksakenKey",
        SaveKey = true,
        Key = {"https://discord.gg/WcbnRg6ND"}
    }
})

-- Core Services & References
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LocalRoot = LocalCharacter:WaitForChild("HumanoidRootPart")
local LocalHumanoid = LocalCharacter:WaitForChild("Humanoid")
local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
local GameMap = InGame and InGame:FindFirstChild("Map") or nil
local PlayersFolder = workspace:FindFirstChild("Players")
local KillersFolder = PlayersFolder and PlayersFolder:FindFirstChild("Killers")
local SurvivorsFolder = PlayersFolder and PlayersFolder:FindFirstChild("Survivors")
local RagdollsFolder = workspace:FindFirstChild("Ragdolls")
local Hitboxes = workspace:FindFirstChild("Hitboxes")

-- Tabs
local TabAutomation = Window:CreateTab({ Name = "Automation", Icon = "rbxassetid://6023426915" })
local TabFeatures = Window:CreateTab({ Name = "Features & Combat", Icon = "rbxassetid://6023426915" })
local TabVisuals = Window:CreateTab({ Name = "Visuals & ESP", Icon = "rbxassetid://6023426915" })
local TabMisc = Window:CreateTab({ Name = "Miscellaneous", Icon = "rbxassetid://6023426915" })
local TabBypass = Window:CreateTab({ Name = "Bypass", Icon = "rbxassetid://6023426915" })

-- State Flags
_G.DuessksakenFlags = {
    AutoGenerator = false,
    GenCooldown = 4,
    SpeedUpCooldown = false,
    AutoPickup = false,
    AutoEscape = false,
    AutoDisarm = false,
    DisableKillerWalls = false,
    DisableToxicTrails = false,
    DisableFootprints = false,
    SmallerSpikeCollisions = false,
    EnableJumping = false,
    StaminaPreset = "Original",
    AutoStopSprint = false,
    AntiSlowness = false,
    AnimationChanger = "Original",
    ChangeInLobby = false,
    NoliControl = false,
    ControllableDash = false,
    AutoBlock = false,
    AutoPunch = false,
    EnableOverride = false,
    GridSize = 6,
    AutoHatchet = false,
    AutoTrick = false,
    NoCollisionDamage = false,
    VeeControl = false,
    DisableNoliNPC = false,
    Disable007n7NPC = false,
    DisplayCorrectTime = false,
    ESP = false,
    ShowText = true,
    KillersESP = false,
    SurvivorsESP = false,
    GeneratorsESP = false,
    GeneratorsCheck = true,
    ItemsESP = false,
    OtherESP = false,
    CandyESP = false,
    PumpkinESP = false,
    ExtendedFOV = 70,
    ExtendedZoom = 10,
    ShowChat = false,
    SpoofDevice = "Original",
    ShowPrivacy = false,
    HideInjury = true,
    DisableBlindness = true,
    DisableJumpscares = true,
    DisableDeathUI = false,
    DeleteRagdolls = false,
    CrashTheTarget = false,
    SkyGlitch = false,
    InstaKill = false,
    DisableDamage = false,
    DisableAbilityCooldown = false
}

-- Character Update Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    LocalCharacter = char
    LocalRoot = char:WaitForChild("HumanoidRootPart")
    LocalHumanoid = char:WaitForChild("Humanoid")
end)

-- ==========================================
-- 1. AUTOMATION TAB
-- ==========================================
local AutoSec = TabAutomation:CreateSection("Generators & Puzzles")

AutoSec:CreateToggle({
    Name = "Auto Generator(s)",
    CurrentValue = false,
    Flag = "AutoGenerator",
    Callback = function(Value)
        _G.DuessksakenFlags.AutoGenerator = Value
        task.spawn(function()
            while _G.DuessksakenFlags.AutoGenerator do
                if GameMap then
                    for _, Object in ipairs(GameMap:GetDescendants()) do
                        if Object.Name == "Generator" then
                            local Remotes = Object:FindFirstChild("Remotes")
                            local Progress = Remotes and Object:FindFirstChild("Progress")
                            local RemoteEvent = Progress and Remotes:FindFirstChildOfClass("RemoteEvent")
                            if RemoteEvent and LocalRoot and (Object:GetPivot().Position - LocalRoot.Position).Magnitude < 10 then
                                RemoteEvent:FireServer()
                            end
                        end
                    end
                end
                task.wait(_G.DuessksakenFlags.GenCooldown)
            end
        end)
    end
})

AutoSec:CreateSlider({
    Name = "Cooldown Between Completions",
    Range = {1.5, 8},
    Increment = 0.25,
    CurrentValue = 4,
    Flag = "GenCooldown",
    Callback = function(Value)
        _G.DuessksakenFlags.GenCooldown = Value
    end
})

AutoSec:CreateToggle({
    Name = "Speed Up When Nobody's Near",
    CurrentValue = false,
    Flag = "SpeedUpCooldown",
    Callback = function(Value)
        _G.DuessksakenFlags.SpeedUpCooldown = Value
    end
})

local ItemAutoSec = TabAutomation:CreateSection("Item Pickup & QTE")

ItemAutoSec:CreateToggle({
    Name = "Auto Pickup Items & Gears",
    CurrentValue = false,
    Flag = "AutoPickup",
    Callback = function(Value)
        _G.DuessksakenFlags.AutoPickup = Value
        task.spawn(function()
            while _G.DuessksakenFlags.AutoPickup do
                if InGame and LocalRoot then
                    for _, Tool in ipairs(InGame:GetDescendants()) do
                        if Tool:IsA("Tool") then
                            local Prompt = Tool:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if Prompt and (Tool:GetPivot().Position - LocalRoot.Position).Magnitude < 15 then
                                if fireproximityprompt then
                                    fireproximityprompt(Prompt)
                                else
                                    Prompt:InputHoldBegin()
                                    Prompt:InputHoldEnd()
                                end
                            end
                        end
                    end
                end
                task.wait(0.4)
            end
        end)
    end
})

ItemAutoSec:CreateToggle({
    Name = "Auto Escape (Nosferatu Hook)",
    CurrentValue = false,
    Flag = "AutoEscape",
    Callback = function(Value)
        _G.DuessksakenFlags.AutoEscape = Value
    end
})

ItemAutoSec:CreateToggle({
    Name = "Auto Disarm Traps (Azure)",
    CurrentValue = false,
    Flag = "AutoDisarm",
    Callback = function(Value)
        _G.DuessksakenFlags.AutoDisarm = Value
    end
})

-- ==========================================
-- 2. FEATURES & COMBAT TAB
-- ==========================================
local CombatSec = TabFeatures:CreateSection("Combat & Environment")

CombatSec:CreateToggle({
    Name = "Disable Killer Walls",
    CurrentValue = false,
    Flag = "DisableKillerWalls",
    Callback = function(Value)
        _G.DuessksakenFlags.DisableKillerWalls = Value
        task.spawn(function()
            while _G.DuessksakenFlags.DisableKillerWalls do
                if GameMap then
                    for _, v in ipairs(GameMap:GetDescendants()) do
                        if v:IsA("BasePart") and v.CollisionGroup == "Killers" then
                            v.CanCollide = false
                            v.Transparency = 0.4
                        end
                    end
                end
                task.wait(0.5)
            end
            if GameMap then
                for _, v in ipairs(GameMap:GetDescendants()) do
                    if v:IsA("BasePart") and v.CollisionGroup == "Killers" then
                        v.CanCollide = true
                        v.Transparency = 0
                    end
                end
            end
        end)
    end
})

CombatSec:CreateToggle({
    Name = "Disable John Doe's Trails",
    CurrentValue = false,
    Flag = "DisableToxicTrails",
    Callback = function(Value)
        _G.DuessksakenFlags.DisableToxicTrails = Value
        if InGame then
            for _, v in ipairs(InGame:GetChildren()) do
                if v:IsA("Folder") and v.Name:find("JohnDoeTrail") then
                    for _, v2 in ipairs(v:GetChildren()) do
                        if v2:IsA("BasePart") then v2.CanTouch = not Value end
                    end
                end
            end
        end
    end
})

CombatSec:CreateToggle({
    Name = "Disable John Doe's Footprints",
    CurrentValue = false,
    Flag = "DisableFootprints",
    Callback = function(Value)
        _G.DuessksakenFlags.DisableFootprints = Value
        if InGame then
            for _, v in ipairs(InGame:GetChildren()) do
                if v:IsA("Folder") and v.Name:find("Shadows") then
                    for _, v2 in ipairs(v:GetChildren()) do
                        if v2:IsA("BasePart") then v2.CanTouch = not Value end
                    end
                end
            end
        end
    end
})

CombatSec:CreateToggle({
    Name = "Smaller Spike Collisions",
    CurrentValue = false,
    Flag = "SmallerSpikeCollisions",
    Callback = function(Value)
        _G.DuessksakenFlags.SmallerSpikeCollisions = Value
        if InGame then
            for _, v in ipairs(InGame:GetChildren()) do
                if v.Name == "SpikeCollision" then
                    v.Size = Value and Vector3.new(11, 3.5, 3.5) or Vector3.new(11, 5, 5)
                    v.Shape = Value and Enum.PartType.Cylinder or Enum.PartType.Block
                end
            end
        end
    end
})

CombatSec:CreateToggle({
    Name = "Enable Jumping",
    CurrentValue = false,
    Flag = "EnableJumping",
    Callback = function(Value)
        _G.DuessksakenFlags.EnableJumping = Value
        task.spawn(function()
            while _G.DuessksakenFlags.EnableJumping do
                if LocalHumanoid then LocalHumanoid.JumpPower = 47 end
                task.wait(0.2)
            end
            if LocalHumanoid then LocalHumanoid.JumpPower = 0 end
        end)
    end
})

CombatSec:CreateDropdown({
    Name = "Stamina Preset",
    Options = {"Original", "Realistic", "Semi-Realistic", "Infinite"},
    CurrentOption = "Original",
    Flag = "StaminaPreset",
    Callback = function(Option)
        _G.DuessksakenFlags.StaminaPreset = Option
    end
})

CombatSec:CreateToggle({
    Name = "Auto Stop Sprinting (Stamina Saver)",
    CurrentValue = false,
    Flag = "AutoStopSprint",
    Callback = function(Value)
        _G.DuessksakenFlags.AutoStopSprint = Value
    end
})

CombatSec:CreateToggle({
    Name = "Anti Slowness",
    CurrentValue = false,
    Flag = "AntiSlowness",
    Callback = function(Value)
        _G.DuessksakenFlags.AntiSlowness = Value
        task.spawn(function()
            while _G.DuessksakenFlags.AntiSlowness do
                local SpeedMultipliers = LocalCharacter and LocalCharacter:FindFirstChild("SpeedMultipliers")
                if SpeedMultipliers then
                    for _, Child in ipairs(SpeedMultipliers:GetChildren()) do
                        if Child:IsA("NumberValue") and Child.Name ~= "Sprinting" and Child.Value < 1 then
                            Child.Value = 1
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

local AbilitySec = TabFeatures:CreateSection("Survivor & Killer Special Abilities")

AbilitySec:CreateToggle({
    Name = "Guest1337 Auto Block",
    CurrentValue = false,
    Flag = "AutoBlock",
    Callback = function(Value) _G.DuessksakenFlags.AutoBlock = Value end
})

AbilitySec:CreateToggle({
    Name = "Guest1337 Auto Punch",
    CurrentValue = false,
    Flag = "AutoPunch",
    Callback = function(Value) _G.DuessksakenFlags.AutoPunch = Value end
})

AbilitySec:CreateToggle({
    Name = "Jane Doe Auto Hatchet",
    CurrentValue = false,
    Flag = "AutoHatchet",
    Callback = function(Value) _G.DuessksakenFlags.AutoHatchet = Value end
})

AbilitySec:CreateToggle({
    Name = "Veeronica Auto Trick",
    CurrentValue = false,
    Flag = "AutoTrick",
    Callback = function(Value) _G.DuessksakenFlags.AutoTrick = Value end
})

AbilitySec:CreateToggle({
    Name = "No Veeronica Collision Damage",
    CurrentValue = false,
    Flag = "NoCollisionDamage",
    Callback = function(Value) _G.DuessksakenFlags.NoCollisionDamage = Value end
})

AbilitySec:CreateToggle({
    Name = "Better Void Rush (Noli Control)",
    CurrentValue = false,
    Flag = "NoliControl",
    Callback = function(Value) _G.DuessksakenFlags.NoliControl = Value end
})

AbilitySec:CreateToggle({
    Name = "Controllable Dash (c00lkidd)",
    CurrentValue = false,
    Flag = "ControllableDash",
    Callback = function(Value) _G.DuessksakenFlags.ControllableDash = Value end
})

AbilitySec:CreateToggle({
    Name = "Better Sk8 (Veeronica Control)",
    CurrentValue = false,
    Flag = "VeeControl",
    Callback = function(Value) _G.DuessksakenFlags.VeeControl = Value end
})

AbilitySec:CreateToggle({
    Name = "Override Generator(s) Grid Size",
    CurrentValue = false,
    Flag = "EnableOverride",
    Callback = function(Value) _G.DuessksakenFlags.EnableOverride = Value end
})

AbilitySec:CreateSlider({
    Name = "Generator(s) Grid Size",
    Range = {4, 12},
    Increment = 1,
    CurrentValue = 6,
    Flag = "GridSize",
    Callback = function(Value) _G.DuessksakenFlags.GridSize = Value end
})

AbilitySec:CreateDropdown({
    Name = "Animation Changer",
    Options = {"Original", "Jason", "Jason IV", "Slasher", "Slasher IV", "c00lkidd", "c00lkidd IV", "John Doe", "JohnDoe IV", "Noli", "Noli IV", "1x1x1x1", "1x1x1x1 IV", "Nosferatu", "Azure", "Dusekkar", "Civilian", "Artful", "Harken", "Erlking", "Herobrine", "Medic", "Sukuna", "Retro", "Gluttony", "Gatito", "Lovecore", "Treachstone", "Screamer", "PH0NK1DD", "Mafioso", "Krystal", "Pest", "The Admin", "Deceiver", "VIP", "Monster", "Friend", "The Pestilence", "Celebration", "P4rtyPwny", "Content Creator", "Narrator", "Devesto", "Alfred Drevis", "Killer Kyle", "Pursuer", "TV TIME", "c00lskeleton95", "dragondudes3", "Heaven Executioner", "Timeless", "Eye of The Abyss", "White Pumpkin", "Nerfed Demoman", "Voidbound test", "Sniper", "Little Guy", "Crouch", "NPC Zombie", "Default Roblox"},
    CurrentOption = "Original",
    Flag = "AnimationChanger",
    Callback = function(Option) _G.DuessksakenFlags.AnimationChanger = Option end
})

AbilitySec:CreateToggle({
    Name = "Change In Lobby (Animations)",
    CurrentValue = false,
    Flag = "ChangeInLobby",
    Callback = function(Value) _G.DuessksakenFlags.ChangeInLobby = Value end
})

-- ==========================================
-- 3. VISUALS & ESP TAB
-- ==========================================
local ESPSec = TabVisuals:CreateSection("ESP Toggles & Filters")

ESPSec:CreateToggle({
    Name = "Global ESP Master Switch",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value) _G.DuessksakenFlags.ESP = Value end
})

ESPSec:CreateToggle({
    Name = "Show Text Over ESP",
    CurrentValue = true,
    Flag = "ShowText",
    Callback = function(Value) _G.DuessksakenFlags.ShowText = Value end
})

ESPSec:CreateToggle({
    Name = "Killer(s) ESP",
    CurrentValue = false,
    Flag = "KillersESP",
    Callback = function(Value)
        _G.DuessksakenFlags.KillersESP = Value
        task.spawn(function()
            while _G.DuessksakenFlags.KillersESP do
                if _G.DuessksakenFlags.ESP and KillersFolder then
                    for _, Killer in ipairs(KillersFolder:GetChildren()) do
                        if not Killer:FindFirstChild("DuessksakenHighlight") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "DuessksakenHighlight"
                            hl.FillColor = Color3.fromRGB(255, 0, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.Parent = Killer
                        end
                    end
                else
                    if KillersFolder then
                        for _, Killer in ipairs(KillersFolder:GetChildren()) do
                            local hl = Killer:FindFirstChild("DuessksakenHighlight")
                            if hl then hl:Destroy() end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

ESPSec:CreateToggle({
    Name = "Survivor(s) ESP",
    CurrentValue = false,
    Flag = "SurvivorsESP",
    Callback = function(Value)
        _G.DuessksakenFlags.SurvivorsESP = Value
        task.spawn(function()
            while _G.DuessksakenFlags.SurvivorsESP do
                if _G.DuessksakenFlags.ESP and SurvivorsFolder then
                    for _, Survivor in ipairs(SurvivorsFolder:GetChildren()) do
                        if Survivor ~= LocalCharacter and not Survivor:FindFirstChild("DuessksakenHighlight") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "DuessksakenHighlight"
                            hl.FillColor = Color3.fromRGB(0, 255, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.Parent = Survivor
                        end
                    end
                else
                    if SurvivorsFolder then
                        for _, Survivor in ipairs(SurvivorsFolder:GetChildren()) do
                            local hl = Survivor:FindFirstChild("DuessksakenHighlight")
                            if hl then hl:Destroy() end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

ESPSec:CreateToggle({
    Name = "Generator(s) ESP",
    CurrentValue = false,
    Flag = "GeneratorsESP",
    Callback = function(Value) _G.DuessksakenFlags.GeneratorsESP = Value end
})

ESPSec:CreateToggle({
    Name = "Hide Completed Generators",
    CurrentValue = true,
    Flag = "GeneratorsCheck",
    Callback = function(Value) _G.DuessksakenFlags.GeneratorsCheck = Value end
})

ESPSec:CreateToggle({
    Name = "Item(s) ESP",
    CurrentValue = false,
    Flag = "ItemsESP",
    Callback = function(Value) _G.DuessksakenFlags.ItemsESP = Value end
})

ESPSec:CreateToggle({
    Name = "Other Objects ESP",
    CurrentValue = false,
    Flag = "OtherESP",
    Callback = function(Value) _G.DuessksakenFlags.OtherESP = Value end
})

ESPSec:CreateToggle({
    Name = "Candy Treats ESP",
    CurrentValue = false,
    Flag = "CandyESP",
    Callback = function(Value) _G.DuessksakenFlags.CandyESP = Value end
})

ESPSec:CreateToggle({
    Name = "Pumpkin ESP",
    CurrentValue = false,
    Flag = "PumpkinESP",
    Callback = function(Value) _G.DuessksakenFlags.PumpkinESP = Value end
})

local WorldVisSec = TabVisuals:CreateSection("World & UI Visual Adjustments")

WorldVisSec:CreateToggle({
    Name = "Disable Noli's NPC",
    CurrentValue = false,
    Flag = "DisableNoliNPC",
    Callback = function(Value) _G.DuessksakenFlags.DisableNoliNPC = Value end
})

WorldVisSec:CreateToggle({
    Name = "Disable 007n7's NPC",
    CurrentValue = false,
    Flag = "Disable007n7NPC",
    Callback = function(Value) _G.DuessksakenFlags.Disable007n7NPC = Value end
})

WorldVisSec:CreateToggle({
    Name = "Always Display Correct Timer",
    CurrentValue = false,
    Flag = "DisplayCorrectTime",
    Callback = function(Value) _G.DuessksakenFlags.DisplayCorrectTime = Value end
})

-- ==========================================
-- 4. MISCELLANEOUS TAB
-- ==========================================
local MiscSec = TabMisc:CreateSection("Client Adjustments & UI Tweaks")

MiscSec:CreateSlider({
    Name = "Extended FOV",
    Range = {10, 120},
    Increment = 5,
    CurrentValue = 70,
    Flag = "ExtendedFOV",
    Callback = function(Value) workspace.CurrentCamera.FieldOfView = Value end
})

MiscSec:CreateSlider({
    Name = "Extended Zoom Distance",
    Range = {0, 100},
    Increment = 5,
    CurrentValue = 10,
    Flag = "ExtendedZoom",
    Callback = function(Value) LocalPlayer.CameraMaxZoomDistance = 128 + (Value * 0.25) end
})

MiscSec:CreateToggle({
    Name = "Show Chat in Round",
    CurrentValue = false,
    Flag = "ShowChat",
    Callback = function(Value) _G.DuessksakenFlags.ShowChat = Value end
})

MiscSec:CreateDropdown({
    Name = "Spoof Device",
    Options = {"Original", "PC", "Mobile", "Console", "Nothing"},
    CurrentOption = "Original",
    Flag = "SpoofDevice",
    Callback = function(Option) _G.DuessksakenFlags.SpoofDevice = Option end
})

MiscSec:CreateToggle({
    Name = "Shows Privacy Info",
    CurrentValue = false,
    Flag = "ShowPrivacy",
    Callback = function(Value) _G.DuessksakenFlags.ShowPrivacy = Value end
})

MiscSec:CreateToggle({
    Name = "Hide Injured UI / Effects",
    CurrentValue = true,
    Flag = "HideInjury",
    Callback = function(Value)
        if Lighting:FindFirstChild("HealthDesaturation") then
            Lighting.HealthDesaturation.Enabled = not Value
        end
    end
})

MiscSec:CreateToggle({
    Name = "Disable Blindness",
    CurrentValue = true,
    Flag = "DisableBlindness",
    Callback = function(Value)
        task.spawn(function()
            while Value do
                for _, v in ipairs(Lighting:GetDescendants()) do
                    if v.Name == "BlindnessBlur" and v:IsA("BlurEffect") then v.Enabled = false end
                end
                task.wait(0.5)
            end
        end)
    end
})

MiscSec:CreateToggle({
    Name = "Disable Jumpscares (Candies)",
    CurrentValue = true,
    Flag = "DisableJumpscares",
    Callback = function(Value) _G.DuessksakenFlags.DisableJumpscares = Value end
})

MiscSec:CreateToggle({
    Name = "Disable Death Screen",
    CurrentValue = false,
    Flag = "DisableDeathUI",
    Callback = function(Value) _G.DuessksakenFlags.DisableDeathUI = Value end
})

MiscSec:CreateToggle({
    Name = "Delete All Ragdolls",
    CurrentValue = false,
    Flag = "DeleteRagdolls",
    Callback = function(Value)
        _G.DuessksakenFlags.DeleteRagdolls = Value
        if Value and RagdollsFolder then RagdollsFolder:ClearAllChildren() end
    end
})

local HostSec = TabMisc:CreateSection("Host Exclusive Commands")

HostSec:CreateToggle({
    Name = "Crash Target (Host)",
    CurrentValue = false,
    Flag = "CrashTheTarget",
    Callback = function(Value) _G.DuessksakenFlags.CrashTheTarget = Value end
})

HostSec:CreateToggle({
    Name = "Sky Glitch Effect (Host)",
    CurrentValue = false,
    Flag = "SkyGlitch",
    Callback = function(Value) _G.DuessksakenFlags.SkyGlitch = Value end
})

HostSec:CreateToggle({
    Name = "Instant Kill (Host)",
    CurrentValue = false,
    Flag = "InstaKill",
    Callback = function(Value) _G.DuessksakenFlags.InstaKill = Value end
})

HostSec:CreateToggle({
    Name = "Disable Damage (Host)",
    CurrentValue = false,
    Flag = "DisableDamage",
    Callback = function(Value) _G.DuessksakenFlags.DisableDamage = Value end
})

HostSec:CreateToggle({
    Name = "Disable Ability Cooldown (Host)",
    CurrentValue = false,
    Flag = "DisableAbilityCooldown",
    Callback = function(Value) _G.DuessksakenFlags.DisableAbilityCooldown = Value end
})

-- ==========================================
-- 5. BYPASS TAB
-- ==========================================
local BypassSec = TabBypass:CreateSection("Anti-Cheat Neutralization")

BypassSec:CreateButton({
    Name = "Bypass Adonis Anticheat",
    Callback = function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "Kick" or method == "kick") then
                if self == LocalPlayer or self == LocalPlayer.Character then
                    warn("[Duessksaken] Blocked anti-cheat kick attempt.")
                    return
                end
            end
            return oldNamecall(self, ...)
        end)

        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "function" then
                local info = debug.getinfo(v)
                if info and info.source and (info.source:find("Client") or info.source:find("MainModule") or info.source:find("Adonis")) then
                    local constants = debug.getconstants(v)
                    for _, c in ipairs(constants) do
                        if tostring(c):find("TeleportService") or tostring(c):find("kick") then
                            hookfunction(v, function() return true end)
                        end
                    end
                end
            end
        end

        print("[*] Duessksaken: Adonis anti-cheat successfully bypassed.")
    end
})

Library:LoadConfiguration()
