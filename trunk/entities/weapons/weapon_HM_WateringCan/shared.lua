if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName = "Watering Can"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Eb"
SWEP.Instructions = "Water seeds"
SWEP.Contact = "Cocks"
SWEP.Purpose = "dafsfsadf"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType("normal")
	end
	self.MaxClip = 10
	util.PrecacheSound("ambient/water/leak_1.wav")
	util.PrecacheSound("ambient/water/drip1.wav")
	util.PrecacheSound("ambient/water/drip2.wav")
	util.PrecacheSound("ambient/water/drip3.wav")
	util.PrecacheSound("ambient/water/drip4.wav")
	util.PrecacheSound("ambient/water/water_spray1.wav")
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true //draw the display?
	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self.Weapon:Clip1() //amount in clip
		self.AmmoDisplay.PrimaryAmmo = 0
	end
	return self.AmmoDisplay //return the table
end 

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	local trace = self.Owner:GetEyeTrace()
	if ( util.PointContents( trace.HitPos ) == 268435488 ) and (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 150) then
		self.Weapon:SetClip1(self.MaxClip)
		self.Owner:EmitSound("ambient/water/water_spray1.wav")
		return
	end

	if (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 150) then
		for k,v in pairs(ents:GetAll()) do
		if v:GetClass() == "hm_seed" and trace.HitPos:Distance(v:GetPos()) <= 100 and v.Watered == 0 then
			if self:Clip1() == 0 then
				self.Owner:EmitSound("ambient/water/drip"..math.random(1,4)..".wav")
			return
			end
			if SERVER then 
				v:Water()
				HMTakeStamina(self:GetOwner())
			end
			self:TakePrimaryAmmo(1)
		end
	end
		if self.Owner:Alive() then
			self.Owner:Freeze(true)
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			local watersound = Sound("ambient/water/leak_1.wav")
			local mysound = CreateSound(self.Owner, watersound)
			mysound:Play()
			timer.Simple(0.9, function() mysound:Stop() end)
			timer.Simple(0.9, function() self.Owner:Freeze(false) end)
		end
	else
	end
end