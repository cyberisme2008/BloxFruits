-- ======================================================
-- SCRIPT BLOX FRUITS BASIC HUB BY FJCYBER
-- Target: Mobile / Executor
-- ======================================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("fjcyber Hub | Blox Fruits", "DarkTheme")

-- Tab Main Auto Farm
local Tab = Window:NewTab("Auto Farm")
local Section = Tab:NewSection("Tính Năng Auto")

_G.AutoFarm = false
_G.BringMob = true
_G.AutoHaki = true

-- Bảng Quest theo Cấp độ (Sea 1)
local function GetQuestByLevel()
    local level = game.Players.LocalPlayer.Data.Level.Value
    if level >= 1 and level <= 9 then
        return "BanditQuest1", 1, "Bandit"
    elseif level >= 10 and level <= 14 then
        return "JungleQuest", 1, "Monkey"
    elseif level >= 15 and level <= 29 then
        return "JungleQuest", 2, "Gorilla"
    elseif level >= 30 and level <= 39 then
        return "BuggyQuest1", 1, "Pirate"
    elseif level >= 40 and level <= 59 then
        return "BuggyQuest1", 2, "Brute"
    else
        return "BanditQuest1", 1, "Bandit"
    end
end

-- Bật Buso Haki
local function CheckHaki()
    if _G.AutoHaki then
        local player = game.Players.LocalPlayer
        if player.Character and not player.Character:FindFirstChild("HasBuso") then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HasBuso")
            end)
        end
    end
end

-- Vòng Lặp Farm Chính
Section:NewToggle("Bật Auto Farm", "Tự động nhận Quest, gom quái và đánh theo level", function(state)
    _G.AutoFarm = state
    if state then
        spawn(function()
            while _G.AutoFarm do
                task.wait()
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        CheckHaki()
                        
                        local questName, questIndex, enemyName = GetQuestByLevel()
                        local activeQuest = player.PlayerGui.Main:FindFirstChild("Quest")
                        
                        if not activeQuest or not activeQuest.Visible then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", questName, questIndex)
                        else
                            local targetEnemy = nil
                            for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                                if v.Name == enemyName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                    targetEnemy = v
                                    break
                                end
                            end
                            
                            if targetEnemy and targetEnemy:FindFirstChild("HumanoidRootPart") then
                                -- Teleport đứng trên đầu quái
                                hrp.CFrame = targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                                
                                -- Bring Mob (Gom quái lại gần)
                                if _G.BringMob then
                                    for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                                        if mob.Name == enemyName and mob ~= targetEnemy and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                                            mob.HumanoidRootPart.CFrame = targetEnemy.HumanoidRootPart.CFrame
                                            mob.HumanoidRootPart.CanCollide = false
                                            mob.Humanoid.WalkSpeed = 0
                                        end
                                    end
                                end
                                
                                -- Tự động đánh
                                local vu = game:GetService("VirtualUser")
                                vu:CaptureController()
                                vu:ClickButton1(Vector2.new(500, 500))
                            end
                        end
                    end
                end)
            end
        end)
    end
end)

Section:NewToggle("Gom Quái (Bring Mob)", "Bật/Tắt gom quái lại 1 điểm", function(state)
    _G.BringMob = state
end)

Section:NewToggle("Tự Động Haki", "Tự bật Buso Haki", function(state)
    _G.AutoHaki = state
end)

-- Tab Settings / Toggle UI
local TabSetting = Window:NewTab("Cài Đặt")
local SettingSection = TabSetting:NewSection("Điện Thoại")

SettingSection:NewButton("Ẩn / Hiện Bảng Menu", "Thu gọn giao diện cho đỡ vướng màn hình", function()
    Library:ToggleUI()
end)
