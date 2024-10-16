local replicatedStorage = game:GetService("ReplicatedStorage")

local remotes = replicatedStorage.Remotes
local kickModuleServer = require(script.KickModuleServer)

remotes.Kick.OnServerEvent:Connect(function(player, power, verticalAngle, accuracy, kickSetup)
	kickModuleServer:Kick(power, verticalAngle, accuracy, kickSetup, game.Workspace.Field.Field.LeftUprights)
end)

kickModuleServer:InitializeKick(70, "Middle")