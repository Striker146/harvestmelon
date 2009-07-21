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
		local Data = util.KeyValuesToTable(file.Read("HarvestMelon/data.txt"))
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
		local Data = (util.KeyValuesToTable(file.Read("HarvestMelon/data.txt")))
		Data[string.lower(pl:SteamID())] = pl.PlayerStats
		local PlayerData = Data[string.lower(pl:SteamID())]
		PlayerData["name"] = pl:Nick()
		file.Write("HMPlyData/data.txt",util.TableToKeyValues(Data))
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
		local Data = util.KeyValuesToTable(file.Read("HarvestMelon/data.txt"))
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
		local Data = (util.KeyValuesToTable(file.Read("HarvestMelon/data.txt")))
		Data[string.lower(pl:SteamID())] = {}
		local PlayerData = Data[string.lower(pl:SteamID())]
		PlayerData["name"] = pl:Nick()
		pl.PlayerStats = PlayerData
		file.Write("HarvestMelon/data.txt",util.TableToKeyValues(Data))
		DebugPrint("Created stats entry for "..pl.PlayerStats["name"]..".")
	end
	
	--[[Check if the stats directory is made..]]--	
	function CheckDataDir()
		if not (file.IsDir("HarvestMelon")) then
			file.CreateDir("HarvestMelon")
			Msg("Created PlayerData Directory!\n")
		end
		if not (file.Exists("HarvestMelon/data.txt")) then
			file.Write("HarvestMelon/data.txt", "\"cocks\"{}")
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