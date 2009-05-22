
include("shared.lua")
include("fruits.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

CreateConVar("HM_DayTime", "8", FCVAR_NOTIFY)

--starting up..
function HMStartup()
	CheckDataDir()
	HMDaysPassed = -1
	HMUpdateFruits()
	HMStartNewDay()
	HMGetFruitProps()
	--HMDumpFruitTable()
end

hook.Add( "Initialize", "HMStartup", HMStartup )


--player respawn function
function GM:PlayerSpawn(ply)
	ply:Give("weapon_physgun")
	ply:Give("gmod_camera")
	ply:Give("weapon_HM_Crowbar")
	ply:Give("weapon_physcannon")
	ply:Give("gmod_tool")
	ply:SetNetworkedFloat("Stamina", 100)
end

--player initial spawn function
function HMInitSpawn(ply)
	setMoney(ply, 10)
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

----------------------------------------------------------
--[[TABLE CREATION AND MANAGEMENT START]]--
----------------------------------------------------------

function HMUpdateFruits()
	Fruits = util.KeyValuesToTable(file.Read("HarvestMelon/fruits.txt"))
end

concommand.Add("HM_Update_Fruits", HMUpdateFruits)

function HMGetFruitProps()
	ValidFruitProps = {}
	for k,v in pairs(Fruits) do
		for l,b in pairs(v) do
			if l == "fmodel" then
				local tablesize = tostring(table.Count(ValidFruitProps))
				if not ValidFruitProps[tablesize] then
					ValidFruitProps[tablesize] = {}
				end
				ValidFruitProps[tablesize]["Model"] = b
				
				for cock,plz in pairs(v) do
					if cock == "fvalue" then
						ValidFruitProps[tablesize]["Value"] = plz
					end
				end
				
				for inmy, mouf in pairs(v) do
					if inmy == "seedcost" then
						ValidFuritProps[tablesize]["SeedCost"] = mouf
					end
				end
			end
		end
	end
end

function HMGetFruitSeeds()
	FruitSeeds = {}
	for k,v in pairs(Fruits) do
		for l,b in pairs(v) do
			if l == "SeedName" then
				local tablesize = tostring(table.Count(FruitSeeds))
				if not ValidFruitProps[tablesize] then
					ValidFruitProps[tablesize] = {}
				end
				ValidFruitProps[tablesize]["Seed"] = b
				for cock,plz in pairs(v) do
					if cock == "SeedCost" then
						ValidFruitProps[tablesize]["Value"] = plz
					end
				end
			end
		end
	end
end

function HMMergeItemTables()

end

function HMDumpFruitTable()
	local Data = Fruits
	file.Write("HarvestMelon/Fruits.txt",util.TableToKeyValues(Data))
	Msg("Fruits table converted and dumped.\n")
end

--------------------------------------------------------
--[[TABLE CREATION AND MANAGEMENT END]]--
--------------------------------------------------------

// Don't touch this until you get right to the bottom

ChatCommands = {}

function PushCmd(Cmd, Fun)
	local Pos = table.Count(ChatCommands)
	ChatCommands[Pos] = {}
	ChatCommands[Pos][0] = Cmd
	ChatCommands[Pos][1] = Fun
end

local function Said(Ply, Text, ToAll)
	local KeyWords = {}
	local Len = string.len(Text)
	local Pos = 0
	local LastEnd = 1
	local Quote = false
	
	// Extract the 'Key Words', from which we can get a command name and any arguments that are provided
	for i=1,Len do
		local Char = string.sub(Text, i, i)
		
		if(Char == " " && !Quote || i == Len) then
			KeyWords[Pos] = string.sub(Text, LastEnd, i)
			
			Pos = Pos + 1
			LastEnd = i
		end
		
		if(Char == "\"") then Quote = !Quote end
	end
	
	local Args = {}
	for j, w in pairs(KeyWords) do
		if(j != 0) then
			Args[j - 1] = string.Trim(w)
		end
	end
	
	for i, v in pairs(ChatCommands) do
		if (string.Trim(KeyWords[0]) == v[0]) then
			ChatCommands[i][1](Ply, Args)
		end
	end
	
	return Text
end

hook.Add("PlayerSay", "SaidCMD", Said);

// Ok, it's safe to touch everything under here

// Add each command you want to use by the PushCmd function, first parameter being the command name, the second being a function to carry out this command's task
// The function will recieve two parameters, Ply the player who called it, and Args, which is a table containing every argument that was passed
// It is recommended that you ensure the values are valid yourself within this function
// Paramters are seperated using a space, however anything in "s will be regarded as one value
// There you go Eb, enjoy <3

local function FSay(Ply, Args)
	Msg("You said "..Args[0].."\n")
end
PushCmd("!say", FSay)

local function FTP(Ply, Args)
	if(table.Count(Args) < 3) then return end
	
	Ply:SetPos(Vector(tonumber(Args[0]), tonumber(Args[1]), tonumber(Args[2])))
end
PushCmd("!tp", FTP)

local function FPlant(Ply, Args)
	if not Args[0] then return end
	local planted = Plant(Ply, Args[0])
	if not planted then return end
end
PushCmd("!plant", FPlant)

function Plant(Ply, Fruit)
	for k,v in pairs(Fruits) do
		if string.lower(Fruit) == string.lower(k) then
			local tr = Ply:GetEyeTrace()
			local allents = ents.GetAll()
			local proceed = true
			for k2,v2 in pairs(allents) do
				if tr.HitPos:Distance(v2:GetPos()) <= 100 and v2:GetClass() == "hm_seed" then proceed = false end
			end
			
			if proceed then
				local proceed2 = true
				if (getMoney(Ply) - tonumber(Fruits[k]["seedcost"])) < 0 then proceed2 = false end
				if proceed2 then
					removeMoney(Ply, tonumber(Fruits[k]["seedcost"]))
					local ent = ents.Create("HM_Seed")
					ent:SetPos(tr.HitPos)
					ent:Spawn()
					ent["Fruit"] = Fruits[tostring(k)]
				end
			end
		end
	end
	if not ent then return 0 end
end

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

		if HMNextDayWeather == 1 then
			for k, v in pairs(player.GetAll()) do

			end
		elseif HMNextDayWeather == 2 then
			for k, v in pairs(player.GetAll()) do

			end
		else
			for k, v in pairs(player.GetAll()) do

			end
		end
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
	
	--New WIP Timechecking code, uses timers instead of a think, should be much more efficient

	function HMDawnStart(DNT, DDT, NDW)
		local plys = player.GetAll()
		for k,v in pairs(plys) do
			v:ConCommand("pp_colormod_contrast 1")
			v:ConCommand("pp_colormod_addr 0")
			v:ConCommand("pp_colormod_addg 5")
			v:ConCommand("pp_colormod_addb 10")
			v:ConCommand("pp_colormod 1")
		end
	timer.Create("DawnEndTimer", DDT, 1, HMDayStart, DNT, DDT, NDW)
	end
	
	function HMDayStart(DNT, DDT, NDW)
		local plys = player.GetAll()
		for k,v in pairs(plys) do
			v:ConCommand("pp_colormod 0")
		end
	timer.Create("DayEndTimer", DNT, 1, HMDuskStart, DNT, DDT, NDW)
	end
	
	function HMDuskStart(DNT, DDT, NDW)
		local plys = player.GetAll()
		for k,v in pairs(plys) do
			v:ConCommand("pp_colormod_contrast 1")
			v:ConCommand("pp_colormod_addr 10")
			v:ConCommand("pp_colormod_addg 5")
			v:ConCommand("pp_colormod_addb 0")
			v:ConCommand("pp_colormod 1")
		end
	timer.Create("DuskEndTimer", DDT, 1, HMNightStart, DNT, NDW)
	end
	
	function HMNightStart(DNT, NDW)
		local plys = player.GetAll()
		for k,v in pairs(plys) do
			v:ConCommand("pp_colormod_contrast .25")
			v:ConCommand("pp_colormod_addr 0")
			v:ConCommand("pp_colormod_addg 5")
			v:ConCommand("pp_colormod_addb 10")
			v:ConCommand("pp_colormod 1")
		end
		timer.Create("NightEndTimer", DNT, 1, HMStartNewDay, NDW)
	end
	
--------------------------------------------
--[[TIMEKEEPING/WEATHER CODE END]]--
--------------------------------------------

----------------------------------
--[[SHOPPING CODE START]]--
----------------------------------

function BuyItem(tblArgs)
	local Ply = tblArgs[1]
	local Item = tblArgs[2]
	local Amount = tblArgs[3]
	Msg("Success!\n")
end

concommand.Add("HM_VendBuy", BuyItem)

----------------------------------
--[[SHOPPING CODE END]]--
----------------------------------

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
		ply:SetNetworkedInt("Money", (getMoney(ply) + amount))
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

--very very wip code, 
function HM_PlotFarmland(ply, Args)
	local tr = ply:GetEyeTrace()
	local hitpos = tr.HitPos
	local Vectors = {}
	Vectors[1] = Vector(tonumber(Args[0]),tonumber(Args[1]),hitpos.z)
	Vectors[2] = Vector(tonumber(Args[2]),tonumber(Args[3]),hitpos.z)
	Vectors[3] = Vector(tonumber(Args[0]) + tonumber(Args[2]), tonumber(Args[1]), hitpos.z)
	Vectors[4] = Vector(tonumber(Args[0]), tonumber(Args[1]) + tonumber(Args[3]), hitpos.z)


	for k,v in pairs(Vectors) do
		local pole = ents.Create("prop_physics")
		pole:SetModel("models/props_docks/channelmarker_gib01.mdl")
		pole:SetPos(v)
		pole:Spawn()
		local phys = pole:GetPhysicsObject()
		if pole:IsValid() then
			phys:EnableMotion(false)
		end
	end
end

PushCmd("!plot", HM_PlotFarmland)
