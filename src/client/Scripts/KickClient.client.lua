-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Variables
local remotes = replicatedStorage.Remotes
local player = players.LocalPlayer
local isKicker = false	

-- Kick Variables
local angleKickUpConnection = nil
local angleKickDownConnection = nil
local kickSetup = nil

-- Modules
local kickModuleClient = require(script.KickModuleClient)

-- Functions
remotes.SteppedOnPad.OnClientEvent:Connect(function(typeOf, argsOne)
	if typeOf == "Kick" then
		kickSetup = argsOne
		isKicker = true
		kickModuleClient:StartKicking(kickSetup)
	end
end)

userInputService.InputBegan:Connect(function(key)
	if key.UserInputType == Enum.UserInputType.MouseButton1 and isKicker == true then
		if kickModuleClient:DetermineSelection() == "Power" then
			kickModuleClient:SelectPower()
		elseif kickModuleClient:DetermineSelection() == "Accuracy" then
			kickModuleClient:SelectAccuracy(kickSetup)
		end
	end
	
	if key.KeyCode == Enum.KeyCode.R and isKicker == true then
		angleKickUpConnection = runService.RenderStepped:Connect(function()
			kickModuleClient:AdjustAngleUp(kickSetup)
		end)
	end
	
	if key.KeyCode == Enum.KeyCode.F and isKicker == true then
		angleKickDownConnection = runService.RenderStepped:Connect(function()
			kickModuleClient:AdjustAngleDown(kickSetup)
		end)
	end
end)

userInputService.InputEnded:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.R and angleKickUpConnection then
		angleKickUpConnection:Disconnect()
	end
	
	if key.KeyCode == Enum.KeyCode.F and angleKickDownConnection then
		angleKickDownConnection:Disconnect()
	end
end)
