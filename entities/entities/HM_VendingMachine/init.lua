include("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:SpawnFunction(plyPlayer,trTrace)
local entSelf = ents.Create("HM_VendingMachine")

entSelf:SetPos(trTrace.HitPos + (trTrace.HitNormal * 40))
entSelf:Spawn()

return entSelf
end

function ENT:Think()
end

function ENT:Use(ply)
 ply:ChatPrint("This vending machine is broken!")
end

function ENT:Initialize()

self:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
self:PhysicsInit( SOLID_BBOX )
self:SetMoveType( MOVETYPE_NONE )
self:SetSolid( SOLID_BBOX )
end