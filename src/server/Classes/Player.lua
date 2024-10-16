local Player = {}
Player.__index = Player

function Player.new(player, team)
	local self = setmetatable({}, Player)
	self.Player = player
	self.Team = team
end
	
return Player
