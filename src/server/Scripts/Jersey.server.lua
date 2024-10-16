-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- Variables
local remotes = replicatedStorage.Remotes
local assets = replicatedStorage.Assets
local playerAddedRemote = remotes.PlayerAdded
local jersey = assets.Tackling.Jersey
local jerseyEvent = remotes.Jersey
local tackleDebounceLength = 7

-- Tables
local tackleablePlayers = {}

-- Functions
local function addJersey(character)
	local jerseyClone = jersey:Clone()
	jerseyClone.Anchored = false
	jerseyClone.Parent = character

	local weld = Instance.new("Weld")
	weld.Parent = character
	weld.Part0 = character.Torso
	weld.Part1 = jerseyClone
	weld.C1 = CFrame.new(0,0.666667,0)
end

game.Players.PlayerAdded:Connect(function(player)
	if not player.Character then
		player.CharacterAdded:Wait()
	end
	
	addJersey(player.Character)

	player.CharacterAdded:Connect(function()
		addJersey(player.Character)
	end)
	
	tackleablePlayers[player.Name] = true
end)

jerseyEvent.OnServerEvent:Connect(function(player, hit)
	if hit.Name == "Jersey" and hit.Parent:FindFirstChild("Humanoid") then
		print(tackleablePlayers)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if tackleablePlayers[hit.Parent.Name] == true then
			humanoid.PlatformStand = true
			tackleablePlayers[humanoid.Parent.Name] = false
			print(hit.Parent.Name .. " has been tackled by " .. player.Name)
			
			task.wait(tackleDebounceLength)
			humanoid.PlatformStand = false
			tackleablePlayers[humanoid.Parent.Name] = true
		end
	end
end)
