--[[ FRUIT EXAMPLE, duplicate of melon, if you want to make a fruit, 
Fruits["Melon"] = {} --change all "Fruit" to your fruit name, leave "Fruits" alone, though
	Fruits["Melon"]["Fruitname"] = "Melon" --name of the fruit, just what the players will see
	Fruits["Melon"]["Children"] = 3 --How many fruits the plant makes when grown
	Fruits["Melon"]["GrowTime"] = 3 --How long it takes to grow
	Fruits["Melon"]["PModel"] = "models/props/CS_militia/fern01.mdl" --the plant's model
	Fruits["Melon"]["FModel"] = "models/props_junk/watermelon01.mdl" --the plant's fruit's model
	Fruits["Melon"]["Regrow"] = 0 --0 or 1, if 1 regrows, 0, doesn't.
	Fruits["Melon"]["RegrowTime"] = 0 --how many days it takes to regrow, generally after all fruits are picked how long it takes for the plant to make more fruit
	Fruits["Melon"]["FValue"] = 100 --the value of each fruit, not used at the moment
	Fruits["Melon"]["FHealth"] = 100 --the health of the fruit, not used at the moment either
	Fruits["Melon"]["PStartHeight"] = -10 --starting height of the plant when it's spawned
	Fruits["Melon"]["PEndHeight"] = 20 --height of the plant when it's fully grown
	Fruits["Melon"]["FHeight"] = 20 --the height from the seed the plant that fruit spawns
	Fruits["Melon"]["FDistFromP"] = 25 --the distance away from the plant that fruits can spawn
]]--

--[[
Fruits = {} -- Changing the name of this table will break ALL fruits.

Fruits["Melon"] = {}
	Fruits["Melon"]["Fruitname"] = "Melon"
	Fruits["Melon"]["Children"] = 3
	Fruits["Melon"]["GrowTime"] = 3
	Fruits["Melon"]["PModel"] = "models/props/CS_militia/fern01.mdl"
	Fruits["Melon"]["FModel"] = "models/props_junk/watermelon01.mdl"
	Fruits["Melon"]["Regrow"] = 0
	Fruits["Melon"]["RegrowTime"] = 0
	Fruits["Melon"]["FValue"] = 3
	Fruits["Melon"]["FHealth"] = 100
	Fruits["Melon"]["PStartHeight"] = -10
	Fruits["Melon"]["PEndHeight"] = 20
	Fruits["Melon"]["FHeight"] = 20
	Fruits["Melon"]["FDistFromP"] = 25
	Fruits["Melon"]["SeedName"] = "Melon Seed"
	Fruits["Melon"]["SeedCost"] = 1

Fruits["BabyWasher"] = {}
	Fruits["BabyWasher"]["Fruitname"] = "Baby Washer"
	Fruits["BabyWasher"]["Children"] = 3
	Fruits["BabyWasher"]["GrowTime"] = 10
	Fruits["BabyWasher"]["PModel"] = "models/props_c17/FurnitureWashingmachine001a.mdl"
	Fruits["BabyWasher"]["FModel"] = "models/props_c17/doll01.mdl"
	Fruits["BabyWasher"]["Regrow"] = 1
	Fruits["BabyWasher"]["RegrowTime"] = 3
	Fruits["BabyWasher"]["FValue"] = 13
	Fruits["BabyWasher"]["FHealth"] = 100
	Fruits["BabyWasher"]["PStartHeight"] = -10
	Fruits["BabyWasher"]["PEndHeight"] = 17
	Fruits["BabyWasher"]["FHeight"] = 40
	Fruits["BabyWasher"]["FDistFromP"] = 15
	
Fruits["Guwaggle"] = {}
	Fruits["Guwaggle"]["Fruitname"] = "Guwaggle Berry"
	Fruits["Guwaggle"]["Children"] = 6
	Fruits["Guwaggle"]["GrowTime"] = 6
	Fruits["Guwaggle"]["PModel"] = "models/props/de_train/bush2.mdl"
	Fruits["Guwaggle"]["FModel"] = "models/props/de_inferno/crate_fruit_break_gib2.mdl"
	Fruits["Guwaggle"]["Regrow"] = 1
	Fruits["Guwaggle"]["RegrowTime"] = 5
	Fruits["Guwaggle"]["FValue"] = 2
	Fruits["Guwaggle"]["FHealth"] = 100
	Fruits["Guwaggle"]["PStartHeight"] = -15
	Fruits["Guwaggle"]["PEndHeight"] = 0
	Fruits["Guwaggle"]["FHeight"] = 15
	Fruits["Guwaggle"]["FDistFromP"] = 10
]]--