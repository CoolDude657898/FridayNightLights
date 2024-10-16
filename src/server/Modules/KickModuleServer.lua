local kickModuleServer = {}

local serverScriptService = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local classes = serverScriptService.Classes
local Football = require(classes.Football)
local assets = replicatedStorage.Assets
local remotes = replicatedStorage.Remotes
local kickAnimations = require(script.Parent.KickAnimations)

function kickModuleServer:InitializeKick(kickPosition, hash)	
	local kickSetupClone = assets.Gameplay.KickSetup:Clone()
	kickSetupClone.Parent = game.Workspace

	if hash == "Left" then
		kickSetupClone:PivotTo(CFrame.new(kickPosition, -14.56, -26.401) * CFrame.Angles(math.rad(0), math.rad(270), math.rad(90)))
	elseif hash == "Right" then
		kickSetupClone:PivotTo(CFrame.new(kickPosition, -14.56, 26.401) * CFrame.Angles(math.rad(0), math.rad(270), math.rad(90)))
	elseif hash == "Middle" then
		kickSetupClone:PivotTo(CFrame.new(kickPosition, -14.56, 0) * CFrame.Angles(math.rad(0), math.rad(270), math.rad(90)))
	end
	
	kickSetupClone.KickerPad.Touched:Connect(function(hit)
		if kickSetupClone.KickerPad:GetAttribute("PlayerUsing") == "" and hit.Parent:FindFirstChild("Humanoid") then
			local player = players:GetPlayerFromCharacter(hit.Parent)
			kickSetupClone.KickerPad:SetAttribute("PlayerUsing", player.Name)
			remotes.SteppedOnPad:FireClient(player, "Kick", kickSetupClone)
		end
	end)
end

function kickModuleServer:Kick(power, verticalAngle, accuracy, kickSetup, goalposts)
	local football = Football.new(kickSetup.Football)
	kickAnimations:KickSnap(kickSetup.Football, kickSetup.Football.Position + Vector3.new(15, 0.5, 0))
	
	task.wait(2)
	
	goalposts.IfGoodChecker.Touched:Connect(function(hit)
		if hit == kickSetup.Football then
			return true
		end
	end)
	
	football:Kick(power, verticalAngle, accuracy)
end


return kickModuleServer
