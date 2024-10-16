-- Services
local serverScriptService = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- Variables
local classes = serverScriptService.Classes
local playTypes = {"Kickoff", "ExtraPoint", "TwoPoint", "RegularPlay"}
local gameValues = replicatedStorage.GameValues
local lineOfScrimmage = game.Workspace.LineOfScrimmage
local firstDown = game.Workspace.FirstDown

-- Classes
local football = require(classes.Football)
local player = require(classes.Player)

-- Functions
local function calculateFirstDown(los, fd)
	if los > fd then 
		return true
	else
		return false
	end
end

local function newPlay(los, typeOfPlay)
	if typeOfPlay == "RegularPlay" then
		--local Football = football.new(game.Workspace.Football:Clone())
		--Football.FootballInstance.Position = Vector3.new(los, 0, 0)
		--Football.FootballInstance.Parent = game.Workspace
		
		lineOfScrimmage.Position = Vector3.new(los, lineOfScrimmage.Position.Y, lineOfScrimmage.Position.Z)
		firstDown.Position = Vector3.new(los + (gameValues.YardsToGo.Value * 3), firstDown.Position.Y, firstDown.Position.Z)
	end	
end

local function startGame()
	if #players:GetPlayers() > 2 then
		newPlay(0, 0, "Kickoff")
	else
		print("Not enough players")
	end
end

newPlay(50, "RegularPlay")