local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local sprinting = false

userInputService.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.Q then
		if sprinting == false then
			player.Character.Humanoid.WalkSpeed = 22
			local sprinting = true
		elseif sprinting == true then
			player.Character.Humanoid.WalkSpeed = 16
			local sprinting = false
		end
	end
end)