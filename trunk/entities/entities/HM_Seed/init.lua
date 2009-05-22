include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

--[[
!!!IMPORTANT!!!
Everything that uses the "Fruits" table, must use all LOWERCASE  or it won't work, it's a bug in the text to table thing, and can not be fixed
The "Fruits" table itsself, must be written exactly as: "Fruits", without quotes of course. The same goes for the self["Fruit"] Tables.


Examples:
	Correct: Fruits["yourfruit"]
	Wrong:  Fruits["YourFruit"]
	
	Correct: Fruits["yourfruit"]["growtime"] = 3
	Wrong:  Fruits["YourFruit"]["GrowTime"] = 3
	Wrong:  Fruits["yourfruit"]["GrowTime"] = 3
	Wrong:  Fruits["YourFruit"]["growtime"] = 3
	Wrong:  fruits["yourfruit"]["growtime"] = 3
	
	Correct: self["Fruit"]["growtime"] = 3
	Wrong:  self["fruit"]["growtime] = 3
	
	Here's hoping you understand.
]]--

function ENT:SpawnFunction(plyPlayer,trTrace)
end

function ENT:Think() --I don't need to think, I'm a plant. >=[
end

function ENT:Use(ply)
end

function ENT:Initialize()
	self:SetModel("models/weapons/w_bugbait.mdl")
	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	--don't edit below, it's declaring variables
	self.Watered = 0
	self.Dying = 0
	self.Growth = 0
	self.Pos = self:GetPos()
	self.entPlant = 0
	self.entFruit = 0
	self.CurChildren = {}
	self.CurChildren["total"] = 0
	self.CurChildren["count"] = {}
end

function ENT:Water()
	self.Watered = 1
	self:SetColor(200,200,255,255)
end

function ENT:UnWater()
	self.Watered = 0
	self:SetColor(255,255,255,255)
end

function ENT:Grow()
		--check if i still have delicious children on me
	if self.Growth == self["Fruit"]["growtime"] then
		local fruitcount = 0
		for i=1,self["Fruit"]["children"] do
			local Proceed = true
			local Ent = self.CurChildren["count"][tostring(i - 1)]
			if(!Ent || !Ent:IsValid()) then Proceed = false end
			if Proceed == true then
				local OldFruitPos = self.CurChildren[tostring(i - 1).."pos"]
				local NewFruitPos = self.CurChildren["count"][tostring(i - 1)]:GetPos()
				if NewFruitPos == OldFruitPos then
					fruitcount = fruitcount + 1
				end
			end
		end
		if fruitcount == 0 and self["Fruit"]["regrow"] == 1  then --if i can move on and have more children:
			self.CurChildren["count"] = {}
			self.CurChildren["total"] = fruitcount
			self.Growth = self.Growth - self["Fruit"]["regrowtime"] --time to repopulate!
		elseif fruitcount == 0 and self["Fruit"]["regrow"] == 0 then --if i'm suicidal and can't live without my delicious children:
			self.entPlant:Remove() --GOODBYE CRUEL WORLD!
			self:Remove()
		end
	end
	
	if self.Watered == 0 then
		if self.Dying == 1 and (self.Growth != self["Fruit"]["growtime"]) then
			local Proceed = true
			local Ent = self.entPlant
			if(Ent == 0) then Proceed = false end
			if Proceed == true then
				self.entPlant:Remove()
			end
			self:Remove()
			return
		else
			self.Dying = 1
		end
		
	elseif self.Watered == 1 then
		self.Dying = 0
		if self.Growth == 0 then
			self.Growth = 1
			self:GrowPlantBase()
		elseif self.Growth >= 1 and self.Growth != self["Fruit"]["growtime"] then
			self.Growth = self.Growth + 1
			local GrowthLength = self["Fruit"]["pendheight"] - self["Fruit"]["pstartheight"]
			self.entPlant:SetPos(self.Pos + Vector(0,0,self["Fruit"]["pstartheight"] + GrowthLength * (self.Growth / self["Fruit"]["growtime"])))
		else
		end
		self:UnWater()
		if self.Growth == self["Fruit"]["growtime"] and self.CurChildren["total"] == 0 then
			self:BearFruit()
			self.CurChildren["total"] = self["Fruit"]["children"]
		end
	end
end

function ENT:GrowPlantBase()
	self.entPlant = ents.Create("prop_physics")
	self.entPlant:SetAngles(Angle(0,math.random(1,360),0))
	self.entPlant:SetPos(self.Pos + Vector(0,0,self["Fruit"]["pstartheight"]))
	self.entPlant:SetModel(self["Fruit"]["pmodel"])
	self.entPlant:Spawn()
	local phys = self.entPlant:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function ENT:BearFruit()
	for i = 1,self["Fruit"]["children"] do
		local NewFruit = ents.Create("prop_physics")
		NewFruit:SetAngles(Angle(0,math.random(1,360),0))
		NewFruit:SetPos(self.Pos + Vector(math.random(-self["Fruit"]["fdistfromp"],self["Fruit"]["fdistfromp"]),math.random(-self["Fruit"]["fdistfromp"],self["Fruit"]["fdistfromp"]),self["Fruit"]["fheight"]))
		NewFruit:SetModel(self["Fruit"]["fmodel"])
		NewFruit:Spawn()
		local phys = NewFruit:GetPhysicsObject()
		if phys:IsValid() then
			phys:Sleep()
		end
		local tablecount = table.Count(self.CurChildren["count"])
		self.CurChildren["count"][tostring(tablecount)] = NewFruit
		self.CurChildren[tostring(tablecount).."pos"] = NewFruit:GetPos()
	end
end
