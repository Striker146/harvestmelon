-----------------------------------------------
--[[TIMEKEEPING/WEATHER CODE START]]--
-----------------------------------------------

	--Run once every day, Starts a new day and parses all time info for the day
	function HMStartNewDay(NDW)
		local ParseDayTime = (GetConVarNumber("HM_DayTime") * 60)
		local DayStartTime = CurTime()
		local DayNigTime = math.floor(ParseDayTime / 2.6)
		local DawDusTime = math.floor(ParseDayTime / 8)
		local HMTime = math.floor(CurTime() - DayStartTime)
		local HMNextDayWeather = NDW
		--SetNetworkedFloat("Time", HMTime)

		local Seeds = ents.FindByClass("HM_Seed")
		for k,v in pairs(Seeds) do
			v:Grow()
		end
		local Bins = ents.FindByClass("HM_SBin")
		for k,v in pairs(Bins) do
			v:PayOwner()
		end
		HMNextDayWeather = math.floor(math.random(1,2))
		HMDawnStart(DayNigTime, DawDusTime, HMNextDayWeather)
	end
	
	concommand.Add("HM_ForceNewDay", HMStartNewDay)
	
	--New WIP Timechecking code, uses timers and usermessages instead of a think, much more efficient

	function HMDawnStart(DNT, DDT, NDW)
		CurDayPhase = 0
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		umsg.Start("HM_Dawn", rp)
		umsg.End()
	timer.Create("DawnEndTimer", DDT, 1, HMDayStart, DNT, DDT, NDW)
	end
	
	function HMDayStart(DNT, DDT, NDW)
		CurDayPhase = 1
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		umsg.Start("HM_Day", rp)
		umsg.End()
	timer.Create("DayEndTimer", DNT, 1, HMDuskStart, DNT, DDT, NDW)
	end
	
	function HMDuskStart(DNT, DDT, NDW)
		CurDayPhase = 2
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		umsg.Start("HM_Dusk", rp)
		umsg.End()
	timer.Create("DuskEndTimer", DDT, 1, HMNightStart, DNT, NDW)
	end
	
	function HMNightStart(DNT, NDW)
		CurDayPhase = 3
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		umsg.Start("HM_Night", rp)
		umsg.End()
		timer.Create("NightEndTimer", DNT, 1, HMStartNewDay, NDW)
	end
	
--------------------------------------------
--[[TIMEKEEPING/WEATHER CODE END]]--
--------------------------------------------