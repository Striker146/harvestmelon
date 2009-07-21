----------------------------------------------------------
--[[MONEY MANAGEMENT CODE START]]--
----------------------------------------------------------

	--By spog, not bad. =D
	//Returns the player's money.
	function getMoney(ply)
		return ply:GetNetworkedInt("Money")
	end

	//Sets the player's money to the given amount.
	function setMoney(ply,amount)
		ply:SetNetworkedInt("Money", amount)
	end

	//Adds the given amount to a player's money.
	function addMoney(ply,amount)
		ply:SetNetworkedInt("Money", (getMoney(ply) + amount))
	end

	//Removes the given amount from a player's money.
	//Will not give a player negative money. Returns 1 on success; 0 on failure.
	function removeMoney(ply,amount)
		if getMoney(ply) >= amount then
			ply:SetNetworkedInt("Money", (getMoney(ply) - amount))
			return 1
		else
			return 0
		end
	end

	//Removes the given amount from a player's money. Will send player into negatives.
	function forceRemoveMoney(ply,amount)
		ply:SetNetworkedInt("Money", (getMoney(ply) - amount))
	end

	//Removes the given amount from plyGive and gives it to plyTake.
	//Has error checking. Returns 1 on success, 0 on failure.
	function transferMoney(plyGive,plyTake,amount)
		if removeMoney(plyGive,amount) == 1 then
			addMoney(plyTake,amount)
			return 1
		else
			return 0 
		end
	end

--------------------------------------------------------
--[[MONEY MANAGEMENT CODE END]]--
--------------------------------------------------------