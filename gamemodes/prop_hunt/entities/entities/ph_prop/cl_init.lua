-- Include needed files
include("shared.lua")

-- Called every frame?
--[[
local function DebugMoveType(ent, fl, bBetterMovement, bIsLocalEntIsEnt)
	if LocalPlayer():SteamID() == "STEAM_0:0:63261691" && GetConVar("developer"):GetInt() > 0 then
		print("PH_PROP RENDERGROUP -> "..tostring(ent:GetRenderGroup()))
		print("PH_PROP BITFLAG -> "..tostring(fl))
		if bBetterMovement then
			print("PH_PROP B_BETTERMOVEMENT => "..tostring(bBetterMovement))
		else
			print("PH_PROP B_BETTERMOVEMENT => "..tostring(bBetterMovement))
		end
		
		if bIsLocalEntIsEnt then
			print("PH_PROP B_ISLOCALENTISENT => "..tostring(bIsLocalEntIsEnt))
		else
			print("PH_PROP B_ISLOCALENTISENT => "..tostring(bIsLocalEntIsEnt))
		end
	end
end
]]--

function ENT:Draw(flag)
	if CL_BETTER_PROP_MOVEMENT then
		if (LocalPlayer():GetPlayerPropEntity() != self.Entity) then
			--DebugMoveType(self, flag, true, false)
			self.Entity:DrawModel()
			self.Entity:DrawShadow(true)
		else
			--DebugMoveType(self, flag, true, true)
			self.Entity:DrawShadow(false)
		end
	else
		--DebugMoveType(self, flag, false, false)
		self.Entity:DrawModel()
	end
end 