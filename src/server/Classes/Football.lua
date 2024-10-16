local Football = {}
Football.__index = Football

local serverStorage = game:GetService("ServerStorage")
local tweenService = game:GetService("TweenService")

function Football.new(footballInstance)
	local self = setmetatable({}, Football)
	
	self.Freefalling = false
	self.Gravity = -39
	self.FootballInstance = footballInstance
	self.FootballTool = nil
	self.PlayerWithFootball = nil
	self.IsKicking = false

	return self
end

function Football:Throw(player, power, origin, target)
	if power < 100 and power > 0 then
		local aim = (target - origin).Unit
		local spawnPosition = origin + (aim * 5)
		local targetPosition = spawnPosition + aim

		self.FootballInstance.Parent = game.Workspace
		self.PlayerWithFootball.PlayerGui:WaitForChild("PowerGui").Enabled = false
		self.PlayerWithFootball = nil

		self.FootballTool:Destroy()
		self.FootballTool = nil

		self.FootballInstance.CFrame = CFrame.new(spawnPosition, targetPosition) * CFrame.Angles(math.pi/2, 0, 0)
		self.FootballInstance.Name = "Football"
		self.FootballInstance.CanCollide = false

		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Parent = self.FootballInstance
		bodyVelocity.MaxForce = Vector3.new(1,1,1) * 1e6
		bodyVelocity.P = 1e6
		bodyVelocity.Velocity = aim * power

		local i = 0
		self.Freefalling = true

		while self.Freefalling do
			i = i + 0.1
			bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, self.Gravity * game:GetService("RunService").Heartbeat:Wait(), 0)
			local position = self.FootballInstance.CFrame.Position
			self.FootballInstance.CFrame = CFrame.new(position, position + bodyVelocity.Velocity) * CFrame.Angles(math.pi/2, math.pi*i, 0)
		end
	else
		warn(self.PlayerWithFootball.Name.." is likely cheating, "..power.." is out of the power range of 5 to 95")
		return nil
	end
end

function Football:Hike(player)
	local footballTool = Instance.new("Tool")
	footballTool.Name = "Football"
	self.FootballInstance.Parent = footballTool
	
	footballTool.Parent = player.Backpack
	player.Character.Humanoid:EquipTool(footballTool)
	
	self.FootballTool = footballTool
	self.FootballInstance.Name = "Handle"
	self.PlayerWithFootball = player
	self.PlayerWithFootball.PlayerGui:WaitForChild("PowerGui").Enabled = true
	
	self.FootballTool.Unequipped:Connect(function()
		if self.FootballTool and self.FootballTool.Parent == self.PlayerWithFootball.Backpack then
			self.FootballTool.Parent = self.PlayerWithFootball.Character
		end
	end)
end

function Football:Stop()
	self.Freefalling = false
	self.FootballInstance.CanCollide = true
	
	if self.FootballInstance:FindFirstChild("BodyVelocity") then
		self.FootballInstance.BodyVelocity:Destroy()
	end
end

function Football:Kick(power, verticalAngle, horizontalAngle)	
	self.Freefalling = true
	self.FootballInstance.Anchored = false
	self.FootballInstance.Orientation = Vector3.new(0, 0, verticalAngle)
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Parent = self.FootballInstance
	bodyVelocity.Velocity = self.FootballInstance.CFrame.RightVector * power + Vector3.new(0,0, horizontalAngle)
	
	self.FootballInstance:ApplyAngularImpulse(Vector3.new(0,0, 100))
	
	task.wait(0.3)	
	
	local kickStoppingPart = game.Workspace.Field.Field.Turf:Clone()
	kickStoppingPart.Parent = game.Workspace
	kickStoppingPart.Transparency = 1
	kickStoppingPart.CanCollide = false
	kickStoppingPart.Anchored = true
	kickStoppingPart.Size = Vector3.new(kickStoppingPart.Size.X, kickStoppingPart.Size.Y + 0.5, kickStoppingPart.Size.Z)
	kickStoppingPart.Name = "KickStoppingPart"
	
	while self.Freefalling == true do
		bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, self.Gravity * game:GetService("RunService").Heartbeat:Wait(), 0)
		
		if game.Workspace:GetPartsInPart(self.FootballInstance) then
			for _, part in pairs(game.Workspace:GetPartsInPart(self.FootballInstance)) do
				if part.Name == "KickStoppingPart" then
					self.FootballInstance.AssemblyAngularVelocity = Vector3.new(0,0,0)
					bodyVelocity:Destroy()
					kickStoppingPart:Destroy()
					self.Freefalling = false
					self.FootballInstance.CanCollide = true
				end
			end
		end
	end
end

return Football
