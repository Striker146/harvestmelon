
include("shared.lua")
include("fruits.lua")
include("time.lua")
include("chatcommands.lua")
include("money.lua")
include("datamanagement.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

CreateConVar("HM_DayTime", "4", FCVAR_NOTIFY)
--IF.Items:SetMaxHeld(1)

--[[TODO
Incorperate Itemforge, this one's a biggie.
	Add fruit items, preferabbly one sent that gets fed arguments, may not be possible.
	Add rucksack and default the player to spawn with it, holds 40 items
	Rucksack will need a way to put held items into it easily, a small rucksack item button you can click and drag stuff into would work.
	Change all weapons into itemforge items.
	Fix the itemforge gui breaking in game. turns out it's a problem with the addon, waiting for the dev to fix it/
	
GUI:
	Day/night changes need to be transitioned.
	Need to make a clock to display the in game time.
	New days start at dawn code side, make it display new days 
	
General:
	Vending machines need a temporary basic ui.
	Players need a way to easily place farm plots, they can only plant in there. first one is free.
	Plots need a cleanup function, 10 minutes after disconnect clean up the entry in the plot table, clear plants, junk, etc.
	plots need to grow weeds and other small nuciances.
	Players need houses! should come with a bed and a form of minimal storage.
	Beds, when used, should put the player to sleep until 6 am the next day. restores stamina completely.
	If all players are sleeping, skip to the next day
	Need some sort of thing to keep player from getting bored while sleeping, maybe spectating or pong or somthing.
	need to incorperate a skill system, shoudlen't be too hard.
	There should be player classes, everyone can do most basic things, but each class has somthing that only it can do
	Fruits should be edible, restores stamina and health
	People should only be able to eat so much in a day. consider mimicing kol
	consider alcohol.
	Weather, some days it rains, other days are disasters.
	Dropping most fruits and valubles should destroy them
	Seasons
	The game needs a in game debug gui. ability to create plants in game is needed, too.
	
Economy:
	players shoulden't just give things to other players. (See: Stranded)
	Have a trade function. and a gui to go with it.
	Trade stands or player operated vending machines, owner sets the items to sell,  and for how much. items must be put in from rucksack.
	
Crafting:
	Create a general crafting system.
	
	Smelting metals:
	
	Smithing:
	
	Plant breeding (melon + berry = melonberry seed):
	
	Animal breeding (hurhur) / taming:
	
	Brewing:
	
	Cooking:
		Have players use a "stove" or somthing to combine 2 or more ingredients to cook somthing.
		have hidden recipies, if the player cooks somthing no recipie matches, give them a "mistake"
]]--

--starting up.
function HMStartup()
	CheckDataDir()
	HMDaysPassed = -1
	HMUpdateFruits()
	HMCreatePlotTable()
	HMStartNewDay()
	HMGetFruitProps()
end

hook.Add( "Initialize", "HMStartup", HMStartup )


--player respawn function
function GM:PlayerSpawn(ply)
	GAMEMODE:SetPlayerSpeed( ply, 250, 500 )
	
	hook.Call( "PlayerLoadout", GAMEMODE, ply )  
	hook.Call( "PlayerSetModel", GAMEMODE, ply )  

	umsg.Start("SendDayPhase", ply)
		umsg.Long( CurDayPhase )
	umsg.End()
end

function GM:PlayerLoadout( ply )
	ply:RemoveAllAmmo()
	ply:Give("weapon_physgun")
	ply:Give("gmod_camera")
	ply:Give("weapon_HM_Crowbar")
	ply:Give("weapon_HM_WateringCan")
	ply:Give("weapon_physcannon")
	ply:Give("gmod_tool")
	ply:SetNetworkedFloat("Stamina", 100)
end

--player initial spawn function
function HMInitSpawn(ply)
	setMoney(ply, 110)
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
						ValidFruitProps[tablesize]["SeedCost"] = mouf
					end
				end
			end
		end
	end
end

--tiny function, i know, here incase if i need it later.
function HMCreatePlotTable()
	Plots = {}
end

--this is used to make a copy of fruits.lua as data/harvestmelon/fruits.txt
function HMDumpFruitTable()
	local Data = Fruits
	file.Write("HarvestMelon/Fruits.txt",util.TableToKeyValues(Data))
	Msg("Fruits table converted and dumped.\n")
end

--------------------------------------------------------
--[[TABLE CREATION AND MANAGEMENT END]]--
--------------------------------------------------------



function Plant(Ply, Fruit)
	local proceed = true
	local tr = Ply:GetEyeTrace()
	local PVectors = nil
	
	--make sure the player is planting in an owned plot
	for k,v in pairs(Plots) do
		for no,u in pairs(v) do
			if no == "Owner" then
				if u == Ply:SteamID() then
					for glamor, slammer in pairs(v) do
						if glamor == "Vectors" then
							PVectors = slammer
						end
					end
				end
			end
		end
	end
	
	if not PVectors then
		proceed = false
		Ply:ChatPrint("You need to plot a farm land to plant in!")
	elseif PVectors then
		local FV = tr.HitPos
		local V1 = PVectors[1]
		local V2 = PVectors[2]
		local V3 = PVectors[3]
		local V4 = PVectors[4]
		proceed = false
		
		if (FV.x > V3.x) and (FV.x < V1.x) and  (FV.y > V3.y) and (FV.y < V1.y) and (FV.z < (V1.z + 150)) and (FV.z > (V1.z - 150)) then
			proceed = true
		else	
		proceed = false
		Ply:ChatPrint("You need to plant in one of your plots!")
		end
	end
	
	--We then check if the player is close enough to where he is looking to plant..
	if tr.HitPos:Distance(Ply:GetPos()) >= 250 then
		proceed = false
		Ply:ChatPrint("Too Far away to plant!")
	end
	
	--then if the ground is suitable to plant seeds
	if not (tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND) then 
		proceed = false
		Ply:ChatPrint("You can't plant there, the ground is too hard!")
	end
	
	local trace = {} --yes, i used stranded to help me with this part.
	trace.StartPos = tr.HitPos
	trace.EndPos = trace.StartPos - Vector(0,0,100000)
	trace.Mask = MASK_SOLID_BRUSHONLY
	
	groundtrace = util.TraceLine(trace)
	
	--no planting in they sky, or walls, jackasses.
	if tr.HitPos.z - 10 <= groundtrace.HitPos.z then
		
	else
		Ply:ChatPrint("You can't plant in the air!")
		proceed = false
	end
	
	local trace = {}
	trace.StartPos = tr.HitPos + Vector(0,0,1)
	trace.EndPos = trace.StartPos + Vector(0,0,100000)
	
	skytrace = util.TraceLine(trace)
	
	--make sure that the plant has sunlight.. doesn't work completely, needs a way to check if the skybox is hit
	if skytrace.HitNonWorld or skytrace.Hit then
		proceed = false
		Ply:ChatPrint("Plants need sunlight, try planting outside.")
	end
	
	local trace = {}
	trace.start = tr.HitPos
	trace.endpos = trace.start + Vector(0,0,1)
	trace.mask = MASK_WATER

	local watertrace = util.TraceLine(trace)

	
	--check if the player is trying to plant underwater
	if watertrace.Hit then
		proceed = false
		Ply:ChatPrint("You can't plant underwater.")
	end

	for k,v in pairs(Fruits) do
		--check if the player is trying to plant a valid plant
		if string.lower(Fruit) == string.lower(k) then
			local allents = ents.GetAll()
			--then check if other plants are too close
			for k2,v2 in pairs(allents) do
				if tr.HitPos:Distance(v2:GetPos()) <= 100 and v2:GetClass() == "hm_seed" then
				Ply:ChatPrint("Too close to other plants!")
					proceed = false
				end
			end
			
			if proceed then
				local proceed2 = true
				--finally, check if the player has enough money, this is temporary until items system is implemented.
				if (getMoney(Ply) - tonumber(Fruits[k]["seedcost"])) < 0 then
					proceed2 = false
					Ply:ChatPrint("You need $"..Fruits[k]["seedcost"].." to plant that seed!")
				end
				--Everything checks out, PLANT!
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
	if not ent then return 0 end -- i forget what this is for =D
end





----------------------------------
--[[SHOPPING CODE START]]--
----------------------------------

--A WIP buying from vending machine code, maybe shold be relocated into vending machine lua file.
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