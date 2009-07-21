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

--port this into a stool, remember to have it ghost the poles,
--have plants check to see if their co-ords are within the farmplot,
--make plants only plantable on the ground and on certain textures
function HM_PlotFarmland(ply, Args)
	if(table.Count(Args) < 2) then return end
	local proceed = true
	
	for key, value in pairs(Plots) do
		for faggot, tree in pairs(value) do
			if faggot == "Owner" then
				if tree == ply:SteamID() then
					ply:ChatPrint("You can only have one plot at a time.")
					proceed = false
				end
			end
		end
	end
	local w, l = tonumber(Args[0]), tonumber(Args[1])
	local amount = math.ceil((w * l) / 100)
	
	if proceed == true then
		if removeMoney(ply, amount) == 0 then
			proceed = false
			ply:ChatPrint("You need $"..amount.." for a plot of that size")
		end
	end
	
	if proceed == true then
		local tr = ply:GetEyeTrace()
		local hitpos = tr.HitPos
		local Vectors = {}



		Vectors[1] = Vector(hitpos.x + (w/2), hitpos.y + (l/2), hitpos.z)
		Vectors[2] = Vector(hitpos.x - (w/2), hitpos.y + (l/2), hitpos.z)
		Vectors[3] = Vector(hitpos.x - (w/2), hitpos.y - (l/2), hitpos.z)
		Vectors[4] = Vector(hitpos.x + (w/2), hitpos.y - (l/2), hitpos.z)
		
		local tablesize = tostring(table.Count(ValidFruitProps))
		Plots[tablesize] = {}
		Plots[tablesize]["Owner"] = ply:SteamID()
		Plots[tablesize]["Vectors"] = Vectors
		

		for k,v in pairs(Vectors) do
			
			local pole = ents.Create("prop_physics")
			pole:SetModel("models/props_docks/dock03_pole01a.mdl")
			pole:SetPos(v)
			pole:Spawn()
			local phys = pole:GetPhysicsObject()
			if pole:IsValid() then
				phys:EnableMotion(false)
			end
		end
	end
end

PushCmd("!plot", HM_PlotFarmland)

function HM_RemovePlot(ply, args)

for key, value in pairs(Plots) do
	for faggot, tree in pairs(value) do
		if faggot == "Owner" then
		local w = 0
		local l = 0
			if tree == ply:SteamID() then
				local v = value["Vectors"]
				local V1 = v[1]
				local V2 = v[2]
				local V3 = v[4]
				w = math.floor(V1:Distance(V3))
				l = math.floor(V2:Distance(V1))
				ply:ChatPrint(tostring(w).." "..tostring(l))
				end
				
				local amount = math.floor(((w * l) / 100) / 2)
				addMoney(ply, amount)
				Plots[key] = {}
			end
		end
	end
end
PushCmd("!unplot", HM_RemovePlot)

function HM_GiveMoney(ply, Args)
	if(table.Count(Args) < 2) then return end
	local plyGive = Args[0]
	local amount = Args[1]
	transferMoney(plyGive,ply,amount)
end

PushCmd("!give, HM_GiveMoney")