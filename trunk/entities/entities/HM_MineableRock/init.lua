include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(ply,tr)
	local ent = ents.Create("HM_MineableRock")

	ent:SetPos(tr.HitPos + (tr.HitNormal * 20))
	ent.owner = ply
	ent:Spawn()

	return entSelf
end

function ENT:Think()

end

function ENT:Use(ply)

end

function ENT:Initialize()
	self:SetModel("models/props_mining/rock_caves01.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
		local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end
