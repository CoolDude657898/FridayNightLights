-- Variables
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local highTackle = game.ReplicatedStorage.Assets.Animations.HighTackle
local lowTackle = game.ReplicatedStorage.Assets.Animations.LowTackle
local character = player.CharacterAdded:Wait()
local jersey = player.Character:FindFirstChild("Jersey")
local replicated = game.ReplicatedStorage
local jerseyEvent = replicated.Remotes.Jersey

-- Functions
if jersey then
		print("Jersey has been found on ".. player.Name)
else
	print("Jersey is missing!")
end

player.CharacterAdded:Connect(function()
	jersey = player.Character:FindFirstChild("Jersey")
end)


userInputService.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.G then
		for _, part in pairs(game.Workspace:GetPartsInPart(jersey)) do
			jerseyEvent:FireServer(part)
		end
		local animationTrack = player.Character.Humanoid:LoadAnimation(highTackle)
		animationTrack:Play()
	end
end)

userInputService.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.V then
		for _, part in pairs(game.Workspace:GetPartsInPart(jersey)) do
			if part.Name == "Jersey" then
				jerseyEvent:FireServer(part)
			end
		end
		local animationTrack = player.Character.Humanoid:LoadAnimation(lowTackle)
		animationTrack:Play()
	end
end)