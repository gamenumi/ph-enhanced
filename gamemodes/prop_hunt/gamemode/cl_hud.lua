surface.CreateFont("PHE.HealthFont", 
{
	font = "Roboto",
	size = 56,
	weight = 650,
	antialias = true,
	shadow = true
})

surface.CreateFont("PHE.ArmorFont", 
{
	font = "Roboto",
	size = 32,
	weight = 500,
	antialias = true,
	shadow = true
})

surface.CreateFont("PHE.TopBarFont", 
{
	font = "Roboto",
	size = 20,
	weight = 500,
	antialias = true,
	shadow = true
})
surface.CreateFont("PHE.TopBarFontTeam", 
{
	font = "Roboto",
	size = 60,
	weight = 800,
	antialias = true,
	shadow = true
})

-- Hides HUD
local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}
hook.Add("HUDShouldDraw", "PHE.ShouldHideHUD", function(hudname)
	if GetConVar("ph_hud_use_new"):GetBool() then
		if (hide[hudname]) then return false end
	end
end)

local curteam
local mat = {
	[1] = 	Material("vgui/phehud/res_hp_1"),
	[2] = 	Material("vgui/phehud/res_hp_2"),
}
local indic = {
	rotate 	= { mat = Material("vgui/phehud/i_rotate"), [0]	= Color(190,190,190,255), [1] = Color(255,255,0,255) },
	halo 	= { mat = Material("vgui/phehud/i_halo"), 	[0]	= Color(190,190,190,255), [1] = Color(0,255,0,255) },
	light 	= { mat = Material("vgui/phehud/i_light"), 	[0]	= Color(190,190,190,255), [1] = Color(255,255,0,255) },
	armor	= { mat = Material("vgui/phehud/i_shield"),	[0] = Color(190,190,190,255), [1] = Color(80,190,255,255) }
}
local hudtopbar = {
	mat = Material("vgui/phehud/hud_topbar"),
	x	= 0,
	y	= 60
}

local ava
	if (ava || IsValid(ava)) then ava:Remove() ava = nil end
local pos = { x = 0, y = ScrH()/1.2 }
local posind = { x = ScrW() - 384, y = ScrH()/1.4 }
local hp
local armor
local hpcolor

local bar = {
	hp = { h = 5, col = Color(250,40,10,240) },
	am = { h = 3, col = Color(80,190,255,220) }
}

-- stupid checks, like seriously tho.
local Rstate = 0
net.Receive("PHE.rotateState", function() Rstate = net.ReadInt(2) end)

local function PopulateAliveTeam(tm)
	local tim = team.GetPlayers(tm)
	local liveply = liveply or 0
	
	for _,pl in pairs(tim) do
		if IsValid(pl) && pl:Alive() then liveply = liveply + 1 end
	end
	
	return liveply
end

local state = false
local disabledcolor = Color(100,100,100,255)
local bSpect

net.Receive("RemoveHUDAvatar", function()
	bSpect = net.ReadBool()
end)

hook.Add("HUDPaint", "PHE.MainHUD", function()

	if GetConVar("ph_hud_use_new"):GetBool() then state = true else state = false end;
	if LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():Team() == TEAM_UNASSIGNED then return end
	
	if IsValid(LocalPlayer()) && LocalPlayer():Alive() && state then
		-- Begin Player Info
		if not IsValid(ava) then
			ava = vgui.Create("AvatarMask")
			ava:SetPos(pos.x+12,pos.y+16)
			ava:SetSize(86,86)
			ava:SetPlayer(LocalPlayer(),128)
			ava:SetVisible(true)
		end
		
		curteam = LocalPlayer():Team()
		hp = LocalPlayer():Health()
		armor = LocalPlayer():Armor()
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( mat[curteam] )
		surface.DrawTexturedRect( pos.x, pos.y, 480, 120 )
		
		surface.SetFont( "Trebuchet24" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( pos.x+8*22, pos.y+12 )
		surface.DrawText( "HEALTH" )
		
		if hp < 0 then hp = 0 end
		if armor < 0 then armor = 0 end
		
		if hp < 30 then
			hpcolor = Color( 255, 1 * (hp*8), 1 * (hp*8), 255 )
		else
			hpcolor = Color( 255, 255, 255, 255 )
		end
		
		-- hp bar
		if hp > 100 then hpx = 100 else hpx = hp end
		if armor > 100 then armx = 100 else armx = armor end
		
		surface.SetDrawColor(bar.hp.col)
		surface.DrawRect(pos.x+8*22, pos.y+2*28.5, 1*(hpx*2.9), bar.hp.h)
		
		surface.SetDrawColor(bar.am.col)
		surface.DrawRect(pos.x+8*22, pos.y+2*32, 1*(armx*2.9), bar.am.h)
		
		draw.DrawText( hp, "PHE.HealthFont", pos.x+8*44, pos.y-6, hpcolor, TEXT_ALIGN_RIGHT )
		draw.DrawText( " / "..armor, "PHE.ArmorFont", pos.x+8*44, pos.y+12, Color( 255,255,255,255 ), TEXT_ALIGN_LEFT )
		
		if LocalPlayer():Team() == TEAM_HUNTERS then
			surface.SetDrawColor(disabledcolor)
		else
			surface.SetDrawColor( indic.rotate[Rstate] )
		end
		surface.SetMaterial( indic.rotate.mat )
		surface.DrawTexturedRect( pos.x+8*21, pos.y+2*37, 32, 32 )
		
		if LocalPlayer():Team() == TEAM_HUNTERS then
			surface.SetDrawColor(disabledcolor)
		else
			surface.SetDrawColor( indic.light[CL_GLOBAL_LIGHT_STATE] )
		end
		surface.SetMaterial( indic.light.mat )
		surface.DrawTexturedRect( pos.x+8*27, pos.y+2*37, 32, 32 )
		
		if LocalPlayer():Team() == TEAM_HUNTERS then
			surface.SetDrawColor(disabledcolor)
		else
			surface.SetDrawColor( indic.halo[tonumber(GetConVar("ph_cl_halos"):GetInt())])
		end
		surface.SetMaterial( indic.halo.mat )
		surface.DrawTexturedRect( pos.x+8*33, pos.y+2*37, 32, 32 )
		
		if LocalPlayer():Armor() < 10 then
			surface.SetDrawColor( indic.armor[0] )
		else
			surface.SetDrawColor( indic.armor[1] )
		end
		surface.SetMaterial( indic.armor.mat )
		surface.DrawTexturedRect (pos.x+8*39, pos.y+2*37, 32, 32 )
	end
	
	if (IsValid(LocalPlayer()) && !LocalPlayer():Alive()) then
		if IsValid(ava) then
			ava:SetVisible(false)
			ava:Remove()
		end
	end
	if (IsValid(LocalPlayer()) && !state) then
		if IsValid(ava) then
			ava:SetVisible(false)
			ava:Remove()
		end
	end
	if (IsValid(LocalPlayer())) && bSpect then
		if IsValid(ava) then
			ava:SetVisible(false)
			ava:Remove()
		end
	end
	
	-- the Team Bar. This requires at least 4 players to get this displayed.
	if GetConVar("ph_show_team_topbar"):GetBool() then
		if ((player.GetCount() >= 4 && LocalPlayer():Alive()) && (LocalPlayer():Team() != TEAM_UNASSIGNED && LocalPlayer():Team() != TEAM_SPECTATOR)) then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( hudtopbar.mat )
			surface.DrawTexturedRect( hudtopbar.x, hudtopbar.y, 400, 50 )
			
			-- Draw Props
			draw.DrawText( "Props", "PHE.TopBarFont", 4, hudtopbar.y+2, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			draw.DrawText( tostring(PopulateAliveTeam(TEAM_PROPS)), "PHE.TopBarFontTeam", 4*24, hudtopbar.y-10, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			
			-- Draw Hunters
			draw.DrawText( "Hunter", "PHE.TopBarFont", 4*74, hudtopbar.y+22, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			draw.DrawText( tostring(PopulateAliveTeam(TEAM_HUNTERS)), "PHE.TopBarFontTeam", 4*55, hudtopbar.y-10, Color(255,255,255,255), TEXT_ALIGN_LEFT )			
		end
	end
end)