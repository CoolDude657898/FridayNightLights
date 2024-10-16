local kickModuleClient = {}

local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local player = players.LocalPlayer
local remotes = replicatedStorage.Remotes
local kickGui = player.PlayerGui:WaitForChild("KickGui")
local playerControls = require(player.PlayerScripts.PlayerModule):GetControls()
local currentCamera = workspace.CurrentCamera
local power = nil
local accuracy = nil
local verticalAngle = nil
local kickMeterForwardTween = tweenService:Create(kickGui.KickFrame.SelectorFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0.5, 0)})
local kickMeterBackwardTween = tweenService:Create(kickGui.KickFrame.SelectorFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0.5, 0)})

function kickModuleClient:StartKicking(kickSetup)
	playerControls:Disable()
	
	currentCamera.CameraType = Enum.CameraType.Scriptable
	currentCamera.CFrame = kickSetup.CameraPart.CFrame
	
	verticalAngle = 35
	
	kickGui.Enabled = true

	kickMeterForwardTween:Play()
	kickMeterForwardTween.Completed:Connect(function()
		kickMeterBackwardTween:Play()
	end)
	
	kickMeterBackwardTween.Completed:Connect(function()
		kickMeterForwardTween:Play()
	end)
end

function kickModuleClient:DetermineSelection()
	if not power then
		return "Power"
	end
	
	if not accuracy and power then
		return "Accuracy"
	end
end

function kickModuleClient:ResetGui()
	if kickMeterForwardTween.PlaybackState == Enum.PlaybackState.Playing then
		kickMeterForwardTween:Pause()
	end

	if kickMeterBackwardTween.PlaybackState == Enum.PlaybackState.Playing then
		kickMeterBackwardTween:Pause()
	end

	task.wait(0.3)

	kickMeterForwardTween:Cancel()
	kickMeterBackwardTween:Cancel()

	kickGui.KickFrame.SelectorFrame.Position = UDim2.new(0, 0, 0.5, 0)
	
	kickMeterForwardTween:Play()
end

function kickModuleClient:SelectPower()
	power = -160 * (kickGui.KickFrame.SelectorFrame.Position.X.Scale - 0.5)^2 + 70
	
	kickModuleClient:ResetGui()
end

function kickModuleClient:SelectAccuracy(kickSetup)
	accuracy = - 10 + 20 * kickGui.KickFrame.SelectorFrame.Position.X.Scale

	kickModuleClient:ResetGui()
	kickModuleClient:CompleteKick(kickSetup)
end

function kickModuleClient:AdjustAngleUp(kickSetup)
	if verticalAngle <= 55 then
		verticalAngle += 0.1

		kickSetup.KickArrow.Orientation = Vector3.new(0, 0, verticalAngle - 180)
	end
end

function kickModuleClient:AdjustAngleDown(kickSetup)
	if verticalAngle >= 15 then
		verticalAngle -= 0.1

		kickSetup.KickArrow.Orientation = Vector3.new(0, 0, verticalAngle - 180)
	end
end

function kickModuleClient:CompleteKick(kickSetup)
	kickGui.Enabled = false
	playerControls:Enable()
	currentCamera.CameraType = Enum.CameraType.Follow
	currentCamera.CameraSubject = kickSetup:FindFirstChild("Football") 
	remotes.Kick:FireServer(power, verticalAngle, accuracy, kickSetup)
end

return kickModuleClient
