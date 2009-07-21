if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName = "Hammer"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Eb"
SWEP.Instructions = "Smash Rocks"
SWEP.Contact = "cocks"
SWEP.Purpose = "To gain minerals from rocks"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType("normal")
	end
	util.PrecacheSound("physics/flesh/flesh_impact_bullet" .. math.random(3, 5) .. ".wav")
	util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
end


function SWEP:PrimaryAttack()
	tr = self.owner:GetEyeTrace()
	if tr.entity:GetClass() == HM_MinableRock then
	rock = tr.entity
	childpos = rock:GetPos()
	rock:Remove()
	
	local child = ents.Create(physics_prop)

	child:SetPos(childpos)
	child:Spawn()
	child:SetModel("models/props_mining/rock_caves01b.mdl")
	child:PhysicsInit( SOLID_VPHYSICS )
	child:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	else end
end
