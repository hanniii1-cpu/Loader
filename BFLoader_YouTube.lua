--[[
    BFLoader v2.5.3 - YouTube Universal Edition
    Works on: Xeno (PC), Delta (Mobile), Solara, Fluxus, KRNL, Arceus X
    Press RIGHT SHIFT to toggle GUI
    Repository: github.com/hanniii1-cpu/Loader
--]]

-- //===== UNIVERSAL COMPATIBILITY =====\\
local function safeWait(t)
    local ok, err = pcall(function() task.wait(t) end)
    if not ok then wait(t) end
end

local function safeSpawn(f)
    local ok, err = pcall(function() task.spawn(f) end)
    if not ok then spawn(f) end
end

-- Executor detection
local EXEC = "Unknown"
pcall(function() EXEC = identifyexecutor() end)
if EXEC == "Unknown" or EXEC == "" then
    pcall(function() EXEC = getexecutorname() end)
end
print("[BFLoader] Executor: " .. tostring(EXEC))

-- //===== SERVICES =====\\
local plr = game:GetService("Players").LocalPlayer
local pg = plr:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

-- //===== CONFIG =====\\
local CONFIG = {
    active = false,
    speed = 0.08,
    eggs = 0, rainbow = 0, golden = 0, shiny = 0, huge = 0, titanic = 0,
    hugeChance = 8,
    titanicChance = 0.5,
    rainbowChance = 20,
    goldenChance = 18,
    shinyChance = 12,
}

-- //===== PET DATABASE =====\\
local NORMAL = {
    "Cat","Dog","Bunny","Fox","Wolf","Bear","Tiger","Lion",
    "Dragon","Phoenix","Griffin","Unicorn","Pegasus","Kitsune","Wyvern",
    "Axolotl","Shark","Eagle","Monkey","Gorilla","Elephant","Rhino",
    "Cosmic Dragon","Atomic Axolotl","Diamond Griffin","Shadow Phoenix",
    "Crystal Unicorn","Storm Wolf","Void Dragon"
}

local HUGE = {
    "Huge Hell Rock","Huge Cat","Huge Dog","Huge Dragon","Huge Unicorn",
    "Huge Pixel Cat","Huge Angel Dog","Huge Pumpkin Cat","Huge Santa Paws",
    "Huge Grinch","Huge Chef Cat","Huge Jelly","Huge Axolotl",
    "Huge Balloon Dragon","Huge Party Cat","Huge Cosmic Axolotl",
    "Huge Atomic Axolotl","Huge Fireball Cat","Huge Storm Agony",
    "Huge Diamond Cat","Huge Peacock","Huge Kitsune","Huge Phoenix",
    "Huge Wyvern","Huge Kraken","Huge Yeti","Huge Manticore",
    "Huge Red Panda","Huge Corgi","Huge Husky","Huge Polar Bear"
}

local TITANIC = {
    "Titanic Hubert","Titanic Balloon Dragon","Titanic Jelly Cat",
    "Titanic Hippomelon","Titanic Nutcracker","Titanic Cat","Titanic Dog",
    "Titanic Dragon","Titanic Unicorn","Titanic Phoenix","Titanic Hydra",
    "Titanic Kitsune","Titanic Wyvern","Titanic Leviathan","Titanic Cosmic Dragon",
    "Titanic Atomic Axolotl","Titanic Diamond Griffin","Titanic Shadow Phoenix"
}

-- //===== CLEANUP =====\\
pcall(function() pg:FindFirstChild("BFLoaderGUI"):Destroy() end)
pcall(function() pg:FindFirstChild("BFLoadingScreen"):Destroy() end)

-- //===== LOADING SCREEN =====\\
local loadGui = Instance.new("ScreenGui")
loadGui.Name = "BFLoadingScreen"
loadGui.ResetOnSpawn = false
loadGui.Parent = pg

local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(1,0,1,0)
loadFrame.BackgroundColor3 = Color3.fromRGB(12,15,30)
loadFrame.BorderSizePixel = 0
loadFrame.Parent = loadGui

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(0,400,0,35)
loadTitle.Position = UDim2.new(0.5,-200,0.43,-17)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "BFLoader v2.5.3"
loadTitle.TextColor3 = Color3.fromRGB(255,255,255)
loadTitle.TextSize = 26
loadTitle.Font = Enum.Font.GothamBold
loadTitle.Parent = loadFrame

local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(0,400,0,22)
loadSub.Position = UDim2.new(0.5,-200,0.50,-11)
loadSub.BackgroundTransparency = 1
loadSub.Text = "YouTube Edition - Loading..."
loadSub.TextColor3 = Color3.fromRGB(140,150,195)
loadSub.TextSize = 13
loadSub.Font = Enum.Font.Gotham
loadSub.Parent = loadFrame

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0,280,0,6)
barBg.Position = UDim2.new(0.5,-140,0.55,-3)
barBg.BackgroundColor3 = Color3.fromRGB(35,40,65)
barBg.BorderSizePixel = 0
barBg.Parent = loadFrame

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(50,90,230)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barPct = Instance.new("TextLabel")
barPct.Size = UDim2.new(0,80,0,18)
barPct.Position = UDim2.new(0.5,-40,0.58,8)
barPct.BackgroundTransparency = 1
barPct.Text = "0%"
barPct.TextColor3 = Color3.fromRGB(180,190,220)
barPct.TextSize = 13
barPct.Font = Enum.Font.Gotham
barPct.Parent = loadFrame

-- Анимация загрузки
safeSpawn(function()
    local steps = {15,30,45,60,75,90,100}
    local texts = {
        "Optimizing...",
        "Loading pet database...",
        "Configuring Huge Hunter...",
        "Syncing egg data...",
        "Calibrating luck booster...",
        "Almost ready...",
        "Press Right Shift to open!"
    }
    for i, pct in pairs(steps) do
        barFill.Size = UDim2.new(pct/100,0,1,0)
        barPct.Text = pct.."%"
        loadSub.Text = texts[i]
        safeWait(0.35)
    end
    safeWait(0.8)
    loadGui:Destroy()
end)

-- //===== MAIN GUI =====\\
local gui = Instance.new("ScreenGui")
gui.Name = "BFLoaderGUI"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = pg

local main = Instance.new("Frame")
main.Size = UDim2.new(0,300,0,240)
main.Position = UDim2.new(0.5,-150,0.32,-120)
main.BackgroundColor3 = Color3.fromRGB(10,13,28)
main.BorderSizePixel = 0
main.Parent = gui

-- Top accent
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,4)
topBar.BackgroundColor3 = Color3.fromRGB(40,80,220)
topBar.BorderSizePixel = 0
topBar.Parent = main

-- Watermark
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(1,0,1,0)
watermark.BackgroundTransparency = 1
watermark.Text = "BFLOADER"
watermark.TextColor3 = Color3.fromRGB(14,18,36)
watermark.TextSize = 60
watermark.Font = Enum.Font.GothamBlack
watermark.Rotation = -15
watermark.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,24)
title.Position = UDim2.new(0,0,0,12)
title.BackgroundTransparency = 1
title.Text = "BFLOADER YT"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = main

local ver = Instance.new("TextLabel")
ver.Size = UDim2.new(1,0,0,14)
ver.Position = UDim2.new(0,0,0,35)
ver.BackgroundTransparency = 1
ver.Text = "v2.5.3 | Universal | " .. tostring(EXEC)
ver.TextColor3 = Color3.fromRGB(90,105,170)
ver.TextSize = 9
ver.Font = Enum.Font.Gotham
ver.Parent = main

-- Separator
local sep = Instance.new("Frame")
sep.Size = UDim2.new(0.85,0,0,1)
sep.Position = UDim2.new(0.075,0,0,52)
sep.BackgroundColor3 = Color3.fromRGB(30,38,70)
sep.BorderSizePixel = 0
sep.Parent = main

-- Stats
local statsText = Instance.new("TextLabel")
statsText.Size = UDim2.new(0.85,0,0,52)
statsText.Position = UDim2.new(0.075,0,0,58)
statsText.BackgroundTransparency = 1
statsText.Text = "🥚 Eggs: 0\n🌈 Rainbow: 0 | ⭐ Golden: 0\n💎 Shiny: 0 | 🌟 Huge: 0\n💜 Titanic: 0"
statsText.TextColor3 = Color3.fromRGB(175,185,215)
statsText.TextSize = 11
statsText.Font = Enum.Font.GothamMedium
statsText.TextWrapped = true
statsText.Parent = main

-- Status
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.85,0,0,16)
statusText.Position = UDim2.new(0.075,0,0,118)
statusText.BackgroundTransparency = 1
statusText.Text = "⚫ Status: Idle"
statusText.TextColor3 = Color3.fromRGB(150,160,195)
statusText.TextSize = 11
statusText.Font = Enum.Font.Gotham
statusText.Parent = main

-- Last pet
local lastText = Instance.new("TextLabel")
lastText.Size = UDim2.new(0.85,0,0,16)
statusText.Position = UDim2.new(0.075,0,0,136)
statusText.BackgroundTransparency = 1
statusText.Text = "Last: -"
statusText.TextColor3 = Color3.fromRGB(155,165,200)
statusText.TextSize = 11
statusText.Font = Enum.Font.Gotham
statusText.Parent = main

-- Button
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.55,0,0,36)
btn.Position = UDim2.new(0.225,0,0,190)
btn.BackgroundColor3 = Color3.fromRGB(18,30,80)
btn.BorderSizePixel = 0
btn.Text = "🔍 HUGE HUNTER: OFF"
btn.TextColor3 = Color3.fromRGB(195,205,235)
btn.TextSize = 12
btn.Font = Enum.Font.GothamBold
btn.AutoButtonColor = false
btn.Parent = main

-- //===== PET GENERATOR =====\\
local function getPet()
    local r = math.random(1,10000)
    
    if r <= CONFIG.titanicChance * 10 then
        CONFIG.titanic = CONFIG.titanic + 1
        return TITANIC[math.random(1,#TITANIC)], "Titanic"
    elseif r <= (CONFIG.titanicChance + CONFIG.hugeChance) * 10 then
        CONFIG.huge = CONFIG.huge + 1
        return HUGE[math.random(1,#HUGE)], "Huge"
    end
    
    local pet = NORMAL[math.random(1,#NORMAL)]
    local prefix = ""
    if math.random(1,100) <= CONFIG.shinyChance then prefix = "Shiny "; CONFIG.shiny = CONFIG.shiny + 1 end
    if math.random(1,100) <= CONFIG.rainbowChance then prefix = prefix .. "Rainbow "; CONFIG.rainbow = CONFIG.rainbow + 1 end
    if math.random(1,100) <= CONFIG.goldenChance then prefix = prefix .. "Golden "; CONFIG.golden = CONFIG.golden + 1 end
    
    return prefix .. pet, "Normal"
end

-- //===== UPDATE UI =====\\
local function update(petName, petType)
    CONFIG.eggs = CONFIG.eggs + 1
    statsText.Text = string.format("🥚 Eggs: %d\n🌈 Rainbow: %d | ⭐ Golden: %d\n💎 Shiny: %d | 🌟 Huge: %d\n💜 Titanic: %d",
        CONFIG.eggs, CONFIG.rainbow, CONFIG.golden, CONFIG.shiny, CONFIG.huge, CONFIG.titanic)
    lastText.Text = "Last: " .. petName
    
    if petType == "Titanic" then
        statusText.Text = "💜 TITANIC FOUND!"
        statusText.TextColor3 = Color3.fromRGB(200,100,255)
    elseif petType == "Huge" then
        statusText.Text = "🌟 HUGE FOUND!"
        statusText.TextColor3 = Color3.fromRGB(255,215,0)
    elseif petName:find("Rainbow") then
        statusText.Text = "🌈 Rainbow!"
        statusText.TextColor3 = Color3.fromRGB(150,255,255)
    elseif petName:find("Golden") then
        statusText.Text = "⭐ Golden!"
        statusText.TextColor3 = Color3.fromRGB(255,215,100)
    elseif petName:find("Shiny") then
        statusText.Text = "💎 Shiny!"
        statusText.TextColor3 = Color3.fromRGB(200,200,255)
    else
        statusText.Text = "🟢 Hatching..."
        statusText.TextColor3 = Color3.fromRGB(130,200,130)
    end
end

-- //===== HATCH LOOP =====\\
local function hatchLoop()
    while CONFIG.active do
        local petName, petType = getPet()
        
        -- Пробуем кликнуть на яйцо (опционально)
        pcall(function()
            for _, obj in pairs(WS:GetChildren()) do
                if obj.Name:lower():find("egg") and obj:IsA("Model") then
                    for _, child in pairs(obj:GetChildren()) do
                        if child:IsA("ProximityPrompt") then
                            fireproximityprompt(child)
                        end
                    end
                end
            end
        end)
        
        update(petName, petType)
        safeWait(CONFIG.speed)
    end
    statusText.Text = "⚫ Status: Idle"
    statusText.TextColor3 = Color3.fromRGB(150,160,195)
end

-- //===== BUTTON TOGGLE =====\\
btn.MouseButton1Click:Connect(function()
    CONFIG.active = not CONFIG.active
    if CONFIG.active then
        btn.Text = "🔍 HUGE HUNTER: ON"
        btn.BackgroundColor3 = Color3.fromRGB(20,60,140)
        btn.TextColor3 = Color3.fromRGB(255,220,80)
        safeSpawn(hatchLoop)
    else
        btn.Text = "🔍 HUGE HUNTER: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(18,30,80)
        btn.TextColor3 = Color3.fromRGB(195,205,235)
    end
end)

-- //===== RIGHT SHIFT TOGGLE =====\\
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- //===== TOUCH TOGGLE ДЛЯ ТЕЛЕФОНОВ (Delta) =====\\
-- Двойной тап по правому верхнему углу для открытия на телефонах
local lastTap = 0
UIS.TouchTap:Connect(function(touchPositions, processed)
    if processed then return end
    if #touchPositions == 0 then return end
    
    local pos = touchPositions[1].Position
    local screenSize = UIS:GetMouseLocation()
    
    -- Если тап в правом верхнем углу (последние 15% экрана по X и первые 15% по Y)
    pcall(function()
        local viewport = WS.CurrentCamera.ViewportSize
        if pos.X > viewport.X * 0.85 and pos.Y < viewport.Y * 0.15 then
            local now = tick()
            if now - lastTap < 0.4 then
                gui.Enabled = not gui.Enabled
            end
            lastTap = now
        end
    end)
end)

print("[BFLoader] YouTube Universal Edition loaded! Right Shift or double-tap top-right to open.")
print("[BFLoader] Executor: " .. tostring(EXEC))
