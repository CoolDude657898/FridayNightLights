-- Services
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

-- Variables
local player = players.LocalPlayer
local power = 50
local indicatorTween
local textTween
local powerGui = player.PlayerGui:WaitForChild("PowerGui")
local mouse = player:GetMouse()
local remotes = replicatedStorage.Remotes

-- Functions
local function updatePowerGui()
	indicatorTween = tweenService:Create(powerGui.PowerFrame.BarFrame.PowerIndicatorFrame, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Position = UDim2.new(power/100, 0, 0, 0)})
	indicatorTween:Play()
	textTween = tweenService:Create(powerGui.PowerFrame.BarFrame.PowerText, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Position = UDim2.new(power/100, 0, -0.9, 0)})
	textTween:Play()
	powerGui.PowerFrame.BarFrame.PowerText.Text = power.."% Power"
end

userInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and player.Character:FindFirstChild("Football") then
		remotes.FootballAction:FireServer("Throw", {power, player.Character.Head.Position, mouse.Hit.Position})
	end
	
	if input.KeyCode == Enum.KeyCode.R and power < 95 then
		power += 5
		updatePowerGui()
	end
	
	if input.KeyCode == Enum.KeyCode.F and power > 5 then
		power -= 5
		updatePowerGui()
	end
end)

