if CLIENT then
include("shared.lua")

--day/night cycle with umessages, yaaay

	local function HM_InitReceiveDayPhase( um )
		CurDayPhase = um:ReadLong()
	end
	usermessage.Hook("SendDayPhase", HM_InitReceiveDayPhase)

	local function HM_Dawn()
		OldDayPhase = CurDayPhase
		CurDayPhase = 0
		Transistion = 1
	end
	usermessage.Hook("HM_Dawn", HM_Dawn)
	
	local function HM_Day()
		OldDayPhase = CurDayPhase
		CurDayPhase = 1
		Transistion = 1
	end
	usermessage.Hook("HM_Day", HM_Day)
	
	local function HM_Dusk()
		OldDayPhase = CurDayPhase
		CurDayPhase = 2
		Transistion = 1
	end
	usermessage.Hook("HM_Dusk", HM_Dusk)
	
	local function HM_Night()
		OldDayPhase = CurDayPhase
		CurDayPhase = 3
		Transistion = 1
	end
	usermessage.Hook("HM_Night", HM_Night)
	
--HUD start
	local function HarvestMelon_HUD()
		--Stamina start
			local Stamina = LocalPlayer():GetNetworkedFloat("Stamina")
			draw.RoundedBox(4, ScrW() / 50, ScrH() - ScrH() / 7, 150, 26, Color(0,0,0,100))
			draw.SimpleText("Stam:", "ScoreboardText", ScrW() / 26, ScrH() - ScrH() / 8, Color(100,100,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.RoundedBox(2, ScrW() / 18, ScrH() - ScrH() / 7.4, 100, 15, Color(0,0,0,255))
			draw.RoundedBox(2, ScrW() / 18, ScrH() - ScrH() / 7.4, Stamina, 15, Color(0,0,255,255))
			draw.SimpleText(""..Stamina.."", "ScoreboardText", ScrW() / 10, ScrH() - ScrH() / 8, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--Stamina end
		
		--Money start
			local Money = LocalPlayer():GetNetworkedFloat("Money")
			draw.WordBox( 2, ScrW() / 50, ScrH() - ScrH() / 6, "$"..Money, "Default", Color(0,0,0,100), Color(100,255,100,255))
		--Money end
		
		--Time display start
		--if LocalPlayer():GetWeapons["HM_PocketWatch"]then
			--local Time = GM:GetNetworkedFloat("Time")
			--local Minutes = Time 
		--else
		
		--end
		--Time display end
		
		if CurDayPhase == 0 then
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0,50,100,80))
		elseif CurDayPhase == 1 then
			
		elseif CurDayPhase == 2 then
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(100,50,0,60))
		elseif CurDayPhase == 3 then
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0,0,1,175))
		end
	end
	
	hook.Add("HUDPaint","HarvestMelon Hud", HarvestMelon_HUD);
end
