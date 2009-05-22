if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName = "Crowbar"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Paranoid*, edited by eb"
SWEP.Instructions = "Whack people :D"
SWEP.Contact = "Paranoid@gamersorigin.com"
SWEP.Purpose = "Request"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 10

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Damage = 10
function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType("normal")
	end
	util.PrecacheSound("physics/flesh/flesh_impact_bullet" .. math.random(3, 5) .. ".wav")
	util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
end


function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + .4)

	local trace = self.Owner:GetEyeTrace()
	local bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 100
	bullet.Damage = 25
	
	if SERVER then
		HMTakeStamina(self:GetOwner())
	end
	
	local e = trace.Entity
	if e ~= nil then
		if (ValidEntity(e) and (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75)) then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Owner:FireBullets(bullet)
			self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random(3, 5) .. ".wav")
		else
			self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		end
	end
end
