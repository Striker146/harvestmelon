

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

CreateConVar("HM_DayTime", "8", FCVAR_NOTIFY)

--starting up..
function HMStartup()
	CheckStatsDir()
	HMDaysPassed = -1
	HMStartNewDay()
end

hook.Add( "Initialize", "HMStartup", HMStartup )


--player respawn function
function GM:PlayerSpawn(ply)
	ply:Give("weapon_physgun")
	ply:Give("gmod_camera")
	ply:Give("weapon_HM_Crowbar")
	ply:SetNetworkedFloat("Stamina", 100)
end

--player initial spawn function
function HMInitSpawn(ply)
	setMoney(ply, 100)
end

hook.Add("PlayerInitialSpawn","playerinitialspawn", HMInitSpawn)

--takes player stamina when called, if stamina is at 0, hurts player
function HMTakeStamina(ply)
	local Stamina = ply:GetNetworkedFloat("Stamina")
	if ply:Alive() then
		ply:SetNetworkedFloat("Stamina",(Stamina - 5))
		if Stamina <= 0 then
			ply:SetHealth(ply:Health() - 5)
			ply:SetNetworkedFloat("Stamina",0)
			if ply:Health() <= 0 then
				ply:Kill()
			end
		end
	end
end

--hook.Add( "KeyPress", "KeyPressedHook", HMTakeStamina )  --just here for testing

-------------------------------------------
--[[DATA SAVE CODE START]]--
-------------------------------------------
--It's obvious that we're going to need to track data
--taken right from ebnetstats, should work perfectly.
	--[[Debugger for when we run into problems.]]--
	function DebugPrint(msg)
		if (not StatsDebug) then return end
		Msg("HM Debug: "..msg.."\n") 
	end
	
	--[[Another debugger for outputting tables easily]]--
	function DebugPrintTable(Data)
		if (not StatsDebug) then return end
		PrintTable(Data)
	end

	--[[New readfile thing]]--
	function ReadFile(steamid)
		local Data = util.KeyValuesToTable(file.Read("MHPlyData/data.txt"))
		local PData = Data[string.lower(steamid)]
		DebugPrint("Reading "..PData["name"].."'s data, outputting contents:")
		DebugPrintTable(PData)
		return PData
	end
	
	--[[function DataIntegretyCheck(Data) --WIP
		local Problem
		for PID, PlStTable in pairs(Data) do
			for l, w in pairs(PlStTable) do
				if () then
				end
			end
		end
	end]]--
	
	--[[New writefile thing]]--
	function SaveData(pl)
		local Data = (util.KeyValuesToTable(file.Read("MHPlyData/data.txt")))
		Data[string.lower(pl:SteamID())] = pl.PlayerStats
		local PlayerData = Data[string.lower(pl:SteamID())]
		local TotalTime = math.floor((CurTime() - pl.TimeJoined) + pl.InitialJoinTime)
		PlayerData["name"] = pl:Nick()
		file.Write("MHPlyData/data.txt",util.TableToKeyValues(Data))
		DebugPrint("Saving "..PlayerData["name"].."'s data with:")
		DebugPrintTable(PlayerData)
	end
	
	hook.Add(	"PlayerDisconnected", "Save on disconnect", SaveData, ply)
	
	--[[]Saves all connected player's data for the routine saves.]]--
	function SaveAllData()
		local AllPlayers = player.GetAll()
		for i, v in pairs(AllPlayers) do
		SaveData(v)
		end
	end
	
	--Checks to make sure that all data has what it should, WIP
	function ReadAllData(CheckData)
		local Data = util.KeyValuesToTable(file.Read("MHPlyData/data.txt"))
		if CheckData then
			local Problem = 0
			DebugPrint("Reading ALL data, checking integrety.")
			--local Problem = DataIntegretyCheck(Data)
			if Problem then
				DebugPrint("Some Data Missing, fixed.")
			else
				DebugPrint("All Data Correct")
			end
		else
			DebugPrint("Reading ALL data.")
		end
		return Data
	end
	
	--[[Adds new player data to the database]]--
	function AddNewData(pl)
		local Data = (util.KeyValuesToTable(file.Read("MHPlyData/data.txt")))
		Data[string.lower(pl:SteamID())] = {}
		local PlayerData = Data[string.lower(pl:SteamID())]
		PlayerData["name"] = pl:Nick()
		pl.PlayerStats = PlayerData
		file.Write("MHPlyData/data.txt",util.TableToKeyValues(Data))
		DebugPrint("Created stats entry for "..pl.PlayerStats["name"]..".")
	end
	
	--[[Check if the stats directory is made..]]--	
	function CheckStatsDir()
		if not (file.IsDir("HMPlyData")) then
			file.CreateDir("MHPlyData")
			Msg("Created PlayerData Directory!\n")
		end
		if not (file.Exists("MHPlyData/data.txt")) then
			file.Write("MHPlyData/data.txt", "\"cocks\"{}")
			Msg("Created PlayerData File!\n")
		end
	end
	
	
	--[[Load player's stats file, if none, make the file.]]--
	function LoadPlayerStats(pl)
	local Data = KeyValuesToTable(file.Read("stats/stats.txt"))
		if (Data[string.lower(pl:SteamID())] == nil) then
			AddNewData(pl)
			local Data = ReadFile(pl:SteamID())
		else
			local Data = ReadFile(pl:SteamID())
			Data["name"] = pl:Nick()
			pl.PlayerStats = Data
			DebugPrint("Loading "..Data["name"].."'s HMData.")
			SaveData(pl)
		end
		HMPlayerInitSpawn(ply)
	end
	--hook.Add( "PlayerInitialSpawn", "LoadPlayerStats", LoadPlayerStats )
	
---------------------------------------
--[[DATA SAVE CODE END]]--
---------------------------------------

-----------------------------------------------
--[[TIMEKEEPING/WEATHER CODE START]]--
-----------------------------------------------

	--Run once every day, Starts a new day and parses all time info for the day
	function HMStartNewDay(HMNextDayWeather)
		local ParseDayTime = (GetConVarNumber("HM_DayTime") * 60)
		local DayStartTime = CurTime()
		local DayNigTime = math.floor(ParseDayTime / 2.6)
		local DawDusTime = math.floor(ParseDayTime / 8)
		local HMTime = math.floor(CurTime() - DayStartTime)
		--SetNetworkedFloat("Time", HMTime)

		if HMNextDayWeather == 1 then
			for k, v in pairs(player.GetAll()) do
				v:SendLua([[
				HMRainSound:Stop
				]])
			end
		elseif HMNextDayWeather == 2 then
			for k, v in pairs(player.GetAll()) do
				v:SendLua([[
				HMRainSound = CreateSound(LocalPlayer(),"sound\ambient\water\water_flow_loop1.wav")
				HMRainSound:Play
				]])
			end
		else
			for k, v in pairs(player.GetAll()) do
				v:SendLua([[
				HMRainSound:Stop
				]])
			end
		end
		HMNextDayWeather = math.floor(math.random(1,2))
		HMDawnStart(DayNigTime, DawDusTime, HMNextDayWeather)
	end
	
	--New WIP Timechecking code, uses timers instead of a think, should be much more efficient

	function HMDawnStart(DNT, DDT, NDW)
		for k,v in pairs(player.GetAll()) do
			v:ConCommand("pp_colormod_contrast 1")
			v:ConCommand("pp_colormod_addr 0")
			v:ConCommand("pp_colormod_addg 5")
			v:ConCommand("pp_colormod_addb 10")
			v:ConCommand("pp_colormod 1")
		end
	timer.Create("DawnEndTimer", DDT, 1, HMDayStart, DNT, DDT, NDW)
	end
	
	function HMDayStart(DNT, DDT, NDW)
		for k,v in pairs(player.GetAll()) do
			v:ConCommand("pp_colormod 0")
		end
	timer.Create("DawnEndTimer", DNT, 1, HMDuskStart, DNT, DDT, NDW)
	end
	
	function HMDuskStart(DNT, DDT, NDW)
		for k,v in pairs(player.GetAll()) do
			v:ConCommand("pp_colormod_contrast 1")
			v:ConCommand("pp_colormod_addr 10")
			v:ConCommand("pp_colormod_addg 5")
			v:ConCommand("pp_colormod_addb 0")
			v:ConCommand("pp_colormod 1")
		end
	timer.Create("DawnEndTimer", DDT, 1, HMNightStart, DNT, NDW)
	end
	
	function HMNightStart(DNT, NDW)
		for k,v in pairs(player.GetAll()) do
			v:ConCommand("pp_colormod_contrast .10")
			v:ConCommand("pp_colormod_addr 0")
			v:ConCommand("pp_colormod_addg 5")
			v:ConCommand("pp_colormod_addb 10")
			v:ConCommand("pp_colormod 1")
		end
		timer.Create("DawnEndTimer", DNT, 1, HMNightStart, NDW)
		HMStartNewDay(NDW)
	end
	
--------------------------------------------
--[[TIMEKEEPING/WEATHER CODE END]]--
--------------------------------------------

----------------------------------------------------------
--[[MONEY MANAGEMENT CODE START]]--
----------------------------------------------------------

	--By spog, not bad. =D
	//Returns the player's money.
	function getMoney(ply)
		return ply:GetNetworkedInt("Money")
	end

	//Sets the player's money to the given amount.
	function setMoney(ply,amount)
		ply:SetNetworkedInt("Money", amount)
	end

	//Adds the given amount to a player's money.
	function addMoney(ply,amount)
		ply:SetNetworkedInt("money", (getMoney(ply) + amount))
	end

	//Removes the given amount from a player's money.
	//Will not give a player negative money. Returns 1 on success; 0 on failure.
	function removeMoney(ply,amount)
		if getMoney(ply) >= amount then
			ply:SetNetworkedInt("Money", (getMoney(ply) - amount))
			return 1
		else
			return 0
		end
	end

	//Removes the given amount from a player's money. Will send player into negatives.
	function forceRemoveMoney(ply,amount)
		ply:SetNetworkedInt("Money", (getMoney(ply) - amount))
	end

	//Removes the given amount from plyGive and gives it to plyTake.
	//Has error checking. Returns 1 on success, 0 on failure.
	function transferMoney(plyGive,plyTake,amount)
		if removeMoney(plyGive,amount) == 1 then
			addMoney(plyTake,amount)
			return 1
		else
			return 0 
		end
	end

--------------------------------------------------------
--[[MONEY MANAGEMENT CODE END]]--
--------------------------------------------------------
