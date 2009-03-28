if CLIENT then

include("shared.lua")
--HUD start
	local function HarvestMelon_HUD()
		--Stamina start
			local Stamina = LocalPlayer():GetNetworkedFloat("Stamina")
			draw.RoundedBox(4, ScrW() / 50, ScrH() - ScrH() / 7, 150, 26, Color(100,100,100,100))
			draw.SimpleText("Stam:", "ScoreboardText", ScrW() / 26, ScrH() - ScrH() / 8, Color(0,0,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.RoundedBox(2, ScrW() / 18, ScrH() - ScrH() / 7.4, 100, 15, Color(0,0,0,255))
			draw.RoundedBox(2, ScrW() / 18, ScrH() - ScrH() / 7.4, Stamina, 15, Color(0,0,255,255))
			draw.SimpleText(""..Stamina.."", "ScoreboardText", ScrW() / 10, ScrH() - ScrH() / 8, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--Stamina end
		
		--Money start
			local Money = LocalPlayer():GetNetworkedFloat("Money")
			draw.WordBox( 2, ScrW() / 50, ScrH() - ScrH() / 6, "$"..Money, "Default", Color(100,100,100,100), Color(0,255,0,255))
		--Money end
		
		--Time display start
		--if LocalPlayer():GetWeapons["HM_PocketWatch"]then
			--local Time = GM:GetNetworkedFloat("Time")
			--local Minutes = Time 
		--else
		
		--end
		--Time display end
	end
	
	hook.Add("HUDPaint","HarvestMelon Hud", HarvestMelon_HUD);
end
