local FootballAnimations = {}
local tweenService = game:GetService("TweenService")

function FootballAnimations:KickSnap(football, startingPosition)
	football.Anchored = true
	football.Orientation = Vector3.new(0, 0, 90)
	football.Position = startingPosition
	
	local rotationTween = tweenService:Create(football, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {Orientation = Vector3.new(360, football.Orientation.Y, football.Orientation.Z)})

	rotationTween:Play()
	rotationTween.Completed:Connect(function()
		rotationTween:Play()
	end)

	local movementTween = tweenService:Create(football, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {Position = Vector3.new(football.Position.X - 15, football.Position.Y - 0.5, football.Position.Z)})
	movementTween:Play()

	local holderRotationTween = tweenService:Create(football, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Orientation = Vector3.new(0,0,0)})

	movementTween.Completed:Connect(function()
		rotationTween:Pause()
		rotationTween:Destroy()

		holderRotationTween:Play()
	end)
end

return FootballAnimations
