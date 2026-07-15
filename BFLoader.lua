-- BFLoader исправленный для Pet Simulator 99
-- Обход анти-чита Big Games и оптимизация под PS99

local function BFLoader()
    -- 1. Обход обнаружения
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        -- Блокировка детектов Big Games
        if method == "FireServer" or method == "InvokeServer" then
            if tostring(self):find("Ban") or tostring(self):find("Detect") or tostring(self):find("Anti") then
                return nil
            end
        end
        
        -- Обход защищенных RemoteEvent
        if method == "Kick" or method == "kick" then
            return nil
        end
        
        return oldNamecall(self, ...)
    end)
    
    -- 2. Защита от обнаружения скриптов
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if key == "Name" and tostring(self):find("LocalScript") then
            return "OriginalScript" -- Маскировка имени скрипта
        end
        return oldIndex(self, key)
    end)
    
    -- 3. Авто-фарм для Pet Simulator 99
    spawn(function()
        while wait(0.1) do
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                
                -- Авто-сбор монет
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Coin") or v.Name:find("Diamond") or v.Name:find("Chest") then
                        if v:IsA("BasePart") then
                            firetouchinterest(character.HumanoidRootPart, v, 0)
                            firetouchinterest(character.HumanoidRootPart, v, 1)
                        end
                    end
                end
                
                -- Авто-открытие яиц (если есть яйца в инвентаре)
                local eggsFolder = workspace:FindFirstChild("Eggs")
                if eggsFolder then
                    for _, egg in pairs(eggsFolder:GetChildren()) do
                        if egg:IsA("BasePart") then
                            firetouchinterest(character.HumanoidRootPart, egg, 0)
                            firetouchinterest(character.HumanoidRootPart, egg, 1)
                            wait(0.5)
                        end
                    end
                end
            end)
        end
    end)
    
    -- 4. Телепортация к лучшим зонам
    spawn(function()
        while wait(1) do
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                
                -- Поиск зон с наибольшим количеством монет
                local bestZone = nil
                local maxCoins = 0
                
                for _, zone in pairs(workspace:GetChildren()) do
                    if zone:IsA("Model") and zone:FindFirstChild("Coins") then
                        local coinCount = #zone.Coins:GetChildren()
                        if coinCount > maxCoins then
                            maxCoins = coinCount
                            bestZone = zone
                        end
                    end
                end
                
                if bestZone then
                    local teleportPart = bestZone:FindFirstChild("Teleport") or bestZone:FindFirstChildWhichIsA("BasePart")
                    if teleportPart then
                        character.HumanoidRootPart.CFrame = teleportPart.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end)
        end
    end)
    
    -- 5. Авто-эквипировка лучших питомцев
    spawn(function()
        while wait(2) do
            pcall(function()
                local player = game.Players.LocalPlayer
                
                -- Поиск GUI инвентаря
                local inventoryGui = player.PlayerGui:FindFirstChild("Inventory", true)
                if inventoryGui then
                    -- Авто-эквипировка сильных питомцев
                    for _, pet in pairs(inventoryGui:GetDescendants()) do
                        if pet:IsA("ImageButton") and pet.Name:find("Pet") then
                            -- Проверка силы питомца
                            local powerLabel = pet:FindFirstChild("Power")
                            if powerLabel and tonumber(powerLabel.Text) > 1000 then
                                -- Клик для экипировки
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(
                                    pet.AbsolutePosition.X + pet.AbsoluteSize.X/2,
                                    pet.AbsolutePosition.Y + pet.AbsoluteSize.Y/2,
                                    0,
                                    true,
                                    nil,
                                    0
                                )
                                wait(0.1)
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(
                                    pet.AbsolutePosition.X + pet.AbsoluteSize.X/2,
                                    pet.AbsolutePosition.Y + pet.AbsoluteSize.Y/2,
                                    0,
                                    false,
                                    nil,
                                    0
                                )
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    -- 6. Защита от AFK кика
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    print("[BFLoader] Pet Simulator 99 Loaded Successfully")
    print("[BFLoader] Features: Auto Farm, Auto Hatch, Anti-Ban, Teleport")
end

-- Запуск загрузчика
BFLoader()
