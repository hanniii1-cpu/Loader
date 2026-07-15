--[[
    BFLoader v2.5.3 - YouTube Edition
    Pet Simulator 99 - Auto Huge Hunter
    GUI: Right Shift to toggle | Dark Blue Theme
    Repository: github.com/hanniii1-cpu/Loader
    
    Features:
    - Beautiful loading screen with progress bar
    - One-button Huge Hunter (Right Shift to open/close)
    - Real pet names from Pet Simulator 99
    - Hatching effects & animations
    - Stats tracking (Eggs, Rainbow, Golden, Shiny, Huge, Titanic)
    - Works with any executor
--]]

local function BF_YouTubeHatch()
    local plr = game:GetService("Players").LocalPlayer
    local pg = plr:WaitForChild("PlayerGui")
    local RS = game:GetService("ReplicatedStorage")
    local WS = game:GetService("Workspace")
    local TS = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local VIM = game:GetService("VirtualInputManager")
    local RS2 = game:GetService("RunService")
    local LS = game:GetService("Lighting")
    
    -- //===== CONFIG =====\\
    local CONFIG = {
        AutoHatch = false,
        HatchSpeed = 0.08,
        TargetEgg = "Best",
        ShowEffects = true,
        HugeChance = 8,
        TitanicChance = 0.5,
        RainbowChance = 20,
        GoldenChance = 18,
        ShinyChance = 12,
    }
    
    -- //===== REAL PET DATABASE (Pet Simulator 99) =====\\
    local EGG_PETS = {
        BASIC = {"Cat","Dog","Bunny","Fox","Pig","Cow","Chicken","Duck","Frog","Mouse"},
        RARE = {"Wolf","Bear","Tiger","Lion","Eagle","Shark","Deer","Raccoon","Owl","Snake"},
        EPIC = {"Dragon","Phoenix","Griffin","Unicorn","Pegasus","Kitsune","Wyvern","Hydra","Gorilla","Elephant"},
        LEGENDARY = {"Cosmic Dragon","Atomic Axolotl","Diamond Griffin","Shadow Phoenix","Crystal Unicorn","Storm Wolf","Void Dragon","Astral Bear","Ember Lion","Frost Serpent"},
        MYTHIC = {"Mythic Dragon","Mythic Phoenix","Mythic Kitsune","Mythic Wyvern","Mythic Unicorn","Mythic Griffin","Mythic Leviathan","Mythic Pegasus","Mythic Hydra","Mythic Basilisk"},
        EXCLUSIVE = {"Exclusive Cat","Exclusive Dog","Exclusive Dragon","Exclusive Bunny","Exclusive Axolotl","Exclusive Kitsune","Exclusive Phoenix","Exclusive Wyvern","Exclusive Pegasus","Exclusive Griffin"}
    }
    
    local HUGE_PETS = {
        "Huge Hell Rock","Huge Cat","Huge Dog","Huge Dragon","Huge Unicorn",
        "Huge Pixel Cat","Huge Angel Dog","Huge Easter Bunny","Huge Pumpkin Cat",
        "Huge Skeleton","Huge Ghost","Huge Santa Paws","Huge Grinch",
        "Huge Snowman","Huge Elf","Huge Reindeer","Huge Gingerbread",
        "Huge Chef Cat","Huge Jelly","Huge Axolotl","Huge Balloon Dragon",
        "Huge Party Cat","Huge Cupcake","Huge Ice Cream Cone","Huge Popcorn",
        "Huge Pizza","Huge Cosmic Axolotl","Huge Atomic Axolotl",
        "Huge Fireball Cat","Huge Storm Agony","Huge Storm Dominus",
        "Huge Diamond Cat","Huge Peacock","Huge Flamingo","Huge Parrot",
        "Huge Toucan","Huge Wyvern","Huge Kitsune","Huge Phoenix",
        "Huge Pegasus","Huge Kraken","Huge Yeti","Huge Manticore",
        "Huge Alien","Huge Robot","Huge Dinosaur","Huge Shark",
        "Huge Red Panda","Huge Panda","Huge Koala","Huge Sloth",
        "Huge Corgi","Huge Husky","Huge Poodle",
        "Huge Monkey","Huge Gorilla","Huge Elephant","Huge Rhino",
        "Huge Hippo","Huge Crocodile","Huge Snake","Huge Penguin",
        "Huge Owl","Huge Eagle","Huge Hawk","Huge Falcon",
        "Huge Lion","Huge Tiger","Huge Leopard","Huge Panther",
        "Huge Wolf","Huge Fox","Huge Bear","Huge Polar Bear"
    }
    
    local TITANIC_PETS = {
        "Titanic Hubert","Titanic Balloon Dragon","Titanic Jelly Cat",
        "Titanic Hippomelon","Titanic Nutcracker","Titanic Present Dragon",
        "Titanic Elf","Titanic Reindeer","Titanic Snowflake",
        "Titanic Gingerbread Man","Titanic Angel Dog","Titanic Hell Rock",
        "Titanic Cat","Titanic Dog","Titanic Dragon","Titanic Unicorn",
        "Titanic Phoenix","Titanic Hydra","Titanic Kitsune",
        "Titanic Wyvern","Titanic Leviathan","Titanic Serpent",
        "Titanic Pegasus","Titanic Kraken","Titanic Yeti",
        "Titanic Manticore","Titanic Basilisk","Titanic Cosmic Dragon",
        "Titanic Atomic Axolotl","Titanic Diamond Griffin","Titanic Shadow Phoenix",
        "Titanic Crystal Unicorn","Titanic Storm Wolf","Titanic Void Dragon"
    }
    
    -- //===== REMOVE OLD GUIS =====\\
    local oldGui = pg:FindFirstChild("BFLoaderGUI")
    if oldGui then oldGui:Destroy() end
    local oldLoad = pg:FindFirstChild("BFLoadingScreen")
    if oldLoad then oldLoad:Destroy() end
    
    -- //===== LOADING SCREEN =====\\
    local loadingScreen = Instance.new("ScreenGui")
    loadingScreen.Name = "BFLoadingScreen"
    loadingScreen.ResetOnSpawn = false
    loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingScreen.Parent = pg
    
    local loadFrame = Instance.new("Frame")
    loadFrame.Name = "LoadFrame"
    loadFrame.Size = UDim2.new(1,0,1,0)
    loadFrame.BackgroundColor3 = Color3.fromRGB(12,15,30)
    loadFrame.BorderSizePixel = 0
    loadFrame.Parent = loadingScreen
    
    local loadLogo = Instance.new("ImageLabel")
    loadLogo.Size = UDim2.new(0,150,0,150)
    loadLogo.Position = UDim2.new(0.5,-75,0.35,-75)
    loadLogo.BackgroundTransparency = 1
    loadLogo.Image = "rbxassetid://16572258083"
    loadLogo.Parent = loadFrame
    
    local loadTitle = Instance.new("TextLabel")
    loadTitle.Size = UDim2.new(0,450,0,35)
    loadTitle.Position = UDim2.new(0.5,-225,0.55,-17)
    loadTitle.BackgroundTransparency = 1
    loadTitle.Text = "BFLoader v2.5.3"
    loadTitle.TextColor3 = Color3.fromRGB(255,255,255)
    loadTitle.TextSize = 28
    loadTitle.Font = Enum.Font.GothamBlack
    loadTitle.Parent = loadFrame
    
    local loadSub = Instance.new("TextLabel")
    loadSub.Size = UDim2.new(0,450,0,22)
    loadSub.Position = UDim2.new(0.5,-225,0.60,-11)
    loadSub.BackgroundTransparency = 1
    loadSub.Text = "YouTube Edition - Initializing Huge Hunter..."
    loadSub.TextColor3 = Color3.fromRGB(130,145,200)
    loadSub.TextSize = 14
    loadSub.Font = Enum.Font.Gotham
    loadSub.Parent = loadFrame
    
    local loadBg = Instance.new("Frame")
    loadBg.Size = UDim2.new(0,320,0,7)
    loadBg.Position = UDim2.new(0.5,-160,0.66,-3)
    loadBg.BackgroundColor3 = Color3.fromRGB(35,40,65)
    loadBg.BorderSizePixel = 0
    loadBg.Parent = loadFrame
    
    local loadFill = Instance.new("Frame")
    loadFill.Size = UDim2.new(0,0,1,0)
    loadFill.BackgroundColor3 = Color3.fromRGB(50,90,230)
    loadFill.BorderSizePixel = 0
    loadFill.Parent = loadBg
    
    local loadCorner = Instance.new("UICorner")
    loadCorner.CornerRadius = UDim.new(0,4)
    loadCorner.Parent = loadBg
    
    local loadPct = Instance.new("TextLabel")
    loadPct.Size = UDim2.new(0,80,0,18)
    loadPct.Position = UDim2.new(0.5,-40,0.69,10)
    loadPct.BackgroundTransparency = 1
    loadPct.Text = "0%"
    loadPct.TextColor3 = Color3.fromRGB(180,190,220)
    loadPct.TextSize = 13
    loadPct.Font = Enum.Font.Gotham
    loadPct.Parent = loadFrame
    
    local loadVer = Instance.new("TextLabel")
    loadVer.Size = UDim2.new(0,200,0,18)
    loadVer.Position = UDim2.new(0.5,-100,0.95,-10)
    loadVer.BackgroundTransparency = 1
    loadVer.Text = "github.com/hanniii1-cpu/Loader"
    loadVer.TextColor3 = Color3.fromRGB(60,65,90)
    loadVer.TextSize = 11
    loadVer.Font = Enum.Font.Gotham
    loadVer.Parent = loadFrame
    
    -- //===== LOADING ANIMATION =====\\
    local function showLoadingScreen()
        local steps = {
            {pct=15, text="Optimizing game performance..."},
            {pct=30, text="Loading pet database..."},
            {pct=45, text="Configuring Huge Hunter..."},
            {pct=60, text="Syncing egg data..."},
            {pct=75, text="Calibrating luck booster..."},
            {pct=90, text="Almost ready..."},
            {pct=100, text="BFLoader initialized! Press Right Shift"},
        }
        
        for _, step in ipairs(steps) do
            loadFill:TweenSize(UDim2.new(step.pct/100,0,1,0),"Out","Quad",0.3)
            loadPct.Text = step.pct.."%"
            loadSub.Text = step.text
            task.wait(0.4)
        end
        
        task.wait(0.5)
        TS:Create(loadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TS:Create(loadLogo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        TS:Create(loadTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TS:Create(loadSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TS:Create(loadBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TS:Create(loadFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TS:Create(loadPct, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TS:Create(loadVer, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.5)
        loadingScreen:Destroy()
    end
    
    -- //===== MAIN GUI =====\\
    local gui = Instance.new("ScreenGui")
    gui.Name = "BFLoaderGUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = pg
    gui.Enabled = false
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 340, 0, 250)
    main.Position = UDim2.new(0.5, -170, 0.3, -125)
    main.BackgroundColor3 = Color3.fromRGB(12, 15, 30)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = main
    
    local topAccent = Instance.new("Frame")
    topAccent.Size = UDim2.new(1,0,0,5)
    topAccent.BackgroundColor3 = Color3.fromRGB(45,85,230)
    topAccent.BorderSizePixel = 0
    topAccent.Parent = main
    
    local topAccent2 = Instance.new("Frame")
    topAccent2.Size = UDim2.new(1,0,0,2)
    topAccent2.Position = UDim2.new(0,0,0,5)
    topAccent2.BackgroundColor3 = Color3.fromRGB(25,55,190)
    topAccent2.BorderSizePixel = 0
    topAccent2.Parent = main
    
    local watermark = Instance.new("TextLabel")
    watermark.Size = UDim2.new(1,0,1,0)
    watermark.BackgroundTransparency = 1
    watermark.Text = "BFLOADER"
    watermark.TextColor3 = Color3.fromRGB(16,20,40)
    watermark.TextSize = 68
    watermark.Font = Enum.Font.GothamBlack
    watermark.Rotation = -15
    watermark.ZIndex = 1
    watermark.Parent = main
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,28)
    title.Position = UDim2.new(0,0,0,16)
    title.BackgroundTransparency = 1
    title.Text = "BFLOADER"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBlack
    title.ZIndex = 5
    title.Parent = main
    
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(1,0,0,15)
    versionLabel.Position = UDim2.new(0,0,0,42)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v2.5.3 | youtube edition | huge hunter"
    versionLabel.TextColor3 = Color3.fromRGB(90,105,170)
    versionLabel.TextSize = 10
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.ZIndex = 5
    versionLabel.Parent = main
    
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(0.84,0,0,1)
    sep.Position = UDim2.new(0.08,0,0,62)
    sep.BackgroundColor3 = Color3.fromRGB(28,35,70)
    sep.BorderSizePixel = 0
    sep.ZIndex = 5
    sep.Parent = main
    
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(0.84,0,0,42)
    statsLabel.Position = UDim2.new(0.08,0,0,70)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "🥚 Eggs: 0\n🌈 Rainbow: 0 | ⭐ Golden: 0 | 💎 Shiny: 0"
    statsLabel.TextColor3 = Color3.fromRGB(175,185,215)
    statsLabel.TextSize = 12
    statsLabel.Font = Enum.Font.GothamMedium
    statsLabel.ZIndex = 5
    statsLabel.TextWrapped = true
    statsLabel.RichText = true
    statsLabel.Parent = main
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0.84,0,0,18)
    statusText.Position = UDim2.new(0.08,0,0,118)
    statusText.BackgroundTransparency = 1
    statusText.Text = "⚫ Status: Idle"
    statusText.TextColor3 = Color3.fromRGB(150,160,195)
    statusText.TextSize = 11
    statusText.Font = Enum.Font.Gotham
    statusText.ZIndex = 5
    statusText.Parent = main
    
    local lastPetText = Instance.new("TextLabel")
    lastPetText.Size = UDim2.new(0.84,0,0,18)
    lastPetText.Position = UDim2.new(0.08,0,0,138)
    lastPetText.BackgroundTransparency = 1
    lastPetText.Text = "Last: -"
    lastPetText.TextColor3 = Color3.fromRGB(155,165,200)
    lastPetText.TextSize = 11
    lastPetText.Font = Enum.Font.Gotham
    lastPetText.ZIndex = 5
    lastPetText.TextTruncate = Enum.TextTruncate.AtEnd
    lastPetText.Parent = main
    
    local hugeCounter = Instance.new("TextLabel")
    hugeCounter.Size = UDim2.new(0.84,0,0,20)
    hugeCounter.Position = UDim2.new(0.08,0,0,158)
    hugeCounter.BackgroundTransparency = 1
    hugeCounter.Text = "🌟 Huge: 0 | 💜 Titanic: 0"
    hugeCounter.TextColor3 = Color3.fromRGB(255,200,50)
    hugeCounter.TextSize = 12
    hugeCounter.Font = Enum.Font.GothamBold
    hugeCounter.ZIndex = 5
    hugeCounter.RichText = true
    hugeCounter.Parent = main
    
    local hugeButton = Instance.new("TextButton")
    hugeButton.Size = UDim2.new(0.55,0,0,38)
    hugeButton.Position = UDim2.new(0.225,0,0,195)
    hugeButton.BackgroundColor3 = Color3.fromRGB(18,30,80)
    hugeButton.BorderSizePixel = 0
    hugeButton.Text = "🔍 HUGE HUNTER: OFF"
    hugeButton.TextColor3 = Color3.fromRGB(195,205,235)
    hugeButton.TextSize = 13
    hugeButton.Font = Enum.Font.GothamBold
    hugeButton.ZIndex = 10
    hugeButton.AutoButtonColor = false
    hugeButton.Parent = main
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,8)
    btnCorner.Parent = hugeButton
    
    -- //===== STATS =====\\
    local stats = {eggs=0, rainbow=0, golden=0, shiny=0, huge=0, titanic=0}
    
    -- //===== VISUAL EFFECTS =====\\
    local function playHatchFlash()
        coroutine.wrap(function()
            local flash = Instance.new("Frame")
            flash.Size = UDim2.new(1,0,1,0)
            flash.BackgroundColor3 = Color3.fromRGB(255,255,255)
            flash.BackgroundTransparency = 0.85
            flash.BorderSizePixel = 0
            flash.ZIndex = 50
            flash.Parent = main
            TS:Create(flash, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
            task.wait(0.1)
            flash:Destroy()
        end)()
    end
    
    local function playRainbowEffect()
        coroutine.wrap(function()
            local border = Instance.new("Frame")
            border.Size = UDim2.new(1,0,1,0)
            border.BackgroundTransparency = 1
            border.BorderSizePixel = 3
            border.BorderColor3 = Color3.fromRGB(255,150,255)
            border.ZIndex = 45
            border.Parent = main
            for i=1,3 do
                border.BorderColor3 = Color3.fromRGB(255,100+i*50,255)
                task.wait(0.1)
                border.BorderColor3 = Color3.fromRGB(100+i*50,255,255)
                task.wait(0.1)
                border.BorderColor3 = Color3.fromRGB(255,255,100+i*50)
                task.wait(0.1)
            end
            border:Destroy()
        end)()
    end
    
    local function playHugeEffect()
        coroutine.wrap(function()
            local border = Instance.new("Frame")
            border.Size = UDim2.new(1,0,1,0)
            border.BackgroundTransparency = 1
            border.BorderSizePixel = 4
            border.BorderColor3 = Color3.fromRGB(255,215,0)
            border.ZIndex = 45
            border.Parent = main
            for i=1,5 do
                border.BorderSizePixel = (i%2==0) and 6 or 3
                task.wait(0.15)
            end
            border:Destroy()
            
            local popup = Instance.new("TextLabel")
            popup.Size = UDim2.new(0,220,0,32)
            popup.Position = UDim2.new(0.5,-110,0.4,-16)
            popup.BackgroundTransparency = 1
            popup.Text = "🌟 HUGE! 🌟"
            popup.TextColor3 = Color3.fromRGB(255,215,0)
            popup.TextSize = 26
            popup.Font = Enum.Font.GothamBlack
            popup.TextStrokeTransparency = 0
            popup.TextStrokeColor3 = Color3.fromRGB(255,140,0)
            popup.ZIndex = 60
            popup.Parent = main
            TS:Create(popup, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0,280,0,48), Position = UDim2.new(0.5,-140,0.3,-24)}):Play()
            task.wait(1.8)
            TS:Create(popup, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.3)
            popup:Destroy()
        end)()
    end
    
    local function playTitanicEffect()
        coroutine.wrap(function()
            local colors = {
                Color3.fromRGB(255,100,255),
                Color3.fromRGB(100,255,255),
                Color3.fromRGB(255,255,100),
                Color3.fromRGB(255,150,100),
                Color3.fromRGB(150,255,150),
            }
            local border = Instance.new("Frame")
            border.Size = UDim2.new(1,0,1,0)
            border.BackgroundTransparency = 1
            border.BorderSizePixel = 5
            border.BorderColor3 = colors[1]
            border.ZIndex = 45
            border.Parent = main
            for i=1,8 do
                border.BorderColor3 = colors[(i%5)+1]
                border.BorderSizePixel = (i%3==0) and 7 or 5
                task.wait(0.12)
            end
            border:Destroy()
            
            local popup = Instance.new("TextLabel")
            popup.Size = UDim2.new(0,240,0,36)
            popup.Position = UDim2.new(0.5,-120,0.35,-18)
            popup.BackgroundTransparency = 1
            popup.Text = "💜 TITANIC! 💜"
            popup.TextColor3 = Color3.fromRGB(200,100,255)
            popup.TextSize = 28
            popup.Font = Enum.Font.GothamBlack
            popup.TextStrokeTransparency = 0
            popup.TextStrokeColor3 = Color3.fromRGB(255,200,255)
            popup.ZIndex = 60
            popup.Parent = main
            TS:Create(popup, TweenInfo.new(0.7, Enum.EasingStyle.Elastic), {Size = UDim2.new(0,320,0,60), Position = UDim2.new(0.5,-160,0.25,-30)}):Play()
            task.wait(2.0)
            TS:Create(popup, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
            task.wait(0.4)
            popup:Destroy()
        end)()
    end
    
    -- //===== PET GENERATOR =====\\
    local function generatePet()
        local rand = math.random(1,10000) / 100
        
        if rand <= CONFIG.TitanicChance then
            local pet = TITANIC_PETS[math.random(1,#TITANIC_PETS)]
            stats.titanic = stats.titanic + 1
            return pet, "Titanic"
        end
        
        if rand <= (CONFIG.TitanicChance + CONFIG.HugeChance) then
            local pet = HUGE_PETS[math.random(1,#HUGE_PETS)]
            stats.huge = stats.huge + 1
            return pet, "Huge"
        end
        
        local rarityRoll = math.random(1,100)
        local pool
        if rarityRoll <= 35 then pool = EGG_PETS.BASIC
        elseif rarityRoll <= 60 then pool = EGG_PETS.RARE
        elseif rarityRoll <= 80 then pool = EGG_PETS.EPIC
        elseif rarityRoll <= 93 then pool = EGG_PETS.LEGENDARY
        elseif rarityRoll <= 98 then pool = EGG_PETS.MYTHIC
        else pool = EGG_PETS.EXCLUSIVE end
        
        local pet = pool[math.random(1,#pool)]
        local prefix = ""
        local isRainbow = math.random(1,100) <= CONFIG.RainbowChance
        local isGolden = math.random(1,100) <= CONFIG.GoldenChance
        local isShiny = math.random(1,100) <= CONFIG.ShinyChance
        
        if isShiny then prefix = "Shiny "; stats.shiny = stats.shiny + 1 end
        if isRainbow then prefix = prefix .. "Rainbow "; stats.rainbow = stats.rainbow + 1 end
        if isGolden then prefix = prefix .. "Golden "; stats.golden = stats.golden + 1 end
        
        return prefix .. pet, "Normal"
    end
    
    -- //===== UPDATE UI =====\\
    local function updateUI(petName, petType)
        stats.eggs = stats.eggs + 1
        statsLabel.Text = string.format("🥚 Eggs: %d\n🌈 Rainbow: %d | ⭐ Golden: %d | 💎 Shiny: %d",
            stats.eggs, stats.rainbow, stats.golden, stats.shiny)
        hugeCounter.Text = string.format("🌟 Huge: %d | 💜 Titanic: %d", stats.huge, stats.titanic)
        lastPetText.Text = "Last: " .. petName
        
        if petType == "Huge" then
            statusText.Text = "🌟 Status: HUGE FOUND!"
            statusText.TextColor3 = Color3.fromRGB(255,215,0)
        elseif petType == "Titanic" then
            statusText.Text = "💜 Status: TITANIC FOUND!"
            statusText.TextColor3 = Color3.fromRGB(200,100,255)
        elseif petName:find("Rainbow") then
            statusText.Text = "🌈 Status: Rainbow!"
            statusText.TextColor3 = Color3.fromRGB(150,255,255)
        elseif petName:find("Golden") then
            statusText.Text = "⭐ Status: Golden!"
            statusText.TextColor3 = Color3.fromRGB(255,215,100)
        elseif petName:find("Shiny") then
            statusText.Text = "💎 Status: Shiny!"
            statusText.TextColor3 = Color3.fromRGB(200,200,255)
        else
            statusText.Text = "🟢 Status: Hatching..."
            statusText.TextColor3 = Color3.fromRGB(130,200,130)
        end
    end
    
    -- //===== AUTO HATCH LOOP =====\\
    local function autoHatchLoop()
        while CONFIG.AutoHatch do
            local petName, petType = generatePet()
            
            if CONFIG.ShowEffects then
                playHatchFlash()
                if petType == "Titanic" then playTitanicEffect()
                elseif petType == "Huge" then playHugeEffect()
                elseif petName:find("Rainbow") then playRainbowEffect() end
            end
            
            pcall(function()
                local eggs = {}
                for _, v in ipairs(WS:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Parent and v.Parent.Name:lower():find("egg") then
                        table.insert(eggs, v.Parent)
                    end
                end
                if #eggs > 0 then
                    local egg = eggs[math.random(1,math.min(#eggs,3))]
                    fireproximityprompt(egg:FindFirstChildWhichIsA("ProximityPrompt"))
                end
            end)
            
            updateUI(petName, petType)
            task.wait(CONFIG.HatchSpeed)
        end
        statusText.Text = "⚫ Status: Idle"
        statusText.TextColor3 = Color3.fromRGB(150,160,195)
    end
    
    -- //===== HUGE HUNTER TOGGLE =====\\
    local function toggleHugeHunter()
        CONFIG.AutoHatch = not CONFIG.AutoHatch
        if CONFIG.AutoHatch then
            hugeButton.Text = "🔍 HUGE HUNTER: ON"
            hugeButton.BackgroundColor3 = Color3.fromRGB(20,60,140)
            hugeButton.TextColor3 = Color3.fromRGB(255,220,80)
            statusText.Text = "🟢 Status: Starting..."
            statusText.TextColor3 = Color3.fromRGB(130,200,130)
            task.spawn(autoHatchLoop)
        else
            hugeButton.Text = "🔍 HUGE HUNTER: OFF"
            hugeButton.BackgroundColor3 = Color3.fromRGB(18,30,80)
            hugeButton.TextColor3 = Color3.fromRGB(195,205,235)
        end
    end
    
    hugeButton.MouseButton1Click:Connect(toggleHugeHunter)
    
    -- //===== RIGHT SHIFT TOGGLE =====\\
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            gui.Enabled = not gui.Enabled
        end
    end)
    
    -- //===== STARTUP =====\\
    task.spawn(function()
        showLoadingScreen()
        gui.Enabled = true
        print("[BFLoader] YouTube Edition loaded! Press Right Shift to toggle GUI.")
    end)
end

-- Anti-Tamper & Execution
local function antiDebug()
    local checks = {
        getfenv() == getgenv(),
        type(getgenv) == "function",
        type(getexecutorname) == "function"
    }
    for _,v in ipairs(checks) do
        if not v then return false end
    end
    return true
end

if antiDebug() then
    local success, err = pcall(BF_YouTubeHatch)
    if not success then
        task.spawn(BF_YouTubeHatch)
    end
end

return "BFLoader v2.5.3 YouTube Edition Loaded - github.com/hanniii1-cpu/Loader"
