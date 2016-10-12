-- Credits & Original code: https://github.com/tyrantelf/gmod-mapvote
-- This is modified as for ease use of MapVote in Prop Hunt Enhanced, to avoid users having difficulties to edit their mapvote config file instead through ConVars.

MapVote = {}
MapVote.Config = {}

--Default Config
MapVoteConfigDefault = {
    MapLimit = 24,
    TimeLimit = 28,
    AllowCurrentMap = false,
    EnableCooldown = true,
    MapsBeforeRevote = 2,
    RTVPlayerCount = 3,
    MapPrefixes = {"ph_"}
    }
--Default Config

local convarlist = {
	{var = "mv_maplimit", 		val = "24", 	flags = {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, help = "numbers of map that shown on mapvote." },
	{var = "mv_timelimit",		val = "28", 	flags = {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY }, help = "time in second for default mapvotes time." },
	{var = "mv_allowcurmap",	val = "0", 	flags = {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, help = "allow current map to be voted (1/0)" },
	{var = "mv_cooldown",		val = "1", 	flags = {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY }, help = "enable cooldown for voting a map" },
	{var = "mv_mapbeforerevote",	val = "2", 	flags = {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY }, help = "how many times that the map which cooldown can be shown again?" },
	{var = "mv_rtvcount",		val = "3", 	flags = {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY }, help = "number of required players to use rtv mapvote." },
	{var = "mv_mapprefix",		val = "ph_,cs_,de_", flags = {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, help = "Map Prefixes that will be shown under mapvote. Use the following example:\n  \"ph_,cs_,de_\" (Dont forget to use quotation marks!)." }
}

if !ConVarExists("mv_maplimit") then
	for _,convars in pairs(convarlist) do
		CreateConVar(convars[var], convars[val], convars[flags], convars[help])
	end
end

function MapVote.HasExtraVotePower(ply)
	return false
end

MapVote.CurrentMaps = {}
MapVote.Votes = {}

MapVote.Allow = false

MapVote.UPDATE_VOTE = 1
MapVote.UPDATE_WIN = 3

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("mapvote/cl_mapvote.lua")

    include("mapvote/sv_mapvote.lua")
    include("mapvote/rtv.lua")
else
    include("mapvote/cl_mapvote.lua")
end
