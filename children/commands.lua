local PS = game:GetService("Players");
local DS = game:GetService("DataStoreService");

lo
local module = {}

local function hasContentAmount (contents, number)
	if #contents >= number then
		return true
	end

	return false
end

local function findPlayer (player_name)
	for i,v in ipairs(PS:GetPlayers()) do
		if v.Name:find("^"..player_name:lower()) then
			return v;
		end
	end
	
	return false
end

local function isAbove (player, target)
	local above = true;
	
	if player:GetRankInGroup(10643741) > target:GetRankInGroup(10643741) then
		above = false;
	end
	
	return above;
end

local function isAble (player, command)
	local rank_abilities = require(script.rank_ablilities);
	local player_rank = player:GetRankInGroup(10643741);
	
	if rank_abilities[player_rank] == nil then
		return false
	end
	
	return rank_abilities[player_rank][command];
end

module.give = function (player, arguments)
	if isAble(player, "give") then
		if hasContentAmount(arguments, 1) then
			local target = findPlayer(arguments[1]);
			
			if target then
				local given = nil;
				
				for i,v in ipairs(player.Character:GetChildren()) do
					if v:IsA("Tool") then
						given = v;
					end
				end
				
				if given ~= nil then
					player.Character.Humanoid:UnequipTools();
					print("yessir");
					given.Parent = target.Backpack;
					target.Character.Humanoid:EquipTool(given);
				end
			end
		end
	else
		print("Player { "..player.Name.." } has failed to execute command { give }");
	end
end

module.respawn = function (player, arguments)
	if isAble(player, "respawn") then
		if hasContentAmount(arguments, 1) then
			if #arguments > 1 then
				local targets = {};
				
				for i,v in ipairs(arguments) do
					local target = findPlayer(v);

					if target and isAbove(player, target) then
						table.insert(targets, target);
					end
				end

				if targets then
					for i,v in ipairs(targets) do
						v:LoadCharacter();
						print("Player { "..player.Name.." } executed command { respawn } on { "..v.Name.." }");
					end
				end
			else
				if arguments[1] == "all" then			
					for i,v in ipairs(PS:GetPlayers()) do
						if isAbove(player, v) then
							v:LoadCharacter();
							print("Player { "..player.Name.." } executed command { respawn } on { "..v.Name.." }");
						end
					end
				else
					local target = findPlayer(arguments[1]);

					if target and isAbove(player, target) then
						target:LoadCharacter();
						print("Player { "..player.Name.." } executed command { respawn } on { "..player.Name.." }");
					end
				end
			end
		else
			player:LoadCharacter();
			print("Player { "..player.Name.." } executed command { respawn } on { "..player.Name.." }");
		end
	else
		print("Player { "..player.Name.." } has failed to execute command { respawn }");
	end
end

module.refresh = function (player, arguments)
	if isAble(player, "refresh") then
		if hasContentAmount(arguments, 1) then
			if #arguments > 1 then
				local targets = {};
				
				for i,v in ipairs(arguments) do
					local target = findPlayer(v);
					
					if target then
						if isAbove(player, target) then
							table.insert(targets, target);
						end
					end
				end
				
				if targets then
					for i,v in ipairs(targets) do
						local previous_position = v.Character.HumanoidRootPart.CFrame;
						v:LoadCharacter();
						v.Character.HumanoidRootPart.CFrame = previous_position;
						print("Player { "..player.Name.." } executed command { refresh } on { "..v.Name.." }");
					end
				end
			else
				if arguments[1] == "all" then			
					for i,v in ipairs(PS:GetPlayers()) do
						if isAbove(player, v) then
							local previous_position = v.Character.HumanoidRootPart.CFrame;
							v:LoadCharacter();
							v.Character.HumanoidRootPart.CFrame = previous_position;
							print("Player { "..player.Name.." } executed command { refresh } on { "..v.Name.." }");
						end
					end
				else
					local target = findPlayer(arguments[1]);
					
					if target and isAbove(player, target) then
						local previous_position = target.Character.HumanoidRootPart.CFrame;
						target:LoadCharacter();
						target.Character.HumanoidRootPart.CFrame = previous_position;
						print("Player { "..player.Name.." } executed command { refresh } on { "..target.Name.." }");
					end
				end
			end
		else
			local previous_position = player.Character.HumanoidRootPart.CFrame;
			player:LoadCharacter();
			player.Character.HumanoidRootPart.CFrame = previous_position;
			print("Player { "..player.Name.." } executed command { refresh } on { "..player.Name.." }");
		end
	else
		print("Player { "..player.Name.." } has failed to execute command { refresh }");
	end
end

module.kick = function (player, arguments)
	if isAble(player, "kick") then
		if arguments[1] == "all" then
			local reason;
				
			if hasContentAmount(arguments, 2) then
				reason = "You have been kicked by "..player.Name.." for:";
				for i,v in ipairs(arguments) do
					if i ~= 1 then 
						reason = reason.." "..v;
					end
				end
			else
				reason = "You have been kicked by "..player.Name;
			end
			
			for i,v in ipairs(PS:GetPlayers()) do
				if isAbove(player, v) then
					v:Kick(reason);
					print("Player { "..player.Name.." } executed command { kick } on { "..v.Name.." }");
				end
			end	
		else
			local target = findPlayer(arguments[1]);
				
			if target and isAbove(player, target) then
				local reason;
						
				if hasContentAmount(arguments, 2) then
					reason = "You have been kicked by "..player.Name.." for:";
						
					for i,v in ipairs(arguments) do
						if i ~= 1 then 
							reason = reason.." "..v;
						end
					end
				else
					reason = "You have been kicked by "..player.Name;
				end
				
				target:Kick(reason);
				print("Player { "..player.Name.." } executed command { kick } on { "..target.Name.." }");
			end
		end
	else
		print("Player { "..player.Name.." } failed to execute command { kick }");
	end
end

module.pban = function (player, arguments)
	if isAble(player, "pban") then
		if hasContentAmount(arguments, 1) then
			local target = findPlayer(arguments[1]);

			if target and isAbove(player, target) then
				local reason;

				if hasContentAmount(arguments, 2) then
					reason = "You have been pbanned by "..player.Name.." for:";

					for i,v in ipairs(arguments) do
						if i ~= 1 then 
							reason = reason.." "..v;
						end
					end
				else
					reason = "You have been pbanned by "..player.Name;
				end

				target:Kick(reason);
				print("Player { "..player.Name.." } executed command { pban } on { "..target.Name.." }");
			end
		end
	else
		print("Player { "..player.Name.." } failed to execute command { pban }");
	end
end

module.sban = function (player, arguments)
	if isAble(player, "pban") then
		if hasContentAmount(arguments, 1) then
			local target = findPlayer(arguments[1]);

			if target and isAbove(player, target) then
				local reason;

				if hasContentAmount(arguments, 2) then
					reason = "You have been pbanned by "..player.Name.." for:";

					for i,v in ipairs(arguments) do
						if i ~= 1 then 
							reason = reason.." "..v;
						end
					end
				else
					reason = "You have been pbanned by "..player.Name;
				end

				target:Kick(reason);
				print("Player { "..player.Name.." } executed command { pban } on { "..target.Name.." }");
			end
		end
	else
		print("Player { "..player.Name.." } failed to execute command { pban }");
	end
end
return module
