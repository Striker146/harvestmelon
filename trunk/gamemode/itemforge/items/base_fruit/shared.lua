--[[
fruit_base
SHARED

base item for fruits, not meant to be spawned.

]]--

if SERVER then AddCSLuaFile("shared.lua") end

ITEM.Name="fruit_base";
ITEM.Description="the base for fruits, not really needed.";
ITEM.Base="item";
ITEM.WorldModel="models/props_junk/watermelon01.mdl";
ITEM.MaxHealth=1;

ITEM.Value=nil;

--wow, pretty empty, huh?