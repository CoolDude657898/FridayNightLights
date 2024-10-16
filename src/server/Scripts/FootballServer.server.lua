-- Services
local serverScriptService = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- Variables
local classes = serverScriptService.Classes
local modules = serverScriptService.Modules
local remotes = replicatedStorage.Remotes

-- Classes
local Football = require(classes.Football)

-- Functions
local function newFootball()
	local football = Football.new(game.Workspace.Football)
	
	football.FootballInstance.Touched:Connect(function(hit)
		if hit.Parent:FindFirstChild("Humanoid") then
			local player = players:GetPlayerFromCharacter(hit.Parent)

			if not player.Backpack:FindFirstChild("Football") and not player.Character:FindFirstChild("Football") then
				football:Stop()
			end
		else
			football:Stop()
		end
	end)

	remotes.FootballAction.OnServerEvent:Connect(function(player, action, argsTable)
		if action == "Throw" then
			football:Throw(player, argsTable[1], argsTable[2], argsTable[3])
		end
	end)
	
	return football
end

remotes.Hike.OnServerEvent:Connect(function(player)
	local football = newFootball()
	football:Hike(player)
end)

-- Kick testing
local football = newFootball()
football:Kick()