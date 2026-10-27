--[[
	Kid Hub - Full Source Code
	Re-uploaded for fjcyber
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Kid Hub | Blox Fruits", HidePremium = false, SaveConfig = true, ConfigFolder = "KidHubConfig"})

-- Global Variables
_G.AutoFarm = false
_G.FastAttack = true
_G.AutoStats = false
_G.SelectStat = "Melee"

-- Main Tab
local MainTab = OrionLib:MakeTab({
	Name = "Main Farm",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
})

MainTab:AddToggle({
	Name = "Auto Farm Level",
	Default = false,
	Callback = function(Value)
		_G.AutoFarm = Value
	end    
})

MainTab:AddToggle({
	Name = "Fast Attack (Đánh nhanh)",
	Default = true,
	Callback = function(Value)
		_G.FastAttack = Value
	end    
})

-- Stats Tab
local StatsTab = OrionLib:MakeTab({
	Name = "Auto Stats",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
})

StatsTab:AddDropdown({
	Name = "Chọn chỉ số cộng",
	Default = "Melee",
	Options = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
	Callback = function(Value)
		_G.SelectStat = Value
	end
})

StatsTab:AddToggle({
	Name = "Auto Cộng Điểm (Stats)",
	Default = false,
	Callback = function(Value)
		_G.AutoStats = Value
	end    
})

-- Teleport / Misc Tab
local MiscTab = OrionLib:MakeTab({
	Name = "Misc / Server",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
})

MiscTab:AddButton({
	Name = "Rejoin Server (Vào lại)",
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end    
})

-- Main Logic Loop
task.spawn(function()
	while task.wait() do
		if _G.AutoFarm then
			pcall(function()
				local player = game.Players.LocalPlayer
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					-- Logic auto farm & fast attack
					local enemy = game.Workspace.Enemies:FindFirstChildOfClass("Model")
					if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
						character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
						if _G.FastAttack then
							game:GetService("VirtualUser"):CaptureController()
							game:GetService("VirtualUser"):ClickButton1(Vector2.new(500, 500))
						end
					end
				end
			end)
		end
        
		if _G.AutoStats then
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", _G.SelectStat, 1)
			end)
		end
	end
end)

OrionLib:Init()
