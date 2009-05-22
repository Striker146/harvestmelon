include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(plyPlayer,trTrace)
	local ent = ents.Create("HM_SBin")

	ent:SetPos(trTrace.HitPos + (trTrace.HitNormal * 20))
	ent.owner = plyPlayer
	ent:Spawn()

	return entSelf
end

function ENT:Think()

end

function ENT:Use(ply)

end

function ENT:Initialize()
	self:SetModel("models/props_c17/FurnitureShelf001b.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetPos(self:GetPos() + Vector(0,0,-10))
	self.NextDayMoney = 0
		local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
	
	local bin = ents.Create("prop_physics")
	bin:PhysicsInit( SOLID_VPHYSICS )
	bin:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	bin:SetModel("models/props_wasteland/laundry_cart002.mdl")
	bin:SetPos(self:GetPos() + Vector(0,0,13))
	bin:SetAngles(self:GetAngles() + Vector(0,90,0))
	bin:Spawn()
	constraint.Weld(self, bin, 0,0,0,true)
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() or ent:IsNPC() or ent:IsWorld() or ent:IsVehicle() or ent:GetModel() == "models/props_wasteland/laundry_cart002.mdl" then
	return end
	if ent:GetClass() == "prop_physics" then
		local value = self:CheckValue(ent)
		self.NextDayMoney = self.NextDayMoney + value
		ent:Remove()
	end
end

function ENT:CheckValue(ent)
	local entmodel = ent:GetModel()
	for k,v in pairs(ValidFruitProps) do
		for no,u in pairs(v) do
			if no == "Model" then
				if u == entmodel then
					return ValidFruitProps[tostring(k)]["Value"]
				end
			end
		end
	end
	return 0
end

function ENT:PayOwner()
local owner = self.owner
local amount = self.NextDayMoney
addMoney(owner, amount)
self.NextDayMoney = 0
end
