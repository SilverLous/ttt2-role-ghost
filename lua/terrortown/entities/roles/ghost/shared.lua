AddCSLuaFile()

if SERVER then
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_gho.vmt")
end

function ROLE:PreInitialize()
	self.index = ROLE_GHOST
	self.color = Color(155, 155, 155, 255)
	self.dkcolor = Color(245, 200, 200, 255)
	self.bgcolor = Color(245, 200, 200, 255)
	self.abbr = 'gho'
	self.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
	self.scoreKillsMultiplier = 1 -- multiplier for kill of player of another team
	self.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill
	self.preventFindCredits = true
	self.preventKillCredits = true
	self.preventTraitorAloneCredits = true
	self.unknownTeam = true -- player does not know their teammates
	
	self.defaultTeam = TEAM_INNOCENT

	self.conVarData = {
		pct = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 1, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		shopFallback = SHOP_DISABLED,
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 20
	}
end

if CLIENT then
	hook.Add("TTT2FinishedLoading", "GhoInitT", function()
		-- setup here is not necessary but if you want to access the role data, you need to start here
		-- setup basic translation !
		LANG.AddToLanguage("English", GHOST.name, "Ghost")
		LANG.AddToLanguage("English", "info_popup_" .. GHOST.name,
			[[You are a Ghost!
				Try to survive and haunt Traitors after your death!]])
		LANG.AddToLanguage("English", "body_found_" .. GHOST.abbr, "This was a Ghost...")
		LANG.AddToLanguage("English", "search_role_" .. GHOST.abbr, "This person was a Ghost!")
		LANG.AddToLanguage("English", "target_" .. GHOST.name, "Ghost")
		LANG.AddToLanguage("English", "ttt2_desc_" .. GHOST.name, [[The Ghost is a better innocent, because his spirit can be seen after his death.
	Try to protect the innocents and haunt Traitors after your death!]])
	end)
end

hook.Add("TTTPrepareRound", "TTTGhostReset", function()
	hook.Remove("Tick","ghostentUpdate")
	hook.Remove("PreDrawHalos","AddGhostHalos")
	local Ghkiller = nil
	local Ghdead = nil
	
end)

hook.Add("PlayerDeath", "thirdperson", function(player,item,killer)
	timer.Simple(3, function()
		if (player:GetSubRole()== ROLE_GHOST) && player!=killer && killer:IsPlayer() then
			local Ghkiller = killer
			local Ghdead = player
			local ghostent = ents.Create( "npc_kleiner" )
			ghostent:SetModel( Ghdead:GetModel())
			ghostent:SetPos(player:GetPos()) 
			ghostent:Spawn()
			ghostent:SetNotSolid(true)
			ghostent:SetColor( Color( 245, 245, 245, 100 ) )
			ghostent:SetRenderMode( RENDERMODE_GLOW )
			hook.Add("Tick","ghostentUpdate",function()			
				if ghostent:IsValid() then 
					local v1 = ghostent:GetPos()
					local v2 = Ghkiller:GetPos()
					if (v1-v2):Length()> 20 then
						ghostent:SetAngles(Vector((v2-v1).x,(v2-v1).y,0):Angle())
					end
					if CurTime()%1==0 &&(v1-v2):Length()> 100 then					
						ghostent:SetPos(Ghdead:GetPos() )
					end
				end
			end)
		end
	end)
end)




