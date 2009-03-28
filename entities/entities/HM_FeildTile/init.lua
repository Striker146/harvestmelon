include("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:SpawnFunction(plyPlayer,trTrace)
local entSelf = ents.Create("HM_FeildTile")

entSelf:SetPos(trTrace.HitPos + (trTrace.HitNormal * 40))
entSelf:Spawn()

return entSelf
end

function ENT:Think()
end

function ENT:Use()

end

function ENT:Initialize()
local Junktype = rand (0,5)
self:SetModel("models/hunter/plates/plate2x2.mdl")
self:SetMaterial("models/props_wasteland/dirtwall001a")
self:PhysicsInit( SOLID_BBOX )
self:SetMoveType( MOVETYPE_NONE )
self:SetSolid( SOLID_BBOX )
self:SetKeyValue("Surfaceprop", "dirt") -- doesn't work
self.Wet = false
end

function Watered()
	self:SetColor(Color(193,138,28,255))
	self.Wet = true
end

function Dry()
	self:SetColor(Color(255,255,255,255))
	self.Wet = false
end